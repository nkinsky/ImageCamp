% Alt figure 2: tracking splitters across days

%% A - plot splitters across days
plotSigSplitters_bw_sesh(G45_alt(4), G45_alt(11));
plotSigSplitters_bw_sesh(G45_alt(4), G45_alt(20));
plotSigSplitters_bw_sesh(G45_alt(20),G45_alt(21));
plotSigSplitters_bw_sesh(G30_alt(13),G30_alt(14));

%% B - PF and splitter correlations versus time

% comp_type = {'all', 'free_only', 'forced_only', 'free_v_forced'};
comp_type = {'loop_v_free', 'free_v_not', 'forced_v_free'};

for j = 1:4
    sessions = alt_all_cell{j};
    for k = 1:length(comp_type)
        splitcorr_v_time(sessions, comp_type{k})
        make_figure_pretty(gcf);
        printNK([sessions(1).Animal ' - split curve corrs v time comp_type - ' ...
            comp_type{k}],'alt')
        close(gcf)
    end
end



%% Prob maintains phenotype versus days...
max_day_lag = 7;
sessions = alt_all_cell; % Change this to make plots for each mouse...

nmice = length(sessions);
stay_prop_v_days = cell(1, max_day_lag + 1);
coactive_prop_v_days = cell(1, max_day_lag + 1);

% Get probabilities for each mouse and day lag
hw = waitbar(0,'Get proportions across days');
for j = 0:max_day_lag
    [ stay_prop, coactive_prop, cat_names ] = ...
        alt_stab_v_cat_batch(j, 'exact', sessions, 'Placefields_cm1.mat');
    stay_prop_v_days{j+1} = stay_prop;
    coactive_prop_v_days{j+1} = coactive_prop;
    waitbar((j+1)/max_day_lag,hw);
end
close(hw)

%%
grps_all = []; stay_prop_all = []; coactive_prop_all = [];
for j = 0:max_day_lag
    prop_for_day = cat(1, stay_prop_v_days{j+1}{:});
    stay_prop_all = cat(1, stay_prop_all, prop_for_day);
    coactive_for_day = cat(1, coactive_prop_v_days{j+1}{:});
    coactive_prop_all = cat(1, coactive_prop_all, coactive_for_day);
    grps_by_day = ones(size(prop_for_day))*j;
    size(grps_by_day)
    grps_all = cat(1, grps_all, grps_by_day);
    
end

% Plot and get stats for splitters
figure
set(gcf,'Position', [2000, 30, 1650, 890])
hstay = subplot(2, 3, 1:2); hrecur = subplot(2, 3, 4:5);
scatterBox(stay_prop_all(:,1), grps_all(:,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Stays Splitter', 'h', hstay);
xlabel('Lag (days)')
title('Splitters - all mice')
scatterBox(coactive_prop_all(:,1), grps_all(:,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', hrecur);
xlabel('Lag (days')

subplot(2,3,3)
[pkw_stay,~,stats_stay] = kruskalwallis(stay_prop_all(:,1), ...
    grps_all(:,1),'off');
text(0.1,0.5, ['pkw_{staysplit} = ' num2str(pkw_stay, '%0.2g')])
axis off

subplot(2,3,6)
[pkw_recur,~,stats_recur] = kruskalwallis(coactive_prop_all(:,1), ...
    grps_all(:,1), 'off');
text(0.1,0.5, ['pkw_{coactive} = ' num2str(pkw_recur, '%0.2g')])
axis off

% Plot and get stats for arm place fields
figure
set(gcf,'Position', [2000, 30, 1650, 890])
hstay = subplot(2, 3, 1:2); hrecur = subplot(2, 3, 4:5);
scatterBox(stay_prop_all(:,3), grps_all(:,3), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Stays Arm PC', 'h', hstay);
xlabel('Lag (days)')
title('Arm Place Cells - all mice')
scatterBox(coactive_prop_all(:,3), grps_all(:,3), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', hrecur);
xlabel('Lag (days')

subplot(2,3,3)
[pkw_stay,~,stats_stay] = kruskalwallis(stay_prop_all(:,1), ...
    grps_all(:,1),'off');
text(0.1,0.5, ['pkw_{staysplit} = ' num2str(pkw_stay, '%0.2g')])
axis off

subplot(2,3,6)
[pkw_recur,~,stats_recur] = kruskalwallis(coactive_prop_all(:,1), ...
    grps_all(:,1), 'off');
text(0.1,0.5, ['pkw_{coactive} = ' num2str(pkw_recur, '%0.2g')])
axis off

% NRK - return to the above when comparing place cell coactivity to
% splitter cells!!!

%% Splitter proportions for looping versus forced alternation versus free 
% alternation sessions - need to account for differences in time of
% session... do I see fewer for sessions that are shorter (e.g. short
% sessions for G48 at the end?)
%
% Take home is that splitter proportion is almost entirely predicted by
% sesssion length, not performance or time.
sesh_use = G30_alt;
grp_names = {'Free', 'Forced', 'Looping'};

[perf, split_prop,~, acclim_bool, forced_bool] = get_split_v_perf(sesh_use);
grps = ones(size(forced_bool)); % free alternation = 1
grps(acclim_bool) = 3; % looping = 3
grps(forced_bool) = 2; % forced = 2
figure; set(gcf,'Position',[600 540 810 260])
ha = subplot(1,2,1);
scatterBox(split_prop, grps, 'xLabels', grp_names(unique(grps)),...
    'yLabel', 'Proportion Splitters', 'h', ha)
make_plot_pretty(gca)

% Get stats for above
[pkw, ~, stats] = kruskalwallis(split_prop, grps,'off');
cmat = multcompare(stats, 'display', 'off');
subplot(1,2,2)
% Put names of all mice included here
text(0.1, 1.0, 'Mice included:')
text(0.1, 0.8, cellfun(@mouse_name_title, unique(arrayfun(@(a) a.Animal, ...
    sesh_use, 'UniformOutput', false)),'UniformOutput', false))
text(0.1, 0.4, 'g1   g2   \Delta_{LB}   \Delta_{est}   \Delta_{UB}   pval')
text(0.1, 0.2, num2str(cmat, '%0.2g \t'))
text(0.1, 0.1, ['pkw = ' num2str(pkw, '%0.2g')])
axis off


%%
[~, ~, ~, G30glmall] = plot_split_v_perf_batch(G30_alt);
printNK('G30 perf time ntrials v splitter proportion', 'alt')
[~, ~, ~, G31glmall] = plot_split_v_perf_batch(G31_alt);
printNK('G31 perf time ntrials v splitter proportion', 'alt')
[~, ~, ~, G45glmall] = plot_split_v_perf_batch(G45_alt);
printNK('G45 perf time ntrials v splitter proportion', 'alt')
[~, ~, ~, G48glmall] = plot_split_v_perf_batch(G48_alt);
printNK('G48 perf time ntrials v splitter proportion', 'alt')

[~, ~, ~, allmice_glmall] = plot_split_v_perf_batch(alt_all);
printNK('All Mice perf time ntrials v splitter proportion', 'alt')
