function find_mapped_cells(Reg_NeuronIDs)
% find_mapped_cells(Reg_NeuronIDs)
%
%

%% Extract list of neurons. 
    %Number of sessions and cells.  
    num_sessions = length(Reg_NeuronIDs); 
    num_cells = length(Reg_NeuronIDs.neuron_id); 

    %Preallocate. 
    neuron_list = cell(num_sessions, num_cells); 
    
    for this_reg_sesh = 1:length(Reg_NeuronIDs)
        
        
    end
        