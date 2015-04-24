function [ ] = match_xylim( hlist )
% match_xylim( hlist )
% takes list of axes handles in hlist (in data structure format), gets the max and min x and y limits,
% and sets it the same for all axes.  hlist is in the format hlist(i).h.

% Get max and min for ALL figures in the list
for j = 1:size(hlist,2);
    axes(hlist(j).h);
    tempx = get(gca,'XLim');
    tempy = get(gca,'YLim');
    if j == 1
        xlimits = tempx;
        ylimits = tempy;
    end
    xlimits(1) = min([xlimits(1) tempx(1)]);
    xlimits(2) = max([xlimits(2) tempx(2)]);
    ylimits(1) = min([ylimits(1) tempy(1)]);
    ylimits(2) = max([ylimits(2) tempy(2)]);
end

% Set the same limits for all figures
for j = 1:size(hlist,2)
    axes(hlist(j).h)
    set(gca,'XLim',xlimits)
    set(gca,'YLim',ylimits)
end
end

