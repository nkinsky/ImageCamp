%% Plot out neuron registration comparison metrics

figure(1234);
n_bins = 20;

% Dist between centroids
metric = squeeze(cm_dist(1,2,:));
metric_jitter = squeeze(cm_dist_jitter(1,2,:));
subplot(2,2,1); 
[f_metric, x_metric] = ecdf(metric); 
stairs(x_metric, f_metric); hold on; 
[f_metric_jitter, x_metric_jitter] = ecdf(metric_jitter);
stairs(x_metric_jitter, f_metric_jitter);
legend('Actual','With Jitter')
xlabel('Distance between centroids (pixels)')

% [n_metric, c_metric] = ecdfhist(f_metric, x_metric, n_bins);
% [n_metric_jitter, c_metric_jitter] = ecdfhist(f_metric_jitter, x_metric_jitter, n_bins);
% subplot(2,3,4);
% plot(c_metric, n_metric/sum(n_metric),'b', c_metric_jitter,...
%     n_metric_jitter/sum(n_metric_jitter),'r')
% legend('Actual','With Jitter')
% xlabel('Distance between centroids (pixels)')
% ylabel('Normalized Count')

% Axis Ratio
metric = abs(squeeze(ratio_diff(1,2,:)));
metric_jitter = abs(squeeze(ratio_diff_jitter(1,2,:)));
metric_shuffle = abs(squeeze(ratio_diff_shuffle(1,2,:)));

subplot(2,2,2); 
[f_metric, x_metric] = ecdf(metric); 
stairs(x_metric, f_metric); hold on; 
[f_metric_jitter, x_metric_jitter] = ecdf(metric_jitter);
stairs(x_metric_jitter, f_metric_jitter);
[f_metric_shuffle, x_metric_shuffle] = ecdf(metric_shuffle);
stairs(x_metric_shuffle, f_metric_shuffle);
legend('Actual','With Jitter','Shuffled')
xlabel('Axis Ratio Difference')

% [n_metric, c_metric] = ecdfhist(f_metric, x_metric, n_bins);
% [n_metric_jitter, c_metric_jitter] = ecdfhist(f_metric_jitter, x_metric_jitter, n_bins);
% [n_metric_shuffle, c_metric_shuffle] = ecdfhist(f_metric_shuffle, x_metric_shuffle, n_bins);
% subplot(2,3,5);
% plot(c_metric, n_metric/sum(n_metric),'b', c_metric_jitter, n_metric_jitter/sum(n_metric_jitter),...
%     'r', c_metric_shuffle, n_metric_shuffle/sum(n_metric_shuffle),'c')
% legend('Actual','With Jitter','Shuffled')
% xlabel('Axis Ratio Difference')
% ylabel('Normalized Count')

% Major Axis Orientation
metric = abs(squeeze(orientation_diff(1,2,:)));
metric_jitter = abs(squeeze(orientation_diff_jitter(1,2,:)));
metric_shuffle = abs(squeeze(orientation_diff_shuffle(1,2,:)));


subplot(2,2,3)
[f_metric, x_metric] = ecdf(metric); 
stairs(x_metric, f_metric); hold on; 
[f_metric_jitter, x_metric_jitter] = ecdf(metric_jitter);
stairs(x_metric_jitter, f_metric_jitter);
[f_metric_shuffle, x_metric_shuffle] = ecdf(metric_shuffle);
stairs(x_metric_shuffle, f_metric_shuffle);
legend('Actual','With Jitter','Shuffled')
xlabel('Major Axis Angle Difference')
xlims = get(gca,'XLim');

% Plot PF distance differences
metric = min_dist{1,2};
metric_jitter = min_dist_jitter{1,2};
metric_shuffle = min_dist_shuffle;

subplot(2,2,4)
[f_metric, x_metric] = ecdf(metric); 
stairs(x_metric, f_metric); hold on; 
[f_metric_jitter, x_metric_jitter] = ecdf(metric_jitter);
stairs(x_metric_jitter, f_metric_jitter);
[f_metric_shuffle, x_metric_shuffle] = ecdf(metric_shuffle);
stairs(x_metric_shuffle, f_metric_shuffle);
legend('Actual','With Jitter','Shuffled')
xlabel('Distance to place field in second session')
xlims = get(gca,'XLim');

% [n_metric, c_metric] = ecdfhist(f_metric, x_metric, n_bins);
% [n_metric_jitter, c_metric_jitter] = ecdfhist(f_metric_jitter, x_metric_jitter, n_bins);
% [n_metric_shuffle, c_metric_shuffle] = ecdfhist(f_metric_shuffle, x_metric_shuffle, n_bins);
% subplot(2,3,6);
% plot(c_metric, n_metric/sum(n_metric),'b', c_metric_jitter, n_metric_jitter/sum(n_metric_jitter),...
%     'r', c_metric_shuffle, n_metric_shuffle/sum(n_metric_shuffle),'c')
% legend('Actual','With Jitter','Shuffled')
% xlabel('Major Axis Angle Difference')
% ylabel('Normalized Count')