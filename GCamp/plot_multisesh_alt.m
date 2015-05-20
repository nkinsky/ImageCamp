function [r,TMap_plot,TMap_resized,final_masks,p] = plot_multisesh_alt(base_path,check)
%[r,TMap_plot,TMap_resized,final_masks] = plot_multisesh_alt(base_path,check)
%
%   Get neuron masks and TMaps for each neuron that is active for all
%   sessions. For now, this also outputs the pairwise correlations between
%   the base session and all registered sessions for each neuron. 
%
%   INPUTS: 
%       base_path: The folder containing MultiRegisteredCells.mat that you
%       will use as your base session. 
%
%       check: Logical indicating whether or not you want to browse the
%       cells. 
%
%   OUTPUTS: 
%       r: NxS matrix where N is the number of neurons and S is the number
%       of total sessions containing the pairwise correlation for each
%       cell between the base session and the registered session. 
%
%       TMap_plot: NxS cell containing TMaps with NaNs for pixels that the
%       mouse never visited.
%
%       TMap_resized: NxS cell containing resized TMaps for correlations.
%
%       final_masks: NxS cell containing the translated neuron masks. 
%

%% Make sure you have the appropriate files. 
    try 
        load(fullfile(base_path,'MultiRegisteredCells.mat'), 'cell_list', 'Reg_NeuronIDs', 'tform_struct', 'pvals'); 
    catch
        disp('MultiRegisteredCells.mat not found! Trying to load Reg_NeuronIDs.mat...'); 
        
        try 
            load(fullfile(base_path,'Reg_NeuronIDs.mat')); 
        catch
            disp('Reg_NeuronIDs.mat not found! Preparing to run multi_image_reg...'); 
            num_sessions = input('How many sessions would you like to register your base image to? '); 
                
            base_file = fullfile(base_path, 'ICmovie_min_proj.tif'); 
            multi_image_reg(base_file,num_sessions,zeros(num_sessions)); 

            load(fullfile(base_path,'Reg_NeuronIDs.mat')); 
        end
            disp('Running find_multisesh_cells...');     
            find_multisesh_cells(Reg_NeuronIDs,1);
            load(fullfile(base_path,'MultiRegisteredCells.mat'), 'cell_list', 'Reg_NeuronIDs', 'tform_struct', 'pvals');
    end

    %Get pvals. 
    p = pvals; 
    
%% Useful parameters. 
    %Number of total sessions, including the base file. 
    num_sessions = length(Reg_NeuronIDs)+1;
    num_cells = size(cell_list,1); 
    date_format = ['(?<month>\d+)-(?<day>\d+)-(?<year>\d+)'];
    

%% Extract data. 
    %Preallocate.
    session = struct; 
    dates = cell(num_sessions,1); 
    disp('Extracting data...'); 
    
    %Get the base session dates. 
    temp = regexp(Reg_NeuronIDs(1).base_path,date_format,'names');
    dates{1} = [temp.month '-' temp.day '-' temp.year]; 
    
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
        
        %Get the registered session dates. 
        temp = regexp(Reg_NeuronIDs(this_sesh-1).reg_path,date_format,'names');
        dates{this_sesh} = [temp.month '-' temp.day '-' temp.year]; 
        
        %Load place fields and neuron mask. 
        load(fullfile(session(this_sesh).path, 'PlaceMaps.mat'), 'TMap', 'OccMap');
        load(fullfile(session(this_sesh).path, 'ProcOut.mat'), 'NeuronImage'); 
      
        %Compile into struct. 
        session(this_sesh).TMap = TMap; 
        session(this_sesh).OccMap = OccMap; 
        session(this_sesh).NeuronImage = NeuronImage; 
    end
    
