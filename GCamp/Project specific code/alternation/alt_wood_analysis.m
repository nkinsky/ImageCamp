function [p, tbl, p_simple, tbl_simple] = alt_wood_analysis(session, varargin)
% [p, tbl] = alt_wood_analysis(session)
%   Does the Emma Wood et al. (2000) splitter analysis to a) double check
%   our splitter results, and b) address systematic differences in speed or
%   lateral stem position in producing splitting...
%
%   INPUT = session: MD to session of interest
%       optional (save_data, use_saved_data) booleans to save data or load
%       previously saved data for easier later access.
%
%   OUTPUT = p: nstem_neurons x 5 array with pvalue for each of the
%   following covariates, obtained by running anovan: 1) L/R trial, 2) stem
%   bin, 3) L/R x stem bin interaction, 4) speed, 5) lateral position
%
%       tbl: table of values/stats for all neurons
%
%   p_simple, bl_simple: same as p, tbl but only includes L/R position,
%   stem_bin, and L/R x stem bin interaction as ANOVA terms
%
%   NK to-do: a) add in L/R and stem bin interaction, and b) try removing
%   speed/lateral position and see how many more splitters we get...

nbinsx = 4; % #stem bins
% This might be unnecessary if you treat the lateral stem position as a 
% continuous variable
nbinsy = 5; % #lateral stem bins

%% Parse Inputs
ip = inputParser;
ip.addRequired('session', @isstruct);
ip.addParameter('save_data', false, @islogical); % save data for fast loading later on
ip.addParameter('use_saved_data', false, @islogical); % load previously saved data!
ip.parse(session, varargin{:})

save_data = ip.Results.save_data;
use_saved_data = ip.Results.use_saved_data;

%% Step 0: load previously run data if specified

load_success = false;
if use_saved_data
    try
        load(fullfile(session.Location,'wood_analysis.mat'), 'wood_analysis');
        if compare_sessions(wood_analysis.session, session) %#ok<NODEF>
            p = wood_analysis.p;
            tbl = wood_analysis.tbl;
            p_simple = wood_analysis.p_simple;
            tbl_simple = wood_analysis.tbl_simple;
            load_success = true;
        end
    catch
        disp('Error loading wood_analysis.mat - running alt_wood_analysis - rerun with save_data flag if desired!')
    end
end

%% Step 1: Load in data
% Alt = []; PSAbool = []; isrunning = []; speed = [];

if ~load_success
load(fullfile(session.Location, 'Alternation.mat'),'Alt')
load(fullfile(session.Location, 'Placefields_cm1.mat'), 'PSAbool', 'isrunning')
load(fullfile(session.Location, 'Pos_align.mat'), 'speed')
speed = speed(isrunning); % Grab only points above speed threshold to match data in Alt
nneurons = size(PSAbool, 1);
ntrials = size(Alt.summary,1);

% ID significant splitters
[sigbool, stembool] = alt_id_sigsplitters(session);
sigind = find(sigbool);
stemind = find(stembool);
nneurons_stem = length(stemind);

% Zero x and y data to beggining and center of stem, respectively
xzero = Alt.x - min(Alt.x(Alt.section == 2)); 
ycent = Alt.y - mean([max(Alt.y(Alt.section == 2)) min(Alt.y(Alt.section == 2))]);

% Get correct/incorrect trials
if ~isempty(regexpi(session.Notes, 'forced')) || ...
        ~isempty(regexpi(session.Notes, 'looping'))
    correct_bool = true(ntrials,1); % Include all trials if looping/forced
else
    correct_bool = logical(Alt.summary(:,3));
end

%% Step 2: Run ANOVA on all neurons in 4 stems along the bin

% First, get occupancy in each stem bin
cent_yrange = max(ycent(Alt.section == 2)) - min(ycent(Alt.section == 2));
cent_xrange = max(xzero(Alt.section == 2)) - min(xzero(Alt.section == 2));
cent_yedges = min(ycent(Alt.section == 2)):cent_yrange/nbinsy:...
    max(ycent(Alt.section == 2));
