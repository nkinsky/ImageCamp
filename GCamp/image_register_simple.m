function [ neuron_map] = image_register_simple( mouse_name, base_date, base_session, reg_date, reg_session, check_neuron_mapping, varargin)
%image_register_simple( mouse_name, base_date, base_session, reg_date, reg_session, check_neuron_mapping, ...)
%   Registers the image ICmovie_min_proj.tif from one session to another so
%   as to map neurons from one session to the next.  Note that you must set
%   the magic variable 'min_thresh' manually within the function code
%
%   INPUTS
%       mouse_name:   string with mouse name
%
%       base_date: date of base session
%
%       base_session: session number for base session
%
%       reg_date: date of session to register to base
%
%       reg_session: session number for session to register to base
%
%       check_cell_mapping: 0 (default) = no check plots are generated.
%       1 = go through cell-by-cell and check how well cells are mapped.
%
%       'multi_reg': (optional) specify as ...,'multi_reg', 1. 0 (default) - 
%       use base_file NeuronImage variable from ProcOut.mat for registration 
%       of neurons.  1 - used only in conjunction with multi_image_reg -
%       uses AllMasks from Reg_NeuronID for future registrations
%
%       'check_multiple_mapping': (optional) scroll through multiple
%       mapping neurons - 2nd session neuron is in a red outline, 1st
%       session neurons will be in yellow
%
%   OUTPUTS 
%       neuron_map contains the following fields and is also saved in the
%       base directory:
%
%       .neuron_id: 1xn cell where n is the number of neurons in the first
%       session, and each value is the neuron number in the 2nd session
%       that maps to the neurons in the 1st session.  An empty cell means
%       that no neuron from the 2nd session maps to that neuron from the 1st
%       session.  A value of NaN means that more than one neuron from the
%       second session is within min_thresh of the 1st session neuron
%
%       .same_neuron: n x m logical, where the a value of 1 indicates that
%       more than one neuron from the second session maps to a cell in the
%       first session.  Each row corresponds to a 1st session neuron, each
%       column to a 2nd session neuron.
%
%       .num_not_assigned: number of neurons that had no neurons in the
%       second session within min_thresh.
%
% Version Tracking
% 0.8: confident that false positives and false negative rates are low.
% Possible false negatives occur due to two factors: 1) drastically
% different shapes of neurons from day 1 to day 2 (unfixable), and 2) two
% different neurons in session 1 mapping to the same neuron in session
%
% 0.85 (working): need to add in some type of flag to load AllMasks when
% doing multiple session registrations

%% Magic variables
min_thresh = 3; % distance in pixels beyond which we consider a cell a different cell
manual_reg_enable = 0; % 0 = do not allow manual adjustment of registration

%% Determine if multiple sessions are happening, or if debug_escape is specified

multi_reg = 0;
debug_escape = 0;
for j = 1:length(varargin)
   if strcmpi('multi_reg',varargin{j})
       multi_reg = varargin{j+1};
   end
   if strcmpi('debug_escape',varargin{j})
      debug_escape = varargin{j+1};
   end
   if strcmpi('check_multiple_mapping',varargin{j})
       check_multiple_mapping = varargin{j+1};
   end
end


%% Perform Image Registration
RegistrationInfoX = image_registerX(mouse_name, base_date, base_session, ...
    reg_date, reg_session, manual_reg_enable);

%% Get working folders for each session

currdir = cd;
sesh(1).folder = ChangeDirectory(mouse_name, base_date, base_session);
sesh(2).folder = ChangeDirectory(mouse_name, reg_date, reg_session);
cd(currdir)

% Define unique filename for file you are registering to that you will
% eventually save in the base path
if multi_reg == 0
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
        num2str(reg_session) '.mat']);
elseif multi_reg == 1
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
    num2str(reg_session) '_multi.mat']);
end

%% Check to see if this has already been run - if so,

try
    load(map_unique_filename)
    disp('Registration Already ran! (neuron_map file detected in base directory). Delete file to re-run');
