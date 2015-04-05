function [ x_rot, y_rot ] = rotate_xy( x, y, rot, limits_percent, x_orig, y_orig)
%[ x_rot, y_rot ] = rotate_xy( x, y, rot ) 
%   x and y are arrays of position data that you wish to rotate
%   rot: degrees of rotation.  There are three options: -90 (CW), 90 (CCW),
%   and 180
%   limits_percent: input to get_occupancy_limits specifying what
%   percentage of points to ignore when calculating the minimum and maximum
%   of your data
%   x_rot and y_rot are the rotated coordinates that are also translated
%   such that the bottom left coordinate (xmin, ymin) is at the location of
%   xmin,ymin in the original coordinates.  Alternatively, if you specify
%   x_orig and y_orig you can set this origin to any point you wish.


% Set origin
if nargin == 4 % Set at min of original coordinates
    [xlim_orig, ylim_orig] = get_occupancy_limits(x, y, limits_percent);
    xmin = xlim_orig(1);
    ymin = ylim_orig(1);
elseif nargin == 6 % Set at specified coordinates
    xmin = x_orig;
    ymin = y_orig;
end
    
if rot == 90 % CW
    
    x_rot = -y;
    y_rot = x;

elseif rot == - 90 % CCW
    
    x_rot = y;
    y_rot = -x;
    
elseif rot == 180
    
    x_rot = -x;
    y_rot = -y;
    
elseif rot == 0
    x_rot = x;
    y_rot = y;
else
    error('You have not entered a valid argument for "rot"')
end

% Translate back to origin (either original or specified)

[xlims, ylims] = get_occupancy_limits( x_rot, y_rot, limits_percent);

dx = xmin - xlims(1);
dy = ymin - ylims(1);

% dx = xmin - min(x_rot);
% dy = ymin - min(y_rot);

x_rot = x_rot + dx;
y_rot = y_rot + dy;


end

