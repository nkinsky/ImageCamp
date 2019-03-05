% Alternation Behavioral Plots
alternation_reference
num_animals = length(alt_all_cell);

%% Plot Performance vs splitting
plot_split_v_perf_batch( alt_all ); % Plot all alone
%%
figure;
for j = 1:num_animals
    MD_use = alt_all_cell{j};
    ha_perf = subplot(2, 4, j);
    ha_time = subplot(2, 4, 4 + j);
    plot_split_v_perf_batch( MD_use, [], ha_perf, ha_time );
    
end
% Plot combined
% ha_perf = subplot(2,5,5);
% ha_time = subplot(2,5,10);
% plot_split_v_perf_batch( alt_all, ha_perf, ha_time );

%% Loop through to see if you still have a significant result when you match
% sample sizes between animals (7 = min (G31), G30 = 10 legit).
max_sesh_num = 7; % 7 = num legit sessions for G31.
niters = 1000;
p_notime = nan(niters,1); F_notime = nan(niters,1);
p_noperf = nan(niters,1); F_noperf = nan(niters,1);
p_both = nan(niters,1); F_both = nan(niters,1);
hw = waitbar(0,['Running ' num2str(niters) ' iterations of size-matched glm for split prop. v time v perf...']);
for j = 1:niters
  [glm_notime, glm_noperf, glm_both ] = plot_split_v_perf_batch(...
      alt_all, max_sesh_num, nan, nan);
  [p_notime(j), F_notime(j)] = glm_notime.coefTest;
  [p_noperf(j), F_noperf(j)] = glm_noperf.coefTest;
  [p_both(j), F_both(j)] = glm_both.coefTest;
  waitbar(j/niters,hw)
end
close(hw)
r_notime = 1; r_noperf = 1; r_both = 2;
nsamp = 4*max_sesh_num;

% Save below to deal with later.
save(fullfile(G30_alt(1).Location,'perfomance_glm_results.mat'),...
    'p_notime', 'p_noperf', 'p_both', 'glm_notime', 'glm_noperf', 'glm_both')

%% Take home: No evidence to support proportion of splitters predicting 
% performance. One mouse (G48) does support this, G31 supports the idea of
% splitters coming online with time, but the other two show mixed
% results...better question might be how does splitting correlate with
% memory load?

%% Better support - proportion of splitters is mainly related to # trials. 
% If I run code below I see a significant results for #trials in the glm
% and a pval of 0.12 for performance and 0.88 for time

[~,~,~, glm_all] = plot_split_v_perf_batch(alt_all);

%% Plot performance for each trial for each mouse
window = 5; % trial averaging window
for j = 1:num_animals
    MD_use = alt_all_cell{j};
    alt_plot_perf_batch(MD_use, 'window', window, 'legend_flag', false,...
        'lc_smooth_window', nan)
end

%% Ditto to above but loop through and spit out a file for each smoothing 
% for learning curves from 3-6
lc_sm_windows = 3:6;
for k = 1:length(lc_sm_windows)
    window = lc_sm_windows(k);
    for j = 1:4
        MD_use = alt_all_behavior_cell{j};
        [~, hf_lc] = alt_plot_perf_batch(MD_use, 'window', window, 'legend_flag', false,...
            'lc_smooth_window', window);
        printNK(['Smoothed Learning Curves Window=' num2str(window)],'alt',...
            'hfig', hf_lc, 'append', true);
    end
end

%% Now spit out overlaid performance plots for classifying learning stages!
lc_sm_windows = 3:6;
for k = 1:length(lc_sm_windows)
    window = lc_sm_windows(k);
    [hsesh, hday] = alt_plot_lc_overlaid(alt_all_behavior_cell, window);
    printNK('LCs overlaid by sesh', 'alt', 'hfig', hsesh, 'append', true);
    printNK('LCs overlaid by day', 'alt', 'hfig', hday, 'append', true);
    close(hsesh); close(hday);
end

%% Summarize Performance in Will's box-whisker plot
position = [2300 460 610 350];
[names,~,~,inds] = get_unique_values(alt_all_behavior);
[perf, split_prop,~, acclim_bool, forced_bool] = ...
    get_split_v_perf(alt_all_behavior);
legit_bool = ~acclim_bool & ~forced_bool;
scatterBox(perf(legit_bool), inds(legit_bool,1), 'xLabels', names, 'yLabel', ...
    'Performance','transparency', 0.7, 'sf', 0.025, 'position', position, ...
    'circleColors', [0.3, 0.3, 0.3]);
hold on;
hcrit = plot(get(gca,'XLim'),[0.70 0.70],'r--');
hchance = plot(get(gca,'XLim'),[0.5 0.5],'k:');
legend(cat(1,hcrit,hchance),{'Criteria','Chance'})
make_plot_pretty(gca)

%% Breakdown splitter propotion

