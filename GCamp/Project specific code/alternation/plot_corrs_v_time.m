function [hf, ha] = plot_corrs_v_time(PFcorr_by_day_apc, PFcorr_by_day_sp, ...
    unique_lags, varargin)
%   [hf, ha] = plot_splitcorrs_v_time(PFcorr_by_day_apc, PFcorr_by_day_sp, ...
%    unique_lags,...(PFpval_by_day optional))
%
%   Plots place-field correlations for arm-place cells (apcs) versus
%   splitters (sp) over time. Use with outputs from splitcorr_v_time. Could
%   be generalized easily if needed. ha(1) = plot, ha(2) = stats

ip = inputParser;
ip.addRequired('PFcorr_by_day_apc', @iscell);
ip.addRequired('PFcorr_by_day_sp', @(a) iscell(a) && length(a) == ...
    length(PFcorr_by_day_apc));
ip.addRequired('unique_lags', @(a) isnumeric(a) && length(a) == ...
    length(PFcorr_by_day_apc));
ip.addParameter('PFpval_by_day', [], @iscell);
ip.addParameter('PFCI_by_day', [], @iscell);
ip.addParameter('mean_or_best', 'mean', @(a) ismember(a, {'mean', 'best'})); %plot mean or linear regression
ip.addParameter('grp_labels', {'Arm PCs', 'Splitters'}, @iscell); % Group names
ip.addParameter('sf_use', 0.05, @isscalar);
ip.parse(PFcorr_by_day_apc, PFcorr_by_day_sp, unique_lags, varargin{:});
PFpval_by_day = ip.Results.PFpval_by_day;
PFCI_by_day = ip.Results.PFCI_by_day;
mean_or_best = ip.Results.mean_or_best;
grp_labels = ip.Results.grp_labels;
sf_use = ip.Results.sf_use;

alpha = 0.05;

labels = {'Mean', 'Best Fit'};
line_label = labels{strcmpi(mean_or_best, {'mean', 'best'})};

hf = figure; set(gcf, 'Position', [10 160 800 760]);
ha(1) = subplot(5,1,1:3);

lag_jitter = 0.1;
% Get place field variables organized nicely
[PFout_apc, PFdayout] = scatterbox_reshape(PFcorr_by_day_apc, unique_lags); % All neurons
PFout_sp = scatterbox_reshape(PFcorr_by_day_sp, unique_lags); % Splitters only

% Grab only days that have valid data for both splitters and place-cells
% (could occur if you only have < 4 cells in a category, most likely
% splitters).
match_bool = all(~isnan([PFout_apc, PFout_sp]), 2);
PFout_sp = PFout_sp(match_bool); PFout_apc = PFout_apc(match_bool);
PFdayout = PFdayout(match_bool);
% Now plot all place field correlations
if ~isempty(PFpval_by_day)
    [pPFout,~] = scatterbox_reshape(PFpval_by_day, unique_lags); % pvals to id gl. rmp. sessions
    % Plot non-remapping days in red
    [~, ~, hp1] = scatterBox(PFout_apc(pPFout < alpha),PFdayout(pPFout < alpha) + lag_jitter,'xLabels',...
        arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', ha(1), ...
        'yLabel', 'mean \rho_{TMmap,smoothed}', 'sf', sf_use, ...
        'circleColors', [1 0 0], 'transparency', 0.7, 'plotBox', false);
    % Plot remapping days in lighter red
    [~, ~, hp2] = scatterBox(PFout_apc(pPFout >= alpha),PFdayout(pPFout >= alpha) + lag_jitter,'xLabels',...
        arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', ha(1), ...
        'yLabel', 'mean \rho_{TMmap,smoothed}', 'sf', sf_use,...
        'circleColors', [0.2 0 0], 'transparency', 0.7, 'plotBox', false);
    % Plot splitters in green
    [~, ~, hps1] = scatterBox(PFout_sp(pPFout < alpha),PFdayout(pPFout < alpha) - lag_jitter,'xLabels',...
        arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', ha(1), ...
        'yLabel', 'mean \rho_{TMmap,smoothed}', 'sf', sf_use,...
        'circleColors', [0 1 0], 'transparency', 0.7, 'plotBox', false);
    set(hps1,'MarkerFaceColor','none','MarkerEdgeColor','flat','Marker','diamond');
    % Plot remapping days in lighter green
    [~, ~, hps2] =scatterBox(PFout_sp(pPFout >= alpha),PFdayout(pPFout >= alpha) - lag_jitter,'xLabels',...
        arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', ha(1), ...
        'yLabel', 'mean \rho_{TMmap,smoothed}', 'sf', sf_use,...
        'circleColors', [0 0.2 0], 'transparency', 0.7, 'plotBox', false);
    set(hps2,'MarkerFaceColor','none','MarkerEdgeColor','flat','Marker','diamond');
