function [firstturn_corr, otherturn_corr, PVcorr_firstturn, PVcorr_otherturn] ...
    = alt_first_trial_split(session, binthresh, plot_flag)
% [firstturn_corr, otherturn_corr, PVcorr_firstturn, PVcorr_otherturn] ...
%    = alt_first_trial_split(session, binthresh, plot_flag)
%   Analyzes the strength of splitting on the first trial versus other
%   trials.
% 
%   INPUTS
%       session: session structure with working directory to analyzed
%
%       binthresh: # bins the neuron must exhibit significant splitting in 
%       to be considered a splitter (default = 3). 0 = consider ALL neurons
%       active on the stem.
%
%       plot_flag: true = plot (default = true)
%
%   OUTPUTS
%       firstturn_corr, otherturn_corr: ncells x ntrials array of
%       correlations between calcium activity on each trial going that
%       direction and entire session tuning curve
%
%       PVcorr_firstturn, PVcorr_otherturn: ntrials array of correlations
%       between tuning curve of all cells on each trial with the whole
%       session curve

if nargin < 3
    plot_flag = true;
    if nargin < 2
        binthresh = 3;
    end
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
% nstem = length(neuronID);
tuningstem = tuningcurves(neuronID);
sigcurvestem = sigcurve(neuronID);

% ID splitters 
sigSplitters_bool = cellfun(@(a) sum(a) >= binthresh, sigcurvestem);
nsplit = sum(sigSplitters_bool);

% Refine variables to include ONLY significant splitters
tuningstem_sig = tuningstem(sigSplitters_bool);
splitters_sig = splittersByTrialType(sigSplitters_bool, :);

%% Identify first trial direction
first_turn_dir = Alt.summary(1,2);
other_turn_dir = find([1 2] ~= first_turn_dir); % Get other turn direction

% Don't run this if you have no significant splitters or if there are less
% than 10 trials on each side!
if ~isempty(splitters_sig) && ...
        (length(splitters_sig{1,1}) + length(splitters_sig{1,2}) >= ntrial_thresh)
ntrials = [size(splitters_sig{1,1},1), ...
    size(splitters_sig{1,2},1)];

%% Make smoothed tuning curve for each trial (look at Heys 2018 Nature
% Neuro paper for analysis inspiration), and grab overall tuning curve for
% all trials. Necessary?

%Smoothing.
%         leftFit = fit((1:nBins)',tuningcurves{inds(i)}(1,:)','smoothingspline');
%         rightFit = fit((1:nBins)',tuningcurves{inds(i)}(2,:)','smoothingspline');
%         leftCurve = feval(leftFit,bins);
%         rightCurve = feval(rightFit,bins);


%% Compare first trial tuning curve to the whole session tuning curve for
% same trial type - correlation? simple multiplication? - single cells
% first
% corr(splittersByTrialType{2,first_turn}(1,:)',tuningstem{2}(first_turn,:)'...
%     ,'type','Spearman')

% Get correlation between first trial and whole session tuning curve
% firstturn_corr = cellfun(@(a,b) corr(a(1,:)', b(first_turn_dir,:)',...
%     'type','Spearman'), splittersByTrialType(:,first_turn_dir), tuningstem);

% Get correlation between all trials going the direction of the first turn
firstturn_corr = nan(nsplit, ntrials(first_turn_dir));
for j = 1:ntrials(first_turn_dir)
    firstturn_corr(:,j) = cellfun(@(a,b) corr(a(j,:)', b(first_turn_dir,:)',...
    'type','Spearman'), splitters_sig(:,first_turn_dir), tuningstem_sig);
end

% Now for all trials going the other direction
otherturn_corr = nan(nsplit, ntrials(other_turn_dir));
for k = 1:ntrials(other_turn_dir)
    otherturn_corr(:,k) = cellfun(@(a,b) corr(a(k,:)', b(other_turn_dir,:)',...
    'type','Spearman'), splitters_sig(:,other_turn_dir), tuningstem_sig);
end

% keyboard
%% Now do the same but for the whole population at once - basically get PV 
% of event rates for all neurons at each bin and compare across the whole
% stem.
tuningPV = cat(3,tuningstem_sig{:}); % Make a population vector of smoothed tuning curves
tuningPV_firstturn = squeeze(tuningPV(first_turn_dir, :, :)); % Break into first and other turn direction
tuningPV_otherturn = squeeze(tuningPV(other_turn_dir, :, :));
trialPV_firstturn = cat(3, splitters_sig{:, first_turn_dir}); % first turn dir PV
trialPV_otherturn = cat(3, splitters_sig{:, other_turn_dir}); % other turn dir PV

% PVcorr_firsttrial = corr(tuningPV_firstturn(:), ...
%     squeeze(trialPV_firstturn(1,:))', 'type', 'Spearman');

PVcorr_firstturn = nan(1, ntrials(first_turn_dir));
for j = 1:ntrials(first_turn_dir)
    PVcorr_firstturn(j) = corr(tuningPV_firstturn(:), ...
    squeeze(trialPV_firstturn(j,:))', 'type', 'Spearman');
end

PVcorr_otherturn = nan(1, ntrials(other_turn_dir));
for j = 1:ntrials(other_turn_dir)
   PVcorr_otherturn(j) = corr(tuningPV_otherturn(:), ...
       squeeze(trialPV_otherturn(j,:))', 'type', 'Spearman');
end

%% Plot if specified

if plot_flag
    figure; 
    set(gcf, 'Position', [2310 590 1170 320])
    subplot(1,2,1)
    % Plot mean corr of all cells for each trial
    hh = histogram([nanmean(otherturn_corr), nanmean(firstturn_corr(:,2:end))]); 
    hold on;
    hfirst = plot([nanmean(firstturn_corr(:,1)), nanmean(firstturn_corr(:,1))],...
        get(gca,'YLim'),'r-');
    xlabel('Spearman''s \rho')
    ylabel('Count');
    legend(cat(2, hfirst, hh), {'First Trial', 'All Other Trials'});
    title({'Correlation b/w Ind. Trials and Whole Session Tuning Curve', ...
        'Single Cells'})
    
    subplot(1,2,2)
    hh = histogram([PVcorr_firstturn(2:end), PVcorr_otherturn]);
    hold on;
    hfirst = plot([PVcorr_firstturn(1), PVcorr_firstturn(1)], ...
        get(gca,'YLim'),'r-');
    xlabel('Spearman''s \rho')
    ylabel('Count');
    legend(cat(2, hfirst, hh), {'First Trial', 'All Other Trials'});
    title({'Correlation b/w Ind. Trials and Whole Session Tuning Curve', ...
        'Population Vectors'})
end


%% could do the above but for each bin along the stem to see where the highest
% correlations occur... e.g. are splitters most reliably providing
% trajectory dependent information at some point along the stem? Make this
% a separate function!!!

%% Last, do this for early, middle, and late sessions?!?


% 5) 

else % If no significant splitters, make everything nan
    
    firstturn_corr = nan;  otherturn_corr = nan; 
    PVcorr_firstturn = nan; PVcorr_otherturn = nan;
end

end

