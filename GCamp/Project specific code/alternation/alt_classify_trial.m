function [Mdl, pred_corr, pred_incorr, pred_incorr_retro, pred_frames_bool, ...
    incorr_frames_bool, pred_corr_shuf] = alt_classify_trial(PSAbool, trial_num, ...
    trial_type, correct, onstem, varargin)
% alt_classify_trial(PSAbool, trial_num, trial_type, correct, onstem,
% class_dir,...)
%
%   Trains an LDA classifier on leave_out_prop*ntrials and decodes the
%   remaining trials.
%
%   INPUTS
%       PSAbool: putative spiking activity for all neurons, nneurons x
%       nframes boolean.
%
%       trial_num: 1 x nframes array of trial number (1 to ntrials)
%
%       trial_type: 1 x nframes. 1 = left, 2 = right
%
%       correct: 1 x nframes boolean, true = correct.
%
%       onstem: 1 x nframes boolean. true = on stem.
%
%       NAME-VALUE PAIRS (optional):
%
%       'leave_out_prop': proportion of trials to leave out, rounded up.
%       Default = 0.01 -> one trial left out.
%
%       'model_retro': make and LDA model for retrospective encoding
%       (previous trial). default = false (to save computing time).
%
%       Note that the retrospective coding output is a bit wonky currently

ip = inputParser;
ip.addRequired('PSAbool', @(a) isnumeric(a) || islogical(a));
ip.addRequired('trial_num', @isnumeric);
ip.addRequired('trial_type', @isnumeric);
ip.addRequired('correct', @islogical);
ip.addRequired('onstem', @islogical);
ip.addParameter('leave_out_prop', 0.5, @(a) isnumeric(a) && a > 0 && a < 1);
ip.addParameter('model_retro', false, @islogical);
ip.addParameter('nshuf', 0, @(a) isnumeric(a) && a > 0 && round(a) == a);
ip.parse(PSAbool, trial_num, trial_type, correct, onstem, varargin{:});

leave_out_prop = ip.Results.leave_out_prop;
model_retro = ip.Results.model_retro;
nshuf = ip.Results.nshuf;

%% Identify correct trials
ntrials = max(trial_num); % get # trials
correct_bool = arrayfun(@(a) unique(correct(trial_num == a)),...
    1:ntrials); %ID correct trials
correct_trials = find(correct_bool);
correct_frames_bool = ismember(trial_num, correct_trials); % ID frames corresponding to correct trials

% Grab only correct trials for training purposes...
% PSAtrue = PSAbool(:,correct_frames_bool);
% trialtrue = trial_num(correct_frames_bool);
% typetrue = trial_type(correct_frames_bool);
% onstemtrue = onstem(correct_frames_bool);

%% Grab random # of trials to train on based on leave_out_prop
ncorrect = length(correct_trials);
ntrain = floor(ncorrect*(1-leave_out_prop));
train_ind_temp = sort(randperm(ncorrect, ntrain)); % Get indices of trials to use in true_trials
train_trials = correct_trials(train_ind_temp); % Get trial numbers to use for training
train_bool = ismember(trial_num, train_trials); % Boolean of frames with correct trials

%% Get training, prediction, and incorrect trial PSA 
pred_bool = ~train_bool & correct_frames_bool;

% Make PSA for training and prediction of true and false trials
train_frames_bool = train_bool & onstem;
pred_frames_bool = pred_bool & onstem;
incorr_frames_bool = ~correct_frames_bool & onstem;
PSAtrain = PSAbool(:, train_frames_bool);
PSApred = PSAbool(:, pred_frames_bool);
PSAincorr = PSAbool(:, incorr_frames_bool);

%% Train classifier and predict correct/incorrect trials (prospective)
Mdl = fitcdiscr(double(PSAtrain'), trial_type(train_bool & onstem)',...
    'discrimType', 'pseudoLinear');

pred_corr = predict(Mdl, double(PSApred'));
pred_incorr = predict(Mdl, double(PSAincorr'));

%% Run shuffling if specified!

% Get list of trial types corresponding to each trial number
trial_list = arrayfun(@(a) unique(trial_type(trial_num == a)), 1:ntrials)';

% Make a list of trials, including 0 for pre-trial and post-last trial
trial_num_list = (0:ntrials)';

% Pre-allocate shuffled array
pred_corr_shuf = nan(size(PSApred,2),nshuf);
parfor j = 1:nshuf
    % Shuffle trial type
    list_shuf = [nan; trial_list(randperm(length(trial_list)))];
    % Assign it to each time point
    trial_type_shuf = arrayfun(@(a) list_shuf(trial_num_list == a) , trial_num);
    
    Mdlshuf = fitcdiscr(double(PSAtrain'), trial_type_shuf(train_bool & onstem)',...
    'discrimType', 'pseudoLinear');

    pred_corr_shuf(:,j) = predict(Mdlshuf, double(PSApred'));
end

%% Set-up, train, and predict incorrect trials with retrospective classifier

pred_incorr_retro = [];
if model_retro
    % Assembly array with trial number in col1 an trial_type in col2
    temp = arrayfun(@(a) [a unique(trial_type(trial_num == a))],...
        (1:ntrials)','UniformOutput', false);
    num_type = cat(1,temp{:});
    
    % Substitute previous trial type in 2nd column
    num_type_retro = num_type;
    num_type_retro(2:end,2) = num_type_retro(1:end-1,2);
    num_type_retro(1,2) = nan;
    
    trial_type_retro = zeros(size(trial_type));
    for j = 1:ntrials
        trial_type_retro(num_type_retro(j,1) == trial_num) = ...
            num_type_retro(j,2);
    end
    
    Mdl_retro = fitcdiscr(double(PSAtrain'), ...
        trial_type_retro(train_bool & onstem)','discrimType', 'pseudoLinear');
    pred_incorr_retro = predict(Mdl_retro, double(PSAincorr'));
end

%% Plot for QC purposes
plot_flag = false;
if plot_flag
    figure; set(gcf,'Position', [2235 30 1290 970]);
    
    % Plot true trials not trained by decoder
    subplot(2,1,1);
    hptrue = plot(pred_corr, 'b.'); hold on
    hactualtrue = plot(trial_type(pred_bool & onstem)','ro');
    ylim([0.5 2.5])
    legend(cat(2, hptrue, hactualtrue), {'Predicted', 'Actual'})
    title('Correct Trial LDA');
    
    % Plot false trials
    subplot(2,1,2);
    hptrue = plot(pred_incorr, 'b.'); hold on
    hactualtrue = plot(trial_type(~correct_frames_bool & onstem)','ro');
    hrtrue = plot(pred_incorr_retro, 'g-');
    ylim([0.5 2.5])
    legend(cat(2,hptrue,hrtrue, hactualtrue), ...
        {'Pred. - Prospective', 'Pred. - Retrospective', 'Actual'});
    title('Incorrect Trial LDA');
    
end

end

