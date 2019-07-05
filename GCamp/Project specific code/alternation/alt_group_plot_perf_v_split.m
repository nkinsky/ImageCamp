function [] = alt_group_plot_perf_v_split(ax, metric_mean, perf_mean, metric_label)
% Plots mean performance v splittiness metrics for each mouse

plot(ax, metric_mean, perf_mean, '^'); 
ylabel(ax, 'Performance (%)');
xlabel(ax, metric_label);

% Get regression line and plot
lm_mice = fitlm(metric_mean, perf_mean);
perf_pred = lm_mice.feval([min(metric_mean), max(metric_mean)]);
ax.NextPlot = 'add'; % hold on
plot(ax, [min(metric_mean), max(metric_mean)], perf_pred, 'r--')
text(ax, min(metric_mean), 75, ['\rho = ' num2str(lm_mice.Rsquared.Ordinary,'%0.2g')]);
text(ax, min(metric_mean), 73, ['p = ' num2str(lm_mice.Coefficients.pValue(2),'%0.2g')]);

make_plot_pretty(ax);

end

