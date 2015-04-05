% QC proper rotation/alignment of arena to compare one session to another

close all

rot_sesh2 = -90; % Angle to rotate session 2 to get it to align with session 1
sesh2_xorig = 85*.15/.6246; % Origin of arena 2 after flipping to align with AVI
sesh2_yorig = 140*.15/.6246;

%% Load files into objects

sesh(1).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\1 - 2env octagon left\Working\';
sesh(2).path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Working\';

for j = 1:2
    cd(sesh(j).path);
    temp = ls('*.avi');
    temp2 = ls('*.dvt');
    sesh(j).avi_path = [sesh(j).path temp];
    sesh(j).dvt_path = [sesh(j).path temp2];
    sesh(j).pos_path = [sesh(j).path 'Pos.mat'];
    sesh(j).rvp_path = [sesh(j).path 'reverse_placefields.mat'];
    sesh(j).pm_path = [sesh(j).path 'PlaceMaps.mat'];
end

% avi1 = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\1 - 2env octagon left\Working\G3011202014001_2env_octagon_left_1_201B.AVI';
% avi2 = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Cineplex\G3011202014002_2env_octagon_right_90CCW_2_201B.AVI';
% 
% dvt1_path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\1 - 2env octagon left\Working\G3011202014001_2env_octagon_left_1_201B.DVT';
% dvt2_path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Cineplex\G3011202014002_2env_octagon_right_90CCW_2_201B.DVT';

obj1 = VideoReader(sesh(1).avi_path); % Load into objects
obj2 = VideoReader(sesh(2).avi_path);

obj1.CurrentTime = 0; % Set times
obj2.CurrentTime = 0;

pFrame1 = readFrame(obj1);
pFrame2 = readFrame(obj2);

dvt1 = importdata(sesh(1).dvt_path);
dvt2 = importdata(sesh(2).dvt_path);

pos1 = importdata(sesh(1).pos_path);
pos2 = importdata(sesh(2).pos_path);

%% Load reverse_placefield data

disp('Loading reverse place field data...')

rvp = importdata(sesh(1).rvp_path);
t1 = load(sesh(1).pm_path,'t'); % A hack b/c my current session doesn't have "t" variable in its reverse_placefield .mat file
rvp(1).t = t1.t; % hack for current data set
rvp(2) = importdata(sesh(2).rvp_path);

rvp(1).Session = 'Session 1';
rvp(2).Session = 'Session 2';

%% Set times to plot

t_plot1 = dvt1(:,2);
t_plot2 = dvt2(:,2);

%% Plot it out

figure
subplot(2,2,1);
imagesc(pFrame1); title('Session 1');
subplot(2,2,2);
imagesc(pFrame2); title('Session 2');

ax1 = subplot(2,2,3);
imagesc(flipud(pFrame1)); title('Session 1 Flipped');
ax2 = subplot(2,2,4);
imagesc(flipud(pFrame2)); title('Session 2 Flipped');


%% Draw arena outlines on avi files and get points
disp('Outline the session 1 (flipped) arena bottom, right click when done')
[x1, y1] = getpts(ax1);

disp('Outline the session 2 (flipped) arena bottom, right click when done')
[x2, y2] = getpts(ax2);

%% Rotate session 2 x/y coords appropriately

[x2_rot, y2_rot] = rotate_xy(rvp(2).x, rvp(2).y, rot_sesh2, sesh2_xorig, sesh2_yorig);
[Xedges2_rot, Yedges2_rot] = rotate_xy(rvp(2).Xedges, rvp(2).Yedges, rot_sesh2, sesh2_xorig, sesh2_yorig);
[x2_arena_rot, y2_arena_rot] = rotate_xy(x2, y2, rot_sesh2, sesh2_xorig*.6246/.15, sesh2_yorig*.6246/.15);

%% Plot arena outline on original plots
rm_scale = .15; % For room 201b (pix2cm scale)

scale = .6246/.15;

figure
subplot(2,2,1)
title('Session 1')
% plotDVTonAVI(obj1,dvt1(:,3),dvt1(:,4),dvt1(:,2),t_plot1)
plotXYonAVI(obj1,rvp(1).x,rvp(1).y,rvp(1).t,pos1.MoMtime,pos1.start_time,rvp(1).t)
hold on; 
plot([x1 ; x1(1)], [y1 ; y1(1)],'g'); 
plot_occupancy_grid(rvp(1).x,rvp(1).y,rvp(1).Xedges,rvp(1).Yedges,scale)
hold off
xlim([90 290]); ylim([60 260])

subplot(2,2,2)
title('Session 2 No rotation')
plotXYonAVI(obj2,rvp(2).x,rvp(2).y,rvp(2).t,pos2.MoMtime,pos2.start_time,rvp(2).t)
hold on; 
plot([x2 ; x2(1)], [y2 ; y2(1)],'g'); 
plot_occupancy_grid(rvp(2).x,rvp(2).y,rvp(2).Xedges,rvp(2).Yedges,scale)
hold off
xlim([340 540]); ylim([50 250]);

subplot(2,2,3)
plotXYonAVI(obj2, x2_rot, y2_rot,rvp(2).t,pos2.MoMtime,pos2.start_time,rvp(2).t, rot_sesh2)
hold on
plot_occupancy_grid(x2_rot, y2_rot, Xedges2_rot, Yedges2_rot, scale)
plot([x2_arena_rot; x2_arena_rot(1)], [y2_arena_rot; y2_arena_rot(1)],'g');
hold off
xlim([50 250]); ylim([100 300])

%% Apply lm to the data to see how it transforms them...

% Adjust data
x1_lmadj = predict(pos_corr(1).lm_x,.6246/.15*rvp(1).x');
y1_lmadj = predict(pos_corr(1).lm_y,.6246/.15*rvp(1).y');
x2_lmadj = predict(pos_corr(3).lm_x,.6246/.15*rvp(2).x');
y2_lmadj = predict(pos_corr(3).lm_y,.6246/.15*rvp(2).y');

% Scale data again because mouse coverage is still skewed a bit - IS THIS
% CORRECT?  DOUBLE CHECK THAT DVT to AVI function is putting the dot in the
% corect place at all four edges of arena...

% This scales one session to another, but maybe better would be to scale
% ALL position data to the same number in the x and y direction?  Would
% need to look at a number of data sets to do this...
% Note that I should do this for data in the square only at this point,
% since that's what I did the calibration on...
xscale = (max(x2_lmadj)-min(x2_lmadj))/(max(x1_lmadj)-min(x1_lmadj));
yscale = (max(y2_lmadj)-min(y2_lmadj))/(max(y1_lmadj)-min(y1_lmadj));



