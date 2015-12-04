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
%   varargins
%       'multi_reg': (optional) specify as ...,'multi_reg', 1. 0 (default) - 
%       use base_file NeuronImage variable from ProcOut.mat for registration 
%       of neurons.  1 - used only in conjunction with multi_image_reg -
%       uses AllMasks from Reg_NeuronID for future registrations, with update_masks = 0. 
%       2 - same as 1 but update_masks = 1. 
%
%       'check_multiple_mapping': (optional) scroll through multiple
%       mapping neurons - 2nd session neuron is in a red outline, 1st
%       session neurons will be in yellow
%
%       'use_neuron_masks': (optional) 1 = use neuron masks to register,
%       not minimum projection (0 = use min projection = default)
%
%       'use_alternate_reg': if specified, you can use an alternate
%       image registration transform to do your image registration.  Must
%       be followed by two arguments: 1) the affine transform matrix T, and
%       2) the name you wish to append to the registration file, e.g.
%       ...'use_alternate_reg', T_alternate, '_reg_with_jitter')
%
%       'add_jitter': same as 'use_alternate_reg' except the affine
%       transform matrix T is multiplied by the actual registration to
%       induce the specified jitter (e.g. [1 0 0; 0 1 0; 3 4 1] results in
%       an additional translation of 3 pixels in the x-direction and 4
%       pixels in the y-direction).  If specified but left empty the
%       original transform matrix will be used.
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

multi_reg = 0; % default
debug_escape = 0; % default
use_neuron_masks = 0; % default
name_append = []; % default
alt_reg_flag = 0;
alt_reg_tform = []; % default
add_jitter = []; % default
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
   if strcmpi('use_neuron_masks',varargin{j})
       use_neuron_masks = varargin{j+1};
       if use_neuron_masks == 1
           name_append = '_regbyneurons';
       end
   end
   if strcmpi('use_alternate_reg',varargin{j})
      alt_reg_tform = varargin{j+1};
      if ~isempty(alt_reg_tform) % Don't do anything if left empty
          alt_reg_flag = 1;
          name_append = varargin{j+2};
      end
   end
   if strcmpi('add_jitter',varargin{j})
       jitter_mat = varargin{j+1};
       if ~isempty(jitter_mat)
           add_jitter = 1;
           name_append = varargin{j+2};
       end
   end
end


%% Perform Image Registration
[RegistrationInfoX, imreg_unique_filename] = image_registerX(mouse_name, base_date, base_session, ...
    reg_date, reg_session, manual_reg_enable,'use_neuron_masks',use_neuron_masks);

% Adjust Image Registration for alternate tform to to add jitter
save_alt = 0;
if alt_reg_flag == 1 && ~isempty(alt_reg_tform)
    disp('Loading alternate registration info - NOTE that this is currently a hack');
    % To improve I should simply calculate the imref2d object separately
    % and not run image_registerX above.
    RegistrationInfoX.tform.T = alt_reg_tform;
    save_alt = 1;
end

if add_jitter == 1
    RegistrationInfoX.tform.T = RegistrationInfoX.tform.T*jitter_mat;
    save_alt = 1;
end
% keyboard
% Save updated RegistrationInfoX if updated
if save_alt == 1
    alt_filename = [imreg_unique_filename(1:end-4) name_append '.mat'];
    save(alt_filename,'RegistrationInfoX');
end

%% Get working folders for each session, and run MakeMeanBlobs if not already done

currdir = cd;
sesh(1).folder = ChangeDirectory(mouse_name, base_date, base_session);
if ~(exist('MeanBlobs.mat','file') == 2)
    disp('MeanBlobs.mat not detected in working directory.  Running MakeMeanBlobs (This may take awhile)')
    load('ProcOut.mat','c','cTon','GoodTrs')
    MakeMeanBlobs(c, cTon, GoodTrs)
end
sesh(2).folder = ChangeDirectory(mouse_name, reg_date, reg_session);
if ~(exist('MeanBlobs.mat','file') == 2)
    disp('MeanBlobs.mat not detected in working directory.  Running MakeMeanBlobs (This may take awhile)')
    load('ProcOut.mat','c','cTon','GoodTrs')
    MakeMeanBlobs(c, cTon, GoodTrs)
end
cd(currdir)

% Define unique filename for file you are registering to that you will
% eventually save in the base path
if multi_reg == 0
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
        num2str(reg_session) name_append '.mat']);
elseif multi_reg == 1
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
    num2str(reg_session) '_updatemasks0' name_append '.mat']);
elseif multi_reg == 2
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
    num2str(reg_session) '_updatemasks1' name_append  '.mat']);
end

%% Check to see if this has already been run - if so,

try
    load(map_unique_filename)
    disp('Neuron Registration Already ran! (neuron_map file detected in base directory). Delete file to re-run');
