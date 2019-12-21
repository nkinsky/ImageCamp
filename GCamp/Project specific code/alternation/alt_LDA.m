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

%% Filter out cells - set up

global WOOD_FILT
global HALF_LIFE_THRESH

if ~isempty(WOOD_FILT) && WOOD_FILT
    lateral_alpha = 0.05;
else
    lateral_alpha = 1;
end

if ~isempty(HALF_LIFE_THRESH) && HALF_LIFE_THRESH
    half_thresh = HALF_LIFE_THRESH;
else
    half_thresh = 100;
end


% First ID any cells to exlucd with extra long transients
[half_all_mean, ~, ~, ~] = get_session_trace_stats(session, ...
    'use_saved_data', true);
exclude_trace = half_all_mean > half_thresh; 

% ID stem cells that are modulated by lateral position. These are ones that
% have significant trajectory modulation after accounting for speed/lateral
% position.
p = alt_wood_analysis(session,'use_saved_data',true);
exclude_lateral = (p(:,1) >= lateral_alpha) & (p(:,3) >= lateral_alpha); 

%% 1) Train classifier with alt_classify_trial
load(fullfile(session.Location,'Alternation.mat'),'Alt');
load(fullfile(session.Location,'Placefields_cm1.mat'),'PSAbool')
PSAbool = PSAbool(~(exclude_lateral | exclude_trace),:); % Exclude neurons if desired
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

