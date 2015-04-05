function [ ] = plot_occupancy_grid( x, y, Xedges, Yedges, scale, color)
% plot_occupancy_grid( x, y, Xedges, Yedges)
%   Plot animal trajectory and grid used to calculate occupancy/velocity
% 	Note that this assumes you have set a figure to plot to previous to
% 	running this function.  scale is an optional input

% Scale coordinates if applicable
if nargin < 5
    scale = 1;
    color = 'r';
elseif nargin < 6
    color = 'r';
end
x = scale*x;
y = scale*y;
Xedges = scale*Xedges;
Yedges = scale*Yedges;


plot(x,y);

hold on

% draw all of the edges
for i = 1:length(Xedges)
    z1 = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z1,'Color',color);
end

for i = 1:length(Yedges)
    z2 = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z2,'Color',color);
end

axis tight;


end

