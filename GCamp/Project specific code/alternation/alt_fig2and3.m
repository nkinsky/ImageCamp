% Alt figure 2: tracking splitters across days & relationship to
% performance

wood_filt = true;
half_thresh = 2;
text_append = alt_set_filters(wood_filt, half_thresh);

%% A - plot splitters across days
plotSigSplitters_bw_sesh(G45_alt(5), G45_alt(12));
% plotSigSplitters_bw_sesh(G45_alt(4), G45_alt(20));
% plotSigSplitters_bw_sesh(G45_alt(20),G45_alt(21));
plotSigSplitters_bw_sesh(G30_alt(13),G30_alt(14));

%% Get dmaxnorm and rely values for sessions above
% Neuron #327 in session 1 here
nstem_thresh = 5;
neuron_id = [327 101];
sessions{1,1} = G45_alt(5); sessions{1,2} = G45_alt(12);
sessions{2,1} = G30_alt(13); sessions{2,2} = G30_alt(14);
for j = 1:2
    neuron_map = neuron_map_simple(sessions{j,1},sessions{j,2});
    
    figure; set(gcf, 'Position', [ 2126        10       1189         800])
    for k = 1:2
        if k == 1; nuse = neuron_id(j); elseif k == 2; 
            nuse = neuron_map(neuron_id(j)); end
        [~, dmax_l, ~, ~, dnorm_1, nactive_1, dinorm_l, ~, relym_1] = ...
            parse_splitters(sessions{j,k}.Location);
        subplot(2,2,2*(k-1)+1);
%         histogram(dnorm_1(nactive_1 >= nstem_thresh));
%         xlabel('|\Delta|_{norm}'); ylabel('Count');
%          duse = dnorm_1(nuse);
%         hold on; plot([duse duse], get(gca,'YLim'),'r-')
%         text(duse,30,num2str(duse,'%0.2g'))
        histogram(dinorm_l(nactive_1 >= nstem_thresh));
        xlabel('\Epsilon|\Delta|_{norm}'); ylabel('Count');
        duse = dinorm_l(nuse);
        hold on; plot([duse duse], get(gca,'YLim'),'r-')
        text(duse,30,num2str(duse,'%0.2g'))
%         histogram(dmax_l(nactive_1 >= nstem_thresh));
%         xlabel('|\Delta|_{max}'); ylabel('Count');
%         duse = dmax_l(nuse);
%         hold on; plot([duse duse], get(gca,'YLim'),'r-')
%         text(duse,30,num2str(duse,'%0.2g'))
        title([mouse_name_title(sessions{j,k}.Animal) ' - ' ...
            mouse_name_title(sessions{j,k}.Date) 's' num2str(...
            sessions{j,k}.Session)])
        subplot(2,2,2*(k-1)+2);
        histogram(relym_1(nactive_1 >= nstem_thresh));
        xlabel('Rely_{mean}'); ylabel('Count')
        ruse = relym_1(nuse);
        hold on; plot([ruse ruse], get(gca,'YLim'),'r-')
        text(duse,30,num2str(ruse,'%0.2g'))
    end
end

%% Get mean dmax and dmax_norm for all animals
[dmax_means, dn_means] = deal(cell(1,4));
metrics_plot = {'|\Delta_{max}|', '|\Delta_{max}|_{norm}', ...
    '\Sigma|\Delta|', 'Rely_{mean}'};
