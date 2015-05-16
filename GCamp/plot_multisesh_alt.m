function plot_multisesh_alt(base_path)
%plot_multisesh_alt(base_path)
%
%

%% Make sure you have the appropriate files. 
    try 
        load(fullfile(base_path,'MultiRegisteredCells.mat')); 
    catch
        disp('MultiRegisteredCells.mat not found! Trying to load Reg_NeuronIDs.mat...'); 
        try 
            load(fullfile(base_path,'Reg_NeuronIDs.mat')); 
            disp('Running find_multisesh_cells...'); 
            
            find_multisesh_cells(Reg_NeuronIDs,1);
            load(fullfile(base_path,'MultiRegisteredCells.mat')); 
        catch
            disp('Reg_NeuronIDs.mat not found! Preparing to run multi_image_reg...'); 
            num_sessions = input('How many sessions would you like to register your base image to? '); 
            
            base_file = fullfile(base_path, 'ICmovie_min_proj.tif'); 
            multi_image_reg(base_file,num_sessions,0); 
            
            load(fullfile(base_path,'Reg_NeuronIDs.mat')); 
            disp('Running find_multisesh_cells...'); 
            
            find_multisesh_cells(Reg_NeuronIDs,1);
            load(fullfile(base_path,'MultiRegisteredCells.mat')); 
        end
    end
    
%% Useful parameters. 
    num_reg_sessions = length(Reg_NeuronIDs);

%% Extract data. 
    for this_sesh = 1:num_reg_sessions
        %Get registered image path. 
        session(this_sesh).path = Reg_NeuronIDs(this_sesh).reg_path; 
        
        %Load place fields and neuron mask. 
        load(fullfile(session(this_sesh).path, 'PlaceMaps.mat'), 'TMap', 'OccMap');
        load(fullfile(session(this_sesh).path, 'ProcOut.mat'), 'NeuronImage'); 
      
        session(this_sesh).TMap = TMap; 
        session(this_sesh).NeuronImage = NeuronImage; 
    end
    
%% 