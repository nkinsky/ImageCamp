function [ hbar, hs, p, cmat] = barscatter( varargin )
% [ hbar, hs, p, cmat ] = barscatter( data1, data2, ... )
%   produces a bar plot of means of data1, data2,... with a scatter plot of
%   of each data point in data1 overlaid. Plots into current axes. Not yet
%   tested for doing multiple conditions (e.g. 3 groups of 2
%   bars/conditions each). Spits out non-parametric estimates of each group
%   vs the others (kruskal-wallis + mult comp mat if > 2 groups, ranksum p
%   if 2 groups).

ngrps = length(varargin);
nconds = size(varargin{1},2);

means_plot = cellfun(@(a) nanmean(a,1), varargin, 'UniformOutput', false);
means_plot = cat(1, means_plot{:});

hbar = bar(means_plot); % xlim([0.5 ngrps+0.5])
hold on
%%
if ngrps == 2
    offset = 0.04;
elseif ngrps > 2
    offset = 0.02;
end
for j = 1:ngrps
    for k = 1:nconds
    xvals = j*ones(size(varargin{j}(:,k)));
    xvaloff = xvals + randn(size(xvals))*offset + hbar(k).XOffset;
    hs(j,k) = scatter(xvaloff(:), varargin{j}(:,k), 'ko');
    end
end
%%

if ngrps == 2
    cmat = nan;
    p = ranksum(varargin{1}(:),varargin{2}(:));
elseif ngrps > 2
    % reshape data to have column vectors only
    data_rs = cellfun(@(a) a(:), varargin, 'UniformOutput', false); 
    data_all = cat(1, data_rs{:});
    grps = arrayfun(@(a,b) a*ones(b,1), 1:ngrps, cellfun(@length,data_rs),...
        'UniformOutput', false);
    grps_all = cat(1, grps{:});
    [p,~, stats] = kruskalwallis(data_all, grps_all,'off');
    cmat = multcompare(stats,'display','off');
end

hold off

end

