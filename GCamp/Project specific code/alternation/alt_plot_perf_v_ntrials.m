function [] = alt_plot_perf_v_ntrials(sessions, ntrial_thresh)
% [] = alt_plot_perf_v_ntrials(sessions, ntrial_thresh)
%   Plots performance versus ntrials. ntrial_thresh = 30 (default) (exclude those
%   under this for analysis).

if nargin < 2
    ntrial_thresh = 30;
end

% Get free sessions
[~, ~, free_bool] = alt_id_sesh_type(sessions);
sesh_free = sessions(free_bool);

% Get performance
[perf_calc, perf_notes, perf_trial] = alt_get_perf(sesh_free);
ntrials = cellfun(@length, perf_trial);
perf_comb = nanmean([perf_calc, perf_notes],2);

% Apply ntrial threshold
ntrial_bool = ntrials >= ntrial_thresh;
ntrials = ntrials(ntrial_bool);
perf_comb = perf_comb(ntrial_bool);

%% Plot everything
figure; set(gcf,'Position', [2245 348 630 575])
hd = plot(ntrials, perf_comb*100, 'o');
set(gca,'Box','off')
ylabel('Performance (%)'); xlabel('# Trials')
unique_names = unique(arrayfun(@(a) ...
    mouse_name_title(a.Animal),sessions,'UniformOutput',false));
title(unique_names) % Put all animal names in here.
hold on;

% Get correlation and best-fit line and plot
[rho, pval] = corr(ntrials, perf_comb);
lm = fitlm(ntrials, perf_comb*100);
ypred = lm.feval([min(ntrials) max(ntrials)]);
hreg = plot([min(ntrials) max(ntrials)], ypred, 'r--');
text(min(ntrials) + 5, 85, ['\rho = ' num2str(rho, '%0.2f')])
text(min(ntrials) + 5, 82, ['p = ' num2str(pval, '%0.2f')])
legend(cat(1,hd,hreg),{'Data','Best Fit'})

% Make things pretty
make_plot_pretty(gca)

end

