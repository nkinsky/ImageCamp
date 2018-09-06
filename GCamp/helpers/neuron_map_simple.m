function [ neuron_map_out, becomes_silent, new_cells, quickr_bool ] = ...
    neuron_map_simple(MDbase, MDreg, varargin)
% [ neuron_map_out, becomes_silent, new_cell ]  = neuron_map_simple(MDbase, MDreg,...)
%   Spits out an array where each entry is the neuron in the registered
%   session that corresponds to the cell index in the base session.
%   becomes_silent lists all cells in the bast session that are inactive in
%   session 2. new_cell lists all cells inactive in session 1 that become
%   active in session 2.  Use these last two entries with caution - I've
%   taken no pains to determine if this is due to overconservative
%   registration, for example.
%

ip = inputParser;
ip.addRequired('MDbase',@isstruct);
ip.addRequired('MDreg',@isstruct);
% specify to use batch map instead of pairwise reg
ip.addParameter('batch_map',[], @(a) isempty(a) || isstruct(a)); 
% Allows calculating the neuron map from base to reg quickly via
% reverse_neuron_map if registration has already been calculated in the
% other direction). Only applies if batch_map is empty and does NOT work if
% you name_append is not empty
ip.addParameter('quick_reverse', true, @islogical); 
% true = plot registered ROIs (will do automatically if no registration 
% has been performed)
ip.addParameter('reg_plot', false); 
ip.KeepUnmatched = true; % pass on any varargins to neuron_register if needs be.
ip.parse(MDbase,MDreg,varargin{:});
batch_map = ip.Results.batch_map;
quick_reverse = ip.Results.quick_reverse;
reg_plot = ip.Results.reg_plot;

% Do registration and/or get neuron_map
quickr_bool = false; % Default is to not use quick reverse of map unless 
% specified and logic to do so below works out
if isempty(batch_map)
    % check if registration is already done in each direction
    [base_reg_exist, reg_base_exist] = check_reg_exist(MDbase, MDreg);
    
    % If quick reverse allowed and base->reg doesn't exist but other
    % direction does, get other direction map and quickly reverse it.
    % Better to put this in neuron_register!!!
    if quick_reverse && reg_base_exist
        neuron_map_rev = neuron_registerMD(MDreg, MDbase, varargin{:});
        nneuronsb = size(neuron_map_rev.same_neuron,2); % Get # neurons in session B
        neuron_map_partial = reverse_neuron_map(neuron_map_rev);
        neuron_map = zeros(nneuronsb,1);
        neuron_map(neuron_map_partial(:,1)) = neuron_map_partial(:,2);
        quickr_bool = true;
    else
        neuron_map = neuron_registerMD(MDbase, MDreg, varargin{:});
        
    end
else
    batch_map = fix_batch_session_map(batch_map);
    sesh_index(1) = get_session_index(MDbase, batch_map.session);
    sesh_index(2) = get_session_index(MDreg, batch_map.session);
    neuron_map = get_neuronmap_from_batchmap(batch_map, sesh_index(1),...
        sesh_index(2));
end

% Make map an array if not already done
neuron_map_out = neuronmap_cell2mat(neuron_map); 

% Identify all cells in each class and parse them out
good_cell_bool = ~isnan(neuron_map_out) & neuron_map_out ~= 0;
empty_bool = neuron_map_out == 0;
nan_bool = isnan(neuron_map_out);

% Get cells in session 1 going silent in session 2
becomes_silent = find(empty_bool);
% Get number of neurons in session 2
load(fullfile(ChangeDirectory_NK(MDreg,0),'FinalOutput.mat'),'NumNeurons');
num_neurons2 = NumNeurons;
% num_neurons2 = size(neuron_map.same_neuron,2); % old broken code
% Get cells that become active in session 2
new_cells = find(~ismember(1:num_neurons2, neuron_map_out(good_cell_bool)))'; 

% Needs de-bugging/checking - plot allICmasks then plot outlines over in
% each category!

% plot registration if specified and if not already done in
% neuron_registerMD above
if reg_plot && base_reg_exist
    reginfo = image_registerX(MDbase.Animal, MDbase.Date, MDbase.Session, ...
        MDreg.Date, MDreg.Session, 'suppress_output',true, varargin{:});
    sesh = complete_MD(MDbase);
    sesh(2) = complete_MD(MDreg);
    for j = 1:2
        load(fullfile(sesh(j).Location,'FinalOutput.mat'),'NeuronImage');
        sesh(j).ROIs = NeuronImage;
    end
    
    ha = plot_reg_neurons(neuron_map_out, reginfo, sesh(1).ROIs, sesh(2).ROIs, ...
        true);
end

end

%% sub-function to check if neuron_map file exists for base_to_reg and vice_versa
function [base_reg_exist, reg_base_exist] = check_reg_exist(MDbase, MDreg)

base_reg_file = fullfile(ChangeDirectory_NK(MDbase,0),['neuron_map-' ...
    MDbase.Animal '-' MDreg.Date '-session' num2str(MDreg.Session) '.mat']);
base_reg_exist = exist(base_reg_file, 'file');

reg_base_file = fullfile(ChangeDirectory_NK(MDreg,0),['neuron_map-' ...
    MDreg.Animal '-' MDbase.Date '-session' num2str(MDbase.Session) '.mat']);
reg_base_exist = exist(reg_base_file, 'file');

end

