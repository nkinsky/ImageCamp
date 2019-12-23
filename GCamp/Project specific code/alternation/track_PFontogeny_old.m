function [ sigmat, MImat, onsetsesh, days_aligned, pkw, cmat,...
    MImat_armonly_atbirth, days_aligned_armonly_atbirth,...
    MImat_stemonly_atbirth, days_aligned_stemonly_atbirth, sesh_final] = ...
    track_PFontogeny_old( MDbase, MDreg, varargin)
%  [ sigmat, MImat, onsetsesh, days_aligned, pkw, cmat,...
%     MImat_armonly_atbirth, days_aligned_armonly_atbirth,...
%     MImat_stemonly_atbirth, days_aligned_stemonly_atbirth, sesh_final] = ...
%     track_PFontogeny( MDbase, MDreg, varargin)
%   tracks the spatial metrics for place cells before and after they become
%   a place cell. Same backbone as track_splitters
%
%   reg_type = 'pairwise' (default) or 'batch' (uses batch_session_map in
%   base_directory). 'batch' generally gets more reliable results, but can
%   be overly conservative if you have one bad registration in the middle
%   of your sessions.

ip = inputParser;
ip.addRequired('MDbase', @isstruct);
ip.addRequired('MDreg', @isstruct);
ip.addOptional('pthresh', 0.05,  @(a) a >= 0 && a <= 1);
ip.addParameter('days_ba', 2, @(a) a > 0 && round(a) == a);
ip.addParameter('free_only', true, @islogical);
ip.addParameter('ignore_sameday', true, @islogical);
ip.addParameter('nactive_thresh', 5 ,@(a) a >= 0 && round(a) == a);
ip.parse(MDbase, MDreg, varargin{:});
pthresh = ip.Results.pthresh;
days_ba = ip.Results.days_ba;
free_only = ip.Results.free_only;
ignore_sameday = ip.Results.ignore_sameday;
nactive_thresh = ip.Results.nactive_thresh;

xlims = [-days_ba - 0.5, days_ba + 0.5];

if ignore_sameday == false && free_only == false
    disp('ignore_sameday=false and free_only=false')
    error('I won''t let you look at forced vs free trial from the same day')
end

%% Step 1: Load batch neuron map and identify session indices for each
% NK - do this for pair-wise sessions too? With try-catch clause?
sesh = cat(2,MDbase,MDreg); % combine all into one structure
sesh = complete_MD(sesh); % fill in all relevant info
basedir = ChangeDirectory_NK(sesh(1),0); 
% if strcmpi(reg_type,'batch')

load(fullfile(basedir,'batch_session_map.mat'), 'batch_session_map'); % load map
% end

% % get number of bins on stem
% load(fullfile(basedir,'sigSplitters.mat'),'deltacurve');
% length(deltacurve{find(~cellfun(@isempty, deltacurve),1,'first')}); %#ok<*IDISVAR,*USENS>

% Get map between all sessions and related info
batch_map = batch_session_map.map;
% % NK replace this with get_neuronmap_from_batchmap later
sesh_inds = arrayfun(@(a) get_session_index(a, batch_session_map.session),...
    sesh); % Get indices in map for each session 

% Get free and forced trials
[loop_bool, forced_bool] = alt_id_sesh_type(sesh);
free_bool = ~forced_bool & ~loop_bool;
if free_only
    sesh = sesh(free_bool);
    sesh_inds = sesh_inds(free_bool);
elseif ~free_only
    sesh = sesh(~loop_bool);
    sesh_inds = sesh_inds(~loop_bool);
end
num_sessions = length(sesh);
num_neurons = size(batch_map,1);

%% Step 2: Step through each session and load pval and MI 

% Pre-allocate
% relymat = nan(num_neurons, num_sessions);
% deltamaxmat = nan(num_neurons, num_sessions);
% deltamax_normmat = nan(num_neurons, num_sessions);
sigmat = nan(num_neurons, num_sessions);
pvalmat = nan(num_neurons, num_sessions);
MImat = nan(num_neurons, num_sessions);
active_arm_mat = false(num_neurons, num_sessions);
active_stem_mat = false(num_neurons, num_sessions);
for j = 1:num_sessions
    
    % Get session and map indices to use
    sesh_use = sesh(j);
    map_use = batch_map(:,sesh_inds(j)+1);
