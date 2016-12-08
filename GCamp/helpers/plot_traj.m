function [ ] = plot_traj(x, y, h, varargin )
%FC_plot_traj(x, y, h, ... )
%   Plots animal trajectory for FC experiment from data in x and y onto
%   axis handle h (new figure if no h is input or is empty).  Will
%   automatically scale to fit data and cut-out any tracking error unless
%   'no_zoom' varargin is specified

%% Parse inputs
smart_zoom = true;
if nargin == 2
    figure;
    h = gca;
end

for j = 1:length(varargin)
    if strcmpi(varargin{j},'no_zoom')
        smart_zoom = false;
    end
end

%% Calc zoom limits
if smart_zoom
    ind_good = ~(x == 0 & y == 0);
    x_adj = x(ind_good);
    y_adj = y(ind_good);
    [fx, xx] = ecdf(x_adj);
    [fy, yy] = ecdf(y_adj);
    xmin = xx(findclosest(fx,0.025)) - 30;
    xmax = xx(findclosest(fx,0.975)) + 30;
    ymin = yy(findclosest(fy,0.025)) - 30;
    ymax = yy(findclosest(fy,0.975)) + 30;
else
    x_adj = x;
    y_adj = y;
    xmin = min(xpos_interp);
    ymin = min(ypos_interp);
    xmax = max(xpos_interp);
    ymax = max(ypos_interp);
end

%% Plot it
axes(h);
plot(x_adj,y_adj)
xlim([xmin, xmax]);
ylim([ymin, ymax]);


end

