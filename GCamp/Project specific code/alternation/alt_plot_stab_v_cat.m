function [stats, hco, hstay ] = alt_plot_stab_v_cat( day_lag, comp_type, ...
    mice_sesh, varargin )
% [stats, hco, hstay ] = alt_plot_stab_v_cat( day_lag, comp_type, mice_sesh,... )
%   Plots stability of all cell types for all mice at day_lag specified.
%   comp_type = 'exact' only calculates metrics for that
%   exact day lag, 'le' calculates metrics for all sessions <= day_lag
%   apart.
%   mice_sesh = data structure with all sessions for one mouse OR cell
%   containing data structure for each mouse for combined plotting
%   color_mice parameter set to true (default) colors each mouse's data
%   point separately, false plots all in black
%   OUPUTS: stats from Kruskal-Wallis and post-hoc Tukey-Kramer test, axes
%   handles to coactive and stay plots

ip = inputParser;
ip.addRequired('day_lag', @(a) round(a) == a && a >= 0);
ip.addRequired('comp_type', @(a) strcmpi(a,'exact') || strcmpi(a,'le'));
ip.addRequired('mice_sesh', @(a) isstruct(a) || iscell(a));
ip.addOptional('color_mice', true, @islogical);
ip.parse(day_lag, comp_type, mice_sesh, varargin{:});
color_mice = ip.Results.color_mice;

% Deal out mice_sesh into appropriate variable
if iscell(mice_sesh)
    num_mice = length(mice_sesh);
elseif isstruct(mice_sesh)
    num_mice = 1;
    temp = mice_sesh; 
    clear mice_sesh
    mice_sesh{1} = temp;
end

% Plot mice different colors unless
if color_mice
    colors = {'r', 'g', 'b', 'c'};
elseif ~color_mice
    colors = {'k', 'k', 'k', 'k'};
end

% Get proportions for all mice
[ stay_prop_all, coactive_prop_all, cat_names ] = ...
    alt_stab_v_cat_batch(day_lag, comp_type, mice_sesh);

%% Plot everything and get individual mouse stats
figure; set(gcf,'Position',[2170 320 850 460]); hstay = gca;
figure; set(gcf,'Position',[2270 420 850 460]); hco = gca;

for j = 1:num_mice
    stay_prop = stay_prop_all{j};
    cats{j} = repmat(1:size(stay_prop,2),size(stay_prop,1),1);
    
    scatterBox(stay_prop(:), cats{j}(:), 'xLabels', cat_names, ...
        'h', hstay,'circleColors', colors{j},'plotBox', false,...
        'yLabel', 'Prob. retains phenotype');
    hold on
    [stats.mouse(j).stay.p, ~, stats.mouse(j).stay.stats] = ...
        kruskalwallis(stay_prop(:), cats{j}(:), 'off');
    stats.mouse(j).stay.c = multcompare(stats.mouse(j).stay.stats,...
        'Display','off');
end

for j = 1:num_mice
    co_prop = coactive_prop_all{j};
    scatterBox(co_prop(:), cats{j}(:), 'xLabels', cat_names, ...
        'h', hco,'circleColors', colors{j},'plotBox', false,...
        'yLabel','Reactivation Probability');
    hold on
    [stats.mouse(j).coactive.p, ~, stats.mouse(j).coactive.stats] = ...
        kruskalwallis(co_prop(:), cats{j}(:), 'off');
    stats.mouse(j).coactive.c = multcompare(stats.mouse(j).coactive.stats,...
        'Display','off');
end

%% Plot by group
if strcmpi(comp_type,'exact')
    comp_str = 'exactly';
elseif strcmpi(comp_type,'le')
    comp_str = '<=';
end

axes(hstay)
stay_all2 = cat(1,stay_prop_all{:});
cats_all = cat(1,cats{:});
boxplot(stay_all2(:), cats_all(:),'color', 'k', 'symbol', 'k',...
    'labels', cat_names)
title(['Sessions ' comp_str ' ' num2str(day_lag) 'day(s) apart'])

axes(hco)
co_all2 = cat(1,coactive_prop_all{:});
cats_all = cat(1,cats{:});
boxplot(co_all2(:), cats_all(:),'color', 'k', 'symbol', 'k',...
    'labels', cat_names)
title(['Sessions ' comp_str ' ' num2str(day_lag) 'day(s) apart'])

%% Run stats on group data
[stats.all.stay.p, ~, stats.all.stay.stats] = kruskalwallis(...
    stay_all2(:), cats_all(:), 'off');
stats.all.stay.c = multcompare(stats.all.stay.stats,'Display','off');

[stats.all.coactive.p, ~, stats.all.coactive.stats] = kruskalwallis(...
    co_all2(:), cats_all(:), 'off');
stats.all.coactive.c = multcompare(stats.all.coactive.stats,'Display','off');


end

