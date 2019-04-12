function [arm_active_bool, all_active_bool] = get_stem_activity(PSAbool, Alt)
% [arm_active_bool, all_active_bool] = get_stem_activity(PSAbool, Alt)
%   Alternation function. Spits out boolean identifying if, for each trial, 
%   that particular neuron was active on the stem.

nneurons = size(PSAbool,1);
ntrials = size(Alt.summary,1);

arm_active_bool = nan(nneurons, ntrials); 
all_active_bool = nan(nneurons, ntrials); 
for j = 1:size(Alt.summary,1)
    % Determine if each neuron was active on the return arm for a given
    % trial
    PSAuse_arm = PSAbool(:,ismember(Alt.section, [5, 8]) & Alt.trial == j); 
    arm_active_bool(:,j) = any(PSAuse_arm,2); 
    
    % Determine if each neuron was active at all during a trial
    PSAuse_all = PSAbool(:, Alt.trial == j); 
    all_active_bool(:,j) = any(PSAuse_all, 2); 
end

end

