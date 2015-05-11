function bounds = sections(x,y,plot_flag)
%function sections(x,y,plot_flag) 
%   
%   This function takes position data and partitions the maze into
%   sections. 
%
%   INPUTS: 
%       X and Y: Position vectors after passing through
%       PreProcessMousePosition. 
%       plot_flag: 1 = plot out bounds (default), 0 = suppress plotting.
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
%           goal_l = in reward zone on left arm
%           goal_r = in reward zone on right arm

%% Check for plot_flag
if ~exist('plot_flag','var')
    plot_flag = 1; % Set to one if not specified
end

%% Get xy coordinate bounds for maze sections. 
    xmax = max(x); xmin = min(x); 
    ymax = max(y); ymin = min(y); 
    
    %Establish maze arm widths. 
    w = (ymax-ymin)/6.5; %40; %Width of arms.
    l = (xmax-xmin)/8.1; % 80; %Shift from top/bottom of maze for center stem. 
    
    %Find center arm borders. 
    center = getcenterarm(x,y,w,l); 
      
%% Left arm. 
    left.x = [xmin, xmin, xmax, xmax];
    left.y = [ymin, ymin+w, ymin, ymin+w]; 
    
%% Right arm. 
    right.x = left.x;
    right.y = [ymax-w, ymax, ymax-w, ymax]; 
    
%% Left return. 
    return_l.x = [xmax-l, xmax-l, xmax, xmax]; 
    return_l.y = [ymin+w, center.y(1), ymin+w, center.y(1)]; 
    
%% Right return. 
    return_r.x = return_l.x;  
    return_r.y = [center.y(2), ymax-w, center.y(2), ymax-w]; 
    
%% Choice. 
    choice.x = [xmin, xmin, xmin+l, xmin+l]; 
    choice.y = [center.y(1), center.y(2), center.y(1), center.y(2)];
    
%% Left approach. 
    approach_l.x = choice.x;  
    approach_l.y = [left.y(2), center.y(1), left.y(2), center.y(1)]; 

%% Right approach. 
    approach_r.x = choice.x;
    approach_r.y = [center.y(2), right.y(1), center.y(2), right.y(1)]; 
    
%% Base. 
    base.x = return_l.x; 
    base.y = choice.y; 
    
%% Right Goal
    xmin_g = 0.7*(xmax-xmin)+xmin;
    xmax_g = xmin_g + 0.1*(xmax-xmin);
    goal_r.x = [ xmin_g xmin_g xmax_g xmax_g]; % Seems to work ok for our current maze...
    goal_r.y = right.y; 
%% Left Goal
    goal_l.x = goal_r.x;
    goal_l.y = left.y;
%% Check with plot. 
    if plot_flag == 1 % Suppress plotting if plot_flag == 0
        figure;
        plot(x,y);
        hold on;
        plot(left.x,left.y, 'r*', right.x, right.y, 'b.', return_l.x, return_l.y, 'k.',...
            return_r.x, return_r.y, 'k.', choice.x, choice.y, 'g.', center.x, center.y, 'm.',...
            base.x, base.y, 'g*', approach_l.x, approach_l.y, 'b.', approach_r.x, approach_r.y, 'k*');
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
    bounds.goal_l = goal_r;
    bounds.goal_r = goal_l;
end
