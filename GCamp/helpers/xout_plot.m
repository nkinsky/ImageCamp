function [ ha ] = xout_plot( ha )
% xout_plot( ha )
%   Puts a dashed red x through a plot to denote it isn't good or something
%   but you are reluctant to delete it from code yet

if nargin == 0
    ha = gca;
end

hold_status = get(gca,'NextPlot');
xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
hold on
plot(xlims,ylims,'r-.',xlims,circshift(ylims,1),'r-.')

set(gca, 'NextPlot', hold_status,'XLim',xlims,'YLim',ylims);

end

