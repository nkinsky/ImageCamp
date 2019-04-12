function [ neuron_map] = neuron_register( mouse_name, base_date, base_session, ...
    reg_date, reg_session, varargin)
% neuron_map = neuron_register( mouse_name, base_date, base_session, ...
%   reg_date, reg_session, check_neuron_mapping, ...)
%
%   Registers neurons from one session to another based on the minimum
%   projection of each session.
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
%       check_cell_mapping (optional): 0 (default) = no check plots are generated.
%       1 = go through cell-by-cell and check how well cells are mapped.
%
%   varargins
%
%       'name_append': name to append to the end of the registration file
%       saved in the base session directory
%
%       'multi_reg': specify as ...,'multi_reg', 1. 0 (default) - 
%       use base_file NeuronImage variable from ProcOut.mat for registration 
%       of neurons.  1 - used only in conjunction with multi_image_reg -
%       uses AllMasks from Reg_NeuronID for future registrations, with update_masks = 0. 
%       2 - same as 1 but update_masks = 1. 
%
%       'check_multiple_mapping': scroll through multiple
%       mapping neurons - 2nd session neuron is in a red outline, 1st
%       session neurons will be in yellow
%
%       'use_neuron_masks': 1 = use neuron masks to register,
%       not minimum projection (0 = use min projection = default)
%
%       'use_alternate_reg': if specified, you can use an alternate
%       image registration transform to do your image registration.  Must
%       be followed by the affine transform matrix T
%
%       'add_jitter': same as 'use_alternate_reg' except the affine
%       transform matrix T is multiplied by the actual registration to
%       induce the specified jitter (e.g. [1 0 0; 0 1 0; 3 4 1] results in
%       an additional translation of 3 pixels in the x-direction and 4
%       pixels in the y-direction).  If specified but left empty the
%       original transform matrix will be used.
%
%       There are others like 'suppress_output' in actual code.
%
%   OUTPUTS 
%       neuron_map contains the following fields and is also saved in the
%       base directory:
%
%       .neuron_id: 1xn cell where n is the number of neurons in the first
%       session, and each value is the neuron number in the 2nd session
%       that maps to the neurons in the 1st session.  An empty cell means
%       that no neuron from the 2nd session maps to that neuron from the 1st
%       session.  A value of NaN means that the closest neuron within the
%       min_thresh distance has already been mapped to another neuron (i.e.
%       it is in a densely packed area)
%
%       .same_neuron: n x m logical, where the a value of 1 indicates that
%       more than one neuron from the second session maps to a cell in the
%       first session.  Each row corresponds to a 1st session neuron, each
%       column to a 2nd session neuron.
%
%       .num_not_assigned: number of neurons that had no neurons in the
%       second session within min_thresh.
%

%% 0: Parameters
% min_thresh = 3; % distance in pixels beyond which we consider a cell a different cell
manual_reg_enable = 0; % 0 = do not allow manual adjustment of registration

%% 1: Parse Inputs
% keyboard

p = inputParser;
p.addRequired('mouse_name', @ischar);
p.addRequired('base_date', @ischar);
p.addRequired('base_session', @isnumeric);
p.addRequired('reg_date', @ischar);
p.addRequired('reg_session', @isnumeric);
p.addOptional('check_neuron_mapping', false, @(a) islogical(a) ...
    || a == 1 || a == 0);  %default = false
p.addParameter('check_multiple_mapping', false, @(a) islogical(a) ...
    || a == 1 || a == 0);  %default = false
p.addParameter('multi_reg', 0, @isnumeric) % default = 0
p.addParameter('use_neuron_masks', false, @(a) islogical(a) ...
    || a == 1 || a == 0);  %default = false
p.addParameter('name_append', '', @(a) isempty(a) || ischar(a)); % default = ''
p.addParameter('alt_reg', [], @(x) isempty(x) || ...
    size(x,1) == 3 && size(x,2) == 3); % default = no alternative tform
p.addParameter('add_jitter', [], @(x) isempty(x) || ...
    size(x,1) == 3 && size(x,2) == 3); % default = no jitter added
p.addParameter('multi_map_method', 2, ...
    @(x) isnumeric(x) && any(x == [0 1 2])); % default = 0