cent_xedges = min(xzero(Alt.section == 2)):cent_xrange/nbinsx:...
    max(xzero(Alt.section == 2));
bin_size = cent_xrange/nbinsx;
[nboth, ~, ~, binx, biny] = histcounts2(xzero(Alt.section == 2), ...
    ycent(Alt.section == 2), cent_xedges, cent_yedges);

% Cut down data to only include stem occupancy
choice_stem = Alt.choice(Alt.section == 2);
trial_stem = Alt.trial(Alt.section == 2);
frames_stem = Alt.frames(Alt.section == 2);
PSA_stem = PSAbool(:, Alt.section == 2);

% Fix bug where a few trials are wonky due to backtracking and don't have
% him on the stem ever
good_stem_tr_bool = false(size(correct_bool));
good_stem_tr_bool(unique(trial_stem(trial_stem ~= 0))) = true;

correct_bool = correct_bool & good_stem_tr_bool;
correct_trials = find(correct_bool);
ncorr = length(correct_trials);

%% Next, calculate speed and lateral position for each traversal of a stem
% bin on correct trials
ypos = nan(ncorr, nbinsx);
speed = nan(ncorr, nbinsx);
for j = 1:ncorr
    trial = correct_trials(j);
    speed(j,:) = arrayfun(@(a) bin_size/range(frames_stem(binx == a & ...
        trial_stem == trial))/20, 1:nbinsx);
    ypos(j,:) = arrayfun(@(a) mean(ycent(binx == a & trial_stem == trial)),...
        1:nbinsx);
    
end

%% Make sector and choice variables
sector = repmat(1:nbinsx, ncorr, 1);
choice = repmat(Alt.summary(correct_bool,2), 1, nbinsx);

%% Next, calculate ER for each neuron on each trial.
% This should match splitters more or less
ER = nan(ncorr, nbinsx, nneurons_stem);
for j = 1:ncorr
    trial = correct_trials(j);
    for k = 1:nneurons_stem
        neuron = stemind(k);
        % Get neuron firing counts in each stem bin
        psa_use = PSA_stem(neuron,:);
        ER(j, :, k) = arrayfun(@(a) sum(psa_use(binx == a & trial_stem == trial))...
            /sum(binx == a & trial_stem == trial), 1:nbinsx);
    end
end

%% Last, do the ANOVA! (Note that Emma only did this on splitters, not all
% stem cells)
% tic
pstem = nan(nneurons_stem, 5);
pstem_simple = nan(nneurons_stem, 3); 
tstem = cell(nneurons_stem,1);
tstem_simple = cell(nneurons_stem,1);
% Include LR, sector, LR x sector, speed, and y-pos as terms
model_use = [1 0 0 0; 0 1 0 0; 1 1 0 0; 0 0 1 0; 0 0 0 1];
for k = 1:nneurons_stem
    [pstem(k,:), tstem{k}] = anovan(reshape(squeeze(ER(:,:,k)),[],1), ...
        [choice(:), sector(:), speed(:), ypos(:)], 'model', model_use,...
        'continuous', [ 3 4], ...
        'varnames', {'LR', 'stem bin', 'speed', 'ypos'}, 'display', 'off');
    [pstem_simple(k,:), tstem_simple{k}] = anovan(...
        reshape(squeeze(ER(:,:,k)),[],1), [choice(:), sector(:)], ...
        'varnames', {'LR', 'stem_bin'},'model', 'interaction', ...
        'display', 'off');
end
% toc

p = nan(nneurons, 5);
p(stembool,:) = pstem;
tbl = cell(nneurons,1);
tbl(stembool) = tstem;

p_simple = nan(nneurons, 3);
p_simple(stembool,:) = pstem_simple;
tbl_simple = cell(nneurons,1);
tbl_simple(stembool) = tstem_simple;

if save_data
    wood_analysis.session = session;
    wood_analysis.p = p;
    wood_analysis.tbl = tbl;
    wood_analysis.p_simple = p_simple;
    wood_analysis.tbl_simple = tbl_simple; %#ok<STRNU>
    save(fullfile(session.Location,'wood_analysis.mat'), 'wood_analysis')
end

end

end

