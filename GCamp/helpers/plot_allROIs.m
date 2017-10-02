function [ h ] = plot_allROIs( ROIs, ref_image, h, extra_neurons_plot )
% h = plot_allROIs( ROIs, ref_image, h, extra_neurons_plot )
%   Plot all ROI outlines.  If ref_image is specified (typically the maximum
%   projection of the motion corrected movie). Specify as imread(ref_image)
%   to avoid most problems.
%
%   INPUTS
%       ROIs: NeuronImage from FinalOutput.mat or selected subset
%
%       ref_image (optional): Reference image (min or max projection
%       usually) to plot ROIs on
%
%       h (optional): axes handle to previous plot
%
%       extra_neurons_plot (optional): not really sure why I added this...

num_neurons = length(ROIs);

%% Make ref_image white background if not specified
if nargin < 2
    ref_image = zeros(size(ROIs{1}));
end

if nargin < 3
    figure;
    h = gca;
end

%% Get boundaries
b = cell(1, num_neurons);
for j = 1:num_neurons
    try
        temp = bwboundaries(ROIs{j});
    catch
        disp(['Error in ROI # ' num2str(j)])
        temp{1} = [1 1];
    end
    b{j} = temp{1};
end

%% Plot stuff
axes(h)
imagesc_gray(ref_image)
hold on
for j = 1:num_neurons
    plot(b{j}(:,2),b{j}(:,1),'r')
end

%%
if exist('extra_neurons_plot','var')
    hold on
    for k = 1:length(extra_neurons_plot)
        j = extra_neurons_plot(k);
        plot(b{j}(:,2),b{j}(:,1))
    end
    hold off
end
axis off
colorbar off

end

