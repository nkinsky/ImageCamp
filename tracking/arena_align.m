function [pos_align] = arena_align(folder1, folder2, moviefolder1, moviefolder2, calib_file, rot_overwrite, xrestrict, yrestrict, manual_enable)
% [pos_align] = arena_align(folder1, folder2, moviefolder2, moviefolder2, calib_file, rot_overwrite xlim, ylim)
%   Function to align one session's data to another in the 2 environment
%   task.  Corrects for lens distortion, then does a secondary alignment to
%   make sure that the data in session 1 and session 2 have approximately
%   the same extents.  This will FAIL if the mouse does not have great
%   coverage of the arena, but otherwise should work out well.
%   rot_overwrite = 1 means there is NO rotation of the arena before
%   alignment, rot_overwrite = 0 or left blank means rotation happens
%   calib_file is the full path to the calibration file you want to use to
%   correct the distorted DVT coordinates back to whatever you define as
%   standard coordinates.
%   xrestrict and yrestrict will limit the valid x and y coordinates that can be
%   used, both are 2x1 arrays

if ~exist('Pix2Cm','var')
    Pix2Cm = 0.15; % Hack for room 201b for now...
end

if ~exist('limits_percent','var')
    limits_percent = 15;
end


%% File locations & rot_overwrite

if nargin >= 2
    curr_dir = cd;
    sesh(1).folder = folder1;
    sesh(2).folder = folder2;
    sesh(1).movie_folder = moviefolder1;
    sesh(2).movie_folder = moviefolder2;
elseif nargin == 0
    curr_dir = cd;
    sesh(1).folder = uigetdir('','Select Session 1 folder:');
    cd(sesh(1).folder);
    sesh(2).folder = uigetdir('','Select Session 2 folder:');
end

if ~exist('calib_file','var') || isempty(calib_file)
    calib_file = 'C:\Users\Nat\Dropbox\Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_hack.mat';
end

if ~exist('rot_overwrite','var') % Set rot_overwrite if not indicated
    rot_overwrite = 0;
end
    
%% Load position data and calibration file


