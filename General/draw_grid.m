function [] = draw_grid( ax, Xedges, Yedges, scale )
%draw_grid( h, Xedges, Yedges, scale )
%   Draw occupancy grid edges on a axis ax.  Xedges and Yedges are the grid
%   edges, scale is the factor to multiply the values by

Xedges = scale*Xedges;
Yedges = scale*Yedges;

axes(ax); % Set axes
hold on

for i = 1:length(Xedges)
    z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z,'Color','r');
end

for i = 1:length(Yedges)
    z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z,'Color','r');
end

axis tight;
hold off

end

