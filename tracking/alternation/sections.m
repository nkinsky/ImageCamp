function [bounds,rot_x,rot_y] = sections(x,y)
%function sections(x,y)
%   
%   This function takes position data and partitions the maze into
%   sections. 
%
%   INPUTS: 
%       X and Y: Position vectors after passing through
%       PreProcessMousePosition. 
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

%% Correct for rotated maze. 
    skewed = 1;
    while skewed
        
        %Try loading previous rotation angle. 
        try load('rotated.mat');
            
        catch
            [rot_x,rot_y,rotang] = rotate_traj(x,y);
        end
        
    %% Get xy coordinate bounds for maze sections. 
        xmax = max(rot_x); xmin = min(rot_x); 
        ymax = max(rot_y); ymin = min(rot_y); 

    %% Establish maze arm boundaries. 
        w = (ymax-ymin)/6.2; %40;   Width of arms.
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
        goal_r.x = [xmin_g xmax_g xmin_g xmax_g]; % Seems to work ok for our current maze...
        goal_r.y = right.y; 

    	%Left Goal
        goal_l.x = goal_r.x;
        goal_l.y = left.y;

    %% Check with plot.   
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
        satisfied = input('Are you satisfied with the rotation? Enter y or n-->','s'); 
        if strcmp(satisfied,'y')       %Break.
            skewed = 0;         
            save rotated rotang rot_x rot_y;
        elseif strcmp(satisfied,'n');  %Delete last rotation and try again.
            if exist('rotated.mat','file') == 2
                delete rotated.mat;
            end
            close all;          
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
