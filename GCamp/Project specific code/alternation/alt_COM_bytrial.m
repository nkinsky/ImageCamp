function [COML, COMR, speedL, speedR, sigID] = alt_COM_bytrial(session, binthresh)
% alt_COM_bytrial(session)
%   Tracks COM of tuning curve along the stem within a session. COM =
%   centroid of firing location.
%
%   NRK Note: could add one more input argument to grab files related to
%   return arms...

if nargin < 2
    binthresh = 3;
end

ntrial_thresh = 20; % Must have this many TOTAL correct trials to analyze...

sigcurve = []; splittersByTrialType = []; neuronID = [];
load(fullfile(session.Location,'splittersByTrialType'), ...
    'splittersByTrialType')
load(fullfile(session.Location,'sigSplitters'), 'sigcurve', 'neuronID')

% ID and keep only splitters (set binthresh = 0 to look at ALL neurons with
% stem activity)
sigcurvestem = sigcurve(neuronID);
sigSplitters_bool = cellfun(@(a) sum(a) >= binthresh, sigcurvestem);
sigID = neuronID(sigSplitters_bool);
splitters_sig = splittersByTrialType(sigSplitters_bool, :);

% Check to make sure you have enough splitters and trials to do the
% analysis
if ~isempty(splitters_sig) && ...
        (length(splitters_sig{1,1}) + length(splitters_sig{1,2}) >= ntrial_thresh)
    
    % Get COM for each cell/trial
    nstem_thresh = 3; % # bins that a trial must have Ca2+ activity in to be considered
    
    COML = calc_COM(splitters_sig(:,1), nstem_thresh);
    COMR = calc_COM(splitters_sig(:,2), nstem_thresh);
    
    % Get speed for each trial
    [speedL, speedR] = alt_get_trial_speed(session);
 
else
    COML = nan;
    COMR = nan;
    speedL = nan;
    speedR = nan;
    sigID = nan;
end

end

%% Sub-function to calculate
function [COM] = calc_COM(activity_by_trial, nbin_thresh)
    nsplit2 = size(activity_by_trial,1); % Get # of splitters
    [ntrials2, nbins] = size(activity_by_trial{1});
    COM = nan(ntrials2, nsplit2);
    for j = 1:nsplit2
        % Get centroid of ca2+ activity in each trial
        COM(:,j) = sum(activity_by_trial{j}.*repmat(1:nbins,ntrials2,1),2)...
            ./sum(activity_by_trial{j},2);
        % Nan out any trials with calcium activity in < nstem_thresh
        COM(sum(activity_by_trial{j} ~= 0,2) < nbin_thresh,j) = nan;
    end
    

end

