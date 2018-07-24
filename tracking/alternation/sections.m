function [bounds, rot_x, rot_y, rotang] = sections(x, y, skip_rot_check, varargin)
% [bounds, rot_x, rot_y, rot_ang] = sections(x, y, skip_rot_check, ...)
%   
%   This function takes position data and partitions the maze into
%   sections. 
%
%   INPUTS: 
%       X and Y: Position vectors after passing through
%       PreProcessMousePosition. 
%       skip_rot_check = 0(default if blank): perform manual check of rotation of
%           maze, 1: skip manual check - use this if you know you have already
%           performed a rotation and have a previously saved 'rotated.mat' file
%           in the working directory
%       manual_rot_overwrite(optional): default = 0, 1 will perform manual
%       rotation even if 'rotated.mat' exists in the working directory.
%       Use this to overwrite previously performed rotations. Sample use:
%       sections(x,y,0,'manual_rot_overwrite',1).,
%
%   OUTPUTS: 
%       BOUNDS: Struct containing coordinates for the corners of maze
%       sections in the following intuitively-named fields. 
%           base = Start position (vertical stripes side). 
%           center = Middle stem. 
%           choice = Choice point (triangle side). 
%           approach_l = Approaching left arm. 
%           approach_r = Approaching right arm. 
%           left = Left arm. 
%           right = Right arm. 
%           return_l = Returning to start position from left arm.
%           return_r = Returning to start position right right arm. 
%           goal_l = in reward zone on left arm.
%           goal_r = in reward zone on right arm.
%

%% Get varargins
manual_rot_overwrite = 0; % default value
for j = 1:length(varargin)
   if strcmpi(varargin{j},'manual_rot_overwrite') 
      manual_rot_overwrite = varargin{j+1}; 
   end
end
%% Assign skip_rot_check if not specified
if ~exist('skip_rot_check','var') || ~exist(fullfile(pwd,'rotated.mat'),'file')
    skip_rot_check = 0;
end
%% Correct for rotated maze. 
skewed = 1;
while skewed
    
    if exist(fullfile(pwd,'Pos_align.mat'),'file') % Skip rotating if already done.
        [rot_x,rot_y,rotang] = rotate_traj(x,y,0);
        disp('Rotated data already found in Pos_align.mat')
    else
        %Try loading previous rotation angle.
        try
            load(fullfile(pwd,'rotated.mat'));
            disp('Rotated data already found in rotated.mat')
            % Run the rotation anyway if manual override is specified
            if manual_rot_overwrite == 1
                [rot_x,rot_y,rotang] = rotate_traj(x,y);
            end
        catch
            [rot_x,rot_y,rotang] = rotate_traj(x,y);
        end
    end
    
    
    %% Get xy coordinate bounds for maze sections.
    xmax = max(rot_x); xmin = min(rot_x);
    ymax = max(rot_y); ymin = min(rot_y);
    
    %% Establish maze arm boundaries.
    w = (ymax-ymin)/5; %40;   Width of arms.
    l = (xmax-xmin)/8.1; %80;   Shift from top/bottom of maze for center stem.
    
    %Find center arm borders.
    center = getcenterarm(rot_x,rot_y,w,l);
    
    %Left arm.
    left.x = [xmin+l, xmax, xmax, xmin+l];
    left.y = [ymin, ymin, ymin+w, ymin+w];
    
    %Right arm.
    right.x = left.x;
    right.y = [ymax-w, ymax-w, ymax, ymax];
    
    %Left return.
    return_l.x = [xmax-l, xmax, xmax, xmax-l];
    return_l.y = [ymin+w, ymin+w, center.y(1), center.y(1)];
    
    %Right return.
    return_r.x = return_l.x;
    return_r.y = [center.y(3), center.y(3), ymax-w, ymax-w];
    
    %Choice.
    choice.x = [xmin, xmin+l, xmin+l, xmin];
    choice.y = [center.y(1), center.y(1), center.y(3), center.y(3)];
    
    %Left approach.
    approach_l.x = choice.x;
    approach_l.y = [ymin, ymin, center.y(1), center.y(1)];
    
    %Right approach.
    approach_r.x = choice.x;
    approach_r.y = [center.y(3), center.y(3), ymax ymax];
    
    %Base.
    base.x = return_l.x;
    base.y = choice.y;
    
    %Right Goal
    xmin_g = 0.7*(xmax-xmin)+xmin;
    xmax_g = xmin_g + 0.1*(xmax-xmin);
    goal_r.x = [xmin_g xmax_g xmax_g xmin_g]; % Seems to work ok for our current maze...
    goal_r.y = right.y;
    
    %Left Goal
    goal_l.x = goal_r.x;
    goal_l.y = left.y;
    
    %% Check with plot.
    if skip_rot_check == 0 % Skip plotting if skip_rot_check = 1;
        figure(555);
        plot(rot_x,rot_y);
        hold on;
        plot([left.x left.x(1)],[left.y left.y(1)], 'k-', ...
            [right.x right.x(1)],[right.y right.y(1)], 'k-', ...
            [return_l.x return_l.x(1)], [return_l.y return_l.y(1)], 'k-', ...
            [return_r.x return_r.x(1)], [return_r.y return_r.y(1)], 'k-', ...
            [center.x center.x(1)], [center.y center.y(1)], 'k-', ...
            [base.x base.x(1)], [base.y base.y(1)], 'g-', ...
            [approach_l.x approach_l.x(1)], [approach_l.y approach_l.y(1)], 'k-', ...
            [approach_r.x approach_r.x(1)], [approach_r.y approach_r.y(1)], 'k-', ...
            [choice.x choice.x(1)], [choice.y choice.y(1)], 'r-');
        hold off;
        
        %Sanity check for trajectory rotation.
        if manual_rot_overwrite == 1
            satisfied = input('Are you satisfied with the rotation? Enter y or n-->','s');
        elseif manual_rot_overwrite == 0
            satisfied = 'y';
        end
        
        if strcmp(satisfied,'y')       %Break.
            skewed = 0;
            if manual_rot_overwrite == 1
                save rotated rotang rot_x rot_y;
            end
        elseif strcmp(satisfied,'n');  %Delete last rotation and try again.
            if exist(fullfile(pwd, 'rotated.mat'), 'file') == 2
                delete rotated.mat;
            end
            close all;
        end
    elseif skip_rot_check == 1
        skewed = 0;
    end
    
end

%% Output. 
    bounds.base = base; 
    bounds.center = center; 
    bounds.choice = choice;
    bounds.approach_l = approach_l;
    bounds.approach_r = approach_r; 
    bounds.left = left; 
    bounds.right = right; 
    bounds.return_l = return_l;
    bounds.return_r = return_r; 
    bounds.goal_l = goal_l;
    bounds.goal_r = goal_r;
end