for j = 1:4
    [~, ~, free_bool] = alt_id_sesh_type(alt_all_cell{j});
    good_seshs = alt_all_cell{j}(free_bool);
    [~, dmax, ~, ~, dnorm, nactive_stem, dinorm, ~, rmean] = arrayfun(@(a) ...
        parse_splitters(a.Location), good_seshs, 'UniformOutput', false);
    sigbool_all = arrayfun(@(a) alt_id_sigsplitters(a, 3), good_seshs, ...
        'UniformOutput', false);
    dmax_means{j} = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), dmax, ...
        nactive_stem);
    dmax_means_sp{j} = cellfun(@(a,b,c) nanmean(a(b > nstem_thresh & c)), dmax, ...
        nactive_stem, sigbool_all);
    dn_means{j} = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), dnorm, ...
        nactive_stem);
    dn_means_sp{j} = cellfun(@(a,b,c) nanmean(a(b > nstem_thresh & c)), dnorm, ...
        nactive_stem, sigbool_all);
    di_means{j} = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), dinorm, ...
        nactive_stem);
    di_means_sp{j} = cellfun(@(a,b,c) nanmean(a(b > nstem_thresh & c)), dinorm, ...
        nactive_stem, sigbool_all);
    rm_means{j} = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), rmean, ...
        nactive_stem);
    rm_means_sp{j} = cellfun(@(a,b,c) nanmean(a(b > nstem_thresh & c)), rmean, ...
        nactive_stem, sigbool_all);
    figure; set(gcf, 'Position', [2263, 20 1400 900]);
    metrics_all = cat(1, dmax, dnorm, dinorm, rmean);
    for k = 1:4
        ha = subplot(2,2,k);
        alt_plot_splitmetric_histos(metrics_all(k,:), nactive_stem,...
            sigbool_all, 5, ha, 'Probability', true);
        xlabel(metrics_plot{k});
    end
    title(subplot(2,2,1), ['Mouse ' num2str(j)])
    make_figure_pretty(gcf);
    printNK(['Split metric distributions - split v nonsplit - Mouse ' num2str(j) '.pdf'],...
        'alt');
end

% Plot to see if there is a systematic difference - there isn't in dmax...
grps = cat(2, ones(1,10), 2*ones(1,7), 3*ones(1,23), 4*ones(1,28));
scatterBox(cat(2,dmax_means{:}),grps)
scatterBox(cat(2,dn_means{:}),grps)

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

%% C - plot splitter proportion for each mouse across days relative to 
% stem cells and ALL cells
pval_thresh = 0.05;
ntrans_thresh = 5;
sig_thresh = 3;

%pre-allocate - 1st row = proportion of stem active neurons, 2nd row = 
% proportion of all neurons, 3rd row = num trials, 4th row = loop_bool, 5th
% row = forced_bool, 6th row = free_bool
split_ratios = arrayfun(@(a) nan(3,a), cellfun(@length, alt_all_cell_G30split),...
    'UniformOutput', false);
nsesh_total = sum(cellfun(@length, alt_all_cell_G30split));
hw = waitbar(0, 'getting % splitters for all mice...');
n = 1;
for j = 1:6
    sessions = alt_all_cell_G30split{j};
    for k = 1:length(sessions)
        try
            % ID cell phenotype
            categories = alt_parse_cell_category( sessions(k), pval_thresh, ...
                ntrans_thresh, sig_thresh, 'Placefields_cm1.mat' );
            
            % Get ratio of all stem active neurons that are splitters
            split_ratios{j}(1,k) = sum(categories == 1)/sum(ismember(categories,...
                [1,2,4]));
            
            % Get ratio of all neurons that are splitters
            split_ratios{j}(2,k) = sum(categories == 1)/length(categories);
        catch
            disp(['Error in session ' num2str(k) ' from mouse ' num2str(j)])
        end
        
        % Get # trials per each session
        load(fullfile(sessions(k).Location, 'Alternation.mat'));
        split_ratios{j}(3,k) = size(Alt.summary,1);
        
        % Get free/forced/looping
        [split_ratios{j}(4,k), split_ratios{j}(5,k), split_ratios{j}(6,k)] ...
            = alt_id_sesh_type(sessions(k));
        
        
        waitbar(n/nsesh_total,hw);
        n = n+1;
    end
end
close(hw)

% Spit out rough numbers!
mean(split_ratios{4}(1:3,split_ratios{4}(6,:)==1),2)

% Spit out ratios for all mice
rat_all = cat(2,split_ratios{:});
nanmean(rat_all(1:3,rat_all(4,:) == 0 & rat_all(6,:) == 1),2) % free ratios mean

rat_all2 = cat(2,split_ratios{3:6}); %breaks out G30 looped and forced separately
forced_mean_min20 = nanmean(rat_all2(1:3, rat_all2(4,:) == 0 & rat_all2(5,:) == 1 & ...
    rat_all2(3,:) >= 20),2) % forced ratios
loop_mean_min20 = nanmean(rat_all2(1:3, rat_all2(4,:) == 1 & rat_all2(5,:) == 0 & ...
    rat_all2(3,:) >= 20),2) % looping ratios
