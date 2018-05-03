function [ y_interp ] = lin_interp2( xarray, yarray, x_interp )
% y_interp = lin_interp2( xarray, yarray, x_interp )
%   Linearly interpolates between the two closest points in x_interp.

% Find indices of values on either side of x_interp in xarray
[id1,id2] = get_lin_bounds(x_interp, xarray);

% Get x and y values on either side of x_interp
xlocal = xarray([id1, id2]); 
ylocal = yarray([id1, id2]);
y_interp = lin_interp(xlocal,ylocal,x_interp);




end

