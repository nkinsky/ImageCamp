function [ neuron_map_array ] = neuronmap_cell2mat( neuron_map_cell )
% neuron_map_array = neuronmap_cell2mat( neuron_map_cell )
%   Converts cell array neuron map (neuron_map.neuron_id made in
%   neuron_register function) to an array with zeros where there is no
%   neuron within the distance threshold, nans where there is an ambiguous
%   mapping, and/or the cell number from the second session in each row.

% Identify all cells in each class and parse them out
if iscell(neuron_map_cell) || isstruct(neuron_map_cell) % code to catch entering in just the neuron_map structure too.
    if isstruct(neuron_map_cell)
        temp = neuron_map_cell.neuron_id;
        clear neuron_map_cell
        neuron_map_cell = temp;
    end
    neuron_map_array = zeros(length(neuron_map_cell),1);
    good_bool = cellfun(@(a) ~isempty(a) && ~isnan(a),neuron_map_cell);
    empty_bool = cellfun(@isempty,neuron_map_cell);
    nan_bool = cellfun(@(a) ~isempty(a) && isnan(a),neuron_map_cell);
    
    % Make legit map in array form - 0s = silent cells, nan = ambiguous
    % registration (2 cells very close to cell in question)
    neuron_map_array(good_bool) = cell2mat(neuron_map_cell(good_bool));
    neuron_map_array(empty_bool) = 0;
    neuron_map_array(nan_bool) = nan;
    
elseif isnumeric(neuron_map_cell) % Don't do anything if array is the input
    neuron_map_array = neuron_map_cell;
end




end

