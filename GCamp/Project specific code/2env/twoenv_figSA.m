% Twoenv Figure SA - reg quality vs coherent neurons

%% Are coherent neurons a result of better neuron registration?
% Use twoenv_coherent_reg and do kstest2 between the two subpopulations to
% determine if that is the case for individual sessions.  Then aggregate
% plots for all sessions

base_sesh = G30_square(1);
mean_aod_all = [];
mean_corr_all = [];
n = 1;
for j = 1:7
    for k = j+1:8
        [rc, rm] = twoenv_coherent_reg(base_sesh, G30_square(j), G30_square(k),...
            'square');
        mean_aod_all = cat(1, mean_aod_all, [mean(abs(rc.orient_diff)),...
            mean(abs(rm.orient_diff))]);
        mean_corr_all = cat(1, mean_corr_all, [mean(abs(rc.avg_corr)),...
            mean(abs(rm.avg_corr))]);
        coh_v_reg_neurons(n).regstats_coh = rc;
        coh_v_reg_neurons(n).regstats_remap = rm;
        n = n+1;
    end
end

save(fullfile(ChangeDirectory_NK(base_sesh,0),'reg_quality_vs_coherent_neurons.mat'), ...
    'mean_aod_all', 'mean_corr_all', 'coh_v_reg_neurons');
figure; hold on;
arrayfun(@(a,b) plot([1 2], [a b],'ko-'), mean_aod_all(:,1), mean_aod_all(:,2));
xlim([0.5 2.5])


%% Plot for one session
figure(27); set(gcf,'Position', [360         447         1200         420])
subplot(1,2,1)
histogram(rc.orient_diff,20,'Normalization','probability'); 
hold on; 
histogram(rm.orient_diff,20,'Normalization','probability'); 
legend('Coherent', 'Rand. Remap')
make_plot_pretty(gca)

% Plot aggregate for all sessions
subplot(1,2,2)
hold on;
arrayfun(@(a,b) plot([1 2], [a b],'ko-'), mean_aod_all(:,1), mean_aod_all(:,2));
xlim([0.5 2.5])
[h,p] = ttest(mean_aod_all(:,1), mean_aod_all(:,2),'tail','left'); % Doesn't look good
% Small but significant increase in mean absolution orientation difference
% for remapping cells over coherent cells.  Actually this biases in our
% favor! Means we might have some remappers due to bad registration!
set(gca,'XTick',[1 2],'XTickLabel',{'Coherent','Rand. Remap'})
ylabel('Mean |\Delta_{orient}|')
make_plot_pretty(gca)
title('All sessions breakdown for G30 square')

%% Are remapping sessions a result of a bad neuron registration?
% Get neuron reg_stats = neuron_reg_qc(sesh1,sesh2) and plot
% mean(abs(reg_stats.orient_diff)) for all remapping sessions vs coherent
% sessions.  Will be difficult for many mice like G45 with no global
% remapping sessions.
