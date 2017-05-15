function [ h , colors_used] = plot_neuron_outlines( base_image, NeuronImage, varargin )
% [h, colors_used]  = plot_neuron_outlines( base_image, NeuronImage,  h)
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
%   OUTPUTS:
%       h: axes handle to plot
%
%       colors_used: color table, good for using with plot_neuron_traces

ip = inputParser;
ip.addRequired('base_image',@(a) isnumeric(a));
ip.addRequired('NeuronImage',@iscell);
ip.addOptional('h',nan,@ishandle);
ip.parse(base_image, NeuronImage, varargin{:});

h = ip.Results.h;

if ~ishandle(h)
    figure; h = gca;
end

axes(h)
if ~isnan(sum(base_image(:)))
    imagesc_gray(base_image); colorbar off; axis off
end
hold on

num_neurons = length(NeuronImage);
colors_used = nan(num_neurons,3);

for j = 1:num_neurons
    b = bwboundaries(NeuronImage{j},'noholes');
    hline = plot(b{1}(:,2),b{1}(:,1));
    hline.LineWidth = 2;
    colors_used(j,:) = hline.Color;
end
hold off

end

