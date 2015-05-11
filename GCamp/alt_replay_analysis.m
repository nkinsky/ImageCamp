function [ ] = alt_replay_analysis( )
%UNTITLED2 Summary of this function goes here
%   Gets  all times when the mouse is within the designated sections.

% Workflow:
% 1) Get timestamps for when the mouse is in the choice or base (make this
% flexible, so that one could use a vargin to designate the areas we want
% to look at, or maybe in the future it will look at all sections!)
% 2) speed threshold to only look at statationary or low-velocity times
% 3) Calculate the locations of ALL calcium transients that occur during
% these times and see where they are - before, after, opposite sides...
% 3a) look at how close together these transients place fields are...
% 3b) look to see if they move in order away from the mouse...
% 4) 

% keyboard

%% Magic Variables - will want to make these as few as possible in the future!

num_trials = 40; % this will probably need to be fixed somehow or automatically counted in Will's script...
% bonehead way is to increment num_trials up until you reach an error...
vel_thresh = 7; % NOT CURRENTLY USED - threshold in cm/s below which we consider the mouse not moving/not encoding placefields
sig_level = 0.05; % p-value threshold, below which you include fields in the analysis

%% Part 0: Hardcoded file locations for original writing of function

working_dir =  'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working'; % laptop
% 'J:\GCamp Mice\Working\alternation\11_4_2014\Working'; %NORVAL
% pos_file = [working_dir '\pos_corr_to_std.mat'];
place_file = [working_dir '\PlaceMaps.mat'];
pf_stats_file = [working_dir '\PFstats.mat'];

% load(pos_file)
load(place_file)
load(pf_stats_file)

% keyboard
%% Part 1: get timestamps for when mouse is in choice or base, and separate
% into left and right trials (and maybe correct/incorrect)
trial_type = [1 2] ; % [left right]
trial_type_text = {'Left Trials' 'Right Trials'};
corr_trial = [1 0] ; % [correct incorrect]
valid_sections = [1 2 3 10]; % matches sections in 'sections.m' file by Will Mau, except 10 = either goal location
section_names = {'Start' 'Center' 'Choice' 'Left Approach' 'Left' 'Left Return' ...
    'Right Approach' 'Right' 'Right Return' 'Goal'};

% Get relevant sections, bounds of those sections, and frames when the
% mouse is in those sections
[sect, goal] = getsection(x, y, 1);
bounds = sections(x, y, 0);
pos_data = postrials(x, y, 0, num_trials, 0);

% Get mouse velocity - use isrunning here
% vel = sqrt(diff(pos_align.x).^2+diff(pos_align.y).^2)/...
%     (pos_align.time_interp(2)-pos_align.time_interp(1));
% vel = [0 vel]; % Make this the same length as position data by saying the mouse's
% % velocity at the first frame is 0.



% keyboard
figure(11)
plot(x,y,'b')
for i = 1:length(trial_type)
    for j = 1:length(valid_sections)
        if valid_sections(j) <= 9 % Filter out only times he is in the specified section
            sect_filter = sect(:,2) == valid_sections(j);
        elseif valid_sections(j) == 10 % Filter out only the times he is in the goal location
            sect_filter = (goal(:,2) == 1 | goal(:,2) == 2);
        end
        sect_and_thresh{i,valid_sections(j)} = ~isrunning & ...
            (sect_filter)' & (pos_data.choice == i) ...
            & (pos_data.alt == 1);
        % put something here to capture frames when the mouse is stopped in a specific area...
        % look at distance of placefield activation from the mouse, and if they
        % are in front of or behind the mouse...need to set up something that
        % identifies areas as illegal, in front, or in back!  or at choie,
        % correct choice or incorrect choice... start simple with just
        % illegal/in front/in back
        
        % Plot to make sure everything above is working correctly (all points in
        % section in yellow stars, below the speed threshold in red circles).
        hold on
        plot(x(sect_filter), y(sect_filter),...
            'y*',x(sect_and_thresh{i,valid_sections(j)}), y(sect_and_thresh{i,valid_sections(j)}),'ro')
        hold off
    end
end

% Define forward, backward, and illegal paths for each section
arms(1).forward = 2;
arms(1).illegal = [6 9];
% arms(1).back = [6 9]; % could be either actually depending on trial type.  Will need to revise.
arms(3).forward = [5 8];
arms(3).illegal = 2;
% arms(3).back = 2;

