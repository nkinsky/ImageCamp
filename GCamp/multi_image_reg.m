function multi_image_reg(base_file, num_sessions, check_neuron_mapping)
%multi_image_reg(base_file, num_session, check_neuron_mapping)
%
%   Registers multiple sessions.
%
%   INPUTS:
%       base_file: Full file path of 

%% 
    %Number of sessions you are comparing the base file to.    
    for this_session = 1:num_sessions
        [reg_filename, reg_path] = uigetfile('*.tif', ['Pick file to register #', num2str(this_session), ': ']); 
        
        image_register_simple(base_file, reg_filename, check_neuron_mapping(this_session)); 
        