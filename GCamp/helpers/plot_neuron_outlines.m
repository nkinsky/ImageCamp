function [ h , colors_used, hline] = plot_neuron_outlines( base_image, NeuronImage, varargin )
% [h, colors_used, hline]  = plot_neuron_outlines( base_image, NeuronImage,  h, varargin)
%   plot outlines of neurons on top of the base image.  h is optional.  
%   h (output) is axis handle to plot, and colors_used is
%   a rgb array where each line is the color used to plot that neuron's
%   outline.
%
%   INPUTS:
%       base_image: Usually imread('ICmovie_min_proj.tif').  Set as NaN to
%       skip plotting this part and either plot onto white or onto an
%       existing plot
%
%       NeuronImage: from FinalOutpu.mat
%
%       h (optional): axes handle to plot into
%
%       colors (parameter): [r g b] color to use.  1 row = use for all the
%       neurons, can also specify a different color for each row
%
%   OUTPUTS:
%       h: axes handle to plot
%
%       colors_used: color table, good for using with plot_neuron_traces

%% Parse inputs
num_neurons = length(NeuronImage);

ip = inputParser;
ip.addRequired('base_image',@(a) isnumeric(a));
ip.addRequired('NeuronImage',@iscell);
ip.addOptional('h',nan,@ishandle);
ip.addParameter('colors', nan, @(a) (isnumeric(a) && size(a,2) == 3) || ...
    (ischar(a) && length(a) == num_neurons));
ip.addParameter('scale_bar',true, @islogical)
ip.parse(base_image, NeuronImage, varargin{:});

h = ip.Results.h;
colors = ip.Results.colors;
scale_bar = ip.Results.scale_bar;

%% Set up variables and figures
if ~ishandle(h)
    figure; h = gca;
end

if ~isnan(colors)
   cust_col_flag = true; 
   if size(colors,1) == 1
       cust_colors = repmat(colors, num_neurons,1);
   elseif size(colors,1) ~= num_neurons
       error('number of custom colors specified does not match number of neurons')
   elseif size(colors,1) == num_neurons
       cust_colors = colors;
   end
elseif isnan(colors)
    cust_col_flag = false;
end

%% Plot base image
axes(h)
if ~isnan(sum(base_image(:)))
    imagesc_gray(base_image); colorbar off; 
end
hold on

%% Plot neurons in red, custom colors on specified neurons
colors_used = nan(num_neurons,3);

for j = 1:num_neurons
    b = bwboundaries(NeuronImage{j},'noholes');
    if ~cust_col_flag
        hline(j) = plot(b{1}(:,2),b{1}(:,1));
    elseif cust_col_flag
        hline(j) = plot(b{1}(:,2),b{1}(:,1),'Color',cust_colors(j,:));
    end
    hline(j).LineWidth = 2;
    colors_used(j,:) = hline(j).Color;
end
if num_neurons == 0
    hline = plot(nan, nan,'Color',colors(1,:));
end

%% Plot scale bar
if scale_bar
    bar_size = 100; % microns at 2x downsampling
    y_loc = max(arrayfun(@(a) max(a.YData), ...
        h.Children(isgraphics(h.Children,'line'))))+25;
    plot([0 bar_size*1.1], [y_loc y_loc],'LineWidth',5,'Color','k');
    text(bar_size*1.1+5,double(y_loc),'100 \mum')
end

hold off
axis equal
axis tight
axis off



end

