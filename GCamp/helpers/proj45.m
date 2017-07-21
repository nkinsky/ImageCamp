function [ x45, y45 ] = proj45( xdata, ydata)
% [ x45, y45 ] = proj45( xdata, ydata)
%   Projects data onto 45 axes for histograms per Roux et al., 2017

r = sqrt(xdata.^2 + ydata.^2);
theta = atan2(ydata,xdata);
alpha = theta + 45;
x45 = r.*cos(alpha);
y45 = r.*sin(alpha);

end

