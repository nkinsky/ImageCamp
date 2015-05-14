function Reg_NeuronIDs = multi_image_reg(base_file, num_sessions, check_neuron_mapping)
%multi_image_reg(base_file, num_session, check_neuron_mapping)
%
%   Registers multiple sessions.
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
%       Reg_NeuronIDs: struct with the following fields...
%           neuron_id: 1xn cell where n is the number of neurons in the first
%           session, and each value is the neuron number in the 2nd session
%           that maps to the neurons in the 1st session.  An empty cell means
%           that no neuron from the 2nd session maps to that neuron from the 1st
%           session.  A value of NaN means that more than one neuron from the
%           second session is within min_thresh of the 1st session neuron
%
%           same_neuron: n x m logical, where the a value of 1 indicates that
%           more than one neuron from the second session maps to a cell in the
%           first session.  Each row corresponds to a 1st session neuron, each
%           column to a 2nd session neuron.
%           
    
%% Check for check_neuron_mapping.
    if nargin < 3
        check_neuron_mapping = zeros(1,num_sessions);
    end

%% Get base path.
    base_path = base_file(1:max(regexp(base_file,'\','end')));
    
%% Do the registrations. 
    %Preallocate.
    reg_filename = cell(1,num_sessions);
    reg_path = cell(1,num_sessions);
    reg_date = cell(1,num_sessions); 

    %Select all the files first. 
    for this_session = 1:num_sessions
        [reg_filename{this_session}, reg_path{this_session}] = uigetfile('*.tif', ['Pick file to register #', num2str(this_session), ': ']);
        
        %Get date.
        date_format = ['(?<month>\d+)-(?<day>\d+)-(?<year>\d+)'];
        temp = regexp(reg_path{this_session},date_format,'names'); 
        reg_date{this_session} = [temp.month '-' temp.day '-' temp.year]; 
    end
    
    %Get base date. 
    temp = regexp(base_file,date_format,'names');
    base_date = [temp.month '-' temp.day '-' temp.year];
    
    %Get full file path. 
    reg_file = fullfile(reg_path, reg_filename); 
        
    %Do the registrations. 
    for this_session = 1:num_sessions
        %Display.
        disp(['Registering ', base_date, ' to ', reg_date{this_session}, '...']); 

        %Perform image registration. 
        [neuron_id, same_neuron, num_bad_cells] = image_register_simple(base_file, reg_file{this_session}, check_neuron_mapping(this_session));
        
        %Build the struct. 
        Reg_NeuronIDs(this_session).neuron_id = neuron_id;
        Reg_NeuronIDs(this_session).same_neuron = same_neuron;
        Reg_NeuronIDs(this_session).num_bad_cells = num_bad_cells;
        Reg_NeuronIDs(this_session).base_date = base_date; 
        Reg_NeuronIDs(this_session).reg_date = reg_date{this_session};
        
        %Save. 
        save ([base_path 'Reg_NeuronIDs.mat'], 'Reg_NeuronIDs'); 
    end
    
end
        
        