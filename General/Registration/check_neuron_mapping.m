function check_neuron_mapping(base_struct,reg_struct)
%check_neuron_mapping(base_struct,reg_struct)
%
%   For visualization of the fidelity of image registration. Scroll through
%   cells as they appear on the plane using left and right arrow keys.
%   Color axis indicates the contour of the cell that appears on one day
%   versus both days. 
%   
%   Blue = Appeared on day 1 only. 
%   Orange = Appeared on day 2 only. 
%   Red = Appeared on both days. 
%
%   INPUTS: 
%       base_struct - Entry from MasterDirectory.mat that corresponds to
%       the base session. 
%       
%       reg_struct - Entry from MasterDirectory.mat that corresponds to the
%       registered session. Must only be one session! Run
%       check_neuron_mapping.m for each session you want to compare. 
%

%% Prepare the data. 
    %Catch error. 
    if length(reg_struct) > 1 
        error(['This function only takes a reg_struct from one session! '...
        'To view multiple neuron mappings, run this script for each session.']); 
    end
    
    %Get session information. 
    mouse = base_struct.Animal;
    reg_date = reg_struct.Date; 
    base_path = base_struct.Location;
    reg_path = reg_struct.Location; 
    session = reg_struct.Session;
    
    %Get the indices of neurons that map onto each other after
    %registration. 
    file = dir(['neuron_map-',mouse,'-',reg_date,'-session',num2str(session),'*.mat']);
    load(fullfile(base_path,file.name)); 
    NeuronIDs = neuron_map.neuron_id;
    
    %Get the cell masks. 
    NeuronPix = load(fullfile(base_path,'ProcOut.mat'),'NeuronImage'); 
    NeuronPix(2) = load(fullfile(reg_path,'ProcOut.mat'),'NeuronImage'); 
    BaseNeuronPix = NeuronPix(1).NeuronImage; 
    RegNeuronPix = NeuronPix(2).NeuronImage; 
    
    %Get dimension of imaging view. 
    dims = size(BaseNeuronPix{1}); 
    
    %Load registration information. 
    load(fullfile(base_path,['RegistrationInfo-',mouse,'-',reg_date,'-session',num2str(session),'.mat'])); 
    
%% Check registration with a cell-by-cell plot. 
    figure(50)
        n = 1;      %Start at the first base neuron. 
        key = 1;
        disp('Use left and right arrows to scroll through cells.  Hit ''esc'' to exit.')
        while key ~= 27            
            if ~isempty(NeuronIDs{n}) && ~isnan(NeuronIDs{n})
                %Get image. 
                reg_neuron = RegNeuronPix{NeuronIDs{n}}; 
                
                % Register 2nd neuron's outline to 1st neuron
                reg_neuron = imwarp(reg_neuron,RegistrationInfoX.tform,'OutputView',...
                    RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
            else 
                % Make 2nd neuron mask all zeros if no cell maps to the 1st
                reg_neuron = zeros(dims);
            end
            
            %Plot the neurons overlaid. 
            imagesc(BaseNeuronPix{n} + 2*reg_neuron); colorbar; colormap jet; caxis([0 3]);
            title(['1st session neuron ' num2str(n) '. 2nd session neuron ' num2str(NeuronIDs{n})]);
            
            %Navigate cells. 
            figure(50)
            [~, ~, key] = ginput(1);
            if key == 29 && n ~= length(NeuronIDs)
                n = n + 1;
            elseif key == 28 && n ~= 1
                n = n - 1;
            end
        end
        
        close(figure(50)); 

end