% keyboard
%% Step 1.5) Parse out times below threshold into epochs...
for i = 1:length(trial_type)
    for j = 1:length(valid_sections)
        n = 1;
        ind_use = find(sect_and_thresh{i, valid_sections(j)});
        clear epoch
        for k = 1:length(ind_use)-1; % Set start of first epoch as first valid frame
            if k == 1
                epoch(n).start = ind_use(k);
                n = n+1;
            elseif ind_use(k-1) ~= ind_use(k) - 1 % assign beginning and ends of epochs
                epoch(n).start = ind_use(k);
                epoch(n-1).end = ind_use(k-1);
                n = n+1;
            elseif k == length(ind_use) - 1 % Set end of last epoch as last valid frame
                epoch(n-1).end = ind_use(k+1);
            end
        end
        
        % Fill in epoch if k is empty
        if isempty(k)
            epoch(1).start = [];
            epoch(1).end = [];
        end
        
        if i == 1
            section(valid_sections(j)).epoch_left = epoch; % assign epochs to section variable
        elseif i == 2
            section(valid_sections(j)).epoch_right = epoch; % assign epochs to section variable
        end
    end
end

keyboard
%% Step 2: Get locations of centers of mass of all placefields (convert from
% TMap coordinates to centimeters...) and spit these out for each epoch a
% mouse is in a given area (next step is to look at order of firing to see
% if they acutally follow a trajectory!)

% Get span of x and y points
Xcm_span = max(x(:))-min(x(:));
Ycm_span = max(y(:))-min(y(:));
Xcm_min = min(x(:));
Ycm_min = min(y(:));

% Get size of grid used to calculated placemaps
[xgrid_size, ygrid_size] = size(TMap{1});

% Get scale value to convert TMap values to centimeters. Use
% Tmap_value*scale + xmin or ymin value
scale1 = Xcm_span/xgrid_size;
scale2 = Ycm_span/ygrid_size;
scale_use = mean([scale1 scale2]);

% Get centroids of TMap
[Tcentroid, TPixelList, TPixelList_all] = TMap_centroid(TMap);

% Convert centroids to mouse position coordinates
Tcent_cm(:,1) = Tcentroid(:,2)*scale_use + Xcm_min;
Tcent_cm(:,2) = Tcentroid(:,1)*scale_use + Ycm_min;

% Get placefields that have significant p-values
sig_fields = find(pval > (1-sig_level));

% keyboard

%% Step 2a: Check to see if placefield mapping is ok
% figure(56); 
% for tt = 1:length(sig_fields)
%     uu = sig_fields(tt);
%     subplot(2,1,1);
%     plot(x,y,'b',Tcent_cm(uu,1),Tcent_cm(uu,2),'r*'); % Plot trajectory with centroid of firing field on top
%     hold on;
%     plot(bounds.left.x,bounds.left.y, 'r*', bounds.right.x, bounds.right.y, 'b.', bounds.return_l.x, bounds.return_l.y, 'k.',...
%     bounds.return_r.x, bounds.return_r.y, 'k.', bounds.choice.x, bounds.choice.y, 'g.', bounds.center.x, bounds.center.y, 'm.',...
%     bounds.base.x, bounds.base.y, 'g*', bounds.approach_l.x, bounds.approach_l.y, 'b.', bounds.approach_r.x, bounds.approach_r.y, 'k*'); 
%     hold off
%     subplot(2,1,2);
%     imagesc(rot90(TMap{uu},1)); % Plot TMap
%     
%     waitforbuttonpress
% end

keyboard
%% Step 3: Get average heat map and place-field centroids for cell 
% activations in each region of interest

% Initialize data structure
activations = struct('AllTMap',[],'AllTMap_bin',[],'AllTMap_bin_out',[],'AllTcent_cm',[],...
    'n_frames',[],'AllTMap_nan',[],'AllTMap_bin_nan',[],'AllTMap_bin_out_nan',[]);
