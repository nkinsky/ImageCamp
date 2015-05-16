function corrs = plot_multisesh_alt(base_path,check)
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
    num_sessions = length(Reg_NeuronIDs)+1;
    num_cells = size(cell_list,1); 

%% Extract data. 
    %Preallocate.
    session = struct; 
    disp('Extracting data...'); 
    
    %Base image stats. 
    session(1).path = Reg_NeuronIDs(1).base_path; 
    
    load(fullfile(session(1).path, 'PlaceMaps.mat'), 'TMap', 'OccMap'); 
    load(fullfile(session(1).path, 'ProcOut.mat'), 'NeuronImage'); 
    
    %Compile into struct. 
    session(1).TMap = TMap; 
    session(1).OccMap = OccMap; 
    session(1).NeuronImage = NeuronImage; 
    
    for this_sesh = 2:num_sessions
        %Get registered image path. 
        session(this_sesh).path = Reg_NeuronIDs(this_sesh-1).reg_path; 
        
        %Load place fields and neuron mask. 
        load(fullfile(session(this_sesh).path, 'PlaceMaps.mat'), 'TMap', 'OccMap');
        load(fullfile(session(this_sesh).path, 'ProcOut.mat'), 'NeuronImage'); 
      
        %Compile into struct. 
        session(this_sesh).TMap = TMap; 
        session(this_sesh).OccMap = OccMap; 
        session(this_sesh).NeuronImage = NeuronImage; 
    end
    
%% Plot.
    %Initialize. 
    figure(600);
    r = nan(num_cells,num_sessions); 
    
    %For each neuron, plot out its cell mask and TMap.
    for this_neuron = 1:num_cells  
        %Resizing variable.
        sizing = nan(num_sessions,1);
        
        %Extract size information. 
        for this_sesh = 1:num_sessions
            sizing(this_sesh) = size(session(this_sesh).TMap{1}); 
        end
        
        %Normalized size. 
        size_use = min(sizing,[],1); 
        
        %Get base TMap. 
        TMap_base = make_nan_TMap(session(1).OccMap, session(1).TMap{cell_list(this_neuron,this_sesh)}); 
        TMap_base = resize(TMap_base,size_use);

        for this_sesh = 2:num_sessions
            this_mask = session(this_sesh).NeuronImage{cell_list(this_neuron,this_sesh)}; 
            [~,TMap_reg] = make_nan_TMap(session(this_sesh).OccMap, session(this_sesh).TMap{cell_list(this_neuron,this_sesh)});
            TMap_reg = resize(TMap_reg,size_use); 
            
            r(this_neuron,this_sesh) = corr2(TMap_base,TMap_reg);
        end
    end
        
    
    if exist('check', 'var') && check == 1
        subplot(num_sessions,3,sesh_sub_ind)
            imagesc(this_mask);
            title('Neuron Mask', 'fontsize', 12); 
        subplot(num_sessions,3,[sesh_sub_ind+1:sesh_sub_ind+2]); 
            imagesc_nan(rot90(TMap_reg));
            title('TMap', 'fontsize', 12);
    end

    %Get next subplot index. 
    sesh_sub_ind = sesh_sub_ind+3;

    
 
    %Scroll with arrow keys. 
    figure(600); 
    [~,~,key] = ginput(1); 
    if key == 29 && this_neuron < num_cells
        this_neuron = this_neuron + 1; 
    elseif key == 28 && this_neuron ~= 1
        this_neuron = this_neuron - 1; 
    elseif key == 27
        keepgoing = 0; 
        close(figure(600)); 
    end
    
            
        
end
                
%% 