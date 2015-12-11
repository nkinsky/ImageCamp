function [ xtrans, ytrans ] = circ2square( xpos_circ, ypos_circ, square_side, circle_radius,varargin )
% [ xtrans, ytrans ] = circ2square( xpos_circ, ypos_circ, square_side, circle_radius )
% Takes position data from the circle environment and transforms it to
% square coordinates.
%
% INPUTS
%

%% Parameters

kc = circle_radius; % cm
ks = square_side/2; % pi()*kc/2; % cm
R_c = kc;

%% Un-skew position data by scaling both x and y to the true radius
[f, x] = ecdf(xpos_circ);
xspan = x(find(f > 0.95,1,'first')) - x(find(f < 0.05,1,'last'));
[f, y] = ecdf(ypos_circ);
yspan = y(find(f > 0.95,1,'first')) - y(find(f < 0.05,1,'last'));

x_use = xpos_circ*circle_radius/xspan;
y_use = ypos_circ*circle_radius/yspan;

%% Transform circle cartesian data to polar coordinates

% First center everything
[fx, x] = ecdf(x_use);
[fy, y] = ecdf(y_use);
xmid = (x(find(fx > 0.95,1,'first')) + x(find(fx < 0.05,1,'last')))/2;
ymid = (y(find(fy > 0.95,1,'first')) + y(find(fy < 0.05,1,'last')))/2;

xcent = x_use - xmid;
ycent = y_use - ymid;

% Get polar coordinates
r_c = sqrt(xcent.^2 + ycent.^2);
theta = atan2(ycent,xcent);

%% Transform circle polar cooridnates to square polar coorinates
% Using algorithm from Lever et. al, Nature, 2002

% Get square radius
R_s = zeros(size(theta));
for j = 1:length(theta)
    if theta(j) < -3*pi/4 || (-pi/4 < theta(j) & theta(j) < pi/4) || (3*pi/4 < theta(j) & theta(j) < 5*pi/4)
        R_s(j) = ks*sqrt(1 + tan(theta(j))^2);
    else
        R_s(j) = ks*sqrt(1 + 1/tan(theta(j))^2);
    end
    
end

r_cprime = r_c.*R_s/R_c;

%% Transform square polar to cartesian
xtrans = r_cprime.*cos(theta) + xmid;
ytrans = r_cprime.*sin(theta) + ymid;

end

