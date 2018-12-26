function [split_metrics, hmain] = plot_perf_v_split_metrics(sessions,...
    plot_flag, cnoise, trial_thresh)
% [split_metrics, hmain]  = plot_perf_v_split_metrics(sessions, plot_flag, ...
%   cnoise, ntrial_thresh)
%  Plots animal performance versus "splittiness" metrics.

if nargin < 4
    % Must have at LEAST this many trials in a session to be considered
    trial_thresh = 20;
    % no noise by default
    if nargin < 3
        cnoise = false;
        % Plot by default
        if nargin < 2
            plot_flag = true;
        end
    end
end

% Must be active on at least this many trials on the stem to be considered
nstem_thresh = 5; 


%% NRK first step = parse into free versus forced sessions
[free_bool, acclim_bool, forced_bool] = alt_get_sesh_type(sessions);

% Get deltamax, deltamax_norm, and rely (1-p) for each neuron in each
% session
[rely_vals, dmax, ~, ~, dmax_norm, nactive_stem, dint_norm, curve_corr] = ...
    arrayfun(@(a) parse_splitters(a.Location, 3, cnoise), sessions, ...
    'UniformOutput', false);

% Load LDA data to get decoder_perf
discr_perf = nan(1, length(sessions));
for j = 1:length(sessions)
    LDAperf = [];
    try % Load previously run LDA data
        load(fullfile(sessions(j).Location,'LDAperf.mat'), 'LDAperf');
    catch
        LDAperf = nan;
    end
    discr_perf(j) = nanmean(LDAperf(:))*100; % Take mean and make into a percentage
end

% Get performance & perform trial threshold
[perf_calc, perf_notes, perf_by_trial] = alt_get_perf(sessions);
ntrials = cellfun(@length, perf_by_trial);
perf_comb = nanmean([perf_calc'; perf_notes'])*100;

% Only include sessions with ntrials > trial_thresh
ntrial_bool = ntrials' > trial_thresh;
free_bool = free_bool & ntrial_bool;
forced_bool = forced_bool & ntrial_bool;
acclim_bool = acclim_bool & ntrial_bool;

perf_comb(~free_bool) = nan;

rely_mean = cellfun(@nanmean, rely_vals);
dmax_mean = cellfun(@nanmean, dmax);
dmax_norm_mean = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), ...
    dmax_norm, nactive_stem);
dint_norm_mean = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), ...
    dint_norm, nactive_stem);
curve_corr_mean = cellfun(@(a,b) nanmean(a(b > nstem_thresh)), ...
    curve_corr, nactive_stem);

% Accumulate splittiness metrics (and performance) into one variable
split_metrics.rely_mean = rely_mean;
split_metrics.dmax_mean = dmax_mean;
split_metrics.dmax_norm_mean = dmax_norm_mean;
split_metrics.perf = perf_comb;
split_metrics.dint_norm_mean = dint_norm_mean;
split_metrics.curve_corr_mean = curve_corr_mean;
split_metrics.trial_thresh = trial_thresh;
split_metrics.nstem_thresh = nstem_thresh;
split_metrics.discr_perf = discr_perf;

% %% Get correlations and stats - now done in plot_func subfunction
% [rho_r, p_r] = corr(rely_mean', perf_comb', 'rows','complete');
% [rho_d, p_d] = corr(dmax_mean', perf_comb', 'rows','complete');
% [rho_dn, p_dn] = corr(dmax_norm_mean', perf_comb', 'rows','complete');

%% Plot stuff & do stats on each for correlations...
if plot_flag
    
    hmain = figure;  set(gcf,'Position', [1964 157 1398 761]);
    
    % Get names of all mice being plotted automatically
    unique_names = unique(arrayfun(@(a) ...
        mouse_name_title(a.Animal),sessions,'UniformOutput',false));
    
    % Plot performnace versus splitter metrics
    h1 = subplot(2,12,1:3); h2 = subplot(2,12,5:7); h3 = subplot(2,12,10:12);
    h4 = subplot(2,12,13:15); h5 = subplot(2,12,17:19);
    plot_func(h1, rely_mean, perf_comb, 'Reliability (1-p)', true);
    title(h1, unique_names); % put in names of all mice plotted
    % Don't plot this anymore - different levels of fluorescence between
    % animals affects it a lot!