forced_mean_nomin = nanmean(rat_all2(1:3, rat_all2(4,:) == 0 & rat_all2(5,:) == 1),2) % forced ratios
loop_mean_nomin = nanmean(rat_all2(1:3, rat_all2(4,:) == 1 & rat_all2(5,:) == 0),2) % looping ratios

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
% Take home is that splitter proportion is almost entirely predicted by
% sesssion length, not performance or time. However, this also implies my
% measurements are a bit wonky since it seems like splitter detection
% depends on number of trials which implies it is a statistics issue.
% Instead, see next section to look at performance vs. "splittiness"
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


%% Save all the above.
[~, ~, ~, G30glmall] = plot_split_v_perf_batch(G30_alt);
printNK(['G30 perf time ntrials v splitter proportion' text_append], 'alt')
[~, ~, ~, G31glmall] = plot_split_v_perf_batch(G31_alt);
printNK(['G31 perf time ntrials v splitter proportion' text_append], 'alt')
[~, ~, ~, G45glmall] = plot_split_v_perf_batch(G45_alt);
printNK(['G45 perf time ntrials v splitter proportion' text_append], 'alt')
[~, ~, ~, G48glmall] = plot_split_v_perf_batch(G48_alt);
printNK(['G48 perf time ntrials v splitter proportion' text_append], 'alt')

[~, ~, ~, allmice_glmall] = plot_split_v_perf_batch(alt_all);
printNK(['All Mice perf time ntrials v splitter proportion' text_append], 'alt')

%% Performance v splittiness
% add noise to corr curves to give L/R only neurons a value (otherwise they go to NaN).
inject_noise = true; 
trial_thresh = 20;
% halt = figure; set(gcf,'Position', [2130 440 960 460]);
for j = 1:4
    sesh_use = alt_all_cell{j};
    plot_perf_v_split_metrics(sesh_use, true, inject_noise, trial_thresh);
    printNK(['Perf v split metrics - ' sesh_use(1).Animal],'alt')
end
%%
plot_perf_v_split_metrics(alt_all, true, inject_noise, trial_thresh);
printNK(['Perf v split metrics - All Mice' text_append], 'alt')

% Do the above but eliminate G48 who might be carrying the team for the
% delta_max_norm metric
plot_perf_v_split_metrics(alt_all(~arrayfun(@(a) ...
    strcmpi(a.Animal,'GCaMP6f_48'),alt_all)), true, inject_noise, trial_thresh);
printNK(['Perf v split metrics - No G48' text append], 'alt')

plot_perf_v_split_metrics(alt_all(~arrayfun(@(a) ...
    strcmpi(a.Animal,'GCaMP6f_30'),alt_all)), true, inject_noise, trial_thresh);
printNK(['Perf v split metrics - No G30' text append], 'alt')

%% Plot LDA correlations by maze thirds to figure out where coding breaks apart
no_shuf = true;
sesh_use = alt_all(alt_all_free_bool);
perf = arrayfun(@alt_get_perf, sesh_use); 
LDAperf3 = nan(3,length(sesh_use)); 
LDAperf3_shuf = nan(3, length(sesh_use), 3);
for k = 1:length(sesh_use) 
    [perf_temp, shuf_temp] = alt_loadLDA(sesh_use(k), no_shuf);
    % Get LDA performance in thirds
    LDAperf3(1,k) = mean(nanmean(perf_temp(1:4,:))); 
    LDAperf3(2,k) = mean(nanmean(perf_temp(5:8,:))); 
    LDAperf3(3,k) = mean(nanmean(perf_temp(9:12,:)));
    
    % Get LDAshuffled means & 95% CIs
    if length(shuf_temp) ~= 1
        for qq = 1:3
            shuf_use = shuf_temp((qq-1)*4+(1:4), :);
            LDAperf3_shuf(qq,k,2) = mean(nanmean(shuf_use,1));
            LDAperf3_shuf(qq,k,[1,3]) = quantile(nanmean(shuf_use,1),[0.025, 0.975]);
        end
    end
