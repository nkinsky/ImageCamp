function [ neuron_map_out, becomes_silent, new_cells ] = neuron_map_simple(MDbase, MDreg, varargin)
% [ neuron_map_out, becomes_silent, new_cell ]  = neuron_map_simple(MDbase, MDreg,...)
%   Spits out an array where each entry is the neuron in the registered
%   session that corresponds to the cell index in the base session.
%   becomes_silent lists all cells in the bast session that are inactive in
%   session 2. new_cell lists all cells inactive in session 1 that become
%   active in session 2.  Use these last two entries with caution - I've
%   taken no pains to determine if this is due to overconservative
%   registration, for example.
%
%   INPUT = neuron_m

% Do registration and/or get neuron_map
neuron_map = neuron_registerMD(MDbase, MDreg, varargin{:}); 

% Make map an array if not already done
neuron_map_out = neuronmap_cell2mat(neuron_map); 

% Identify all cells in each class and parse them out
good_cell_bool = ~isnan(neuron_map_out) & neuron_map_out ~= 0;
empty_bool = isempty(neuron_map_out);
nan_bool = isnan(neuron_map_out);

% Get cells in session 1 going silent in session 2
becomes_silent = find(empty_bool);
% Get number of neurons in session 2
num_neurons2 = size(neuron_map.same_neuron,2); 
% Get cells that become active in session 2
new_cells = find(ismember(1:num_neurons2, neuron_map_out(good_cell_bool)))'; 

% Needs de-bugging/checking - plot allICmasks then plot outlines over in
% each category!

end

