function [ corr_matrix ] = corr_bw_TMap( TMap1, TMap2, neuron_map, include_index )
% corr_array = corr_bw_sessions( TMap1, TMap2, neuron_map )
%   Get correlations between TMaps for two sessions with mapping between
%   them in neuron_map (value 8 at index 2 means neuron 8 in 2nd session
%   maps to neuron 2 in 1st session).  Include index is a logical array the
%   length of TMap1 that tells you which neurons to include and which to
%   exclude

if nargin < 4
    include_index = true(size(TMap1));
end

neurons_use = find(include_index);
num_neurons = min(length(TMap1),length(neuron_map));

corr_matrix = nan(length(TMap1),1);
for j = 1:num_neurons
    % Get neurons back to original mapping
    sesh1_neuron = neurons_use(j);
    sesh2_neuron = neuron_map(sesh1_neuron);
    % Get the correlations only if both neurons are validly mapped
    if (sesh1_neuron ~= 0 && ~isnan(sesh1_neuron)) && (sesh2_neuron ~= 0 && ~isnan(sesh2_neuron))
        corr_matrix(j,1) = corr(TMap1{sesh1_neuron}(:),...
            TMap2{sesh2_neuron}(:),'rows','complete','type','Spearman');
    end
end


