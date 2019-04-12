function [outputArg1,outputArg2] = alt_wood_analysis(session)
% alt_wood_analysis(session)
%   Does the Emma Wood et al. (2000) splitter analysis to a) double check
%   our splitter results, and b) address systematic differences in speed or
%   lateral stem position in producing splitting...

nbinsx = 4; % #stem bins
% This might be unnecessary if you treat the lateral stem position as a 
% continuous variable
nbinsy = 5; % #lateral stem bins

%% Step 1: Load in data
Alt = []; PSAbool = []; isrunning = []; speed = [];
load(fullfile(session.Location, 'Alternation.mat'),'Alt')
load(fullfile(session.Location, 'Placefields_cm1.mat'), 'PSAbool', 'isrunning')
load(fullfile(session.Location, 'Pos_align.mat'), 'speed')
speed = speed(isrunning); % Grab only points above speed threshold to match data in Alt
nneurons = size(PSAbool, 1);
ntrials = size(Alt.summary(1));

% ID significant splitters
[sigbool, stembool] = alt_id_sigsplitters(session);
sigind = find(sigbool);
stemind = find(stembool);
nneurons_stem = length(stemind);

% Zero x and y data to beggining and center of stem, respectively
xzero = Alt.x - min(Alt.x(Alt.section == 2)); 
ycent = Alt.y - mean([max(Alt.y(Alt.section == 2)) min(Alt.y(Alt.section == 2))]);

% Get correct/incorrect trials
if regexpi(session.Notes, 'forced') || regexpi(session.Notes, 'looping')
    correct_bool = true(ntrials,1); % Include all trials if looping/forced
else
    correct_bool = logical(Alt.summary(:,3));
end
correct_trials = find(correct_bool);
ncorr = length(correct_trials);
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

% Next, calculate speed and lateral position for each traversal of a stem
% bin on correct trials
ypos = nan(ncorr, nbinsx);
speed = nan(ncorr, nbinsx);
for j = 1:ncorr
    trial = correct_trials(trial);
    speed(j,:) = arrayfun(@(a) bin_size/range(frames_stem(binx == a & ...
        trial_stem == trial))/20, 1:nbinsx);
    ypos(j,:) = arrayfun(@(a) mean(ycent(binx == a & trial_stem == trial)),...
        1:nbinsx);
    
end

% Make sector and choice variables
sector = repmat(1:nbinsx, ncorr, 1);
choice = repmat(Alt.summary(correct_bool,2), 1, nbinsx);

% Next, calculate ER for each neuron on each trial and run the ANCOVA
ER = nan(ncorr, nbinsx, nneurons_stem);
for j = 1:ncorr
    trial = correct_trials(trial);
    for k = 1:nneurons_stem
        neuron = stemind(k);
        % Get neuron firing counts in each stem bin
        psa_use = PSAbool(neuron,:);
        ER(j, :, k) = arrayfun(@(a) sum(psa_use(j, binx == a & trial_stem == trial)), ...
            1:nbinsx);
        
    end
    
end

% Last, do the ANCOVA! (Note that Emma only did this on splitters, not all
% stem cells)
for k = 1:nneurons_stem
    p = anovan(squeeze(ER(:,:,k)), [choice(:), sector(:), speed(:), ypos(:)], ...
        'continuous',[ 3 4], 'varnames', {'LR', 'stem bin', 'speed', 'ypos'});
end

end