%     map_use = neuron_map_simple(MDbase, sesh_use, 'batch_map', batch_session_map);
    
    % Get placefield pvalues and mutual information values
    load(fullfile(sesh_use.Location,'Placefields_cm1.mat'),'PSAbool', ...
        'pval', 'MI');
    
    % Identify legit place cells by the significance of their mutual
    % information scores
    sigPF_bool = pval < pthresh; % Threshold to get significant PFs
    
    % Grab # trials each neuron was active on the return arms
    load(fullfile(sesh_use.Location,'Alternation.mat'),'Alt');
    [arm_active_bool, all_active_bool] = get_stem_activity(PSAbool, Alt); % Get stem activity by trial 
    nactive_arm = sum(arm_active_bool,2);
    nactive_all = sum(all_active_bool,2);

    % Get validly mapped cells for that session and if active at all/on the
    % return arm
    valid_bool = ~isnan(map_use) & map_use ~= 0; % Get boolean for validly mapped cells
    active_arm_pass = nactive_arm >= nactive_thresh; % Boolean for cells above activity threshold
    active_all_pass = nactive_all >= nactive_thresh; % Ditto for all trials
    
    % ID if cells are active on the stem or not so that you can pull out
    % cells without any activity on the stem for comparison purposes!
    [ ~, ~, ~, stem_bool, ~, nactive_stem] = ...
        parse_splitters( sesh_use.Location, 3);
    active_stem_bool = nactive_stem >= nactive_thresh; % Boolean for cells above activity threshold
    stem_bool = stem_bool & active_stem_bool; % Redundant: Is it active at all on the stem AND is it active enough
    
    % Map valid & active neurons to batch_map numbering scheme
    valid_bool_all = false(num_neurons, 1);
    valid_bool_all(valid_bool) = active_all_pass(map_use(valid_bool));
          
    % Dump all the values into the matrices
    pvalmat(valid_bool_all,j) = pval(map_use(valid_bool_all));
    MImat(valid_bool_all,j) = MI(map_use(valid_bool_all));
    sigmat(valid_bool_all,j) = sigPF_bool(map_use(valid_bool_all));
    active_arm_mat(valid_bool_all,j) = active_arm_pass(map_use(valid_bool_all));
    active_stem_mat(valid_bool_all,j) = stem_bool(map_use(valid_bool_all));
    
end

%% Step 3: Identify when each neuron becomes a statistically significant 
% place cell

sigmatbool = sigmat;
sigmatbool(isnan(sigmat)) = false;
sigmatbool = logical(sigmatbool);

onsetsesh = nan(num_neurons,1);
PCs = find(any(sigmatbool,2));
for j = 1:length(PCs)
    row_use = PCs(j);
    onsetsesh(row_use) = find(sigmatbool(row_use,:),1,'first');
end

%% Step 4: Get day of all sessions

num_PCs = length(PCs);
dayarray = arrayfun(@(a) get_time_bw_sessions(sesh(1),a),sesh)+1;

%%% NRK - ignore these? Yes, most straightforward - put in flag to do
%%% so...should also put in flag for free_only 
% Add in half day 2nd session to any day with 2 sessions

dayarray(find(diff(dayarray) == 0)+1) = ...
    dayarray(find(diff(dayarray) == 0)+1)+0.25;
dayarray = repmat(dayarray,num_PCs,1);

% keyboard
% NK put code here to grab hand checked reg matrix and discard any
% registrations that aren't great by setting them as NaN? Then they
% shouldn't plot...

