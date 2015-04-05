function [grid_info] = assign_occupancy_grid(x, y, cmperbin, no_adjust)
% [Xedges, Yedges, cmperbin] = assign_occupancy_grid(x, y, cmperbin, adjust_option)
%
% This fuction takes x and y tracking data, creates an occupancy grid at
% spacing cmperbin, and plots it out.
% no_adjust: when set to 1, adjusting the cmperbin within the function is
% disabled.  If set to 0 or omitted, adjustment is allowed.

% NRK to-do
% 1) run occupancy limits function to get Xrange and Yrange, spit this out
% for future reference so that you don't ever have to run this again and we
% have the limits for future use in reverse_placefield function
% 2) Make it so you can use either cmperbin or num_bins...back calculate
% cmperbin if num_bins entered...

bin_ok = 'n';

h = figure;
while ~strcmpi(bin_ok,'y')
    
    Xrange = max(x)-min(x); % NRK - run occupancy limits function here to get Xrange and Yrange
    Yrange = max(y)-min(y);
    
    NumXBins = ceil(Xrange/cmperbin);
    NumYBins = ceil(Yrange/cmperbin);
    
    Xedges = (0:NumXBins)*cmperbin+min(x);
    Yedges = (0:NumYBins)*cmperbin+min(y);
    
    figure(h); plot(x,y); hold on
    
    % draw all of the edges
    for i = 1:length(Xedges)
        z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
        set(z,'Color','r');
    end
    
    for i = 1:length(Yedges)
        z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
        set(z,'Color','r');
    end
    
    axis tight; hold off
    
    % Don't allow adjustment of cmperbin if indicated
    if ~exist('no_adjust','var') || no_adjust == 0
        bin_ok = input('Is this ok? Type y/n, or c to adjust cmperbin: ','s');
    elseif no_adjust == 1
        bin_ok = 'y';
    end
    
    if strcmpi(bin_ok,'c')
        cmperbin = input('Enter new value for cmperbin: ');
        bin_ok = 'n';
    end
end

close(h)

grid_info.Xedges = Xedges;
grid_info.Yedges = Yedges;
grid_info.NumXBins = NumXBins;
grid_info.NumYBins = NumYBins;
grid_info.cmperbin = cmperbin;

save occupancy_grid_info grid_info
   
    
end