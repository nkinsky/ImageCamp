% Alt figure 2: tracking splitters across days

%% A - plot splitters across days
plotSigSplitters_bw_sesh(G45_alt(4), G45_alt(11));
plotSigSplitters_bw_sesh(G45_alt(4), G45_alt(20));
plotSigSplitters_bw_sesh(G45_alt(20),G45_alt(21));
plotSigSplitters_bw_sesh(G30_alt(10),G30_alt(14));

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
%% Probability 