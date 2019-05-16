function [he_cd, hhist_cd, he_od, hhist_od ] = reg_qc_plot(centroid_dist, ...
    orient_diff, avg_corr, varargin )
% [he_cd, hhist_cd, he_od, hhist_od ] = reg_qc_plot(centroid_dist, ...
%   orient_diff, avg_corr, h )
%  Plot neuron registration metrics.  Leave empty to omit plots.  h is a
%  handle to an existing figure (if ommitted it will plot to a new figure).
%  'multi_sesh' parameter set to true/1 plots all as ecdfs.  Otherwise,
%  they are plotted as histograms.  Low level function for reg_qc_plot2 or
%  reg_qc_plot_batch. 
%
%  Outputs handle to stairs/line handles for ecdf and hist for 
%  centroid distance (cd) orientation difference (od) plots
%  plots.

% NRK - convert pixels into microns

p = inputParser;
p.KeepUnmatched = true;
p.addRequired('centroid_dist', @(a) isnumeric(a) || iscell(a))
p.addRequired('orient_diff', @(a) isnumeric(a) || iscell(a))
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
hhist_cd = gobjects(1); he_cd = gobjects(1);
if ~isempty(centroid_dist) && ~all(isnan(centroid_dist))
    
    % Histogram plot
    subplot(2,2,1)
    hold on
    hhist_cd = histplotfun(centroid_dist, dist_edges, multi_sesh, plot_shuf, 'count');
    xlabel('Centroid Distance (pixels)')
    hold off
    
    % ecdf plot
    subplot(2,2,3)
    hold on
    he_cd = ecdfplotfun(centroid_dist, plot_shuf);
    xlabel('Centroid Distance (pixels)')
    ylabel('F(Centroid Distance)')
end

hhist_od = gobjects(1); he_od = gobjects(1);
if ~isempty(orient_diff)
    subplot(2,2,2)
    hold on
    hhist_od = histplotfun(orient_diff, orient_edges, multi_sesh, plot_shuf, 'probability');
    xlabel('Absolute Orientation Difference (\theta, degrees)')
    hold off
    
    subplot(2,2,4)
    hold on
    he_od = ecdfplotfun(orient_diff, plot_shuf);
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
function [he] = ecdfplotfun(a, shuf)
he = [];
ecdf_bins = 0:0.01:1;

if shuf == 0
    ecdf(abs(a));
    hetemp = get(gca,'Children');
    he = hetemp(1);
elseif shuf == 1 || shuf == 2
    %     [f, x] = ecdf(abs(a(:)));
    %     hs2 = stairs(x,f);
    
    % Fix if cell
    if iscell(a)
        atemp = a;
        clear a
        a = cat(1,atemp{:});
        
        % Get ecdf in 0.01 bins for each shift/shuffle
        a_ecdf_cell = cellfun(@(b) quantile(abs(b),ecdf_bins),atemp,'UniformOutput',false);
        a_ecdf = cat(1,a_ecdf_cell{:});
    else
        a_ecdf = nan(size(a,2),length(ecdf_bins));
        for j = 1:size(a,2)
            a_ecdf(j,:) = quantile(abs(a(:,j)), ecdf_bins);
        end
        
    end
    CI95_ecdf = quantile(a_ecdf,[0.025 0.5 0.975]); % Get 95% CIs
    he = plot(CI95_ecdf, ecdf_bins,'k--');
    set(he(2),'LineStyle','-','Color','k');
end

end

%% histogram plot sub-function
function [hhist] = histplotfun(a, edges, multi_sesh, plot_shuf, normalization)
hhist = [];
centers = mean([edges(1:end-1); edges(2:end)]);

if ~multi_sesh && ~plot_shuf
    % Plot bars with count
    if strcmpi(normalization,'count')
        hhist = histogram(a, edges);
        ylabel('Count');
    
    % Plot bars with probabilities for orient_diff
    elseif strcmpi(normalization,'probability')
%         n = histc(a, edges);
%         n_use = n(1:end-1);
%         plot(centers, n_use/sum(n_use), '.-')
        hhist = histogram(a,edges,'Normalization', 'Probability');
        ylabel('Probability')
    end
    
elseif multi_sesh || plot_shuf % otherwise, plot as probabilities
    if ~iscell(a) 
        n = histc(abs(a), edges);
    elseif iscell(a)
        nn = cellfun(@(b) histc(abs(b), edges), a, 'UniformOutput',false);
        n = cat(2,nn{:});
    end
    if ~plot_shuf % Solid line with dots for real data
        n_use = n(1:end-1);
        hhist = plot(centers, n_use/sum(n_use), '.-');
    elseif plot_shuf
        n_use = n(1:end-1,:);
        prob_use = n_use./sum(n_use,1);
%         plot(centers, n_use/sum(n_use), 'k--');  % Dotted lines for shuffled data
%        CI95 = quantile(n(1:end-1,:)',[0.975 0.5 0.025]); % get 95% CI
       CI95prob = quantile(prob_use',[0.975 0.5 0.025]); % get 95% CI
%        CI95prob = CI95/size(a,1); % Make into probabilities
       hhist = plot(centers, CI95prob, 'k-'); % plot
       arrayfun(@(a) set(a,'LineStyle','--'), hhist([1 3])); % Set 95% CIs to dashed, leave median as solid
    end
    ylabel('Probability');
    
end


end