%     plot_func(h2, dmax_mean, perf_comb, '|\Delta_{max}|', true);
    plot_func(h2, discr_perf, perf_comb, 'Decoder (LDA) Accuracy (%)', true);
    plot_func(h3, dmax_norm_mean, perf_comb, '|\Delta_{max}|_{norm}', true); 
    plot_func(h4, dint_norm_mean, perf_comb, '\Sigma|\Delta|_{norm}', true);
    plot_func(h5, curve_corr_mean, perf_comb, '\rho_{mean}', true);
    
    % Free vs Forced for all metrics - don't use ntrial_thresh here? Not
    % sure how useful this is anymore, keeping as legacy just in case
    figure(hmain);
    hr = subplot(2,12,22); hd = subplot(2,12,23); hdn = subplot(2,12,24);
    perf_groups = (free_bool + 2*(forced_bool | acclim_bool))';
    
    if length(unique(perf_groups(ntrial_bool))) > 1
        scatterBox(rely_mean(ntrial_bool), perf_groups(ntrial_bool), 'xLabels', ...
            {'Free', 'Not'}, 'yLabel', 'Reliability (1-p)', 'h', hr);
        
        scatterBox(dmax_mean(ntrial_bool), perf_groups(ntrial_bool), 'xLabels', ...
            {'Free', 'Not'}, 'yLabel', '|\Delta_{max}|', 'h', hd);
        
        scatterBox(dmax_norm_mean(ntrial_bool), perf_groups(ntrial_bool), 'xLabels', ...
            {'Free', 'Not'}, 'yLabel', '|\Delta_{max}|_{norm}', 'h', hdn);
        
        % Stats on Free vs Forced
        prks_r = ranksum(rely_mean(free_bool), rely_mean(forced_bool | acclim_bool),...
            'tail', 'right');
        prks_d = ranksum(dmax_mean(free_bool), dmax_mean(forced_bool | acclim_bool),...
            'tail', 'right');
        try
            prks_dn = ranksum(dmax_norm_mean(free_bool), dmax_norm_mean(forced_bool | ...
                acclim_bool), 'tail', 'right');
        catch
            prks_dn = nan;
        end
        
        subplot(2,12,20);
        text(0.1, 0.9, 'Rank-sum p vals')
        text(0.1, 0.8, 'One-sided (free > forced)')
        text(0.1, 0.7, ['rely = ' num2str(prks_r,' %0.2f')])
        text(0.1, 0.6, ['|Delta_{max}| = ' num2str(prks_d,' %0.2f')])
        text(0.1, 0.5, ['|Delta_{max}|_{norm} = ' num2str(prks_dn,' %0.2f')])
        text(0.1, 0.3, ['ntrial\_thresh = ' num2str(trial_thresh)])
        text(0.1, 0.2, ['nstem\_thresh = ' num2str(nstem_thresh)])
        text(0.1, 0.1, ['inject_noise = ' num2str(cnoise)])
        axis off
        
    elseif length(unique(perf_groups(ntrial_bool))) == 1
        subplot(2,12,22:24);
        text(0.1,0.5, 'No forced or looping trials for comparison')
        axis off
    end
    
else
    hmain = [];
    
end



end

%% Plot function - plots performance vs. splittiness metric and puts stats on it
function [] = plot_func(ax, metric, perf, metric_label, plot_stats)

% Get corr value and stats
[rho, p] = corr(metric', perf', 'rows','complete');
free_bool = ~isnan(perf);

% Plot ploints
plot(ax, metric, perf, 'o');
ylabel(ax, 'Performance (%)');
xlabel(ax, metric_label);
% Plot stats
if plot_stats
    text(ax, min(metric(free_bool)) + 0.01, max(perf(free_bool)) - 5, ...
        ['\rho = ' num2str(rho, '%0.2f')]);
    text(ax, min(metric(free_bool)) + 0.01, max(perf(free_bool)) - 7, ...
        ['p = ' num2str(p, '%0.2g')]);
    set(gca,'Box','off');
    make_plot_pretty(gca);
    
    % Get regression line and plot
    lm = fitlm(metric, perf);
    perf_pred = lm.feval([min(metric(free_bool)), max(metric(free_bool))]);
    ax.NextPlot = 'add'; % hold on
    hpred = plot(ax, [min(metric(free_bool)), max(metric(free_bool))], perf_pred, 'r--');
    legend(hpred, 'Best-fit')
end
make_plot_pretty(ax);

end

