function [neuron_map_reverse] = reverse_neuron_map(neuron_map)
% neuron_map_reverse = reverse_neuron_map(neuron_map)
%   If neuron_map maps all neurons in session A -> session B,
%   neuron_map_reverse calculates how session B maps to session A. However,
%   format is a bit different: 1st column = neuron B #, 2nd column = neuron
%   A #.

map_use = neuronmap_cell2mat(neuron_map); % Make map into an array
valid_neuronsa = find(~isnan(map_use) & map_use ~= 0); % Get validly mapped neurons in session A
map_full = [valid_neuronsa map_use(valid_neuronsa)];

[bs, ib] = sort(map_full(:,2)); % Sort according to neurons in B
neuron_map_reverse = [bs, map_full(ib,1)];

end