catch
%% Get centers-of-mass of all cells after registering 2nd image to 1st image
for k = 1:2
    % Load Neuron Masks and average activation
    load(fullfile(sesh(k).folder, 'ProcOut.mat'),'NeuronImage');
    load(fullfile(sesh(k).folder, 'MeanBlobs.mat'),'BinBlobs');
    if k == 2 % Don't get registration info if base session
        
        [tform_struct ] = get_reginfo(sesh(1).folder, sesh(2).folder, RegistrationInfoX );
    end
    
    % overwrite NeuronImage to include ALLmasks for base folder if doing multiple
    % sessions
    if k == 1 && multi_reg == 1
        load(fullfile(sesh(1).folder,'Reg_NeuronIDs.mat'));
        NeuronImage = Reg_NeuronIDs(1).AllMasks;
        BinBlobs = Reg_NeuronIDs(1).AllMasksMean;
    end
    
    disp(['Calculating cell center of masses for session ' num2str(k)])
    for j = 1:size(NeuronImage,2);
        temp = NeuronImage{j};
        temp2 = BinBlobs{j};
        if k == 2 % do registration if in 2nd session
            neuron_image_use = imwarp(temp,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
            neuron_mean_use = imwarp(temp2,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
        elseif k == 1 % Don't do registration if base session
            neuron_image_use = temp;
            neuron_mean_use = temp2;
        end
%         [it, jt] = find(neuron_image_use == 1);
        temp3 = regionprops(neuron_image_use,'Centroid');
%         day(k).cms(j).x = mean(jt);
%         day(k).cms(j).y = mean(it);  
        % Dump centers-of-mass of neurons into day structure
        if size(temp3,1) == 1
            day(k).cms(j).x = temp3.Centroid(1);
            day(k).cms(j).y = temp3.Centroid(2);
        else % If multiple blobs are present for a neuron, only use the largest one
            temp4 = regionprops(neuron_image_use,'ConvexArea');
            sizes = arrayfun(@(a) a.ConvexArea,temp4);
            blob_use = max(sizes) == sizes;
            day(k).cms(j).x = temp3(blob_use).Centroid(1);
            day(k).cms(j).x = temp3(blob_use).Centroid(2);
        end
        
        day(k).NeuronImage_reg{j} = neuron_image_use;
        day(k).NeuronMean_reg{j} = neuron_mean_use;
    end
end

% keyboard
%% Get distance to all other neurons
disp('Calculating Distances between cells')
cm_dist = 100*ones(size(day(1).cms,2),size(day(2).cms,2)); % Set all values to arbitrarily large distances to start.
for j = 1:size(day(1).cms,2); % Cycle through all base session neurons
    if ~isempty(day(1).cms(j).x)
        pos_cm(:,1) = [day(1).cms(j).x ; day(1).cms(j).y];
        for m = 1:size(day(2).cms,2) % get distances to all registration session neurons
            if ~isempty(day(2).cms(m).x)
                try % Error catching try/catch statement
                    pos_cm(:,2) = [day(2).cms(m).x ; day(2).cms(m).y];
                catch
                    disp(['Error at j = ' num2str(j) ' & m = ' num2str(m)])
                    keyboard
                end
                temp = dist(pos_cm);
                cm_dist(j,m) = temp(1,2);
            elseif isempty(day(2).cms(m).x)
                % Edge case where one of the neurons has disappeared during
                % registration (probably due to being near the edge of the 
                % screen - shouldn't happen if you are using the same base
                % session for both Tenaspis and multi_image_reg, but can if you
                % are doing independent registrations
                cm_dist(j,m) = 100; % Set distance to very far for these neurons so they never get mapped to another neuron
            end
        end
    elseif isempty(day(1).cms(j).x)
        cm_dist(j,:) = 100*ones(size(cm_dist(j,:)));
    end
end

cm_dist_min = min(cm_dist,[],2); % Get minimum distance to nearest neighbor for all cells

% exclude cells whose closest neighbor exceeds the distance threshold you
% set
n = 0;
for j = 1:length(cm_dist_min)
    if cm_dist_min(j) > min_thresh
        neuron_id{j,1} = [];
        n = n+1;
    else
        neuron_id{j,1} = find(cm_dist_min(j) == cm_dist(j,:));
    end
    
end

neuron_id_temp = neuron_id; % Save neuron_id for later debugging purposes
%% Look for false positives due to multiple cells in the 1st session mapping
% to a single cell in the 2nd session
disp('Sorting out multiple base session cells mapping to the same cell in the second session')
% Initialize same_neuron variable
same_neuron = zeros(size(day(1).NeuronImage_reg,2),size(day(2).NeuronImage_reg,2));
neuron_id_nan = neuron_id;
for j = 1:size(day(2).NeuronImage_reg,2);
    % Find cases where more than one neuron in the 1st session maps to
    % the same neuron in the second session
    same_ind = find(cellfun(@(a) ~isempty(a) && a == j,neuron_id));
    if length(same_ind) > 1
%         keyboard
        overlap_ratio = zeros(1,length(same_ind)); % Pre-allocate
        for k = 1:length(same_ind)
            % Note neurons in the 1st session that map to the same cell
            % in the 2nd session and set their values to NaN in the
            % neuron_id variable
            same_neuron(same_ind(k),j) = 1;
            neuron_id_nan{same_ind(k)} = nan;
            overlap_pixels = sum(day(1).NeuronMean_reg{same_ind(k)}(:) & ...
                day(2).NeuronMean_reg{j}(:));
            total_pixels = sum(day(1).NeuronMean_reg{same_ind(k)}(:) | ...
                day(2).NeuronMean_reg{j}(:));
%             min_neuron_size = min([sum(day(1).NeuronMean_reg{same_ind(k)}(:)) ...
%                 sum(day(2).NeuronMean_reg{j}(:))]);
%             overlap_ratio(k) = overlap_pixels/min_neuron_size; 
            overlap_ratio(k) = overlap_pixels/total_pixels;
        end
        % Get neuron whose mask has the most overlap with the cell in the registration session
        most_overlap = max(overlap_ratio) == overlap_ratio; 
        least_overlap = find(~most_overlap);
        if sum(most_overlap) == 1 % Only choose the cell with the most overlap if it is truly the most
            neuron_id{same_ind(most_overlap)} = j;   
        elseif sum(most_overlap) > 1 % send all to nans if more than one neuron is completely inside the other
            for m = 1: length(most_overlap)
                neuron_id{same_ind(most_overlap(m))} = nan;
            end
        end
        for m = 1:length(least_overlap)
            neuron_id{same_ind(least_overlap(m))} = nan;
        end
    end
    
end

num_same = sum(same_neuron(:));
num_notassigned = n;

%% Plot out combined sessions
for k = 1:2
    sesh(k).AllNeuronMask = create_AllICmask(day(k).NeuronImage_reg);
end

figure;
imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); colorbar
title('1 = session 1, 2 = session 2, 3 = both sessions')

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
                neuron2_reg = imwarp(temp5{2,neuron_id{nn}},RegistrationInfoX.tform,'OutputView',...
                    RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
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
    
    %% Check multiple mapping neurons
    
    if exist('check_multiple_mapping','var') && check_multiple_mapping == 1
        same_neuron_list = find(sum(same_neuron,1));
        figure(200)
        for j = 1:length(same_neuron_list)
            % Get boundaries of 2nd session neuron
            bounds_image = bwboundaries(day(2).NeuronImage_reg{same_neuron_list(j)});
            bounds_mean = bwboundaries(day(2).NeuronMean_reg{same_neuron_list(j)});
            same_neuron1 = find(same_neuron(:,same_neuron_list(j)));
            temp_image = zeros(size(day(1).NeuronImage_reg{1}));
            temp_mean = zeros(size(day(1).NeuronImage_reg{1}));
            for k = 1:length(same_neuron1)
                temp_image = temp_image + day(1).NeuronImage_reg{same_neuron1(k)};
                temp_mean = temp_mean + day(1).NeuronMean_reg{same_neuron1(k)};
            end
            
            bounds_plot_x = [min(bounds_mean{1}(:,2))-5 max(bounds_mean{1}(:,2))+5];
            bounds_plot_y = [min(bounds_mean{1}(:,1))-5 max(bounds_mean{1}(:,1))+5];
            
            subplot(2,2,1)
            imagesc(day(1).NeuronImage_reg{same_neuron1(1)}); colorbar
            hold on;
            plot(bounds_image{1}(:,2),bounds_image{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronImage: 1st session neuron = ' num2str(same_neuron1(1)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            subplot(2,2,2)
            imagesc(day(1).NeuronImage_reg{same_neuron1(2)}); colorbar
            hold on;
            plot(bounds_image{1}(:,2),bounds_image{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronImage: 1st session neuron = ' num2str(same_neuron1(2)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            subplot(2,2,3)
            imagesc(day(1).NeuronMean_reg{same_neuron1(1)}); colorbar
            hold on;
            plot(bounds_mean{1}(:,2),bounds_mean{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronMean: 1st session neuron = ' num2str(same_neuron1(1)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            subplot(2,2,4)
            imagesc(day(1).NeuronMean_reg{same_neuron1(2)}); colorbar
            hold on;
            plot(bounds_mean{1}(:,2),bounds_mean{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronMean: 1st session neuron = ' num2str(same_neuron1(2)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            waitforbuttonpress
        end

    end
    
    %% Escape to keyboard for debugging if specified
    if debug_escape == 1
        keyboard
    end

%% Find how many cells don't map onto the second session. 
    nonmapped = sum(cellfun(@isempty, neuron_id));          %Cells that disappeared/appeared over the two sessions. 
    crappy = sum(cellfun(@sum,cellfun(@isnan,neuron_id,'UniformOutput',false)));    %Multiple of these cells in session 1 map onto session 2. 

    num_bad_cells.nonmapped = nonmapped;
    num_bad_cells.crappy = crappy;                          %Number of cells that didn't make the cut. 


%% Save neuron mapping - currently doesn't include multiple sessions...
neuron_map.mouse = mouse_name;
neuron_map.base_date = base_date;
neuron_map.base_session = base_session;
neuron_map.base_file = RegistrationInfoX.base_file;
neuron_map.reg_date = reg_date;
neuron_map.reg_session = reg_session;
neuron_map.register_file = RegistrationInfoX.register_file;
neuron_map.neuron_id = neuron_id;
neuron_map.same_neuron = same_neuron;
neuron_map.num_bad_cells = num_bad_cells;

if multi_reg == 1
    neuron_map.base_date = 'Multiple - all prior sessions in Reg_NeuronIDs in base directory';
    neuron_map.base_session = 'Multiple - all prior sessions in Reg_NeuronIDs in base directory';
end

save(map_unique_filename, 'neuron_map');

end % End try/catch statement



end

%% Old code we may be able to harvest to get cell overlaps and include for
% registering cells in some fashion

% new_cell_add = 3;
% num_reg_ICs = size(reg_data.GoodICf,2);
%
% figure(FigNum)
%
% if use_manual_adjust == 1
%     tform = tform_manual;
% end
%
% reg_GoodICf = cellfun(@(a) imwarp(a,tform,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest'), ...
%     reg_data.GoodICf,'UniformOutput',0); % Register each IC to the base image
%
% % Create cell map cell variable if one doesn't already exist
% if base_map == 1
%     cell_map = cell(size(base_IC,2),2);
%     cell_overlap = cell(size(base_IC,2),2);
%     COM_weighted = cell(size(base_IC,2),2);
%     for j = 1:size(cell_map,1)
%         cell_map{j,1} = j;
%         cell_overlap{j,1} = 1;
%     end
%     reg_col = 2;
% elseif base_map == 0
%     cell_map = base_data.cell_map;
%     cell_overlap = base_data.cell_overlap;
%     COM_weighted = base_data.COM_weighted;
%     cell_map_header = base_data.cell_map_header;
%     reg_col = size(cell_map,2) + 1;
% end
%
%
% % Step through each cell in registered image and match to base image cells.
% % Note that if this is the base mapping, you are registering the GoodICfs
% % to all the ICs from the base session.
% overlap = cell(1,size(reg_data.GoodICf,2));
% overlap_ratio = cell(1,size(reg_data.GoodICf,2));
%
%  % Get registered COMs
%
%  for j = 1:num_reg_ICs
%      [reg_COM_weighted{j}(2) reg_COM_weighted{j}(1)] = transformPointsForward(tform,...
%          reg_data.COM_weighted{j}(2),reg_data.COM_weighted{j}(1));
%  end
%
% % NK Note - need to automate this for base mapping now? All ICs are good,
% % apparently...
% base_map_error_cells = [];
% if base_map == 1
%     runthrough = input('Do you want to step through and check each cell for the base mapping (y/n)?','s');
% else
%     runthrough = 'y';
% end
%
%
% CLIM_upper = max(max(base_data.AllIC,[],1),[],2) + new_cell_add;
% h1 = figure(FigNum);
% if strcmpi(runthrough,'y')
%     for j = 1:num_reg_ICs
%         num_cells_total = size(cell_map,1); % Get total number of cells
%
%         % Get union of each IC from the base image with the given registered IC
%         temp = cellfun(@(a) a & reg_GoodICf{j},base_IC, ...
%             'UniformOutput',0);
%         overlap{j} = find(cellfun(@(a) sum(sum(a)) > 0,temp));
%
%         if ~isempty(overlap{j})
% %             keyboard
%             for k = 1:size(overlap{j},2)
%                 overlap_ratio{j}(k) = sum(sum(temp{overlap{j}(k)}))/...
%                     sum(sum(base_IC{overlap{j}(k)})); % Get ratio of mask that overlaps with each cell in base image
%                 if overlap_ratio{j}(k) == 1 % Make overlap ratio > 100% if base IC is completely enveloped by reg IC
%                    overlap_ratio{j}(k) = sum(sum(reg_GoodICf{j}))...
%                        /sum(sum(base_IC{overlap{j}(k)}));
%                 end
%
%             end
%
%             % Sort from most to least overlap
%             if size(overlap{j},2) > 1
%                 ii = [];
%                 [overlap_ratio{j} ii] = sort(overlap_ratio{j},'descend');
%                 overlap{j} = overlap{j}(ii);
%             end
%
%             % Auto-assign cells that meet criteria
%             override = [];
%             if overlap_ratio{j}(1) >= overlap_auto_same && ...
%                     sum(overlap_ratio{j} >= overlap_auto_same) == 1 % Auto-assign as same cell (unless more than 1 cell meets the criteria)
%                 temp2 = overlap{j}(1);
%                 disp([num2str(j) '/' num2str(num_reg_ICs) ') Automatically assigned to base image cell #' num2str(overlap{j}(1)) ]);
% %                 override = input('Hit enter to proceed.  Hit "o" to override: ','s');
%
%             elseif overlap_ratio{j} < overlap_auto_new % Auto-assign as a new cell
%                 temp2 = [];
%                 disp([num2str(j) '/' num2str(num_reg_ICs) ')Automatically assigned as a new cell']);
% %                 override = input('Hit enter to proceed.  Hit "o" to override: ','s');
%             else  % Display overlap ratios on the screen if not auto-sorted
%
%                 % Calculate limits for plotting
%                 zoom_pix = 25; % +/- pixels to zoom in
%                 comb_level = max(max(base_data.AllIC + (base_data.AllIC + new_cell_add*reg_GoodICf{j}),[],1),[],2);
%                 if comb_level == new_cell_add % catch if entirely new cell
%                     comb_level = new_cell_add + 1;
%                 end
%                 xlim_zoom = [reg_COM_weighted{j}(2) - zoom_pix reg_COM_weighted{j}(2) + zoom_pix];
%                 ylim_zoom = [reg_COM_weighted{j}(1) - zoom_pix reg_COM_weighted{j}(1) + zoom_pix];
%
%                 figure(FigNum)
%                 subplot(3,3,[1 2 4 5]) % Overall View
%                 imagesc(base_data.AllIC + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
%                 colorbar('YTick',[0 1 new_cell_add comb_level],'YTickLabel',...
%                     {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
%                 subplot(3,3,9) % Zoom-in View
%                 imagesc(base_data.AllIC + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
%                 xlim(xlim_zoom); ylim(ylim_zoom);
%
%
%                 for k = 1:size(overlap{j},2)
%                     disp([num2str(j) '/' num2str(num_reg_ICs) ') This cell overlaps with base image cell #' ...
%                         num2str(overlap{j}(k)) ' by ' num2str(100*overlap_ratio{j}(k),'%10.f') '%.'])
%                 end
%
%
%
%
%                 figure(FigNum); % For some reason figure 3 gets hidden occassionally when I get to this point, manually overriding. Doesn't work!
%
%                 % For cells with multiple overlap, plot out one cell at a time
%                 % only!
%                 if size(overlap{j},2) >= 1
%
%
%                     subplot(3,3,3)
%                     imagesc(base_data.GoodICf_comb{overlap{j}(1)} + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
%                     xlim(xlim_zoom); ylim(ylim_zoom); title(['Overlap with cell ' num2str(overlap{j}(1)) ' only']);
%
%                     if size(overlap{j},2) > 1
%                         subplot(3,3,6)
%                         imagesc(base_data.GoodICf_comb{overlap{j}(2)} + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
%                         xlim(xlim_zoom); ylim(ylim_zoom); title(['Overlap with cell ' num2str(overlap{j}(2)) ' only']);
%                     else
%                         subplot(3,3,6)
%                         imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
%                     end
%                 else
%                     subplot(3,3,3)
%                     imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
%                     subplot(3,3,6)
%                     imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
%                 end
%
%             end
%
%             if base_map == 1
%                 temp2 = overlap{j}(k); % THIS ISN'T IN A FOR LOOP, NEEDS TO BE CORRECTED/CHECKED
%                 temp3 = input('Hit enter to confirm.  Enter cell number to log error in mapping this cell: ');
%                 base_map_error_cells = [base_map_error_cells temp3];
%             elseif strcmpi(override,'o') && base_map ~= 1 % NRK - make this simpler.  Automatically fill in cell with most overlap, and have user overwrite if not ok...?
%                 temp2 = input('Enter base image cell number to register with this neuron (enter nothing for new neuron):');
%                 % Check to make sure you didn't make an obvious error
%                 if isempty(temp2) || sum(overlap{j} == temp2) == 0 && sum(overlap_ratio{j} >= 0.5) == 1
%                     % Check if you entered a cell number that doesn't overlap, or
%                     % new neuron was entered even though there is more than 80%
%                     % overlap with a cell
%                     temp2 = input('Possible error detected.  Confirm previous cell number entry: ');
%                 elseif sum(overlap{j} == temp2) == 1 && overlap_ratio{j}(overlap{j} == temp2) < 0.5
%                     % Check if you entered the neuron with lesser overlap by
%                     % accident
%                     temp2 = input('Possible error detected.  Confirm previous cell number entry: ');
%                 end
%
%             end
%
%             if ~isempty(temp2)
%                 cell_map{temp2,reg_col} = j; % Assign registered image good IC number to appropriate base image IC
%                 cell_overlap{temp2,reg_col} = overlap_ratio{j}(overlap{j} == temp2); % Track overlap percentage
%                 COM_weighted{temp2,reg_col} = reg_COM_weighted{j};
%             elseif isempty(temp2)
%                 cell_map{num_cells_total+1,reg_col} = j;
%                 cell_overlap{num_cells_total+1,reg_col} = 1;
%                 COM_weighted{num_cells_total+1,reg_col} = reg_COM_weighted{j};
%             end
%
%
%         elseif isempty(overlap{j})
%
%             % clear out the zoomed in single cell overlap subplots
%             subplot(3,3,3)
%             imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
%             subplot(3,3,6)
%             imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
%
%             disp([num2str(j) '/' num2str(num_reg_ICs) ...
%                 ') No overlap with previous cells.  Automatically assigned as a new cell'])
% %
% %             temp4 = input([num2str(j) '/' num2str(num_reg_ICs) ...
% %                 ')This cell does not overlap with any cells from base image. Hit any key to proceed.']);
%             cell_map{num_cells_total+1,reg_col} = j;
%             cell_overlap{num_cells_total+1,reg_col} = 1;
%             COM_weighted{num_cells_total+1,reg_col} = reg_COM_weighted{j};
%         end
%
%
%     end
% elseif strcmpi(runthrough,'n')
%     cell_map(:,2) = cell_map(:,1);
%     [cell_overlap{:,2}] = deal(1);
%     COM_weighted(:,2) = reg_COM_weighted;
% end
%
% FigNum = FigNum + 1;
%
% figure(FigNum) % Plot out combined cells after registration
% subplot(2,1,1)
% imagesc(base_data.AllIC+ AllIC_reg*new_cell_add,[0 CLIM_upper]); title('Combined Image Cells'); colormap(jet)
% h = colorbar('YTick',[0 1 new_cell_add new_cell_add+1],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});


