% Alternation Behavioral Plots
alternation_reference
num_animals = length(alt_all_cell);

%% Plot Performance vs splitting
plot_split_v_perf_batch( alt_all ); % Plot all alone
figure;
for j = 1:num_animals
    MD_use = alt_all_cell{j};
    ha = subplot(2,3,j);
    plot_split_v_perf_batch( MD_use, ha );
    
end
% Plot combined
ha = subplot(2,3,5);
plot_split_v_perf_batch( alt_all, ha );

%% Plot performance for each trial for each mouse
window = 5; % trial averaging window
for j = 1:num_animals
    MD_use = alt_all_cell{j};
    
    alt_plot_perf_batch(MD_use, window)
end

%% Summarize Performance in Will's box-whisker plot
position = [2300 360 840 450];
[names,~,~,inds] = get_unique_values(alt_all);
[perf, ~,~, acclim_bool, forced_bool] = get_split_v_perf(alt_all);
legit_bool = ~acclim_bool & ~forced_bool;
scatterBox(perf(legit_bool), inds(legit_bool,1), 'xLabels', names, 'yLabel', 'Performance',...
    'transparency',0.7,'sf', 0.01,'position',position);
hold on;
plot(get(gca,'XLim'),[0.75 0.75],'r--')
make_plot_pretty(gca)