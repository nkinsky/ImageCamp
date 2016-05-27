function [ mapped_ROIs, valid_neurons] = map_ROIs( neuron_map, reg_ROIs )
% [ mapped_ROIs, valid_neurons] = map_ROIs( neuron_map, reg_ROIs )
%   Takes a neuron map between two session (base session and reg session)
%   obtained from image_register_simple and maps the neuron ROIs (reg_ROIs) 
%   from the registered session to the same indices as the neuron ROIs in 
%   the base session. Outputs all the neuron ROIs that have a valid mapping in
%   registered_ROIs as well as the indices of all the valid neurons.
%   Non-validly mapped ROIs are left as empty in registered_ROIs
%
%   Use in conjunction with dist_bw_reg_sessions.  Note that this DOES not
%   register the ROIs to match the size of the of base session!
%
%   INPUTS
%   neuron_map: neuron_map.neuron_id from image_register_simple output
%
%   reg_ROIs: NeuronImage output from either ProcOut.mat or T2output in
%   registered session directory
%
%   OUTPUTS
%
%   mapped_ROIs: a cell with the registered neuron ROIs placed in the
%   matching index indicated in neuron map. cells that are not validly
%   mapped in the second session are left empty
%
%   valid_neurons: a list of the base session neurons with a valid map
%   between sessions.
%


% Get validly mapped neurons (e.g. non-empty values)
valid_neurons = find(cellfun(@(a) ~isempty(a) && ~isnan(a), neuron_map));
sesh2_neurons = cell2mat(neuron_map(valid_neurons));

mapped_ROIs = cell(1,length(neuron_map)); % Pre-allocate
for j = 1:length(valid_neurons)
    mapped_ROIs{valid_neurons(j)} = reg_ROIs{sesh2_neurons(j)};
end


end

