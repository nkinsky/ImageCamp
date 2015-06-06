function [ all_session_map ] = build_multisesh_mapping( Reg_NeuronIDs )
%  all_session_map  = build_multisesh_mapping( Reg_NeuronIDs )
% Builds a map that tracks all cells from day 1 to day N (saved in
% Reg_NeuronIDs file in base session folder)when registering cells across days.

num_sessions = size(Reg_NeuronIDs,2);
num_neurons = size(Reg_NeuronIDs(num_sessions).neuron_id,1);
% Pre-allocate
all_session_map = cell(num_neurons,num_sessions+1);
all_session_map(:,1) = arrayfun(@(a) a,[1:num_neurons]','UniformOutput',0);
for j = 1:num_sessions
    num_neurons_in_sesh = size(Reg_NeuronIDs(j).neuron_id,1);
    all_session_map(1:num_neurons_in_sesh,j+1) = Reg_NeuronIDs(j).neuron_id;
end


end