end
meanCIs = squeeze(mean(LDAperf3_shuf,2));
third_text = {'1st', '2nd', '3rd'};
figure; set(gcf, 'Position', [93    93   674   572]);
for j = 1:3
    subplot(2,2,j);
    plot(100*LDAperf3(j,:), 100*perf, 'o'); 
    hold on;
    title([third_text{j} ' Third of Maze']);
    xlabel('Decoder Accuracy (%)');
    ylabel('Performance (%)');
    good_bool = ~isnan(perf) & ~isnan(LDAperf3(j,:));
    [r,p] = corr(100*perf(good_bool)', 100*LDAperf3(j, good_bool)');
    text(35, 80, ['r = ' num2str(r,'%0.2g')])
    text(35, 75, ['p = ' num2str(p, '%0.2g')])
    lm = fitlm(LDAperf3(j,:)*100, perf*100);
    perf_pred = lm.feval([min(LDAperf3(j,:)*100), max(LDAperf3(j,:)*100)]);
    hpred = plot([min(LDAperf3(j,:)*100), max(LDAperf3(j,:)*100)], perf_pred,...
        'r--');
    plot(meanCIs(j,2)*[100,100], [40 90])
    legend(hpred, 'Best-fit')
end
make_figure_pretty(gcf);
printNK(['LDA v perf by maze thirds' text_append], 'alt');

%% Breakdown above by individual mice - should probably do for different trial thresholds too

% Use alt_all_cell_sp to divide up G45 and G48 into early and late sessions
sesh_cell_use = alt_all_cell; 

% Pre-allocate mean performance and dnorm arrays
perf_mean = []; dnorm_mean = []; dint_mean = []; curve_corr_mean = [];
rely_mean_mean = []; discr_perf_mean = []; dmax_mean = []; sigprop_mean = [];

% Calculate values for each mouse
for j = 1:length(sesh_cell_use)
    split_metrics = plot_perf_v_split_metrics(sesh_cell_use{j}, ...
        false, inject_noise, trial_thresh);
    perf_mean = [perf_mean, nanmean(split_metrics.perf)];
    dmax_mean = [dmax_mean, nanmean(split_metrics.dmax_mean)];
    dnorm_mean = [dnorm_mean, nanmean(split_metrics.dmax_norm_mean)];
    dint_mean = [dint_mean, nanmean(split_metrics.dint_norm_mean)];
    curve_corr_mean = [curve_corr_mean, nanmean(split_metrics.curve_corr_mean)];
    rely_mean_mean = [rely_mean_mean, nanmean(split_metrics.rely_mean_mean)];
    discr_perf_mean = [discr_perf_mean, nanmean(split_metrics.discr_perf)];
    sigprop_mean = [sigprop_mean, nanmean(split_metrics.sigprop_mean)];
end

%% Plot points
figure; set(gcf,'Position', [30 157 1400 761]);
h1 = subplot(2,3,1); h2 = subplot(2,3,2); h3 = subplot(2,3,3);
h4 = subplot(2,3,4); h5 = subplot(2,3,5);

 alt_group_plot_perf_v_split(h1, dnorm_mean, perf_mean, ...
     '|\Delta_{max}|_{norm}'); xlim(h1, [0.4 0.7]); ylim(h1, [66 80])

alt_group_plot_perf_v_split(h2, dint_mean, perf_mean, ...
    '\Sigma|\Delta|_{norm}'); xlim(h2, [0.4 0.625]); ylim(h2, [66 80])
alt_group_plot_perf_v_split(h3, 1 - curve_corr_mean, perf_mean, ...
    '1 - \rho_{mean}'); xlim(h3, [0.45 0.85]); ylim(h3, [66 80])
alt_group_plot_perf_v_split(h4, rely_mean_mean, perf_mean, ...
    'Reliability (1-p)'); xlim(h4, [0.2 0.3]); ylim(h4, [66 80])
alt_group_plot_perf_v_split(h5, discr_perf_mean, perf_mean, ...
    'Decoder (LDA) Accuracy (%)'); xlim(h5, [45 75]); ylim(h5, [66 80])
subplot(2,3,6);
text(0.1, 0.4, ['inject\_noise = ' num2str(inject_noise)])
text(0.1, 0.6, ['ntrial_thresh = ' num2str(split_metrics.trial_thresh)])
text(0.1, 0.8, ['nstem_thresh = ' num2str(split_metrics.nstem_thresh)])
axis off

