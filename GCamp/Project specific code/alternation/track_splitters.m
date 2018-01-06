function [ relymat, deltamaxmat, deltamat, sigmat, onsetsesh, dayarray ] = track_splitters( ...
    MDbase, MDreg, sigthresh )
% [ relymat, deltamax_mat, delta_mat, onsetsesh, day_lag ] = track_splitters( MDbase, MDreg, ...
%       sigthresh )
%   track splitters across days by spitting out relymat and deltamat that
%   tracks 1-pval and deltacurve from sigsplitters.mat for each neuron, and
%   onsetmat which identifies the day the neuron first achieves significant
%   splitting. day_lag provides the day lag between each session in MDbase
%   to MDreg. sigmat is 1 if a stem cell is a splitter, 0 if it isn't, and
%   nans are either non stem cells or non-active cells. sigthresh is the
%   number of bins on the stem that must exhibit signicant splitting to be
%   considered a splitter. deltamax_mat spits out the max deltacurve value
%   for each cell, wherease delta_mat spits out the whole curve for each
%   cell

%%% NRK Note - scrap deltamat for now since num stem bins is not the same
%%% across all sessions - need to change this somehow! or maybe just
%%% resize?

if nargin < 3
    sigthresh = 3;
end

%% Step 1: Load batch neuron map and identify session indices for each
sesh = cat(2,MDbase,MDreg); % combine all into one structure
sesh = complete_MD(sesh); % fill in all relevant info
basedir = ChangeDirectory_NK(sesh(1),0); 
load(fullfile(basedir,'batch_session_map.mat')); % load map

% get number of bins on stem
load(fullfile(basedir,'sigSplitters.mat'),'deltacurve');
length(deltacurve{find(~cellfun(@isempty, deltacurve),1,'first')});

% Get map between all sessions and related info
batch_map = batch_session_map.map;
sesh_inds = arrayfun(@(a) get_session_index(a, batch_session_map.session),...
    sesh); % Get indices in map for each session
num_sessions = length(sesh);
num_neurons = size(batch_map,1);

%% Step 2: Step through each session and load in 1-pval, deltacurve, and sigsplitting
% Make this into a function??

% Pre-allocate
relymat = nan(num_neurons, num_sessions);
deltamat = nan(num_neurons, num_sessions);
deltamaxmat = nan(num_neurons, num_sessions);
sigmat = nan(num_neurons, num_sessions);
for j = 1:num_sessions
    sesh_use = sesh(j);
    map_use = batch_map(:,sesh_inds(j)+1);
    load(fullfile(sesh_use.Location,'sigSplitters'),'pvalue','sigcurve',...
        'deltacurve');
    nneurons_sesh = length(pvalue); % get number of neurons in sesh_use
    valid_bool = ~isnan(map_use) & map_use ~= 0; % Get boolean for validly mapped cells
    sigsplitter_bool = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters
    
    % Identify cells active on the stem
    stem_bool = ~cellfun(@isempty, pvalue); % in sesh(j) numbering
    valid_stem_bool = false(num_neurons,1); 
    valid_stem_bool(valid_bool) = stem_bool(map_use(valid_bool)); % in batch_map numbering
    
    % Assign reliability and delta_max values to the appropriate neurons
    rely_val = nan(nneurons_sesh,1); delta_max = nan(nneurons_sesh,1);
    rely_val(stem_bool) = cellfun(@(a) 1 - min(a), pvalue(stem_bool));
    delta_max(stem_bool) = cellfun(@(a) max(abs(a)),deltacurve(stem_bool));
    %     delta_val = cell2mat(deltacurve(stem_bool));
    
    % Dump all the values into the matrices
    sigmat(valid_stem_bool,j) = sigsplitter_bool(map_use(valid_stem_bool)); % Map sig
    relymat(valid_stem_bool,j) = rely_val(map_use(valid_stem_bool)); % Map sig
    deltamaxmat(valid_stem_bool,j) = delta_max(map_use(valid_stem_bool)); % Map sig
    
end

%% Step 3: Identify significant splitting onset for all cells
sigmatbool = sigmat;
sigmatbool(isnan(sigmat)) = false;
sigmatbool = logical(sigmatbool);

onsetsesh = nan(num_neurons,1);
splitters = find(any(sigmatbool,2));
for j = 1:length(splitters)
    row_use = splitters(j);
    onsetsesh(row_use) = find(sigmatbool(row_use,:),1,'first');
end

%% Step 4: Get day of all sessions

num_splitters = length(splitters);
dayarray = arrayfun(@(a) get_time_bw_sessions(sesh(1),a),sesh)+1;
% Add in half day 2nd session to any day with 2 sessions
dayarray(find(diff(dayarray) == 0)+1) = ...
    dayarray(find(diff(dayarray) == 0)+1)+0.5; 
dayarray = repmat(dayarray,num_splitters,1);

onset2 = onsetsesh(splitters);
onset_day = dayarray(sub2ind(size(dayarray),(1:size(dayarray,1))',onset2));
days_aligned = dayarray - onset_day;

%% Step 5: Plot
relymat2 = relymat(splitters,:);
deltamaxmat2 = deltamaxmat(splitters,:);
valid_bool = ~isnan(relymat2);
unique_daydiff = unique(days_aligned(valid_bool));
day_labels = arrayfun(@(a) num2str(a,'%0.2g'), unique_daydiff, ...
    'UniformOutput',false);

figure('Position',[560 100 1060 890]);
ha = subplot(2,1,1);
scatterBox(deltamaxmat2(valid_bool),days_aligned(valid_bool), 'xLabels', day_labels, ...
    'yLabel', '\Deltacurve', 'h', ha);
xlim([-3.5 3.5])
xlabel('Days From Splitter Onset')
title(['Splitter Ontogeny - ' mouse_name_title(sesh(1).Animal)])

ha = subplot(2,1,2);
scatterBox(relymat2(valid_bool(:)),days_aligned(valid_bool(:)), 'xLabels', day_labels, ...
    'yLabel', 'reliability (1-p)', 'h', ha);
xlim([-3.5 3.5])
xlabel('Days From Splitter Onset')
make_figure_pretty(gcf);

% dmax_by_day = arrayfun(@(a) deltamaxmat2(days_aligned == a), unique(days_aligned),...
%     'UniformOutput',false);
% rely_by_day = arrayfun(@(a) relymat2(days_aligned == a), unique(days_aligned),...
%     'UniformOutput',false);

end

