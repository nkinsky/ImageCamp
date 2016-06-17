function [ mapped_ROIs, valid_neurons] = map_ROIs( neuron_map, reg_ROIs, perform_mapping )
% registered_ROIs = map_ROIs( neuron_map, reg_ROIs, perform_mapping )
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
%   neuron_map: neuron_map.neuron_id from image_register_simple output, or
%   an array pulled from batch_session_map.
%
%   reg_ROIs: NeuronImage output from either ProcOut.mat or T2output in
%   registered session directory
%
%   perform_mapping: 1 = actually register reg_ROIs to mapped_ROIs, 0 =
%   just calculated valid_neurons.  Default = 1
%
%   OUTPUTS
%
%   mapped_ROIs: a cell with the registered neuron ROIs placed in the
%   matching index indicated in neuron map.
%
%   valid_neurons: a list of the base session neurons with a valid map
%   between sessions.
%

if nargin < 3
    perform_mapping = 1;
end

% Get validly mapped neurons (e.g. non-empty values in neuron_map.neuron_id, zeros in batch_session_map)
if iscell(neuron_map)
    valid_neurons = find(cellfun(@(a) ~isempty(a) && ~isnan(a), neuron_map));
    sesh2_neurons = cell2mat(neuron_map(valid_neurons));
elseif isnumeric(neuron_map)
    valid_neurons = find(neuron_map ~= 0);
    sesh2_neurons = neuron_map(valid_neurons);
end



mapped_ROIs = cell(1,length(neuron_map)); % Pre-allocate
if perform_mapping ==1
    for j = 1:length(valid_neurons)
        mapped_ROIs{valid_neurons(j)} = reg_ROIs{sesh2_neurons(j)};
    end
end


end

