% Generate rotation analysis plots for all mice and session-pairs in local
% cue aligned = 0 format and format #2 where we calculate the rotation of
% each session's map relative to distal cues and compare it to the rotation
% of the arena

sesh_type = {'square', 'circle', 'circ2square'};
num_comps = [28 28 64];
alpha = 0.05;
animal_use = 1;
k = 2;
num_shuffles = 1000;
local_ref = true;

% Get significance - max of chi-squared test and shuffle test
sesh_use = Mouse(animal_use).sesh.(sesh_type{k});
sig_values_comb = cat(3, Mouse(animal_use).coherency.(sesh_type{k}).pmat,...
    Mouse(animal_use).global_remap_stats.(sesh_type{k}).p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

twoenv_rot_analysis_full(sesh_use, sesh_type{k}, 'num_shuffles', 1000,...
    'sig_star', sig_star, 'sig_value', sig_value_use, 'local_ref', local_ref);
