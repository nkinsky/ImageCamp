function [ ] = twoenv_DI_topo( DI_use, batch_session_map, sesh_ind )
% twoenv_DI_topo( DI_use, batch_map, sesh1_ind, sesh2_ind )
%   Plot neuron ROIs with color coding for discrimination ratio

% ID valid neurons
valid_neurons = ~isnan(DI_use);
DI_valid = DI_use(valid_neurons);
for j = 1:2
    sesh(1).neurons = batch_session_map.map(valid_neurons, sesh_ind(j)+1);
    sesh_dir = ChangeDirectory_NK(batch_session_map.session(sesh_ind(j)),0);
    load(fullfile(sesh_dir,'FinalOutput.mat'),'NeuronImage');
    sesh(j).ROIs = NeuronImage;
end

keyboard

high_DI = abs(DI_valid) <= 1 & abs(DI_valid) > 0.75;
low_DI = abs(DI_valid) < 0.25;

h = figure;
for j=1:2
    
    plot_neuron_outlines(nan, NeuronImage, h, 'colors', [0 0 1]); % Plot all neurons
end



end