printNK(['Perf v splittiness by mice' text_append],'alt')
%%
figure; set(gcf, 'Position', [20 30 890 430]);
hd1 = subplot(1,2,1);
% alt_group_plot_perf_v_split(hd1, dmax_mean, perf_mean, ...
%     '|\Delta_{max}|_{mean}'); xlim(hd1, [0.11 0.21]); ylim(hd1, [66 80])
alt_group_plot_perf_v_split(hd1, sigprop_mean, perf_mean, 'Sig. Prop');
ylim(hd1, [66, 80]);
subplot(1,2,2);
text(0.1, 0.4, ['inject\_noise = ' num2str(inject_noise)])
text(0.1, 0.6, ['ntrial_thresh = ' num2str(split_metrics.trial_thresh)])
text(0.1, 0.8, ['nstem_thresh = ' num2str(split_metrics.nstem_thresh)])
axis off

printNK(['Perf v splittiness by mice - sig prop only ' text_append],'alt')

%% Run decoder analysis - needed before running the code above!
niters = 100; % num iterations
leave_out_prop = 0.5;
nshuf = 1000;

% Pre-allocate #animals x niters x nsesh x nbins_stem
tic
% corr_ratio_mean_all = nan(4, niters, length(sesh_use), 12); 
corr_ratio_mean_all = cell(1,4);
corr_ratio_mean_shuf_all = cell(1,4);
for n = 1:4
    sesh_use = alt_all_cell{n}; % Grab all sessions for one animal
    sesh_use = sesh_use(alt_get_sesh_type(sesh_use)); % Grab free sessions only
    hw = waitbar(0, ['Running LDA analysis for ' ...
        mouse_name_title(sesh_use(1).Animal) ' ...']); 
    corr_ratio_mean_all{n} = nan(length(sesh_use), 12, niters);
    corr_ratio_mean_shuf_all{n} = nan(length(sesh_use), 12, nshuf);
    for j = 1:length(sesh_use)
        LDAperf = nan(12,niters);
%         try
%             load(fullfile(sesh_use(j).Location,'LDAperf.mat'), 'LDAperf');
%         catch
            LDAperf_shuf = nan;
            for k = 1:niters
                % Correct ratio = average decoder performance along the whole stem
                
                try
                    if k == 1
                        [temp, LDAperf_shuf] = alt_LDA(sesh_use(j), ...
                            leave_out_prop, nshuf);
                    elseif k > 1 % Don't shuffle after 1st iteration
                        temp = alt_LDA(sesh_use(j), leave_out_prop, 0);
                    end
                catch
                    temp = nan;
                end
                
                LDAperf(:,k) = temp;
                waitbar(((j-1)*niters+k)/(niters*length(sesh_use)),hw);
            end
%         end
        corr_ratio_mean_all{n}(j,:,:) = LDAperf;
        corr_ratio_mean_shuf_all{n}(j,:,:) = LDAperf_shuf;
        save(fullfile(sesh_use(j).Location,['LDAperf_w_shuf' text_append '.mat']), 'LDAperf',...
            'LDAperf_shuf', 'niters', 'nshuf', 'leave_out_prop');
        waitbar(j/length(sesh_use),hw);
        
    end
    close(hw);
end
toc

%% Now do above but downsample each mouse's sessions to match that of G31 or
% upsample/resample all the mice to match G48...
[alt_c_match_min, alt_c_match_max] = match_sesh_num(alt_all_cell);
[~,~, rhos, pvals] = plot_perf_v_split_metrics(cat(2,alt_c_match_min{:}));
plot_perf_v_split_metrics(cat(2,alt_c_match_max{:}));

%% Now do the above but shuffle everything and get a p-value for downsampling
% then plot distribution
nshuf = 1000;

hw = waitbar(0,'Downsampling and calculating perf v splittiness pvals');
pdown = struct([]);
rhodown = struct([]);
for j = 1:nshuf
    [alt_c_match_min, ~] = match_sesh_num(alt_all_cell);
    [~, h, rhotemp, ptemp] = plot_perf_v_split_metrics(cat(2,alt_c_match_min{:}), ...
        true);    
    close(h)
    waitbar(j/nshuf, hw);
    pdown = cat(1, pdown, ptemp);
    rhodown = cat(1, rhodown, rhotemp);
end
close(hw)

save_file = fullfile(G30_alt(1).Location, ['perf_v_split_downsampled_stats_' ...
    datestr(now,1)]);