p.addParameter('min_thresh', 3, @isnumeric);
p.addParameter('save_on', true, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('suppress_output', false, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('regtype','rigid',@ischar); 
p.KeepUnmatched = true;
p.parse(mouse_name, base_date, base_session, reg_date, reg_session, ...
    varargin{:});

check_neuron_mapping = p.Results.check_neuron_mapping;
check_multiple_mapping = p.Results.check_multiple_mapping;
multi_reg = p.Results.multi_reg;
use_neuron_masks = p.Results.use_neuron_masks;
name_append = p.Results.name_append;
alt_reg_tform = p.Results.alt_reg;
jitter_mat = p.Results.add_jitter;
multi_map_method = p.Results.multi_map_method;
min_thresh = p.Results.min_thresh;
save_on = p.Results.save_on;
suppress_output = p.Results.suppress_output;
regtype = p.Results.regtype;
%% 2: Perform Image Registration
[RegistrationInfoX, imreg_unique_filename] = image_registerX(mouse_name, base_date, base_session, ...
    reg_date, reg_session, manual_reg_enable,'use_neuron_masks',use_neuron_masks,...
    'suppress_output', suppress_output,'name_append',name_append,...
    'regtype', regtype);

% 2A:Adjust Image Registration for alternate tform
% save_alt = 0;
if ~isempty(alt_reg_tform)
    disp('Using user-specified transform for registration');
    RegistrationInfoX.tform.T = alt_reg_tform;
    save(imreg_unique_filename,'RegistrationInfoX');
%     save_alt = 1;
%     save_on = false;
end

% 2B: Adjust Image registration to add "jitter"
if ~isempty(jitter_mat)
    RegistrationInfoX.tform.T = RegistrationInfoX.tform.T*jitter_mat;
    name_append = '_dontsave'; % Necessary to make sure a new neuron map is formed by causing an error in the try/catch statement below.
%     save_alt = 1;
end

% Save updated RegistrationInfoX if updated
% if save_alt == 1 && ~save_on
%     alt_filename = [imreg_unique_filename(1:end-4) name_append '.mat'];
%     save(alt_filename,'RegistrationInfoX');
% end

%% 3: Get working folders for each session

sesh(1).folder = ChangeDirectory(mouse_name, base_date, base_session, 0);
sesh(2).folder = ChangeDirectory(mouse_name, reg_date, reg_session, 0);

% Define unique filename for file you are registering to that you will
% eventually save in the base path
if multi_reg == 0
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
        num2str(reg_session) name_append '.mat']);
elseif multi_reg == 1 % used only for batch neuron registration
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
    num2str(reg_session) '_updatemasks0' name_append '.mat']);
elseif multi_reg == 2 % used only for batch neuron registration
    map_unique_filename = fullfile(sesh(1).folder,['neuron_map-' mouse_name '-' reg_date '-session' ...
    num2str(reg_session) '_updatemasks1' name_append  '.mat']);
end

%% 4: Get centers-of-mass of all cells after registering 2nd image to 1st image

% Check to see if this has already been run - if so, skip all of the stuff
% below
try
    load(map_unique_filename, 'neuron_map')
    if ~suppress_output
        disp('Neuron Registration Already ran! Using existing neuron map file');
    end
catch
    
    if multi_reg == 0  && ~suppress_output % display only for single session registrations (reduces spam for multi-session registrations)
        disp(['Registering neurons from ' mouse_name ' ' base_date ' session ' num2str(base_session) ...
            ' to ' reg_date ' session ' num2str(reg_session)]);
    end
