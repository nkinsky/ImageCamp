function [ all_session_map ] = build_multisesh_mapping( Reg_NeuronIDs )
%  all_session_map  = build_multisesh_mapping( Reg_NeuronIDs )
% Builds a map that tracks all cells from day 1 to day N (saved in
% Reg_NeuronIDs file in base session folder)when registering cells across days.

num_neurons = size(Reg_NeuronIDs(1).neuron_id,1);
num_sessions = size(Reg_NeuronIDs,2);
% Pre-allocate
all_session_map = cell(num_neurons,num_sessions+1);
all_session_map(:,1) = arrayfun(@(a) a,[1:num_neurons]','UniformOutput',0);
for j = 1:num_sessions;
    all_session_map(:,j+1) = Reg_NeuronIDs(j).neuron_id;
end


end

