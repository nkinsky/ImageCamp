function [ y_interp ] = lin_interp( x ,y, x_interp )
%lin_interp Linear interpolation between two data points
% INPUT VARIABLES
%   x:          1 x 2 array
%   y:          1 x 2 array
%   x_interp:   point between x(1) and x(2) for which you wish to
%               interpolate
% OUTPUT VARIABLES
% y_interp:     y value at x_interp

if all(x_interp == x) % if x_interp is exactly equal to a value in x
    y_interp = y(1);
elseif (sum(x_interp < x) == 0 || sum(x_interp >= x) == 0) && ...
        (sum(x_interp == x) ~= 2)
    error('x_interp is outside the range of x')
else % perform interpolation if x_interp is within x
    y_interp = (y(2)-y(1))/(x(2)- x(1))*(x_interp-x(1)) + y(1);
end

end

