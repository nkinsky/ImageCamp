% arena_align_simple
% Script to test arena alignments using linear models to scale the data
% appropriately.

clear all
close all

%% Top-level variables

dvt_avi_scale = 0.6246;
dropbox_path = 'C:\Users\Nat\Dropbox\'; % Home 
% 'C:\Users\kinsky.AD\Dropbox\'; % Work

% Cells with position and square information for auto find
arena_search = {'square' 'octagon'};
position_search = {'left' 'mid' 'right'};

colorspec = {'r' 'b'}; % Keeps colors consistent for all plotting

% percent of occupancy data to exclude (1/2 at min and max of data) when
% calculating occupancy limits for scaling later
limits_percent = 5; 
wall_offset = 0.5; % The effective closest limit the mouse can get to the wall, currently in inches
arena_size = [10 11] ; % Maximum x and y dimensions (currently in inches) of the arenas in the order of arena_search cell above
arena_eff_size = [arena_size(1)-2*wall_offset arena_size(2)-2*wall_offset] ; % effective arena size (the maximum limits the tracking data can get to) for square and octagon


%% Enter paths of sessions to compare.  Folders should contain at least the
% DVT file and the AVI file.

% sesh(1).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\'; % Home 
% sesh(2).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\'; % Home
% sesh(1).path = 'i:\GCamp Mice\G30\2env\11_19_2014_nb\1 - 2env square left 201B\Cineplex\'; % Work
% sesh(2).path = 'i:\GCamp Mice\G30\2env\11_19_2014_nb\2 - 2env square mid 201B\Cineplex\';  % Work
% sesh(1).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\'; % Home
% sesh(2).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\2 - 2env square mid 201B\Working\'; % Home
sesh(1).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_25_2014\1 - 2env square left 201B\Working\'; % Home
sesh(2).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_25_2014\2 - 2env square right 90CCW 201B\Working\'; % Home

calibration_file = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_correction.mat'];
calib_left_avi = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\2env_cal_square_left.AVI'];
calib_mid_avi = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\2env_cal_square_mid.AVI'];
calib_right_avi = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\2env_cal_square_right.AVI'];


for j = 1:2
    sesh(j).arena = arena_search{~cellfun(@(a) isempty(regexp(sesh(j).path,a,'once')),arena_search)};
    sesh(j).position = position_search{~cellfun(@(a) isempty(regexp(sesh(j).path,a,'once')),position_search)};
end


%% Load calibration file and find appropriate indices to use for current data
load(calibration_file);

% Get correct index for scaling by linear model in pos_corr
for j = 1:2
    corr_ind(j) = find(arrayfun(@(a) strcmp(sesh(j).position,a.location) & ...
        strcmp(sesh(j).arena,a.arena),pos_corr));
end

%% Get AVI and DVT paths automatically
for j = 1:2
    cd(sesh(j).path);
    temp = ls('*.avi');
    temp2 = ls('*.dvt');
    sesh(j).avi_path = [sesh(j).path temp];
    sesh(j).dvt_path = [sesh(j).path temp2];
end

%% Remove all DVT points at (0,0)

for j = 1:2
   pos(j).DVT = importdata(sesh(j).dvt_path);
   temp = find(~(pos(j).DVT(:,3) == 0 & pos(j).DVT(:,4) == 0));
   pos(j).DVT_corr = pos(j).DVT(temp,:);
end

%% Plot DVT data on top of AVI frame in same figure, subplots
figure(1)

for j = 1:2
    
    % Get index of appropriate arena and position
    
   subplot(2,2,j)
   obj = VideoReader(sesh(j).avi_path);
   pFrame = readFrame(obj);
   imagesc(flipud(pFrame));
   hold on
   plot(pos(j).DVT_corr(:,3)*dvt_avi_scale,pos(j).DVT_corr(:,4)*dvt_avi_scale,colorspec{j});
   title(['Session ' num2str(j)]);
   plot([pos_corr(corr_ind(j)).arena_limits(:,1) ; pos_corr(corr_ind(j)).arena_limits(1,1)],...
       [pos_corr(corr_ind(j)).arena_limits(:,2) ; pos_corr(corr_ind(j)).arena_limits(1,2)],'g')
   axis equal
   
   hold off
    
end


%% Figure out how much of arena is covered in each position - e.g. are more E-W 
% pixels covered on the right than the middle, but the same N-S for all
% three positions?  Figure this out both before scaling with the linear
% model AND after

% figure(1)
% for j = 1:2
%     disp('Select extent of data')
%     subplot(2,2,j)
%     sesh(j).data_extents = getrect();
%     hold on
%     rectangle('Position',sesh(j).data_extents);
%     hold off
% end



%% Plot out LM scaled trajectories with arena boundary overlaid, two separate
% plots, then overlay the two LM scaled plots and see if there is a
% difference

%%% IMPORTANT - need to adjust data from the arena to align with the corner
%%% of the calibration data- WHY IS MY DATA ALL ALIGNED IMPROPERLY IN THE Y DIRECTION?  
%%% - also, may need to manually re-size all data in x and y directions
%%% after scaling... x and y seem off a bit
%%% double check linear models - 11/22 data should be between 0 and 10 for
%%% everything, but is off in the y direction for some reason

% Scale via lm

for j = 1:2
    
    lm_x = pos_corr(corr_ind(j)).lm_x;
    lm_y = pos_corr(corr_ind(j)).lm_y;
    
    pos(j).x_corr = predict(lm_x,pos(j).DVT_corr(:,3)*dvt_avi_scale);
    pos(j).y_corr = predict(lm_y,pos(j).DVT_corr(:,4)*dvt_avi_scale);
    
end

figure(2)
for j = 1:2
   subplot(2,2,j)
   plot(pos(j).x_corr,pos(j).y_corr,colorspec{j}); title(['Session ' num2str(j)]);
   axis equal
   subplot(2,2,3)
   hold on
   plot(pos(j).x_corr,pos(j).y_corr,colorspec{j}); 
   title('No 2ndary scaling')
   axis equal
   hold off
   
end
legend('Session 1','Session 2')

%% If there is a difference, apply one more scale factor and then compare.  
% Probably should scale both to 9 in (assumption is that the mouse's
% centroid can get at closes 1/2" to the wall edges...

figure(2)

for j = 1:2
    arena_ind = strcmpi(sesh(j).arena,arena_search); % Get appropriate effective size to use
   [x_lim{j}, y_lim{j}] =  get_occupancy_limits(pos(j).x_corr, ...
       pos(j).y_corr, limits_percent);
   
   scale_factor_x(j) = arena_eff_size(arena_ind)/abs(x_lim{j}(2)-x_lim{j}(1));
   scale_factor_y(j) = arena_eff_size(arena_ind)/abs(y_lim{j}(2)-y_lim{j}(1));
   
   xtemp = pos(j).x_corr*scale_factor_x(j);
   ytemp = pos(j).y_corr*scale_factor_y(j);
   
   x_offset = x_lim{j}(1)*scale_factor_x(j) - wall_offset;
   y_offset = y_lim{j}(1)*scale_factor_y(j) - wall_offset;
   
   pos(j).x_corr2 = xtemp - x_offset;
   pos(j).y_corr2 = ytemp - y_offset;

   subplot(2,2,4)
   hold on
   plot(pos(j).x_corr2, pos(j).y_corr2,colorspec{j});
   hold off
   
   axis equal
   title('With 2ndary scaling')
   
end








