function [corr_bin_ratio, corr_bin_ratio_shuf] = alt_LDA(session, leave_out_prop, ...
    nshuf)
% [corr_bin_ratio, corr_bin_ratio_shuf] = alt_LDA(session, leave_out_prop, nshuf)
%   Trains an LDA classifier on a given session and calculates its success
%   in ~2cm bins across the stem. Spits out values for shuffled

% 0 shuffles by default
if nargin < 3
    nshuf = 0;
    % Train on 50% of trials and decode on other 50% of trials by default.
    if nargin < 2
        leave_out_prop = 0.5;
    end
end

% Pseudo-code
%% 1) Train classifier with alt_classify_trial
load(fullfile(session.Location,'Alternation.mat'),'Alt');
load(fullfile(session.Location,'Placefields_cm1.mat'),'PSAbool')
[Mdl, pred_corr, pred_incorr, pred_incorr_retro, pred_frames_bool, ...
    incorr_frames_bool, pred_corr_shuf] = alt_classify_trial(PSAbool, Alt.trial, ...
    Alt.choice, Alt.alt == 1, Alt.section == 2, 'leave_out_prop', leave_out_prop, ...
    'nshuf', nshuf);

%% 2) Calculcate success rate
[ncorr, xedges, yedges] = histcounts2(Alt.x(pred_frames_bool)', ...
    pred_corr == Alt.choice(pred_frames_bool)', [12, 2]);
corr_bin_ratio = ncorr(:,2)./sum(ncorr,2);
%% 3) Calculate shuffled values if there

corr_bin_ratio_shuf = nan(12,nshuf);
for j = 1:nshuf
   ncorr_shuf = histcounts2(Alt.x(pred_frames_bool)', ...
       pred_corr_shuf(:,j) == Alt.choice(pred_frames_bool)', [12, 2]);
   corr_bin_ratio_shuf(:,j) = ncorr_shuf(:,2)./sum(ncorr_shuf,2);
end
% 3) If desired, use model to predict other session
% 3a) register PSA to other session and load Alternation data
% 3b) spit out prediction and do the same as above!

end

