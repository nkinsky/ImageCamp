function [PVreg ] = register_PV( PV, neuron_map, silent_include )
% PVreg = register_PV( PV, neuron_map, neuron_dim, silent_include )
%   Takes a population vector (PV) and registers it to another session via
%   the neuron_map. neuron_dim must be the last dimension in the PV array. 
%   (e.g. #xbins x #ybins X #neurons). silent_include = true (default) sets silent
%   cell event rates to 0. false sets them to nan.

if nargin < 3
    silent_include = 3;
end

%% Reshape PV to #bins x #neurons 
PVsize = size(PV);
PVrs = reshape(PV,prod(PVsize(1:(end-1))),PVsize(end));

%% Register PV according to neuron_map
PVtemp = nan([size(PVrs,1), length(neuron_map)]);
for j = 1:size(PVrs,1)
    PVtemp(j,:) = assign_FR( PVrs(j,:), neuron_map, silent_include);
end
PVreg = reshape(PVtemp,[PVsize(1:(end-1)), length(neuron_map)]); % Return to original shape

end