save(save_file, 'pdown', 'rhodown');

%% Plot all the above metrics in hisogram format
figure; set(gcf,'Position',[2400 560 870 405]);

metrics = cat(2, cat(1,pdown.rely), cat(1,pdown.LDA), cat(1,pdown.dmaxnorm),...
    cat(1,pdown.dint), cat(1,pdown.rho));
titles = {'Rely Score', 'LDA Accuracy', '\Delta_{max,norm}', ...
    '\Sigma|\Delta|_{norm}', '\rho'};

xlims = [0 1; 0 1; 0 0.4; 0 0.4; 0 1];

for j = 1:5
    ha = subplot(2,3,j);
    histogram(metrics(:,j)); hold on
    plot(mean(metrics(:,j))*ones(1,2), get(gca,'YLim'), 'k--')
    xlabel('pval'); ylabel('Count'); title(titles{j});
    text(0.4*ha.XLim(2), 0.8*ha.YLim(2),['mean = ' ...
        num2str(mean(metrics(:,j)),'%0.2g')])
    ha.Box = 'off';
    ha.XTick = xlims(j,:);
    ha.XLim = xlims(j,:);
end

printNK('Downsampled perf_v_split pvalues','alt')

%% Related to above - Performance versus ntrials...
[alt_c_match_min, alt_c_match_max] = match_sesh_num(alt_all_cell);
alt_plot_perf_v_ntrials(cat(2,alt_c_match_min{:}))

%% Get # splitters for all mice each day
nsplit = cell(1,4);
for j = 1:4
    sesh_use = alt_all_cell{j}(alt_all_free_boolc{j}); % Get free sessions for each mouse
    nsplit{j} = nan(length(sesh_use),1);
    for k = 1:length(sesh_use)
       load(fullfile(sesh_use(k).Location,'sigSplitters.mat'),'numSplitters')
       nsplit{j}(k) = numSplitters;
    end
end

%% Do Emma Wood analysis and get % of our splitters that pass her criteria
sig_thresh = 3;
alpha = 0.05;

pct_pass = cell(1,4);
for j = 1:4
    disp(['Doing Emma Wood analysis for mouse ' num2str(j)])
    [~, ~, free_bool] = alt_id_sesh_type(alt_all_cell{j});
    seshs_use = alt_all_cell{j}(free_bool);
    pct_pass{j} = nan(1,length(seshs_use));
    for k = 1:length(seshs_use)
       [p, tbl, ps, ts] = alt_wood_analysis(seshs_use(k));
       sigwood = p(:,1) < alpha | p(:,3) < alpha;
       sigbool = alt_id_sigsplitters(seshs_use(k), sig_thresh);
       pct_pass{j}(k) = sum(sigbool & sigwood)/sum(sigbool);
    end
    
end
    
pass_mean = cellfun(@nanmean, pct_pass)
pass_std = cellfun(@nanstd, pct_pass)

%% Plot reliability vs discriminatbility
[~, ~, sigbool, ~, ~, ~, dint_norm, ~, rely_mean] = ...
    arrayfun(@(a) parse_splitters(a.Location, 3, true), alt_all, ...
    'UniformOutput', false);
sigbool_all = cat(1,sigbool{:});
dint_norm_all = cat(1, dint_norm{:});
rely_mean_all = cat(1, rely_mean{:});

figure; set(gcf, 'Position', [375 440 660 435]);
hp = plot(dint_norm_all(~sigbool_all), rely_mean_all(~sigbool_all), 'b.',...
    dint_norm_all(sigbool_all), rely_mean_all(sigbool_all), 'r.');
xlabel('Reliability'); ylabel('Discriminability');
legend(hp,{'Non-splitters','Splitters'})
make_plot_pretty(gca)
printNK('Reliability vs Discriminability Scatter - All Mice','alt');

figure; set(gcf, 'Position', [475 540 660 435]);
hd = histogram(dint_norm_all, 0:0.05:1); 
hold on; 
hr = histogram(rely_mean_all, 0:0.05:1);
ylabel('Count'); xlabel('Disc. or Rely. Value');
legend(cat(1,hd,hr),{'Discriminability','Reliability'})
make_plot_pretty(gca)
printNK('Reliability and Discriminability Histograms - All Mice','alt');


