function [pkw, stats, cmat, hplot, hstats] = split_ontogeny_plot(metric, ...
    daydiff, varargin)
% [pkw, stats, cmat] = split_ontogeny_plot(daydiff, metric, group_size,...)
%   Plots a given splitting metric versus days before/after splitter onset.
%
%   INPUTS:
%       metric: metric to plot. Meant to be means for each session-pair,
%       but could be individual data points too. nx1 array.
%
%       daydiff: day differences (-5, 2, 14, etc.) corresponding to all the
%       values in metric
%
%       group_size: number of days you want to group together (effectively
%       smoothing results). 1 = show ...,-2, -1, 0, 1, 2, ...  3 = show
%       day lag of -6to-4, -3to-1, 0, 1to3, 4to6, etc. default = 3
%       
%       NAME-VALUE PAIRS
%       ylabel: what you want to put on the yaxis. e.g. '\Delta-{max}'
%
%       ha (optional): axes to plot into. creates new figure/axes by
%       default. If two axes are specified, plots stats in second. If only
%       one, stats are omitted.
%
%       max_day: maximum number of days to look before/after for plot AND
%       stats. Default = 9.

ip = inputParser;
ip.addRequired('metric', @isnumeric);
ip.addRequired('daydiff', @isnumeric);
ip.addOptional('group_size', 3, @(a) isnumeric(a) && a > 0 && round(a) == a);
ip.addParameter('ylabel', 'Metric', @ischar);
ip.addParameter('ha', [], @(a) ishandle(a) || isempty(a));
ip.addParameter('max_day', 9, @(a) isnumeric(a) && a > 0 && round(a) == a);
ip.parse(metric, daydiff, varargin{:});
group_size = ip.Results.group_size;
ylabel = ip.Results.ylabel;
ha = ip.Results.ha;
max_day = ip.Results.max_day;

%% Set up figure

% Make new figure if no axes specified
if isempty(ha)
    figure;
    set(gcf,'Position',[200 420 1340 390]);
    ha(1) = subplot(1,3,1:2);
    ha(2) = subplot(1,3,3);
end

hplot = ha(1);
if length(ha) == 2
    hstats = ha(2);
else
    hstats = [];
end

%% Get xlimits - as usual, I'm sure there is a much easier way.
groups = floor(max(min(daydiff),-1*max_day)/group_size):1:...
    ceil(min(max(daydiff),max_day)/group_size);
day_lims_ref = groups'*group_size;
day_lims = nan(length(groups),2);
day_lims(day_lims_ref < 0,1) = day_lims_ref(day_lims_ref < 0);
day_lims(day_lims_ref > 0,2) = day_lims_ref(day_lims_ref > 0);
day_lims(day_lims(:,2) > 0,1) = day_lims_ref(day_lims_ref > 0,1) - (group_size-1);
day_lims(day_lims(:,1) < 0,2) = day_lims_ref(day_lims_ref < 0,1) + (group_size-1);
day_lims(day_lims_ref == 0,:) = 0;

% Make corresponding figure labels
xlabels = arrayfun(@(a,b) [num2str(a) ' to ' num2str(b)], ...
    day_lims(:,1), day_lims(:,2),'UniformOutput', false);
xlabels{day_lims(:,1) == 0} = num2str('0');

%% Plot it

groups_ba = nan(size(daydiff));
% Assign each data point the appropriate day group to get plotted into
for j = 1:size(day_lims,1)
    lims_use = day_lims(j,:);
    good_bool = daydiff <= lims_use(2) & daydiff >= lims_use(1);
    groups_ba(good_bool) = groups(j);
end

% Grab only valid daydiffs
valid_daydiff_bool = ~isnan(groups_ba);
groups_ba = groups_ba(valid_daydiff_bool);
metric = metric(valid_daydiff_bool);

scatterBox(metric, groups_ba, 'xLabels', xlabels, 'yLabel', ...
    ylabel, 'h', hplot);
xlabel('Days from splitting onset')
make_plot_pretty(gca)

%% Get stats
[pkw, ~, stats] = kruskalwallis(metric, groups_ba, 'off');
cmat = multcompare(stats,'display','off');

% plot if specified
if ~isempty(hstats)
    axes(hstats)
    text(0.1, 1.2, 'g1   g2   pval')
    text(0.1, 0.5, num2str(cmat(:,[1 2 6]), '%0.2g \t'))
    text(0.5, 1.1, ['pkw = ' num2str(pkw, '%0.2g') ', n = ' ...
        num2str(sum(~isnan(metric))) ' sessions'])
    axis off
    ylim([0 1.1])
end

end

