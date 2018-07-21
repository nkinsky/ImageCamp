function [ map_sesh1_sesh2 ] = get_neuronmap_from_batchmap( batch_map, ...
    sesh1_index, sesh2_index )
% map_sesh1_sesh2 = get_neuronmap_from_batchmap( batch_map, sesh1_index, sesh2_index_ )
%  Takes batch_map and constructs a map between two arbitrary sessions from
%  it


sessions = [];
if isstruct(batch_map) && isfield(batch_map,'map')
    sessions = batch_map.session;
    batch_map = batch_map.map;
end
%% Set up everything
index = [sesh1_index, sesh2_index];

% Get range of neurons to work with
neuron_range = cell(1,2);
map = cell(1,2);
for j = 1:2
    
    map{j} = batch_map(:,1+index(j));
    valid_indices = map{j}(:) ~= 0;
    neuron_range{j} = [min(map{j}(valid_indices)) ...
        max(map{j}(valid_indices))];

end
if ~isempty(sessions)
    load(fullfile(ChangeDirectory_NK(sessions(sesh1_index),0),...
        'FinalOutput.mat'),'NumNeurons');
    nneurons1 = NumNeurons;
else
    nneurons1 = max(neuron_range{1});
end

%% Map session 2 to session 1

% sesh1_neurons = neuron_range{1}(1):neuron_range{1}(2);
% map_sesh1_sesh2 = zeros(neuron_range{1}(2),1);
sesh1_neurons = 1:nneurons1;
map_sesh1_sesh2 = zeros(nneurons1,1);
for j = 1:length(sesh1_neurons)
    find_neuron1 = find(j == map{1}); % Find index for 1st session neuron
    if find_neuron1 ~= 0
        map_sesh1_sesh2(j) = map{2}(find_neuron1);
    end
end

end

