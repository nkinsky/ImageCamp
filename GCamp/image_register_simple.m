function [ neuron_id, same_neuron, num_bad_cells] = image_register_simple( base_file, reg_file, check_neuron_mapping)
%image_register_simple( base_file, reg_file)
%   Registers the image ICmovie_min_proj.tif from one session to another so
%   as to map neurons from one session to the next.  Note that you must set
%   the magic variable 'min_thresh' manually within the function code
%
%   INPUTS
%       base_file: full path to the base_file, ICMovie_min_proj.tif, to
%       which you wish to register a second session
%
%       reg_file: full path to the file, also ICMovie_min_proj.tif, you
%       wish you register to base_file
%
%       check_cell_mapping: 0 (default) = no check plots are generated.
%       1 = go through cell-by-cell and check how well cells are mapped.
%
%   OUTPUTS
%       neuron_id: 1xn cell where n is the number of neurons in the first
%       session, and each value is the neuron number in the 2nd session
%       that maps to the neurons in the 1st session.  An empty cell means
%       that no neuron from the 2nd session maps to that neuron from the 1st
%       session.  A value of NaN means that more than one neuron from the
%       second session is within min_thresh of the 1st session neuron
%
%       same_neuron: n x m logical, where the a value of 1 indicates that
%       more than one neuron from the second session maps to a cell in the
%       first session.  Each row corresponds to a 1st session neuron, each
%       column to a 2nd session neuron.
%
%       num_not_assigned: number of neurons that had no neurons in the
%       second session within min_thresh.

%% Magic variables
    min_thresh = 3; % distance in pixels beyond which we consider a cell a different cell
    manual_reg_enable = 0; % 0 = do not allow manual adjustment of registration

%% Perform Image Registration
    RegistrationInfoX = image_registerX(base_file, reg_file, manual_reg_enable);

%% Get working folders for each session

    sesh(1).folder = base_file(1:max(regexpi(base_file,'[\\,/]'))-1);
    sesh(2).folder = reg_file(1:max(regexpi(reg_file,'[\\,/]'))-1);

%% Get centers-of-mass of all cells after registering 2nd image to 1st image
    for k = 1:2
        load(fullfile(sesh(k).folder, 'ProcOut.mat'),'NeuronImage');
        if k == 2 % Don't get registration info if base session
    %         keyboard
            [tform_struct ] = get_reginfo(sesh(1).folder, sesh(2).folder, RegistrationInfoX );
        end
        disp(['Calculating cell center of masses for session ' num2str(k)])
        for j = 1:size(NeuronImage,2);
            temp = NeuronImage{j};
            if k == 2 % Don't do registration if base session
                neuron_image_use = imwarp(temp,tform_struct.tform,'OutputView',...
                    tform_struct.base_ref,'InterpolationMethod','nearest');
            elseif k == 1
                neuron_image_use = temp;
            end
            [it, jt] = find(neuron_image_use == 1);
            day(k).cms(j).x = mean(jt);
            day(k).cms(j).y = mean(it);
            day(k).NeuronImage_reg{j} = neuron_image_use;
        end
    end

%% Get distance to all other cells
    disp('Calculating Distances between cells')
    for j = 1:size(day(1).cms,2);
        pos_cm(:,1) = [day(1).cms(j).x ; day(1).cms(j).y];
        for m = 1:size(day(2).cms,2)
            pos_cm(:,2) = [day(2).cms(m).x ; day(2).cms(m).y];
            temp = dist(pos_cm);
            cm_dist(j,m) = temp(1,2);

        end
    end

    cm_dist_min = min(cm_dist,[],2);

% exclude cells whose closest neighbor exceeds the distance threshold you
% set
    n = 0;
    for j = 1:length(cm_dist_min)
        if cm_dist_min(j) > min_thresh
            neuron_id{j} = [];
            n = n+1;
        else
            neuron_id{j} = find(cm_dist_min(j) == cm_dist(j,:));
        end

    end

% Check to see if any cells from session 1 map to the same cell in session
% 2 or vice versa
    for j = 1:size(neuron_id,2)-1; 
        for k = j+1:size(neuron_id,2)
            if neuron_id{j} == neuron_id{k} 
                same_neuron(j,k) = 1;
                % exclude 2nd session cells that map to the same cell in the
                % 1st session
                neuron_id{j} = nan;
                neuron_id{k} = nan;
            else
                same_cell(j,k) = 0;
            end
        end
    end

    num_same = sum(same_cell(:));
    num_notassigned = n;

%% Plot out combined sessions
    for k = 1:2
       sesh(k).AllNeuronMask = create_AllICmask(day(k).NeuronImage_reg); 
    end

    figure;
    imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); colorbar
    title('1 = session 1, 2 = session 2, 3 = both sessions')

% keyboard

%% Plot out each cell mapped to another to see how good the registraton is..


    if exist('check_neuron_mapping','var') && check_neuron_mapping == 1
        % Dump all neuron images into a single variable
        for i = 1:2
            cd(sesh(i).folder);
            load('ProcOut.mat','NeuronImage');
            for j = 1:size(NeuronImage,2)
                temp5{i,j} = NeuronImage{j};
            end
        end

        % Check registration with a cell-by-cell plot
        figure(50)
        nn = 1; % Set initial conditions
        tt = 1;
        disp('Use left and right arrows to scroll through cells.  Hit ''esc'' to exit.')
        while tt ~= 27
            if ~isempty(neuron_id{nn}) && ~isnan(neuron_id{nn})
                % Register 2nd neuron's outline to 1st neuron
                neuron2_reg = imwarp(temp5{2,neuron_id{nn}},tform_struct.tform,'OutputView',...
                    tform_struct.base_ref,'InterpolationMethod','nearest');
            else
                % Make 2nd neuron mask all zeros if no cell maps to the 1st
                neuron2_reg = zeros(size(temp5{1,1}));
            end
            imagesc(temp5{1,nn} + 2*neuron2_reg); colorbar; colormap jet; caxis([0 3]);
            title(['1st session neuron ' num2str(nn) '. 2nd session neuron ' num2str(neuron_id{nn})])

            % Use arrow keys to navigate around
            figure(50)
            [~, ~, tt] = ginput(1);
            if tt == 29 && nn ~= length(neuron_id)
                nn = nn + 1;
            elseif tt == 28 && nn ~= 1
                nn = nn - 1;
            end

        end

    end

%% Find how many cells don't map onto the second session. 
    nonmapped = sum(cellfun(@isempty, neuron_id));          %Cells that disappeared/appeared over the two sessions. 
    crappy = sum(cellfun(@sum,cellfun(@isnan,neuron_id,'UniformOutput',false)));    %Multiple of these cells in session 1 map onto session 2. 

    num_bad_cells.nonmapped = nonmapped;
    num_bad_cells.crappy = crappy;                          %Number of cells that didn't make the cut. 


%% Save neuron mapping - currently doesn't include multiple sessions...
neuron_map.base_file = RegistrationInfoX.base_file;
neuron_map.register_file = RegistrationInfoX.register_file;
neuron_map.neuron_id = neuron_id;
save([sesh(1).folder '\neuron_map.mat'], 'neuron_map');

end