catch
%% Get centers-of-mass of all cells after registering 2nd image to 1st image
for k = 1:2
    % Load Neuron Masks and average activation
    load(fullfile(sesh(k).folder, 'ProcOut.mat'),'NeuronImage');
    try
        load(fullfile(sesh(k).folder, 'MeanBlobs.mat'),'BinBlobs');
    catch
        disp(['Running MakeMeanBlobs for session ' num2str(k) ' - this may take awhile'])
        load(fullfile(sesh(k).folder,'ProcOut.mat'),'c','cTon','GoodTrs');
        MakeMeanBlobs(c,cTon,GoodTrs)
    end
    if k == 2 % Get registration info only if register session
        
        [tform_struct ] = get_reginfo(sesh(1).folder, sesh(2).folder, RegistrationInfoX );
    end
    
    % overwrite NeuronImage to include ALLmasks for base folder if doing multiple
    % sessions
    if k == 1 && multi_reg >= 1
        load(fullfile(sesh(1).folder,['Reg_NeuronIDs_updatemasks'  num2str(multi_reg-1) name_append '.mat']));
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
%         sesh(k).cms(j).x = mean(jt);
%         sesh(k).cms(j).y = mean(it);  
        % Dump centers-of-mass of neurons into day structure
        if size(temp3,1) == 0 % If registered neuron disappears, dump it to 0,0
            disp([' Size zero neuron detected.  See neuron # ' num2str(j)])
            sesh(k).cms(j).x = 0;
            sesh(k).cms(j).y = 0;
        elseif size(temp3,1) == 1 % Normal case
            sesh(k).cms(j).x = temp3.Centroid(1);
            sesh(k).cms(j).y = temp3.Centroid(2);
        else % If multiple blobs are present for a neuron, only use the largest one
            temp4 = regionprops(neuron_image_use,'ConvexArea');
            sizes = arrayfun(@(a) a.ConvexArea,temp4);
            blob_use = max(sizes) == sizes;
            % Put in size limitation here - must be bigger than say, 20
            % pixels!
            try
                if length(blob_use) > 1 || max(sizes) < 20
                    disp(['MULTIPLE BLOBS AND/OR SMALL SIZE OF NEURON ' num2str(j) ...
                        ' DETECTED.'])
                    % Aribtrarily set the 1st valid valud in blob_use to 1
                    temp = find(blob_use);
                    blob_use = temp(1);
                end
                try % Debugging clause
                    sesh(k).cms(j).x = temp3(blob_use).Centroid(1);
                    sesh(k).cms(j).y = temp3(blob_use).Centroid(2);
                catch
                    disp('Error - sent to keyboard to check!')
                    keyboard
                end
            catch
                disp('Error in first try/catch statement')
                keyboard
            end
        end
        
        sesh(k).NeuronImage_reg{j} = neuron_image_use;
        sesh(k).NeuronMean_reg{j} = neuron_mean_use;
        % Dump center of mass info into one array for each session for
        % later use
        sesh(k).cms_all(j,:) = [sesh(k).cms(j).x sesh(k).cms(j).y];
    end
    
    % Dump cms into arrays

end



% keyboard
%% Get distance to all other neurons
disp('Calculating Distances between cells')
cm_dist = 100*ones(size(sesh(1).cms,2),size(sesh(2).cms,2)); % Set all values to arbitrarily large distances to start.
for j = 1:size(sesh(1).cms,2); % Cycle through all base session neurons
    if ~isempty(sesh(1).cms(j).x)
        pos_cm(:,1) = [sesh(1).cms(j).x ; sesh(1).cms(j).y];
        for m = 1:size(sesh(2).cms,2) % get distances to all registration session neurons
            if ~isempty(sesh(2).cms(m).x) && ~isempty(sesh(2).cms(m).y)
                try % Error catching try/catch statement
                    pos_cm(:,2) = [sesh(2).cms(m).x ; sesh(2).cms(m).y];
                catch
                    disp(['Error at j = ' num2str(j) ' & m = ' num2str(m)])
                    keyboard
                end
                temp = dist(pos_cm);
                cm_dist(j,m) = temp(1,2);
            elseif isempty(sesh(2).cms(m).x)
                % Edge case where one of the neurons has disappeared during
                % registration (probably due to being near the edge of the 
                % screen - shouldn't happen if you are using the same base
                % session for both Tenaspis and multi_image_reg, but can if you
                % are doing independent registrations
                cm_dist(j,m) = 100; % Set distance to very far for these neurons so they never get mapped to another neuron
            end
        end
    elseif isempty(sesh(1).cms(j).x)
        cm_dist(j,:) = 100*ones(size(cm_dist(j,:)));
    end
end

cm_dist_min = min(cm_dist,[],2); % Get minimum distance to nearest neighbor for all cells

% exclude cells whose closest neighbor exceeds the distance threshold you
% set
n = 0;
for j = 1:length(cm_dist_min)
    % Exclude any neurons whose cms are outside the distance threshold or
    % whose cms reside at 0,0 (meaning that they have disappeared due to
    % registtration)
    if cm_dist_min(j) > min_thresh || (sesh(1).cms(j).x == 0 && sesh(1).cms(j).y == 0)
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
same_neuron = zeros(size(sesh(1).NeuronImage_reg,2),size(sesh(2).NeuronImage_reg,2));
neuron_id_nan = neuron_id;
for j = 1:size(sesh(2).NeuronImage_reg,2);
    % Find cases where more than one neuron in the 1st session maps to
    % the same neuron in the second session
    try % Debugging!
        same_ind = find(cellfun(@(a) ~isempty(a) && a == j,neuron_id));
    catch
        disp('error')
        keyboard
    end
    if length(same_ind) > 1
%         keyboard
        overlap_ratio = zeros(1,length(same_ind)); % Pre-allocate
        for k = 1:length(same_ind)
            % Note neurons in the 1st session that map to the same cell
            % in the 2nd session and set their values to NaN in the
            % neuron_id variable
            same_neuron(same_ind(k),j) = 1;
            neuron_id_nan{same_ind(k)} = nan;
            % Calculate overlapping pixels 
            overlap_pixels = sum(sesh(1).NeuronMean_reg{same_ind(k)}(:) & ...
                sesh(2).NeuronMean_reg{j}(:));
            total_pixels = sum(sesh(1).NeuronMean_reg{same_ind(k)}(:) | ...
                sesh(2).NeuronMean_reg{j}(:));
%             min_neuron_size = min([sum(sesh(1).NeuronMean_reg{same_ind(k)}(:)) ...
%                 sum(sesh(2).NeuronMean_reg{j}(:))]);
%             overlap_ratio(k) = overlap_pixels/min_neuron_size; 
            overlap_ratio(k) = overlap_pixels/total_pixels;
        end
        % Get neuron whose mask has the most overlap with the cell in the registration session
        most_overlap = find(max(overlap_ratio) == overlap_ratio);
        most_overlap_logical = max(overlap_ratio) == overlap_ratio;
        least_overlap = find(~most_overlap_logical);
        if length(most_overlap) == 1 % Only choose the cell with the most overlap if it is truly the most
            neuron_id{same_ind(most_overlap)} = j;
        elseif length(most_overlap) > 1 % send all to nans if more than one neuron is completely inside the other
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
    sesh(k).AllNeuronMask = create_AllICmask(sesh(k).NeuronImage_reg);
end

figure;
imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); colorbar
title('1 = session 1, 2 = session 2, 3 = both sessions')

