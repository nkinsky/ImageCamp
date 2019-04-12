function [firstturn_stem_corrs, otherturn_stem_corrs] = ...
    alt_stem_split_corrs(session, binthresh)
% alt_stem_corrs(session, binthresh)
%   Finds out how reliable the splitting activity is across all bins

if nargin < 2
    binthresh = 3;
end

ntrial_thresh = 20; % Must have this many TOTAL correct trials to analyze...

%% Load variables
sigcurve = []; tuningcurves = []; neuronID = [];
load(fullfile(session.Location,'sigSplitters'), 'sigcurve', 'tuningcurves', ...
    'neuronID')
splittersByTrialType = [];
load(fullfile(session.Location,'splittersByTrialType'), ...
    'splittersByTrialType')
Alt = [];
load(fullfile(session.Location,'Alternation'),'Alt')

% Grab only neurons that are active on the stem and get their tuning curves
% and if they exhibit significant splitting
nstem = length(neuronID);
tuningstem = tuningcurves(neuronID);
sigcurvestem = sigcurve(neuronID);

% ID splitters 
sigSplitters_bool = cellfun(@(a) sum(a) >= binthresh, sigcurvestem);
nsplit = sum(sigSplitters_bool);

% Refine variables to include ONLY significant splitters
tuningstem_sig = tuningstem(sigSplitters_bool);
splitters_sig = splittersByTrialType(sigSplitters_bool, :);

% Identify first trial direction
first_turn_dir = Alt.summary(1,2);
other_turn_dir = find([1 2] ~= first_turn_dir); % Get other turn direction

if ~isempty(splitters_sig) && ...
        (length(splitters_sig{1,1}) + length(splitters_sig{1,2}) >= ntrial_thresh)
ntrials = [size(splitters_sig{1,1},1), ...
    size(splitters_sig{1,2},1)];

%% Now do the same but for the whole population at once - basically get PV 
% of event rates for all neurons at each bin and compare across the whole
% stem.
tuningPV = cat(3,tuningstem_sig{:}); % Make a population vector of smoothed tuning curves
tuningPV_firstturn = squeeze(tuningPV(first_turn_dir, :, :)); % Break into first and other turn direction
tuningPV_otherturn = squeeze(tuningPV(other_turn_dir, :, :));
trialPV_firstturn = cat(3, splitters_sig{:, first_turn_dir}); % first turn dir PV
trialPV_otherturn = cat(3, splitters_sig{:, other_turn_dir}); % other turn dir PV

%% Now get correlations for each bin
nbins = size(tuningPV,2); % # stem bins
firstturn_stem_corrs = nan(ntrials(first_turn_dir), nbins);
otherturn_stem_corrs = nan(ntrials(other_turn_dir), nbins);
for j = 1:nbins
    for k = 1:ntrials(first_turn_dir)
        firstturn_stem_corrs(k,j) = corr(tuningPV_firstturn(j,:)',...
            squeeze(trialPV_firstturn(k,j,:)), 'type', 'Spearman');
    end
    
    for k = 1:ntrials(other_turn_dir)
        otherturn_stem_corrs(k,j) = corr(tuningPV_otherturn(j,:)',...
            squeeze(trialPV_otherturn(k,j,:)), 'type', 'Spearman');
    end
    
end
else
    
end

end

