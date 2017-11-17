function [ hax, vidobj_out ] = plot_vidframe( vidobj_in, time_plot, varargin )
% [hax, vidobj_out ] = plot_vidframe( vidobj_in, time_plot, varargin )
%   Plots frame in VideoReader object vidobj_in at time_plot. Can specify existing
%   hax (axes handle) to plot to with parameter 'hax'. 'flip_vert'
%   parameter set to true flips the maze vertical (e.g. about a horizontal
%   line)

%% Parse Inputs
ip = inputParser;
ip.addRequired('vidobj_in',@isobject);
ip.addRequired('time_plot',@(a) a >= 0);
ip.addParameter('hax', nan, @ishandle);
ip.addParameter('flip_vert', false, @islogical);
ip.parse(vidobj_in, time_plot, varargin{:})

% Make new axes if not specified
hax = ip.Results.hax;
flip_vert = ip.Results.flip_vert;
if ~ishandle(hax)
    figure; hax = gca;
end
%% Upate time and plot
vidobj_in.CurrentTime = time_plot;
axes(hax)

% Flip it if required
frame_plot = readFrame(vidobj_in);
if flip_vert
    frame_plot = flipud(frame_plot);
end
imagesc(frame_plot)

vidobj_out = vidobj_in;

end