cd(sesh(1).folder);
s1 = importdata('Pos.mat');
% s1.x = s1.xpos_interp;
% s1.y = s1.ypos_interp;
corr_flag1 = 'DVT';
cd(sesh(1).movie_folder);
movie_name = ls('*.h5');
cd(sesh(1).folder)
avi_name = ls('*.avi');
avi_path1 = [sesh(1).folder '\' avi_name];
[s1.t, s1.x, s1.y, s1.index_scopix_valid] = AlignImagingToTracking_NK(...
    [sesh(1).movie_folder '\' movie_name], '', s1.xpos_interp, s1.ypos_interp,...
    s1.time_interp, s1.MoMtime);

cd(sesh(2).folder);
movie_name = ls('*.h5');
s2 = importdata('Pos.mat');
s2.x = s2.xpos_interp;
s2.y = s2.ypos_interp;
corr_flag2 = 'DVT';
cd(sesh(2).movie_folder);
movie_name = ls('*.h5');
cd(sesh(2).folder)
avi_name = ls('*.avi');
avi_path2 = [sesh(2).folder '\' avi_name];
load(calib_file);
[s2.t, s2.x, s2.y, s2.index_scopix_valid] = AlignImagingToTracking_NK(...
    [sesh(2).movie_folder '\' movie_name], '', s2.xpos_interp, s2.ypos_interp,...
    s2.time_interp, s2.MoMtime);



% If xrestrict isn't specified, include everything
if ~exist('xrestrict','var') || isempty(xrestrict)
    xrestrict = [min([min(s1.x) min(s2.x)]) max([max(s1.x) max(s2.x)])];
    yrestrict = [min([min(s1.y) min(s2.y)]) max([max(s1.y) max(s2.y)])];
    [xrestrict, yrestrict] = tracking_to_cm_std( xrestrict, yrestrict, ...
    pos_corr(ind_use).lm_x, pos_corr(ind_use).lm_y, Pix2Cm, corr_flag1, 0);

end

% keyboard

%% Send 1st session to undistorted coordinates
% Get appropriate indices to use in pos_corr for grabbing linear models
ind_use = arrayfun(@(a) ~isempty(regexpi(sesh(1).folder,a.arena)),pos_corr) & ...
    arrayfun(@(a) ~isempty(regexpi(sesh(1).folder,a.location)),pos_corr);
[ s1.x_corr, s1.y_corr ] = tracking_to_cm_std( s1.x, s1.y, ...
    pos_corr(ind_use).lm_x, pos_corr(ind_use).lm_y, Pix2Cm, corr_flag1, limits_percent);


pos_restrict1 = s1.x_corr >= xrestrict(1) & s1.x_corr <= xrestrict(2) ...
    & s1.y_corr >= yrestrict(1) & s1.y_corr <= yrestrict(2);

x1_use = s1.x_corr(pos_restrict1);
y1_use = s1.y_corr(pos_restrict1);

[xlims, ylims] = get_occupancy_limits(x1_use,y1_use,limits_percent);

% arena_effective_size = [diff(xlims) diff(ylims)];

x_orig = xlims(1);
y_orig = ylims(1);

%% Send 2nd session to undistorted coordinates, rotate, scale, and align with 1st session
% Get appropriate indices to use in pos_corr for grabbing linear models
% keyboard

ind_use = arrayfun(@(a) ~isempty(regexpi(sesh(2).folder,a.arena)),pos_corr) & ...
    arrayfun(@(a) ~isempty(regexpi(sesh(2).folder,a.location)),pos_corr);   

% Search for rotation in pathnames...
if rot_overwrite == 1 % Don't rotate if flagged not to
    rot = 0;
elseif rot_overwrite == 0
    if ~isempty(regexpi(sesh(2).folder,'90CW'))
        rot = 90;
    elseif ~isempty(regexpi(sesh(2).folder,'90CCW'))
        rot = -90;
    elseif ~isempty(regexpi(sesh(2).folder,'180'))
        rot = 180;
    else
        rot = 0;
    end
end

[ s2x_int, s2y_int ] = tracking_to_cm_std( s2.x, s2.y, ...
    pos_corr(ind_use).lm_x, pos_corr(ind_use).lm_y, Pix2Cm, corr_flag2, limits_percent);

[ s2x_rot, s2y_rot ] = rotate_xy(s2x_int, s2y_int, rot, limits_percent, x_orig, y_orig);

pos_restrict2 = s2x_rot >= xrestrict(1) & s2x_rot <= xrestrict(2) & ...
    s2y_rot >= yrestrict(1) & s2y_rot <= yrestrict(2);

x2_use = s2x_rot(pos_restrict2);
y2_use = s2y_rot(pos_restrict2);


[xlims2, ylims2] = get_occupancy_limits(x2_use, y2_use, limits_percent);

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
subplot(2,3,1)
plot(s1.x,s1.y,'r'); title('Session 1 cm')
subplot(2,3,2)
plot(s2.x,s2.y,'b'); title('Session 2 cm')
subplot(2,3,4)
plot(s1.x_corr,s1.y_corr,'r',s2x_rot,s2y_rot,'b',[xlims(1) xlims(1) xlims(2) ...
    xlims(2) xlims(1)],[ylims(1) ylims(2) ylims(2) ylims(1) ylims(1)],'k--')
title('Session 1 with Session 2 rotated but NOT scaled')
subplot(2,3,5);
plot(s1.x_corr,s1.y_corr,'r',s2.x_corr,s2.y_corr,'b',[xlims(1) xlims(1) xlims(2) ...
    xlims(2) xlims(1)],[ylims(1) ylims(2) ylims(2) ylims(1) ylims(1)],'k--')
% Compare AVIs!!!
subplot(2,3,3)
plot_arena_rot(avi_path1, 0); title('Session 1 Un-rotated')
subplot(2,3,6)
plot_arena_rot(avi_path2, rot); title('Session 2 Rotated')

keyboard

%% Manually adjust if necessary
if manual_enable == 1
    manual_adj = 'n';
    hf = figure;
    while strcmpi(manual_adj,'n')
        % Re-plot originally scaled data
        figure(hf)
        plot(s1.x_corr,s1.y_corr,'r',s2.x_corr,s2.y_corr,'b',[xlims(1) xlims(1) xlims(2) ...
            xlims(2) xlims(1)],[ylims(1) ylims(2) ylims(2) ylims(1) ylims(1)],'k--')
        drawnow
        
        % Get limits manually
        disp('Draw rectangle for limits of red track')
        title('Draw rectangle for limist of red track (1st session)')
        s1_limits = getrect(hf);
        disp('Draw rectangle for limits of blue track');
        title('Draw rectangle for limist of blue track (2nd session)')
        s2_limits = getrect(hf);
        % Calculate scale factors
        manual_scale = s1_limits(3:4)./s2_limits(3:4);
        for j = 1:2
            manual_trans(j) = s1_limits(j) - s2_limits(j)*manual_scale(j);
        end
        s2x_manual = manual_scale(1)*s2.x_corr + manual_trans(1);
        s2y_manual = manual_scale(2)*s2.y_corr + manual_trans(2);
        
        figure(hf)
        plot(s1.x_corr,s1.y_corr,'r',s2x_manual,s2y_manual,'b',[xlims(1) xlims(1) xlims(2) ...
            xlims(2) xlims(1)],[ylims(1) ylims(2) ylims(2) ylims(1) ylims(1)],'k--')
        drawnow
        manual_adj = input('Is this ok (y/n)? ','s');
        
    end
    s2.x_corr = s2x_manual;
    s2.y_corr = s2y_manual;
    
end

%% Save scale factors? Probably...

pos_align.x = s1.x_corr;
pos_align.y = s1.y_corr;
pos_align.time_interp = s1.t;
pos_align.scale_x = [];
pos_align.scale_y = [];
pos_align.limits_percent = limits_percent;

cd(sesh(1).folder);
if rot_overwrite == 0
    save pos_corr_to_std pos_align
elseif rot_overwrite == 1
   save pos_corr_to_std_no_rotate pos_align 
end

pos_align.x = s2.x_corr;
pos_align.y = s2.y_corr;
pos_align.time_interp = s2.t;
pos_align.scale_x = scale_x;
pos_align.scale_y = scale_y;
pos_align.limits_percent = limits_percent;

cd(sesh(2).folder);
if rot_overwrite == 0
    save pos_corr_to_std pos_align
elseif rot_overwrite == 1
   save pos_corr_to_std_no_rotate pos_align 
end

% keyboard

cd(curr_dir); % Return to starting directory

end