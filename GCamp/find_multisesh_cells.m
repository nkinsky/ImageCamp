function [cell_list,stacked_masks,pvals,tform_struct] = find_multisesh_cells(Reg_NeuronIDs,check_neuron_mapping)
%[cell_list,final,tform_struct] = find_multisesh_cells(Reg_NeuronIDs,check_neuron_mapping)
%
%   Find neurons that are present across all specified registration
%   sessions. Also plots the overlaid cell masks. 
%
%   INPUTS:
%       Reg_NeuronIDs: 1xN struct (where N is the number of registered
%       sessions) from multi_image_reg.m 
%
%       check_neuron_mapping: logical specifying whether or not you want to
%       verify the validity of registrations. 
%
%   OUTPUTS: 
%       cell_list: CxN+1 matrix where C is the number of neurons that were
%       active for all chosen sessions and N is the number of registered
%       sessions. The first column indexes the neurons from ProcOut.mat of
%       the base image. The following columns index neurons from the
%       sessions you chose in order. 
%
%       final_masks: cell array containing the stacked cell masks of all
%       the registered sessions. 
%
%       tform_struct: struct containing the translation information for
%       registered sessions. 
%

%% Useful parameters. 
    num_sessions = length(Reg_NeuronIDs);
    base_path = Reg_NeuronIDs.base_path; 
    
%% Extract same neurons.
    %Extract neuron list. 
    for this_sesh = 1:num_sessions
        neuron_list(:,this_sesh) = Reg_NeuronIDs(this_sesh).neuron_id';
    end
    
    %Indices of the neurons that are at least present across all registered
    %sessions.
    exist_cells = find(all(~cellfun(@isempty, neuron_list),2)); 
    
    %Some register badly. Find the ones that don't. 
    temp = cellfun(@isnan, neuron_list, 'UniformOutput', false); 
    temp2 = cellfun(@any, temp); 
    not_crappy_cells = find(~any(temp2,2)); 
    
    %Indices of neuron_list where good cells are being captured across all
    %recording sessions.
    good_cells = intersect(exist_cells, not_crappy_cells); 
    num_good_cells = length(good_cells); 
    
    %List of cells. Also get the pvals of TMaps.  
    cell_list(:,1) = good_cells; 
    pvals = nan(num_good_cells,num_sessions+1);
    
    %Load base session pvals. 
    load(fullfile(base_path, 'PlaceMaps.mat'), 'pval'); 
    pvals(:,1) = pval(good_cells); 
    
    for this_sesh = 1:num_sessions
        cell_list(:,this_sesh+1) = cat(1,neuron_list{good_cells,this_sesh}); 
    end
    
    for this_sesh = 1:num_sessions
        ind = cell_list(:,this_sesh+1); 
        pvals(:,this_sesh+1) = Reg_NeuronIDs(this_sesh).pval(ind); 
    end
    
%% Sanity check with a cell-by-cell plot. 
    %Load the base file NeuronImage. 
    load(fullfile(base_path, 'ProcOut.mat'), 'NeuronImage'); 
    
    %Dump neuron masks. 
    mask = cell(1,num_sessions+1); 
    mask{1} = NeuronImage; 
        
    %Get transformations. 
    for this_sesh = 1:num_sessions
        %Get path information. 
        this_reg_path = Reg_NeuronIDs(this_sesh).reg_path; 
        date_format = ['(?<month>\d+)_(?<day>\d+)_(?<year>\d+)'];
        temp = regexp(this_reg_path,date_format,'names'); 
        this_date = [temp.month '_' temp.day '_' temp.year];
        
        %Load neuron masks. 
        load(fullfile(this_reg_path, 'ProcOut.mat'), 'NeuronImage'); 
        mask{this_sesh+1} = NeuronImage; 
        
        %Load the registration info. 
        load(fullfile(base_path, ['RegistrationInfo ', this_date, '.mat'])); 
        
        %Get transformation. 
        tform_struct(this_sesh) = RegistrationInfoX; 
    end
    
    %Preallocate. 
    penultimate = cell(num_good_cells,num_sessions); 
    
    %Get the cell masks. 
    parfor this_sesh = 1:num_sessions
        disp(['Registering cells from session ', num2str(this_sesh), '...']); 
        for this_neuron = 1:num_good_cells
            %Get indices. 
            this_ind = neuron_list{good_cells(this_neuron),this_sesh}; 

            %Transform. 
            penultimate{this_neuron,this_sesh} = imwarp(mask{this_sesh+1}{this_ind},...
                tform_struct(this_sesh).tform,'OutputView',tform_struct(this_sesh).base_ref,...
                'InterpolationMethod','nearest');
        end
    end
    
    %Preallocate. 
    stacked_masks = cell(1,num_good_cells); 

    %Compress the masks. Essentially stacking the masks. 
    for this_neuron = 1:num_good_cells
        comp = cat(3,penultimate{this_neuron,:}); 
        stacked_masks{this_neuron} = sum(comp,3); 
    end
    
    if exist('check_neuron_mapping','var') && check_neuron_mapping == 1
        disp('Use left and right arrow keys to scroll through cells. Press Esc to exit'); 
        
        %Plot the masks. 
        this_neuron = 1; 
        keepgoing = 1;

        %Scroll through cells. 
        while keepgoing
            figure(50); 
            %Plot the stacked cell masks. 
            imagesc(stacked_masks{this_neuron}); 
                colorbar;
                caxis([0 num_sessions]); 
                title(['Neuron #', num2str(good_cells(this_neuron)), ' from session 1'], 'fontsize', 12); 

            figure(50);
            [~,~,key] = ginput(1); 

            if key == 29 && this_neuron < num_good_cells
                this_neuron = this_neuron + 1; 
            elseif key == 28 && this_neuron ~= 1
                this_neuron = this_neuron - 1; 
            elseif key == 27
                keepgoing = 0; 
                close(figure(50)); 
            end
        end
    end
    
    %Save. 
    save(fullfile(base_path, 'MultiRegisteredCells.mat'), 'cell_list', 'stacked_masks', 'Reg_NeuronIDs', 'tform_struct', 'pvals'); 
end