onset2 = onsetsesh(PCs);
onset_day = dayarray(sub2ind(size(dayarray),(1:size(dayarray,1))',onset2));
days_aligned = dayarray - onset_day;

if ignore_sameday
    days_aligned(abs(days_aligned) == 0.25) = nan;
    days_aligned = round(days_aligned);
end

%% Step 5: Plot
MImat = MImat(PCs,:);
active_arm_mat = active_arm_mat(PCs,:);
active_stem_mat = active_stem_mat(PCs,:);

% Identify neurons with activity on arm only or stem only on day they
% first become place cells
active_armonly_atbirth = any(active_arm_mat & days_aligned == 0,2) & ...
    ~any(active_stem_mat & days_aligned == 0,2);
active_stemonly_atbirth = ~any(active_arm_mat & days_aligned == 0,2) & ...
    any(active_stem_mat & days_aligned == 0,2);

MImat_armonly_atbirth = MImat(active_armonly_atbirth,:);
MImat_stemonly_atbirth = MImat(active_stemonly_atbirth,:);
days_aligned_armonly_atbirth = days_aligned(active_armonly_atbirth,:);
days_aligned_stemonly_atbirth = days_aligned(active_stemonly_atbirth,:);

valid_bool_arm = ~isnan(MImat_armonly_atbirth) & ...
    ~isnan(days_aligned_armonly_atbirth);
valid_bool_stem = ~isnan(MImat_stemonly_atbirth) & ...
    ~isnan(days_aligned_stemonly_atbirth);
% valid_bool2 = ~isnan(MImat) & ~isnan(days_aligned); % Grab all non-nan values
% % Get all cells that have activity on the return arms only.
% valid_arm_only = valid_bool2 & active_arm_mat & ~active_stem_mat;
% % Ditto for stem neurons
% valid_stem_only = valid_bool2 & ~active_arm_mat & active_stem_mat;
% unique_daydiff_arms = unique(days_aligned(valid_arm_only));
% arm_day_labels = arrayfun(@(a) num2str(a,'%0.2g'), unique_daydiff_arms, ...
%     'UniformOutput',false);
unique_daydiff_arms = unique(days_aligned_armonly_atbirth(valid_bool_arm));
arm_day_labels = arrayfun(@(a) num2str(a,'%0.2g'), unique_daydiff_arms, ...
    'UniformOutput',false);
%%
figure('Position',[1940, 64, 1833, 900]);
ha = subplot(2,3,1:2);
% scatterBox(MImat(valid_arm_only), days_aligned(valid_arm_only), ...
%     'xLabels', arm_day_labels, 'yLabel', 'Mutual Information', 'h', ha);
scatterBox(MImat_armonly_atbirth(valid_bool_arm), ...
    days_aligned_armonly_atbirth(valid_bool_arm), ...
    'xLabels', arm_day_labels, 'yLabel', 'Mutual Information', 'h', ha);
xlim(xlims)
xlabel('Days From Place Field Birth')
title(['Place Cell Ontogeny - Return Arm Neurons: ' ...
    mouse_name_title(sesh(1).Animal)])

ha = subplot(2,3,4:5);
% unique_daydiff_stem = unique(days_aligned(valid_stem_only));
unique_daydiff_stem = unique(days_aligned_stemonly_atbirth(valid_bool_stem));
stem_day_labels = arrayfun(@(a) num2str(a,'%0.2g'), unique_daydiff_stem, ...
    'UniformOutput',false);
% scatterBox(MImat(valid_stem_only), days_aligned(valid_stem_only), ...
%     'xLabels', stem_day_labels, 'yLabel', 'Mutual Information', 'h', ha);
scatterBox(MImat_stemonly_atbirth(valid_bool_stem), ...
    days_aligned_stemonly_atbirth(valid_bool_stem), ...
    'xLabels', stem_day_labels, 'yLabel', 'Mutual Information', 'h', ha);
xlim(xlims)
xlabel('Days From Place Field Birth')
title(['Place Cell Ontogeny - Stem Neurons: ' ...
    mouse_name_title(sesh(1).Animal)])

% dmax_by_day = arrayfun(@(a) deltamaxmat2(days_aligned == a), unique(days_aligned),...
%     'UniformOutput',false);
% rely_by_day = arrayfun(@(a) relymat2(days_aligned == a), unique(days_aligned),...
%     'UniformOutput',false);

%% Step 6: Run ANOVA on the days before and after and Tukey test
days_use = ceil(-days_ba:1:days_ba);

%%% PLOT STATS FOR ARM NEURONS
% Get days to look at
% daysvalid = days_aligned(valid_arm_only);
daysvalid = days_aligned_armonly_atbirth(valid_bool_arm);
ba_bool = arrayfun(@(a) ismember(a, days_use), daysvalid);

% Run for deltamax
% MIvalid = MImat(valid_arm_only);
MIvalid = MImat_armonly_atbirth(valid_bool_arm);
[pkw, ~, stats] = kruskalwallis(MIvalid(ba_bool), daysvalid(ba_bool),'off');
[cmat, ~] = multcompare(stats,'Display','off');
unique_days = unique(daysvalid(ba_bool));
cmat(:,1) = unique_days(cmat(:,1));
cmat(:,2) = unique_days(cmat(:,2));

subplot(2,3,3)
text(0.1, 1, ['First sesh date = ' mouse_name_title(MDbase.Date)])
text(0.1, 0.9, 'day1   day2   pval')
text(0.1, 0.5, num2str(cmat(:,[1 2 6]), '%0.2g \t'))
text(0.1, 0.95, ['pkw = ' num2str(pkw, '%0.2g')])
axis off

%%% PLOT STATS FOR ARM NEURONS
% Get days to look at
% daysvalid = days_aligned(valid_stem_only);
daysvalid = days_aligned_stemonly_atbirth(valid_bool_stem);
ba_bool = arrayfun(@(a) ismember(a, days_use), daysvalid);

% Run for deltamax
% MIvalid = MImat(valid_stem_only);
MIvalid = MImat_stemonly_atbirth(valid_bool_stem);
[pkw, ~, stats] = kruskalwallis(MIvalid(ba_bool), daysvalid(ba_bool),'off');
[cmat, ~] = multcompare(stats,'Display','off');
unique_days = unique(daysvalid(ba_bool));
cmat(:,1) = unique_days(cmat(:,1));
cmat(:,2) = unique_days(cmat(:,2));

subplot(2,3,6)
text(0.1, 1, ['First sesh date = ' mouse_name_title(MDbase.Date)])
text(0.1, 0.9, 'day1   day2   pval')
text(0.1, 0.5, num2str(cmat(:,[1 2 6]), '%0.2g \t'))
text(0.1, 0.95, ['pkw = ' num2str(pkw, '%0.2g')])
axis off

%% Step 7: save sesh_final
sesh_final = sesh;


end

