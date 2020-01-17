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
ip.addParameter('PFname','Placefields_cm1.mat', @ischar);
ip.addParameter('matchER', true, @islogical);
ip.addParameter('trial_type', 'free_only', @ischar);
ip.parse(day_lag, comp_type, mice_sesh, varargin{:});
color_mice = ip.Results.color_mice;
PFname = ip.Results.PFname;
matchER = ip.Results.matchER;
trial_type = ip.Results.trial_type;

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
    alt_stab_v_cat_batch(day_lag, comp_type, mice_sesh, PFname, matchER, ...
    trial_type);

%% Plot everything and get individual mouse stats
% figure; set(gcf,'Position',[2170 320 850 460]); hstay = gca;
% figure; set(gcf,'Position',[2270 420 850 460]); hco = gca;
figure; set(gcf, 'Position', [2180, 20, 1440, 980]);
hstay = subplot(2,3,1:2); hco = subplot(2,3,4:5);

for j = 1:num_mice
    stay_prop = stay_prop_all{j};
    if ~isempty(stay_prop)
        cats{j} = repmat(1:size(stay_prop,2),size(stay_prop,1),1);
        
        scatterBox(stay_prop(:), cats{j}(:), 'xLabels', cat_names, ...
            'h', hstay,'circleColors', colors{j},'plotBox', false,...
            'yLabel', 'Prob. retains phenotype');
        hold on
        [stats.mouse(j).stay.p, ~, stats.mouse(j).stay.stats] = ...
            kruskalwallis(stay_prop(:), cats{j}(:), 'off');
        stats.mouse(j).stay.c = multcompare(stats.mouse(j).stay.stats,...
            'Display','off');
    elseif isempty(stay_prop) % set to all NaNs if no data for this mouse/time point
        stats.mouse(j).stay.p = nan;
        stats.mouse(j).stay.stats = nan;
        stats.mouse(j).stay.c = nan;
    end
end

for j = 1:num_mice
    co_prop = coactive_prop_all{j};
    if ~isempty(co_prop)
        scatterBox(co_prop(:), cats{j}(:), 'xLabels', cat_names, ...
            'h', hco,'circleColors', colors{j},'plotBox', false,...
            'yLabel','Reactivation Probability');
        hold on
        [stats.mouse(j).coactive.p, ~, stats.mouse(j).coactive.stats] = ...
            kruskalwallis(co_prop(:), cats{j}(:), 'off');
        stats.mouse(j).coactive.c = multcompare(stats.mouse(j).coactive.stats,...
            'Display','off');
    elseif isempty(co_prop)
        % set to all NaNs if no data for this mouse/time point
        stats.mouse(j).coactive.p = nan;
        stats.mouse(j).coactive.stats = nan;
        stats.mouse(j).coactive.c = nan;
    end
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
boxProps = get(gca,'Children');
[boxProps(1).Children.LineWidth] = deal(2);
title({['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'],...
    ['matchER = ' num2str(matchER) ' trial\_type = '...
    mouse_name_title(trial_type)]})
make_plot_pretty(gca)

axes(hco)
co_all2 = cat(1,coactive_prop_all{:});
cats_all = cat(1,cats{:});
boxplot(co_all2(:), cats_all(:),'color', 'k', 'symbol', 'k',...
    'labels', cat_names)
boxProps = get(gca,'Children');
[boxProps(1).Children.LineWidth] = deal(2);
title({['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'],...
    ['matchER = ' num2str(matchER) ' trial\_type = ' ...
    mouse_name_title(trial_type)]})
make_plot_pretty(gca);

%% Run stats on group data
[stats.all.stay.p, ~, stats.all.stay.stats] = kruskalwallis(...
    stay_all2(:), cats_all(:), 'off');
stats.all.stay.c = multcompare(stats.all.stay.stats,'Display','off');

[stats.all.coactive.p, ~, stats.all.coactive.stats] = kruskalwallis(...
    co_all2(:), cats_all(:), 'off');
stats.all.coactive.c = multcompare(stats.all.coactive.stats,'Display','off');


%% Plot stats

split_ind = find(strcmpi('Splitters', cat_names));
apc_ind = find(strcmpi('Arm PCs', cat_names));

% Recurrence of phenotype stats
subplot(2,3,3)
text(0.1, 1.0, 'Mice included:')
text(0.1, 0.8, cellfun(@mouse_name_title, unique(cellfun(@(a) a.Animal, ...
    mice_sesh, 'UniformOutput', false)),'UniformOutput', false))
text(0.1, 0.6, 'g1   g2   pval')
text(0.1, 0.2, num2str(stats.all.stay.c(:,[1 2 6]), '%0.2g \t'))
text(0.1, 0.65, ['pkw = ' num2str(stats.all.stay.p, '%0.2g')])
axis off

% Re-activation stats
subplot(2,3,6)
text(0.1, 1.0, 'Mice included:')
text(0.1, 0.8, cellfun(@mouse_name_title, unique(cellfun(@(a) a.Animal, ...
    mice_sesh, 'UniformOutput', false)),'UniformOutput', false))
text(0.1, 0.6, 'g1   g2    pval')
text(0.1, 0.2, num2str(stats.all.coactive.c(:, [1 2 6]), '%0.2g \t'))
text(0.1, 0.65, ['pkw = ' num2str(stats.all.coactive.p, '%0.2g')])
text(0.5, 0,65, 'Splitters vs. Arm PCs only:')
text(0.5, 0.55, ['p_{signrank,1sided} = ' num2str(...
    signrank(co_all2(:, split_ind), co_all2(:,apc_ind),'tail','right'), '%0.2g')])
axis off

%% Plot just splitters v arm pcs paired
figure; set(gcf, 'Position', [ 2180 332 716 480]);
ha = subplot(1,2,1);
x_use = co_all2(:,[split_ind apc_ind]);
match_bool = all(~isnan(x_use),2);
x_use = x_use(match_bool,:);
groups = ones(size(x_use)).*[1 2];
paired_ind = repmat((1:size(x_use,1))',1,2);
scatterBox(x_use(:), groups(:), 'paired_ind', paired_ind(:), 'xLabels', ...
    {'Splitters', 'Arm PCs'}, 'yLabel', 'Prob. Present', 'h', ha);
prsign = signrank(co_all2(:,split_ind), co_all2(:,apc_ind),'tail','right');
subplot(1,2,2);
text(0.1,0.5,['psign-rank (1-sided) = ' num2str(prsign,'%0.2g')])
text(0.1,0.3,['trial_type = ' mouse_name_title(trial_type)])
text(0.1,0.1,['matchER = ' num2str(matchER)])
axis off

end

