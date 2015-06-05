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
%           AllMasks: this only occurs in Reg_NeuronIDs(1) and included the
%           masks for ALL cells that accumulate with each session!
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
%           is_new_cell: indices of all cells in the 2nd session that do
%           not appear in the first.  This does NOT include 2nd session
%           cells that have multiple cells in the 1st session mapping to
%           them.
%
%           multiple_map: 
%           
%           num_bad_cells: struct containing the following fields:
%               nonmapped: Neurons that weren't mapped onto the second
%               session.
%               crappy: Neurons that map onto a neuron that another neuron
%               is mapping to. 
%
% Version Tracking
%  0.8: only tracks neurons that correspond to neurons from the 1st session.
%  Does NOT include capability to map new cells from the 2nd session onto
%  subsequent sessions (yet!).
%
%  For 0.85: Save all NeuronImage masks as you progress (i.e. add in masks
%  of new neurons found in subsequent sessions).  Test by registering two
%  sessions each directly to the base session (e.g. 1-2 and 1-3), then
%  comparing the 1-3 mapping you get when you register through session 2
%  (e.g. 1-2 and 2-3). Currently anytime a cell has multiple cells mapping
%  to it from another session it will not be included in future analyses!
%
%  For 0.9: take care of multiple mapping cells by letting arbitrarily
%  assining the 2nd session cell to have the first of multiple cells from
%  the base session register to it.
    
keyboard
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
    base_masks = load(fullfile(pwd,'ProcOut.mat'),'NeuronImage');
    for this_session = 1:num_sessions
        %Display.
        disp(['Registering ', mouse '_' base_date, '_session' base_session ...
            ' to ', mouse '_' reg_date{this_session}, '_session' ...
            reg_session{this_session} '...']); 

        %Perform image registration. 
        % Add in something here to indicate if this is a simple
        % registration or involves multiple sessions (at which point you
        % want to load AllMasks, not just NeuronImage from the base
        % session!!!)
        neuron_map = image_register_simple(base_file, ...
            reg_file{this_session}, check_neuron_mapping(this_session));
       
        %Also get the pval for TMaps. 
        load(fullfile(reg_path{this_session},'PlaceMaps.mat'), 'pval');
        
        %%% Get all new cells that appear in registered session (i.e. cell
        %%% numbers that DON'T appear in neuron_id and are NOT NaNs
        
        % First, get all neurons in registered session that have multiple
        % neurons from the base session map to it
        [~, temp] = find(neuron_map.same_neuron);
        same_ind = unique(temp); % Vector containing all the neurons in the second session that have multiple neurons in the first session mapping to them...
        
        % Pre-allocate
        is_registered = zeros(size(neuron_map.same_neuron,2),1);
        multiple_maps = zeros(size(neuron_map.same_neuron,2),1);
        
        for j = 1:size(neuron_map.same_neuron,2)
            % Get all neurons in session 2 that map to session 1, not including
            % any NaNs
            is_registered(j) = sum(cellfun(@(a) ~isempty(a) && a == j,test(1).neuron_id)) ~= 0;
            % Create boolean to ID session 2 neurons with multiple neurons
            % in 1 mapping to them
            if sum(is_registered(j) == same_ind) > 0
                multiple_maps = 1;
            end
        end
        
        is_new_cell = find(~is_registered & ~multiple_maps); % New cell numbers in session 2
        
        % Load registered session Neuron masks so that you can get masks
        % for new file
        reg_masks = load(full_file(reg_path,'ProcOut.mat'),'NeuronImage');
        if this_session ~= 1
            AllMasks = Reg_NeuronIDs(1).AllMasks;
        end
            
        % Add in new neurons to neuron_map. There is probably a more
        % elegant way to do this in one line of code, but I don't know it.
        id_temp = neuron_map.neuron_id;
        n = size(AllMasks,2) + 1;
        for kk = 1:length(is_new_cell);
            % Add in new neurons to bottom of id_temp
            id_temp{1,n} = is_new_cell(kk);
            AllMasks{1,n} = reg_masks.NeuronImage{is_new_cell(kk)}; % Update cells masks to include new cell
            n = n + 1;
        end
        neuron_map.neuron_id = id_temp;
        
        %Build the struct. 
        Reg_NeuronIDs(this_session).mouse = mouse; 
        Reg_NeuronIDs(this_session).base_path = base_path; 
        Reg_NeuronIDs(this_session).reg_path = reg_path{this_session};
        Reg_NeuronIDs(1).AllMasks = AllMasks; % This ALWAYS stays only in the 1st index for future registrations
        Reg_NeuronIDs(this_session).neuron_id = neuron_map.neuron_id;
        Reg_NeuronIDs(this_session).is_new_cell = is_new_cell;
        Reg_NeuronIDs(this_session).multiple_maps = multiple_maps;
        Reg_NeuronIDs(this_session).same_neuron = neuron_map.same_neuron;
        Reg_NeuronIDs(this_session).num_bad_cells = neuron_map.num_bad_cells;
        Reg_NeuronIDs(this_session).pval = pval;
        
        %Save. 
        save (fullfile(base_path,'Reg_NeuronIDs.mat'), 'Reg_NeuronIDs'); 
    end
    
    %% Bulid cell_map from Reg_NeuronIDs and save it
   all_session_map = build_multisesh_mapping(Reg_NeuronIDs);
   Reg_NeuronIDs(1).all_session_map = all_session_map;
   
   %Save.
   save (fullfile(base_path,'Reg_NeuronIDs.mat'), 'Reg_NeuronIDs');
   
    
end