for k = 1:2
    
    % Load Neuron Masks and average activation
    load(fullfile(sesh(k).folder,'FinalOutput.mat'),'NeuronImage','NeuronAvg');
    ROIavg = MakeAvgROI(NeuronImage,NeuronAvg);
    
    % Overwrite NeuronImage to include ALLmasks for base folder if doing multiple
    % sessions
    if k == 1 && multi_reg >= 1
        load(fullfile(sesh(1).folder,['Reg_NeuronIDs_updatemasks'  num2str(multi_reg-1) name_append '.mat']));
        NeuronImage = Reg_NeuronIDs(1).AllMasks;
        ROIavg = Reg_NeuronIDs(1).AllMasksMean;
    end
    if ~suppress_output
        disp(['Calculating cell center of masses for session ' num2str(k)])
    end
    for j = 1:size(NeuronImage,2)
        temp = NeuronImage{j};
        temp2 = ROIavg{j};
        if k == 2 % do registration if in 2nd session
            neuron_image_use = imwarp(temp,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
            neuron_mean_use = imwarp(temp2,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
        elseif k == 1 % Don't do registration if base session
            neuron_image_use = temp;
            neuron_mean_use = temp2;
        end
        temp3 = regionprops(neuron_image_use,'Centroid');

        % Dump centers-of-mass of neurons into data structure
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
            % Size limitation here - must be bigger than 20 pixels
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

end

%% 5: Get distance to all other neurons
if ~suppress_output
    disp('Calculating Distances between cells')
    p = ProgressBar(size(sesh(1).cms,2));
end
cm_dist = 100*ones(size(sesh(1).cms,2),size(sesh(2).cms,2)); % Set all values to arbitrarily large distances to start.
for j = 1:size(sesh(1).cms,2) % Cycle through all base session neurons
    if ~isempty(sesh(1).cms(j).x)
        pos_cm(:,1) = [sesh(1).cms(j).x ; sesh(1).cms(j).y]; % Set base neuron location
        for m = 1:size(sesh(2).cms,2) % get distances to all registration session neurons
            
            if ~isempty(sesh(2).cms(m).x) && ~isempty(sesh(2).cms(m).y)
                try % Error catching try/catch statement
                    pos_cm(:,2) = [sesh(2).cms(m).x ; sesh(2).cms(m).y];
                catch
                    disp(['Error at j = ' num2str(j) ' & m = ' num2str(m)])
                    keyboard
                end
                % Calculate Distance
                cm_dist(j,m) = sqrt((pos_cm(1,1)-pos_cm(1,2))^2 + ...
                    (pos_cm(2,1)-pos_cm(2,2))^2);

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
    if ~suppress_output
        p.progress;
    end
end
if ~suppress_output
    p.stop;
end

cm_dist_min = min(cm_dist,[],2); % Get minimum distance to nearest neighbor for all cells


% Exclude cells whose closest neighbor exceeds the distance threshold you
% set
n = 0;
neuron_id = cell(length(cm_dist_min),1);
for j = 1:length(cm_dist_min)
    % Exclude any neurons whose cms are outside the distance threshold or
    % whose cms reside at 0,0 (meaning that they have disappeared due to
    % registration)
    if cm_dist_min(j) > min_thresh || (sesh(1).cms(j).x == 0 && sesh(1).cms(j).y == 0)
        neuron_id{j,1} = [];
        n = n+1;
    else % Map each neuron in the registered session to the closest neuron in the base session
        neuron_id{j,1} = find(cm_dist_min(j) == cm_dist(j,:));
        if length(neuron_id{j,1}) > 1 % Fix very rare edge case where two neurons in reg session are exactly the same distance from the base session neuron.
            neuron_id{j,1} = [];
        end
    end
    
end

% neuron_id_temp = neuron_id; % Save neuron_id for later debugging purposes
%% 6: Look for false positives due to multiple cells in the 1st session mapping
% to the same cell in the 2nd session
if ~suppress_output
    disp('Sorting out multiple base session cells mapping to the same cell in the second session')
end
% Initialize same_neuron variable
same_neuron = zeros(size(sesh(1).NeuronImage_reg,2),size(sesh(2).NeuronImage_reg,2));
neuron_id_nan = neuron_id;
% oratio_all = [];
% corr_all = [];
for j = 1:size(sesh(2).NeuronImage_reg,2)
    % Find cases where more than one neuron in the 1st session maps to
    % the same neuron in the second session
    same_ind = find(cellfun(@(a) ~isempty(a) && a == j,neuron_id));
    
    % Choose which neuron maps best.
    if length(same_ind) > 1
        
        if multi_map_method == 0 % use overlaps to disambiguate
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
                overlap_ratio(k) = overlap_pixels/total_pixels;
                
            end
            
            % Best match = most overlap
            [~, best_match] = max(overlap_ratio);
            best_match_logical = max(overlap_ratio) == overlap_ratio;
            worst_match = find(~best_match_logical);

%             oratio_all = [oratio_all overlap_ratio];

        elseif multi_map_method == 1 % Use closest neuron
            % Note neurons in the 1st session that map to the same cell
            % in the 2nd session and set their values to NaN in the
            % neuron_id variable
            same_neuron(same_ind(k),j) = 1;
            neuron_id_nan{same_ind(k)} = nan;
            % Calculate distances
            pos_cm(:,2) = [sesh(2).cms(j).x ; sesh(2).cms(j).y]; % Get session 2 neuron location
            multi_dist = zeros(size(same_ind));
            for k = 1:length(same_ind)
                pos_cm(:,1) = [sesh(1).cms(same_ind(k)).x ; sesh(1).cms(same_ind(k)).y]; % Get session 1 neuron location
                multi_dist(k) = sqrt((pos_cm(1,1)-pos_cm(1,2))^2 + (pos_cm(2,1)-pos_cm(2,2))^2);
            end
            
            % Best match = closest
            [~, best_match] = min(multi_dist);
            best_match_logical = min(multi_dist) == multi_dist;
            worst_match = find(~best_match_logical);
            
        elseif multi_map_method == 2 % use correlation
            corr_value = zeros(1,length(same_ind)); % Pre-allocate
            for k = 1:length(same_ind)
                % Note neurons in the 1st session that map to the same cell
                % in the 2nd session and set their values to NaN in the
                % neuron_id variable
                same_neuron(same_ind(k),j) = 1;
                neuron_id_nan{same_ind(k)} = nan;
                % Calculate overlapping pixels
                corr_value(k) = corr(sesh(1).NeuronMean_reg{same_ind(k)}(:),...
                    sesh(2).NeuronMean_reg{j}(:),'type','Spearman');
            end
            
            % Best match = highest correlation
            [~, best_match] = max(corr_value);
            best_match_logical = max(corr_value) == corr_value;
            worst_match = find(~best_match_logical);
            
%             corr_all = [corr_all corr_value];
        end
        
        % Sort out neurons with best/worst match and map to best match
        if length(best_match) == 1 % Only choose the cell with the highest correlation
            neuron_id{same_ind(best_match)} = j;
        elseif length(best_match) > 1 % send all to nans if more than one neuron has the same highest correlation
            for m = 1: length(best_match)
                neuron_id{same_ind(best_match(m))} = nan;
            end
        end
        for m = 1:length(worst_match)
            neuron_id{same_ind(worst_match(m))} = nan;
        end
    end
    
end

num_same = sum(same_neuron(:));
num_notassigned = n;
%% 7: Plot out combined sessions
if ~suppress_output
    map_use = neuronmap_cell2mat(neuron_id);
    plot_reg_neurons(map_use, RegistrationInfoX, sesh(1).NeuronImage_reg,...
        sesh(2).NeuronImage_reg, false);

% Below code doesn't work because I turn off axes in plot_reg_neurons
%     xlabel([mouse_name_title(mouse_name) ' ' mouse_name_title(base_date) ' session ' num2str(base_session) ...
%             ' to ' mouse_name_title(reg_date) ' session ' num2str(reg_session)]);

        % Add in mouse name and sessions to title
        title_use = get(gca,'Title');
        title_use.String = {title_use.String, mouse_name_title(mouse_name), ...
            [mouse_name_title(base_date) '-s' num2str(base_session) ' to ' ...
            mouse_name_title(reg_date) '-s' num2str(reg_session)]};
end


%% 8(Optional): Plot out each cell mapped to another to see how good the registration is..

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

%% 9(Optional, not well updated): Check multiple mapping neurons

if check_multiple_mapping
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
    
%% Find how many cells don't map onto the second session. 
nonmapped = sum(cellfun(@isempty, neuron_id));          %Cells that disappeared/appeared over the two sessions.
crappy = sum(cellfun(@sum,cellfun(@isnan,neuron_id,'UniformOutput',false)));    %Multiple of these cells in session 1 map onto session 2. Not necessarily crappy, just densedly packed.

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
neuron_map.neuron_id_nan = neuron_id_nan;
neuron_map.same_neuron = same_neuron;
neuron_map.min_thresh = min_thresh;
neuron_map.multi_map_method = multi_map_method;
 
neuron_map.num_bad_cells = num_bad_cells;

if multi_reg >= 1
    neuron_map.base_date = 'Multiple - all prior sessions in Reg_NeuronIDs in base directory';
    neuron_map.base_session = 'Multiple - all prior sessions in Reg_NeuronIDs in base directory';
end

% Don't save if specified
if save_on
    save(map_unique_filename, 'neuron_map');
end

end % End try/catch statement



end