elseif isempty(PFpval_by_day)
    % Plot place cells in red
    [~, ~, hp1] = scatterBox(PFout_apc, PFdayout + lag_jitter,'xLabels',...
        arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', ha(1), ...
        'yLabel', 'mean \rho_{TMmap,smoothed}', 'sf', sf_use, ...
        'circleColors', [1 0 0], 'transparency', 0.7, 'plotBox', false);
    % Plot splitters in green
    [~, ~, hps1] = scatterBox(PFout_sp, PFdayout - lag_jitter,'xLabels',...
        arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', ha(1), ...
        'yLabel', 'mean \rho_{TMmap,smoothed}', 'sf', sf_use, ...
        'circleColors', [0 1 0], 'transparency', 0.7, 'plotBox', false);
end
xlabel('Lag (days)');
hold on; 
if ~isempty(PFCI_by_day)
    hCI = plot(unique_lags, PFCI_by_day, 'k-'); set(hCI([1 3]),...
        'LineStyle','--')
end
% title([mouse_name_title(session1.Animal) ' - ' mouse_name_title(comp_type)])

% Plot linear regression line/mean
PFlm = fitlm(PFdayout, PFout_apc);
PFslm = fitlm(PFdayout, PFout_sp);
day_bounds = [min(unique_lags), max(unique_lags)];
if strcmpi(mean_or_best, 'best')
    hbfp = plot(day_bounds, PFlm.Coefficients.Estimate(2)*day_bounds + ...
        PFlm.Coefficients.Estimate(1), 'r-');
    hbfp_s = plot(day_bounds, PFslm.Coefficients.Estimate(2)*day_bounds + ...
        PFslm.Coefficients.Estimate(1), 'g-');
elseif strcmpi(mean_or_best, 'mean')
    hbfp = plot(unique_lags, cellfun(@nanmean, PFcorr_by_day_apc), 'r-');
    hbfp_s = plot(unique_lags, cellfun(@nanmean, PFcorr_by_day_sp), 'g-');
end
set(gca,'XLim', get(gca,'XLim') + [-1 1]) % make sure xlims fall below data limits
if ~isempty(PFpval_by_day)
    legend(cat(1, hp1, hp2, hps1, hps2, hbfp, hbfp_s), {grp_labels{1}, ...
        [grp_labels{1} ' - Rmp. Sesh'], grp_labels{2}, ...
        [grp_labels{2} ' - Rmp. Sesh'], [line_label ' - ' grp_labels{1}], ...
        [line_label ' - ' grp_labels{2}]});
elseif isempty(PFpval_by_day)
    legend(cat(1, hp1, hps1, hbfp, hbfp_s), {grp_labels{1},  grp_labels{2}, ...
        [line_label ' - ' grp_labels{1}], [line_label ' - ' grp_labels{2}]});
end
make_plot_pretty(gca);

%% Perform signed-rank test at all lags and dump into figure
ha(2) = subplot(5,1,5);
p = cellfun(@(a,b) signrank(a, b, 'tail', 'right'), ...
    PFcorr_by_day_sp, PFcorr_by_day_apc);
[~, ip] = sort(p);
alpha_sort = (0.05/length(p):0.05/length(p):alpha)';
pass_bool(ip) = p(ip) < alpha_sort;
sigs = ' *';
lags_w_sig = arrayfun(@(a,b) cat(2,num2str(a),b,' '), unique_lags, ...
    sigs(pass_bool+1)', 'UniformOutput', false);
text(0.1, 1, ['* = signifcant at \alpha= ' num2str(alpha, '%0.1g') ' after Holm-Bonferroni correction'])
text(0.1, 0.8, ['lags = ' cat(2,lags_w_sig{:})])
text(0.1, 0.6, ['prksign = ' num2str(p', '%0.2g \t')])
text(0.1, 0.4, ['nsession_pairs = ' num2str(cellfun(@(a,b) sum(~isnan(a) & ~isnan(b)), ...
    PFcorr_by_day_apc, PFcorr_by_day_sp)')])
axis off

% 
% % Plot with boxes
% hPF2 = subplot(2,1,2);
% scatterBox(PFout_apc,PFdayout,'xLabels',...
%     arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF2, ...
%     'yLabel', 'mean \rho_{TMmap,smoothed}',...
%     'circleColors', [0.3 0.3 0.3], 'transparency', 0.7, 'plotBox', true);
% xlabel('Lag (days)');
% hold on; 
% if ~isempty(PFCI_by_day)
%     hCI = plot(unique_lags, PFCI_by_day, 'k-'); set(hCI([1 3]),...
%         'LineStyle','--')
% end
% PFlm = fitlm(PFdayout,PFout_apc);
% day_bounds = [min(unique_lags), max(unique_lags)];
% plot(day_bounds, PFlm.Coefficients.Estimate(2)*day_bounds + ...
%     PFlm.Coefficients.Estimate(1), 'g-');

end