for j = 1:length(valid_sections)
    nn = 1; % Counter for subplot handles
    for i = 1:length(trial_type)
        % Get bounds of section you are looking at so that you can exclude
        % cells who have a PF in that area...
         section_bounds = get_section_bounds(valid_sections(j),bounds); % Won't work yet for goal locations...
         if valid_sections(j) == 10 && trial_type(i) == 2 % hack to correctly assign section_bounds for right goal
             section_bounds = get_section_bounds(11,bounds);
         end
         bounds_use.y = (section_bounds.x([1 2 3 4 1])-Xcm_min)/scale_use; % Swap these because TMap and x/y are currently set differently...
         bounds_use.x = (section_bounds.y([1 2 4 3 1])-Ycm_min)/scale_use;
        
        % Get placefield information for all epochs in the section of interest
        % Not working correctly for goal locations currently - see lots of
        % activations in the goal box!!! WTF!?!
        if i == 1
            temp = centroid_from_epochs(section(valid_sections(j)).epoch_left,...
                FT, TMap, Tcent_cm,'exclude',bounds_use,TPixelList_all);
        elseif i == 2
            temp = centroid_from_epochs(section(valid_sections(j)).epoch_right,...
                FT, TMap, Tcent_cm,'exclude',bounds_use,TPixelList_all);
        end
        % put NaNs in places of zero occupancy for plotting purposes!
        [ ~, TMap_nan ] = make_nan_TMap( OccMap, temp.AllTMap );
        temp.AllTMap_nan = TMap_nan;
        [ ~, TMap_bin_nan ] = make_nan_TMap( OccMap, temp.AllTMap_bin );
        temp.AllTMap_bin_nan = TMap_bin_nan;
        [ ~, TMap_bin_out_nan ] = make_nan_TMap( OccMap, temp.AllTMap_bin_out );
        temp.AllTMap_bin_out_nan = TMap_bin_out_nan;
        
        if j ~= 1 % Hack to get data structure assignments to work!
            activations(valid_sections(j),i) = activations(1);
        end
        activations(valid_sections(j),i) = temp; % Assign to activations data structure
        
        % Plot summed heatmap out for each section
        figure(20+j)
        h(nn) = subplot(2,1,i);  nn = nn + 1;
        imagesc_nan(rot90(TMap_bin_out_nan/temp.n_frames,1)); colorbar; colormap jet;
        clims(i,:) = get(gca,'CLim');
        title(['Sum of Heatmaps for Non-Running Epochs in ' ...
            section_names{valid_sections(j)} ' Section - ' trial_type_text{i}]);
        hold on;
        bounds_use = get_bounds(bounds,valid_sections(j),i); % Grab appropriate bounds for section
        plot((bounds_use.x([1 2 3 4 1])-Xcm_min)/scale_use, ...
            (bounds_use.y([1 2 4 3 1])-Ycm_min)/scale_use,'r--') % Plot bounds boxes
        
        
        %     colorbar
        %     subplot(2,1,2)
        %     imagesc_nan(rot90(TMap_bin_nan,1));
        %     title(['Sum of Binary Heatmaps for Non-Running Epochs in ' ...
        %         section_names{valid_sections(j)} ' Section']);
        %     colorbar
    end
    % Get min and max CLIM values for each subplot and make them the same
    % for each subplot...
    clim_min = min(clims(:,1)); clim_max = max(clims(:,2));
    for k = 1: length(h)
    set(h(k),'CLim',[0,clim_max]);
    end
end
    

%% Get L-R plots
for j = 1:length(valid_sections)
    figure(30+j); 
    left = activations(valid_sections(j),1);
    right = activations(valid_sections(j),2);
    LRdiff = left.AllTMap_bin_nan/left.n_frames...
        - right.AllTMap_bin_nan/right.n_frames;
    imagesc_nan(rot90(LRdiff,1)); % Plot and rotate
    % Set CLim to be equal
    clims2 = get(gca,'CLim');
    clim_eq = max(abs(clims2));
    set(gca,'CLim',[-clim_eq clim_eq]);
    colormap jet;
    colorbar('Ticks',[-clim_eq 0 clim_eq],'TickLabels', {'R > L' 'L = R' 'L > R'});
    title(['Sum of Heatmaps for Non-Running Epochs in ' ...
        section_names{valid_sections(j)} ' Section: L-R trials']);
    hold on;
    bounds_use = get_bounds(bounds,valid_sections(j),1); % Grab appropriate bounds for section
    plot((bounds_use.x([1 2 3 4 1])-Xcm_min)/scale_use, ...
        (bounds_use.y([1 2 4 3 1])-Ycm_min)/scale_use,'r--') % Plot bounds boxes
end

keyboard
%% Plot activations in order by epoch

epoch_use = section(1).epoch_right;
figure(50)
for m = 1:length(epoch_use)
    frames_use = epoch_use(m).start:epoch_use(m).end;
    [ ~, ~, TMap_order ] = get_activation_order(frames_use, FT, TMap);
    [~, TMap_order_nan ] = make_nan_TMap( OccMap, TMap_order );
    imagesc_nan(rot90(TMap_order_nan,1)); colorbar; colormap jet;
    
   waitforbuttonpress
end

%% Keyboard statement if you want to debug/mess around at the end
keyboard

end

