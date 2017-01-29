function [ ] = reg_qc_plot(centroid_dist, orient_diff, avg_corr, varargin )
% reg_qc_plot(centroid_dist, orient_diff, avg_corr, h )
%  Plot neuron registration metrics.  Leave empty to omit plots.  h is a
%  handle to an existing figure (if ommitted it will plot to a new figure).
%  'multi_sesh' parameter set to true/1 plots all as ecdfs.  Otherwise,
%  they are plotted as histograms.

% NRK - convert pixels into microns

p = inputParser;
p.addRequired('centroid_dist', @isnumeric)
p.addRequired('orient_diff', @isnumeric)
p.addRequired('avg_corr', @isnumeric)
p.addOptional('h', 0, @ishandle)
p.addParameter('plot_shuf', 0, @(a) isnumeric(a) || a == 0 || a == 1 || a == 2); % 0 = normal, 1 = shuffled, 2 = shifted
p.addParameter('multi_sesh', false, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('dist_edges', 0:0.1:3, @isnumeric);
p.addParameter('orient_edges', 0:5:180, @isnumeric);
p.parse(centroid_dist, orient_diff, avg_corr, varargin{:});

h = p.Results.h;
multi_sesh = p.Results.multi_sesh;
plot_shuf = p.Results.plot_shuf;
dist_edges = p.Results.dist_edges;
orient_edges = p.Results.orient_edges;

% dist_centers = mean([dist_edges(1:end-1); dist_edges(2:end)]);
% orient_centers = mean([orient_edges(1:end-1); orient_edges(2:end)]);


if h == 0
    h = figure;
end

figure(h)

if ~isempty(centroid_dist)
    
    % Histogram plot
    subplot(2,2,1)
    hold on
    histplotfun(centroid_dist, dist_edges, multi_sesh, 0, 'count');
    xlabel('Centroid Distance (pixels)')
    hold off
    
    % ecdf plot
    subplot(2,2,3)
    hold on
    ecdfplotfun(centroid_dist, plot_shuf)
    xlabel('Centroid Distance (pixels)')
    ylabel('F(Centroid Distance)')
end

if ~isempty(orient_diff)
    subplot(2,2,2)
    hold on
    histplotfun(abs(orient_diff), orient_edges, multi_sesh, plot_shuf, 'probability')
    xlabel('Absolute Orientation Difference (\theta, degrees)')
    hold off
    
    subplot(2,2,4)
    hold on
    ecdfplotfun(abs(orient_diff), plot_shuf)
    xlabel('Absolute Orientation Difference (\theta, degrees)')
    ylabel('F(\theta)')
end

        
%         if ~isempty(avg_corr)
%             subplot(2,2,3)
%             hold on
%             plotfun(avg_corr, plot_shuf)
%             xlabel('Average ROI Activation Correlation (x)')
%             ylabel('F(x)')
%             hold off
%         end
        

end

%% ecdf Plot sub-function
function [] = ecdfplotfun(a, shuf)

if shuf == 0
    ecdf(a);
elseif shuf == 1 || shuf == 2
    [f, x] = ecdf(a);
    hs2 = stairs(x,f);
    set(hs2,'LineStyle','--','Color','k')
end

end

%% histogram plot sub-function
function [] = histplotfun(a, edges, multi_sesh, plot_shuf, normalization)

centers = mean([edges(1:end-1); edges(2:end)]);

if ~multi_sesh && ~plot_shuf
    % Plot bars with count
    if strcmpi(normalization,'count')
        histogram(a, edges);
        ylabel('Count');
    
    % Plot bars with probabilities for orient_diff
    elseif strcmpi(normalization,'probability')
%         n = histc(a, edges);
%         n_use = n(1:end-1);
%         plot(centers, n_use/sum(n_use), '.-')
        histogram(a,edges,'Normalization', 'Probability')
        ylabel('Probability')
    end
    
elseif multi_sesh || plot_shuf % otherwise, plot as probabilities
    n = histc(a, edges);
    n_use = n(1:end-1);
    if ~plot_shuf % Solid line with dots for real data
        plot(centers, n_use/sum(n_use), '.-');
    elseif plot_shuf % Dotted lines for shuffled data
        plot(centers, n_use/sum(n_use), 'k--');
    end
    ylabel('Probability');
    
end


end

