function [ x_lim, y_lim ] = get_occupancy_limits( x, y, percent )
% [ x_lim y_lim ] = get_occupancy_limits( x, y, percent )
%   Takes input tracking data "x" and gets the limits of that data.
%   Computes an ecdf of the occupancy data, then finds the limits based on
%   excluding a percentage of data at each end
%
%   x: input tracking data
%   percent: total percentage of data you wish to exclude from each end of
%   the data.  e.g if you specify 5%, xmin is the value of x at which 2.5%
%   of the total occupancy data falls below, and xmax is the value of x at
%   which 2.5% of the occupancy data falls above.
%
%   x_lim and y_lim: min and max values of occupancy data

[f_x, xe_x] = ecdf(x);
[f_y, xe_y] = ecdf(y);


x_lim(1) = xe_x(find(f_x > percent/100/2, 1 ));
x_lim(2) = xe_x(find(f_x < (1 - percent/100/2), 1, 'last' ));
y_lim(1) = xe_y(find(f_y > percent/100/2, 1 ));
y_lim(2) = xe_y(find(f_y < (1 - percent/100/2), 1, 'last' ));




end