%% Get the correlations.
    %Preallocate. 
    r = nan(num_cells,num_sessions-1); 
    this_mask = cell(num_cells,num_sessions); 
    final_masks = cell(num_cells,num_sessions); 
    TMap_temp = cell(num_cells,num_sessions); 
    TMap_plot = cell(num_cells,num_sessions); 
    TMap_resized = cell(num_cells,num_sessions); 
    
    %For each neuron, get sizing information, TMaps, transformation
    %information, and neuron masks.
    disp('Transforming neurons...'); 
    for this_neuron = 1:num_cells  
        %Resizing variable.
        sizing = nan(num_sessions,2);
        
        %Extract.  
        for this_sesh = 1:num_sessions
            %Get the size of a TMap. 
            sizing(this_sesh,[1:2]) = size(session(this_sesh).TMap{1}); 
            
            %Index for NeuronImage, TMap. 
            neuron_ind = cell_list(this_neuron,this_sesh); 
            
            %Get individual neuron masks, tform structs, and TMaps. 
            this_mask{this_neuron,this_sesh} = session(this_sesh).NeuronImage{neuron_ind};
            TMap_temp{this_neuron,this_sesh} = session(this_sesh).TMap{neuron_ind}; 
            
            %Get TMap_nan. 
            [~,TMap_plot{this_neuron,this_sesh}] = make_nan_TMap(session(this_sesh).OccMap, TMap_temp{this_neuron,this_sesh});
            
            %Translate the mask if it's not the base session. 
            if this_sesh ~= 1
                final_masks{this_neuron,this_sesh} = imwarp(this_mask{this_neuron,this_sesh},...
                    tform_struct(this_sesh-1).tform,'OutputView',tform_struct(this_sesh-1).base_ref,...
                    'InterpolationMethod','nearest');
            else
                final_masks{this_neuron,this_sesh} = this_mask{this_neuron,this_sesh}; 
            end
            
        end
        
        %Normalized size. 
        size_use = min(sizing,[],1); 
    end

    %Correlations. 
    disp('Calculating correlations...'); 
    for this_neuron = 1:num_cells
        for this_sesh = 2:num_sessions
            %Some TMaps are full of NaNs. Exclude them from the
            %correlation. 
            if sum(isnan(TMap_temp{this_neuron,this_sesh}(:))) ~= 0 || sum(isnan(TMap_temp{this_neuron,1}(:))) ~= 0
                r(this_neuron,this_sesh-1) = nan; 
            else
                %Otherwise, resize the TMaps and do the correlation. 
                TMap_resized{this_neuron,this_sesh} = resize(TMap_temp{this_neuron,this_sesh},size_use);
                TMap_resized{this_neuron,1} = resize(TMap_temp{this_neuron,1},size_use); 
                
                %Correlate the TMap of the base image to that of the
                %registered image.
                r(this_neuron,this_sesh-1) = corr2(TMap_resized{this_neuron,1},TMap_resized{this_neuron,this_sesh});
            end
        end
    end
    
    keyboard
    
%% Plot the masks and TMaps.  
    keepgoing = 1; 
    this_neuron = 1; 
    
    if exist('check', 'var') && check == 1
    disp('Use left and right arrow keys to scroll through cells.');
    disp('Press up arrow to save to working directory.');
    disp('Press Esc to exit.'); 
        while keepgoing
            fig = figure(600);
            set(fig, 'units', 'normalized', 'position', [0.2, 0.1, 0.6, 0.8]); 
            
            sesh_sub_ind = 1;

            %Plot each session. 
            for this_sesh = 1:num_sessions
                %Plot the mask. 
                subplot(num_sessions,3,sesh_sub_ind)     
                    imagesc(final_masks{this_neuron,this_sesh});
                    title(['Neuron #', num2str(cell_list(this_neuron,this_sesh))], 'fontsize', 12); 
                    set(gca,'ticklength',[0 0],'xtick', [],'ytick',[]); 
                    
                %Plot the TMap. 
                subplot(num_sessions,3,[sesh_sub_ind+1:sesh_sub_ind+2]); 
                    imagesc_nan(rot90(TMap_plot{this_neuron,this_sesh}));
                    
                    %Get session date. 
                    title(['Session ', num2str(this_sesh), ' on ', dates{this_sesh}], 'fontsize', 12);
                    set(gca,'ticklength',[0 0],'xtick', [],'ytick',[]); 

                sesh_sub_ind = sesh_sub_ind+3; 
            end

            %Get key press. 
            [~,~,key] = ginput(1); 

            %Advance or backtrack. 
            if key == 29 && this_neuron < num_cells
                this_neuron = this_neuron + 1; 
            elseif key == 28 && this_neuron ~= 1
                this_neuron = this_neuron - 1; 
            elseif key == 30
                save2pdf(fullfile(base_path, ['Neuron #' num2str(cell_list(this_neuron,1))]), fig); 
                close(fig); 
            elseif key == 27
                keepgoing = 0; 
                close(fig); 
            end
        end
    end          
        
end
