function [ha, hstem, hsplit] = alt_plot_splitmetric_histos(metric, nactive_stem, ...
    sigbool, nstem_thresh, ha, norm_type, exclude_split)
% [ha, hstem, hsplit] = alt_plot_splitmetric_histos(metric, nactive_stem...
%     sigbool, nstem_thresh, ha)
%   Plots histograms of metric from alt_fig2 for all neurons that are active on at
%   least nstem_thresh trials and overlays it with distributions for
%   splitters that have at least sigthresh bins with their deltacurve p <
%   0.05.

if nargin < 7
    exclude_split = false; % exclude splitters from stem-cells
    if nargin < 6
        norm_type = 'Probability';
        if nargin < 5
            figure; set(gcf, 'Position', [2263         362         599         386]);
            ha = gca;
        end
    end
end

if ~exclude_split
    metric_stem = cellfun(@(a,b) a(b > nstem_thresh), metric, nactive_stem, ...
        'UniformOutput', false);
elseif exclude_split
    metric_stem = cellfun(@(a,b,c) a(b > nstem_thresh & ~c), metric, ...
        nactive_stem, sigbool, 'UniformOutput', false);
end
metric_split = cellfun(@(a,b,c) a(b > nstem_thresh & c), metric, ...
    nactive_stem, sigbool, 'UniformOutput', false);

hstem = histogram(ha, cat(1,metric_stem{:}),'Normalization', norm_type); 
ha.NextPlot = 'add'; % hold on
hsplit = histogram(ha, cat(1,metric_split{:}), hstem.BinEdges,...
    'Normalization', norm_type);
if ~exclude_split
    legend(ha, cat(1, hstem, hsplit), {'All Stem Neurons', 'Splitters'})
elseif exclude_split
    legend(ha, cat(1, hstem, hsplit), {'Stem Non-Splitters', 'Splitters'})
end
ylabel(norm_type);

end