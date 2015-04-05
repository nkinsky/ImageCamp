% Even more simple arena alignment script

% global limits_percent

Pix2Cm = 0.15;
limits_percent = 5;


%% File locations
curr_dir = cd;
sesh(1).folder = uigetdir('','Select Session 1 folder:');
cd(sesh(1).folder);
sesh(2).folder = uigetdir('','Select Session 2 folder:');
cd(curr_dir); % Return to starting directory

% Adjust this appropriately if you aren't using dropbox to store all your
% files
dropbox_path = 'C:\Users\Nat\Dropbox\';
% calibration_file = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_correction.mat']; % Real
calibration_file = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_hack.mat']; % hack to use square lms for octagon and check if correction is good enough...

%% Load position data and calibration file

cd(sesh(1).folder);
s1 = importdata('Placemaps.mat');
cd(sesh(2).folder);
s2 = importdata('Placemaps.mat');

load(calibration_file);

%% Send 1st session to undistorted coordinates
% Get appropriate indices to use in pos_corr for grabbing linear models
ind_use = arrayfun(@(a) ~isempty(regexpi(sesh(1).folder,a.arena)),pos_corr) & ...
    arrayfun(@(a) ~isempty(regexpi(sesh(1).folder,a.location)),pos_corr);
[ s1.x_corr, s1.y_corr ] = tracking_to_cm_std( s1.x, s1.y, ...
    pos_corr(ind_use).lm_x, pos_corr(ind_use).lm_y, Pix2Cm, 'cm', limits_percent);

[xlims, ylims] = get_occupancy_limits(s1.x_corr,s1.y_corr,limits_percent);

arena_effective_size = [diff(xlims) diff(ylims)];

x_orig = xlims(1);
y_orig = ylims(1);

%% Send 2nd session to undistorted coordinates, rotate, scale, and align with 1st session
% Get appropriate indices to use in pos_corr for grabbing linear models
ind_use = arrayfun(@(a) ~isempty(regexpi(sesh(2).folder,a.arena)),pos_corr) & ...
    arrayfun(@(a) ~isempty(regexpi(sesh(2).folder,a.location)),pos_corr);

% Search for rotation in pathnames...
if ~isempty(regexpi(sesh(2).folder,'90CW')) 
    rot = 90;
elseif ~isempty(regexpi(sesh(2).folder,'90CCW')) 
    rot = -90;
elseif ~isempty(regexpi(sesh(2).folder,'180')) 
    rot = 180;
else
    rot = 0;
end

[ s2x_int, s2y_int ] = tracking_to_cm_std( s2.x, s2.y, ...
    pos_corr(ind_use).lm_x, pos_corr(ind_use).lm_y, Pix2Cm, 'cm', limits_percent);

[ s2x_rot, s2y_rot ] = rotate_xy(s2x_int, s2y_int, rot, limits_percent, x_orig, y_orig);

[xlims2, ylims2] = get_occupancy_limits(s2x_rot,s2y_rot,limits_percent);

scale_x = abs(diff(xlims)/diff(xlims2));
scale_y = abs(diff(ylims)/diff(ylims2));

xs2 = scale_x*s2x_rot;
ys2 = scale_y*s2y_rot;

[xlims3, ylims3] = get_occupancy_limits(xs2,ys2,limits_percent);

x_offset = x_orig - xlims3(1);
y_offset = y_orig - ylims3(1);

s2.x_corr = xs2 + x_offset;
s2.y_corr = ys2 + y_offset;
%% Plot the two for QC purposes

figure
subplot(2,2,1)
plot(s1.x,s1.y,'r'); title('Session 1 cm')
subplot(2,2,2)
plot(s2.x,s2.y,'b'); title('Session 2 cm')
subplot(2,2,3)
plot(s1.x_corr,s1.y_corr,'r',s2x_rot,s2y_rot,'b',[xlims(1) xlims(1) xlims(2) ...
    xlims(2) xlims(1)],[ylims(1) ylims(2) ylims(2) ylims(1) ylims(1)],'k--')
title('Session 1 with Session 2 rotated but NOT scaled')
subplot(2,2,4)
plot(s1.x_corr,s1.y_corr,'r',s2.x_corr,s2.y_corr,'b',[xlims(1) xlims(1) xlims(2) ...
    xlims(2) xlims(1)],[ylims(1) ylims(2) ylims(2) ylims(1) ylims(1)],'k--')

%% Save scale factors? Probably...