function [ map_sesh1_sesh2 ] = get_neuronmap_from_batchmap( batch_map, sesh1_index, sesh2_index )
% map_sesh1_sesh2 = get_neuronmap_from_batchmap( batch_map, sesh1_index, sesh2_index_ )
%  Takes batch_map and constructs a map between two arbitrary sessions from
%  it

%% Set up everything
index{1} = sesh1_index;
index{2} = sesh2_index;

% Get range of neurons to work with
neuron_range = cell(1,2);
for j = 1:2
    
    map{j} = batch_map(:,1+index{j});
    valid_indices = map{j}(:) ~= 0;
    neuron_range{j} = [min(map{j}(valid_indices)) ...
        max(map{j}(valid_indices))];
end

%% Map session 2 to session 1

sesh1_neurons = neuron_range{1}(1):neuron_range{1}(2);
map_sesh1_sesh2 = zeros(neuron_range{1}(2),1);
for j = 1:length(sesh1_neurons)
    find_neuron1 = find(j == map{1}); % Find index for 1st session neuron
    try
    if find_neuron1 ~= 0
        map_sesh1_sesh2(j) = map{2}(find_neuron1);
    end
    catch
        keyboard
    end

end

