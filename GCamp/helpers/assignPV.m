function [ PVout ] = assignPV(single_sesh_vals, PVmap )
% PVout = assignPV(single_sesh_vals, PVmap )
%   Assigns values from all neurons in single_sesh_vals to appropriate
%   point in population vector according to PVmap. Puts NaN values where
%   there is no valid map. get PVmap from
%   get_neuronmap_from_batchmap(batch_map,1,session_index)

valid_ind = ~isnan(PVmap) & PVmap ~= 0; % Get valid mappings

map_use = PVmap(valid_ind); % Find only valid mappings

PVout = nan(length(PVmap),1);
PVout(valid_ind) = single_sesh_vals(map_use);

end

