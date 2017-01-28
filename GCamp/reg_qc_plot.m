function [ ] = reg_qc_plot(centroid_dist, orient_diff, avg_corr, varargin )
% reg_qc_plot(centroid_dist, orient_diff, avg_corr, h )
%  Plot neuron registration metrics.  Leave empty to omit plots.  h is a
%  handle to an existing figure (if ommitted it will plot to a new figure).
%  'multi_sesh' parameter set to true/1 plots all as ecdfs.  Otherwise,
%  they are plotted as histograms.

p = inputParser;
p.addRequired('centroid_dist', @isnumeric)
p.addRequired('orient_diff', @isnumeric)
p.addRequired('avg_corr', @isnumeric)
p.addOptional('h', 0, @ishandle)
p.addParameter('plot_shuf', 0, @(a) isnumeric(a) || a == 0 || a == 1 || a == 2); % 0 = normal, 1 = shuffled, 2 = shifted
p.addParameter('multi_sesh', false, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('dist_edges', 0:0.1:3, @isnumeric);
p.addParameter('orient_edges', -180:10:180, @isnumeric);
p.parse(centroid_dist, orient_diff, avg_corr, varargin{:});

h = p.Results.h;
multi_sesh = p.Results.multi_sesh;
plot_shuf = p.Results.plot_shuf;
dist_edges = p.Results.dist_edges;
orient_edges = p.Results.orient_edges;

dist_centers = mean([dist_edges(1:end-1); dist_edges(2:end)]);
orient_centers = mean([orient_edges(1:end-1); orient _edges(2:end)]);


if h == 0
    h = figure;
end

figure(h)

switch multi_sesh
    case 0 % Not finished
        if ~isempty(centroid_dist)
            edges = 0:0.1:3;
            subplot(1,2,1)
            hold on
            if shuf == 0
                histogram(centroid_dist, edges);
            elseif shuf == 1
                histogram(centroid_dist, edges, 'DisplayStyle', 'stairs');
            end
            xlabel('Centroid Distance (cd)')
            % ylabel('Count')
            ylabel('F(cd)')
            hold off
        end
        
        if ~isempty(orient_diff)
            subplot(1,2,2)
            hold on
            ecdfplotfun(abs(orient_diff), plot_shuf)
            xlabel('Absolute Orientation Difference (\theta, degrees)')
            ylabel('F(\theta)');
            hold off
        end
        
    case 1
        if ~isempty(centroid_dist)
            subplot(1,2,1)
            hold on
            % histogram(centroid_dist,0:0.25:10);
            ecdfplotfun(centroid_dist, plot_shuf);
            xlabel('Centroid Distance (cd)')
            % ylabel('Count')
            ylabel('F(cd)')
            hold off
        end
        
        if ~isempty(orient_diff)
            subplot(1,2,2)
            hold on
            ecdfplotfun(abs(orient_diff), plot_shuf)
            xlabel('Absolute Orientation Difference (\theta, degrees)')
            ylabel('F(\theta)');
            hold off
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

end

%% ecdf Plot sub-function
function [] = ecdfplotfun(a, shuf)

if shuf == 0
    ecdf(a);
elseif shuf == 1 || shuf == 2
    [f, x] = ecdf(a);
    hs2 = stairs(x,f);
    set(hs2,'LineStyle','--')
end

end

%% histogram plot sub-function
function [] = plotfunhist(a, shuf)

end