%% Plot out each cell mapped to another to see how good the registration is..

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
            bounds_image = bwboundaries(sesh(2).NeuronImage_reg{same_neuron_list(j)});
            bounds_mean = bwboundaries(sesh(2).NeuronMean_reg{same_neuron_list(j)});
            same_neuron1 = find(same_neuron(:,same_neuron_list(j)));
            temp_image = zeros(size(sesh(1).NeuronImage_reg{1}));
            temp_mean = zeros(size(sesh(1).NeuronImage_reg{1}));
            for k = 1:length(same_neuron1)
                temp_image = temp_image + sesh(1).NeuronImage_reg{same_neuron1(k)};
                temp_mean = temp_mean + sesh(1).NeuronMean_reg{same_neuron1(k)};
            end
            
            bounds_plot_x = [min(bounds_mean{1}(:,2))-5 max(bounds_mean{1}(:,2))+5];
            bounds_plot_y = [min(bounds_mean{1}(:,1))-5 max(bounds_mean{1}(:,1))+5];
            
            subplot(2,2,1)
            imagesc(sesh(1).NeuronImage_reg{same_neuron1(1)}); colorbar
            hold on;
            plot(bounds_image{1}(:,2),bounds_image{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronImage: 1st session neuron = ' num2str(same_neuron1(1)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            subplot(2,2,2)
            imagesc(sesh(1).NeuronImage_reg{same_neuron1(2)}); colorbar
            hold on;
            plot(bounds_image{1}(:,2),bounds_image{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronImage: 1st session neuron = ' num2str(same_neuron1(2)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            subplot(2,2,3)
            imagesc(sesh(1).NeuronMean_reg{same_neuron1(1)}); colorbar
            hold on;
            plot(bounds_mean{1}(:,2),bounds_mean{1}(:,1),'r');
            hold off
            xlim(bounds_plot_x); ylim(bounds_plot_y);
            title(['NeuronMean: 1st session neuron = ' num2str(same_neuron1(1)) '. 2nd session =  ' num2str(same_neuron_list(j))])
            
            subplot(2,2,4)
            imagesc(sesh(1).NeuronMean_reg{same_neuron1(2)}); colorbar
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
neuron_map.base_cms = sesh(1).cms_all;
neuron_map.reg_date = reg_date;
neuron_map.reg_session = reg_session;
neuron_map.register_file = RegistrationInfoX.register_file;
neuron_map.reg_cms = sesh(2).cms_all;
neuron_map.neuron_id = neuron_id;
neuron_map.same_neuron = same_neuron;
 
neuron_map.num_bad_cells = num_bad_cells;

if multi_reg >= 1
    neuron_map.base_date = 'Multiple - all prior sessions in Reg_NeuronIDs in base directory';
    neuron_map.base_session = 'Multiple - all prior sessions in Reg_NeuronIDs in base directory';
end

save(map_unique_filename, 'neuron_map');

end % End try/catch statement



end

