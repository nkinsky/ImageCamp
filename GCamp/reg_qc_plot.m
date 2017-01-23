function [ ] = reg_qc_plot(centroid_dist, orient_diff, avg_corr, varargin )
% reg_qc_plot(centroid_dist, orient_diff, avg_corr, h )
%  Plot neuron registration metrics.  Leave empty to omit plots.  h is a
%  handle to an existing figure (if ommitted it will plot to a new figure).

p = inputParser;
p.addRequired('centroid_dist', @isnumeric)
p.addRequired('orient_diff', @isnumeric)
p.addRequired('avg_corr', @isnumeric)
p.addOptional('h', 0, @ishandle)
p.addParameter('plot_shuf', 0, @(a) isnumeric(a) || a == 0 || a == 1 || a == 2); % 0 = normal, 1 = shuffled, 2 = shifted
p.parse(centroid_dist, orient_diff, avg_corr, varargin{:});

h = p.Results.h;
plot_shuf = p.Results.plot_shuf;

if h == 0
    h = figure;
end

figure(h)
if ~isempty(centroid_dist)
    subplot(2,2,1)
    hold on
    % histogram(centroid_dist,0:0.25:10);
    plotfun(centroid_dist, plot_shuf);
    xlabel('Centroid Distance (cd)')
    % ylabel('Count')
    ylabel('F(cd)')
    hold off
end

if ~isempty(orient_diff)
    subplot(2,2,2)
    hold on
    plotfun(abs(orient_diff), plot_shuf)
    xlabel('Absolute Orientation Difference (\theta, degrees)')
    ylabel('F(\theta)');
    hold off
end

if ~isempty(avg_corr)
    subplot(2,2,3)
    hold on
    plotfun(avg_corr, plot_shuf)
    xlabel('Average ROI Activation Correlation (x)')
    ylabel('F(x)')
    hold off
end

end

%% Plot sub-function
function [] = plotfun(a, shuf)

if shuf == 0
    ecdf(a);
elseif shuf == 1 || shuf == 2
    [f, x] = ecdf(a);
    hs2 = stairs(x,f);
    set(hs2,'LineStyle','--')
end

end

