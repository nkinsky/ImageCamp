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
vel_thresh = 7; % threshold in cm/s below which we consider the mouse not moving/not encoding placefields
sig_level = 0.05; % p-value threshold, below which you include fields in the analysis

%% Part 0: Hardcoded file locations for original writing of function

working_dir = 'J:\GCamp Mice\Working\alternation\11_11_2014\Working'; %NORVAL 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_11_2014\Working'; % laptop
pos_file = [working_dir '\pos_corr_to_std.mat'];
place_file = [working_dir '\PlaceMaps.mat'];
pf_stats_file = [working_dir '\PFstats.mat'];

load(pos_file)
load(place_file)
load(pf_stats_file)

%% Part 1: get timestamps for when mouse is in choice or base
valid_sections = [1 3]; % matches sections in 'sections.m' file by Will Mau
section_names = {'Start' 'Center' 'Choice' 'Left Approach' 'Left' 'Left Return' ...
    'Right Approach' 'Right' 'Right Return'};

% Get relevant sections, bounds of those sections, and frames when the
% mouse is in those sections
sect = getsection(x, y, 1);
bounds = sections(x, y, 0);
pos_data = postrials(x, y, 0, num_trials, 0);

% Get mouse velocity - use isrunning here
% vel = sqrt(diff(pos_align.x).^2+diff(pos_align.y).^2)/...
%     (pos_align.time_interp(2)-pos_align.time_interp(1));
% vel = [0 vel]; % Make this the same length as position data by saying the mouse's
% % velocity at the first frame is 0.

% below_thresh = vel < vel_thresh;
below_thresh = ~isrunning;

figure
plot(x,y,'b')
for j = 1:length(valid_sections)
    sect_and_thresh{valid_sections(j)} = below_thresh & (sect(:,2) == valid_sections(j))';
   % put something here to capture frames when the mouse is stopped in a specific area...
   % look at distance of placefield activation from the mouse, and if they
   % are in front of or behind the mouse...need to set up something that
   % identifies areas as illegal, in front, or in back!  or at choie,
   % correct choice or incorrect choice... start simple with just
   % illegal/in front/in back
   
   % Plot to make sure everything above is working correctly (all points in
   % section in yellow stars, below the speed threshold in red circles).
   hold on
   plot(x(sect(:,2) == valid_sections(j)), y(sect(:,2) == valid_sections(j)),...
       'y*',x(sect_and_thresh{valid_sections(j)}), y(sect_and_thresh{valid_sections(j)}),'ro')
   hold off
end

% Define forward, backward, and illegal paths for each section
arms(1).forward = 2;
arms(1).illegal = [6 9];
% arms(1).back = [6 9]; % could be either actually depending on trial type.  Will need to revise.
arms(3).forward = [5 8];
arms(3).illegal = 2;
% arms(3).back = 2;

%% Step 1.5) Parse out times below threshold into epochs...

for j = 1:length(valid_sections)
    n = 1;
    ind_use = find(sect_and_thresh{valid_sections(j)});
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
            epoch(n-1).end = length(ind_use) - 1;
        end
    end
    section(valid_sections(j)).epoch = epoch; % assign epochs to section variable
end
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
Tcentroid = TMap_centroid(TMap);

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

% keyboard
%% Step 3: Get average heat map and place-field centroids for cell 
% activations in each region of interest

% Initialize data structure
activations = struct('AllTMap',[],'AllTMap_bin',[],'AllTcent_cm',[],'AllTMap_nan',[],'AllTMap_bin_nan',[]);
for j = 1:length(valid_sections)
    % Get placefield information for all epochs in the section of interest
    temp = centroid_from_epochs(section(valid_sections(j)).epoch,...
        FT, TMap, Tcent_cm);
    % put NaNs in places of zero occupancy for plotting purposes!
    [ ~, TMap_nan ] = make_nan_TMap( OccMap, temp.AllTMap );
    temp.AllTMap_nan = TMap_nan; 
    [ ~, TMap_bin_nan ] = make_nan_TMap( OccMap, temp.AllTMap_bin );
    temp.AllTMap_bin_nan = TMap_bin_nan; 
    
    if j ~= 1 % Hack to get data structure assignments to work!
        activations(valid_sections(j)) = activations(1);
    end
    activations(valid_sections(j)) = temp; % Assign to activations data structure
    
    % Plot summed heatmap out for each section
    figure
%     subplot(2,1,1)
    imagesc_nan(rot90(TMap_nan,1));
    title(['Sum of Heatmaps for Non-Running Epochs in ' ...
        section_names{valid_sections(j)} ' Section']);
    hold on;
    bounds_use = get_bounds(bounds,valid_sections(j)); % Grab appropriate bounds for section
    plot((bounds_use.x([1 2 3 4 1])-Xcm_min)/scale_use, ...
        (bounds_use.y([1 2 4 3 1])-Ycm_min)/scale_use,'r--') % Plot bounds boxes
%     colorbar
%     subplot(2,1,2)
%     imagesc_nan(rot90(TMap_bin_nan,1));
%     title(['Sum of Binary Heatmaps for Non-Running Epochs in ' ...
%         section_names{valid_sections(j)} ' Section']);
%     colorbar
   
end

keyboard

end

