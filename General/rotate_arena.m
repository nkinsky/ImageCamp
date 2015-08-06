function [ x_rot, y_rot ] = rotate_arena( x, y, rot)
%[ x_rot, y_rot ] = rotate_xy( x, y, rot ) 
%
%   INPUTS
%   x and y: arrays of position data that you wish to rotate
%
%   rot: in degress, how much you wish to rotate the data.   There are 
%   three options: -90 (CW), 90 (CCW), and 180
%
%   OUTPUTS
%   x_rot, y_rot: new x and y coordinates after rotation, translated back
%   to the original min of x and y

% Get original min coordinates
x_orig = min(x);
y_orig = min(y);

% perform the rotation
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
x_rot_min = min(x_rot); dx = x_orig - x_rot_min;
y_rot_min = min(y_rot); dy = y_orig - y_rot_min;

x_rot = x_rot + dx;
y_rot = y_rot + dx;

end

