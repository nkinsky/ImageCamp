function [ pos ] = get_center_bounds( xBin, yBin, Alt )
% pos = get_center_bounds( xBin, yBin, Alt )
%   Detailed explanation goes here

yoffset = 1;

xmin = min(xBin(Alt.section == 2));
xmax = max(xBin(Alt.section == 2));
ymin = min(yBin(Alt.section == 2));
ymax = max(yBin(Alt.section == 2));
w = xmax - xmin;
h = ymax - ymin + 3*yoffset;

pos = [xmin + 1, ymin - yoffset, w, h];


end

