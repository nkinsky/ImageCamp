function [ coh_bool, remap_bool, silent_bool, valid_bool ] = twoenv_filter_cells( ...
    best_angle_pop, best_angle_all, PSAbool1, PSAbool2, map_use)
% [ coh_bool, remap_bool, silent_bool, valid_bool ] = twoenv_filter_cells( ...
%     best_angle_pop, best_angle_all, PSAbool1, PSAbool2, map_use)
%
%   Filters cells into coherent, remapping, and silent cells for later use.
% INPUTS: best_angle_pop and best_angle_all are from full_rotation_analysis
% saved files, PSAbool1/2 are from the two sessions in question, map_use is
% the map between sessions (get_neuronmap_from_batchmap).

% 1) get valid cells - those with good mapping between session 1 and session 2
valid_bool = ~isnan(map_use) & map_use ~= 0;

% 2) get silent cells
act1 = sum(PSAbool1,2)/size(PSAbool1,2); %Get mean activity of each neuron in sesh1
act2 = sum(PSAbool2,2)/size(PSAbool2,2);
act2_ref = nan(length(act1),1);
act2_ref(valid_bool) = act2(map_use(valid_bool));
% Get cells active in one session but not the other
silent_bool = (act1 ~= 0 & act2_ref == 0) | (act1 == 0 & act2_ref ~= 0);

% 3) Get coherent cells
coh_bool_temp = get_coherent_neurons(best_angle_pop,best_angle);
coh_bool = coh_bool_temp & ~silent_bool;

% 4) Get remapping cells
remap_bool = ~coh_bool_temp & ~silent_bool;


end

