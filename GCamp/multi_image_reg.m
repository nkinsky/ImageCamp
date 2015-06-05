function [Reg_NeuronIDs, cell_map] = multi_image_reg(base_file, num_sessions, check_neuron_mapping)
%[ Reg_NeuronIDs, cell_map] = multi_image_reg(base_file, num_sessions, check_neuron_mapping)
%
%   Registers a base file to multiple recording sessions and saves these
%   registrations in a .mat file claled Reg_NeuronIDs.mat in your base file
%   directory. 
%
%   INPUTS:
%       base_file: Full file path of ICmovie_min_proj.tif to which you want
%       to register other sessions.
%
%       num_session: Number of sessions you want to register base_file to. 
%
%       check_neuron_mapping: Logical vector where each element corresponds
%       to whether or not you want to check how well each neuron maps.
%       Default is zero for all sessions. 
%
%   OUTPUTS: 
%       Reg_NeuronIDs: 1xN struct (where N is the number of registered
%       sessions) containing the following fields...
%
%           mouse: string containing the name of the mouse. Usually in the
%           format 'GXX' where X is a digit. 
%
%           base_path: path to your base file. 
%
%           reg_path: path to the file to which you registered to for that
%           N. 
%
%           neuron_id: 1xn cell where n is the number of neurons in the
%           first session, and each value is the neuron number in the 2nd
%           session that maps to the neurons in the 1st session.  An empty
%           cell means that no neuron from the 2nd session maps to that
%           neuron from the 1st session.  A value of NaN means that more
%           than one neuron from the second session is within min_thresh of
%           the 1st session neuron
%
%           same_neuron: n x m logical, where the a value of 1 indicates
%           that more than one neuron from the second session maps to a
%           cell in the first session.  Each row corresponds to a 1st
%           session neuron, each column to a 2nd session neuron.
%           
%           num_bad_cells: struct containing the following fields:
%               nonmapped: Neurons that weren't mapped onto the second
%               session.
%               crappy: Neurons that map onto a neuron that another neuron
%               is mapping to. 
%
% Version Tracking
% 0.8: only tracks neurons that correspond to neurons from the 1st session.
%  Does NOT include capability to map new cells from the 2nd session onto
%  subsequent sessions (yet!).
%
% This is a test comment for nat's image-reg-branch to see if branching is
% working correctly.
    
%% Check for check_neuron_mapping.
    if nargin < 3
        check_neuron_mapping = zeros(1,num_sessions);
    end

%% Get base path.
    base_path = fileparts(base_file);
%% Do the registrations. 
    %Preallocate.
    reg_filename = cell(1,num_sessions);
    reg_path = cell(1,num_sessions);
    reg_date = cell(1,num_sessions); 
    reg_session = cell(1,num_sessions);
    mouse_name  = cell(1,num_sessions);
    
    [ mouse, base_date, base_session ] = get_name_date_session( base_path );
    
    
    %Select all the files first. 
    for this_session = 1:num_sessions
        
        
        [reg_filename{this_session}, reg_path{this_session}] = ...
            uigetfile('*.tif', ['Pick file to register #', num2str(this_session), ': ']);
        
        [ mouse_name{this_session}, reg_date{this_session}, reg_session{this_session} ] = ...
            get_name_date_session(reg_path{this_session});
        
       
        % Check to make sure you are looking at the same mouse for each
        % session
        if ~strcmpi(mouse,mouse_name{this_session})
            error('You are not analyzing the same mouse in the base and registered files!')
        end
    end
    
    %Get full file path to all registered files
    reg_file = fullfile(reg_path, reg_filename); 
        
    %Do the registrations. 
    for this_session = 1:num_sessions
        %Display.
        disp(['Registering ', mouse '_' base_date, '_session' base_session ...
            ' to ', mouse '_' reg_date{this_session}, '_session' ...
            reg_session{this_session} '...']); 

        %Perform image registration. 
        neuron_map = image_register_simple(base_file, ...
            reg_file{this_session}, check_neuron_mapping(this_session));
       
        %Also get the pval for TMaps. 
        load(fullfile(reg_path{this_session},'PlaceMaps.mat'), 'pval'); 
        
        %Build the struct. 
        Reg_NeuronIDs(this_session).mouse = mouse; 
        Reg_NeuronIDs(this_session).base_path = base_path; 
        Reg_NeuronIDs(this_session).reg_path = reg_path{this_session};
        Reg_NeuronIDs(this_session).neuron_id = neuron_map.neuron_id;
        Reg_NeuronIDs(this_session).same_neuron = neuron_map.same_neuron;
        Reg_NeuronIDs(this_session).num_bad_cells = neuron_map.num_bad_cells;
        Reg_NeuronIDs(this_session).pval = pval;
        
        %Save. 
        save (fullfile(base_path,'Reg_NeuronIDs.mat'), 'Reg_NeuronIDs'); 
    end
    
end
