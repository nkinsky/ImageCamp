function [h, rdnorm, pdnorm, rdintn, pdintn, rdmax, pdmax] = ...
    alt_split_v_recur_batch(day_lag, comp_type, mice_sesh, varargin)
% [h, rdnorm, pdnorm, rdintn, pdintn] = alt_split_v_recur_batch(day_lag, comp_type, mice_sesh )
%   Plot various metrics of cell stability vs various metrics of
%   "splittiness" for all cells. Spits out correlation and p values for
%   dmax_norm and dint_norm...

ip = inputParser;
ip.addRequired('day_lag', @(a) a >=0);
ip.addRequired('comp_type', @(a) ismember(a,{'le', 'exact'})); % le: <=
ip.addRequired('mice_sesh', @(a) iscell(a) || isstruct(a));
% min # trials a neuron must be active on to be considered
ip.addParameter('ntrial_stem_thresh', 12, @(a) a >=0);
ip.addParameter('sigthresh', 3, @(a) a >= 1);
% Ensures min. resolution of 0.2 on calculated probabilities
ip.addParameter('bin_num_thresh', 5, @(a) a >= 1);
% resolution of reliability and delta bins
ip.addParameter('rely_res', 0.05, @(a) a > 0 && a <= 1); 
ip.addParameter('rely_mean_res', 0.05, @(a) a > 0 && a <= 1); 
ip.addParameter('delta_res', 0.1, @(a) a > 0 && a <= 1);
ip.addParameter('p_res', 0.1, @(a) a > 0 && a <= 1);
% range of bins for rely and delta
ip.addParameter('rely_range', [0.6 1], @(a) size(a,1) == 1 && size(a,2) == 2);
ip.addParameter('rely_mean_range', [0 1],  @(a) size(a,1) == 1 && size(a,2) == 2);
ip.addParameter('delta_range', [0 1], @(a) size(a,1) == 1 && size(a,2) == 2);
ip.addParameter('p_range', [0 1], @(a) size(a,1) == 1 && size(a,2) == 2);
% keep splitters only - see plot_split_v_recur
ip.addParameter('splitters_only', false, @islogical);
ip.addParameter('sesh_include', 'free_only', @(a) ismember(a,{'free_only',...
    'free_forced', 'all'}));

ip.parse(day_lag, comp_type, mice_sesh, varargin{:});
ntrial_stem_thresh = ip.Results.ntrial_stem_thresh;
sigthresh = ip.Results.sigthresh;
bin_num_thresh = ip.Results.bin_num_thresh;
rely_res = ip.Results.rely_res;
rely_mean_res = ip.Results.rely_mean_res;
delta_res = ip.Results.delta_res;
rely_range = ip.Results.rely_range;
rely_mean_range = ip.Results.rely_mean_range;
delta_range = ip.Results.delta_range;
splitters_only = ip.Results.splitters_only; 
p_range = ip.Results.p_range;
p_res = ip.Results.p_res;
sesh_include = ip.Results.sesh_include;

% ntrial_thresh = min # trials a neuron must be active on to be considered
% sigthresh = 3; % # sig. bins to be considered a splitter

% exclude histogram bins with fewer than this many neurons in them,
% designed to not calculate probabilities for bins with only a few neurons
% in them which could give us very inaccurate numbers (e.g. if there are 20
% neurons with a delta_max value between 0.5 and 0.55, but only 1 between
% 0.55 and 0.6, don't calculate probabilites for the latter - it is either
% 0 or 1! Other alternative is to use larger bins!
% bin_num_thresh = 5; % Ensures min. resolution of 0.2 on calculated probabilities

% rely_res = 0.05; 
% delta_res = 0.1;
rely_edges = rely_range(1):rely_res:rely_range(2); % 0:0.025:1;  
rely_mean_edges = rely_mean_range(1):rely_mean_res:rely_mean_range(2); % 0:0.025:1;  
delta_edges = delta_range(1):delta_res:delta_range(2); % 0:0.05:1; 
p_edges = p_range(1):p_res:p_range(2); % 0:0.05:1; 

nbins_rely = length(rely_edges) - 1;
nbins_rely_mean = length(rely_mean_edges) - 1;
nbins_delta = length(delta_edges) - 1;
nbins_p = length(p_edges) - 1;

% Deal out mice_sesh into appropriate variable (must be a cell)
if iscell(mice_sesh)
    num_mice = length(mice_sesh);
elseif isstruct(mice_sesh)
    num_mice = 1;
    temp = mice_sesh; 
    clear mice_sesh
    mice_sesh{1} = temp;
end

switch comp_type
    case 'exact'
        compfun = @eq;
    case 'le'
        compfun = @le;
    otherwise
        error('Must specify either ''exact'' or ''le'' for 2nd arg')
end

%% Get day lag between all sessions
tdiff_cell = cell(num_mice,1);
good_seshs = cell(num_mice,1);
for j = 1:num_mice
    tdiff_cell{j} = make_timediff_mat(mice_sesh{j});
    % ID sessions that are day_lag apart
    tdiff_bool = feval(compfun, tdiff_cell{j}, day_lag);
    % Get hand_check_mat to grab only good sessions
    [~, good_reg_mat_hand] = alt_hand_reg_order_check(mice_sesh{j});
    % reject any sessions not meeting the hand check
    tdiff_bool(good_reg_mat_hand == 0) = false;
    switch sesh_include
        case 'no_loop'
            [loop_bool, forced_bool, free_bool] = alt_id_sesh_type(mice_sesh{j});
            sesh_bool = (free_bool | forced_bool) & ~loop_bool;
            tdiff_bool = tdiff_bool.*sesh_bool';
        case 'free_only'
            [~, ~, free_bool] = alt_id_sesh_type(mice_sesh{j});
            tdiff_bool = tdiff_bool.*free_bool';
        case 'all' % keep as above if 'all'
            
    end
    [a,b] = find(tdiff_bool);
    good_seshs{j} = [a,b];
end
num_sesh = max(cellfun(@(a) size(a,1),good_seshs));

% NRK - exclude any forced or looping sessions?
%% Run alt_stability_v_cat
pco_v_rely_all = nan(num_mice,num_sesh,nbins_rely);
pstaybec_v_rely_all = nan(num_mice,num_sesh,nbins_rely); 
pco_v_relym_all = nan(num_mice,num_sesh,nbins_rely_mean);
pstaybec_v_relym_all = nan(num_mice,num_sesh,nbins_rely_mean); 
pco_v_dmax_all = nan(num_mice,num_sesh,nbins_delta);
pstaybec_v_dmax_all = nan(num_mice,num_sesh,nbins_delta);
pco_v_dnorm_all = nan(num_mice,num_sesh,nbins_delta);
pstaybec_v_dnorm_all = nan(num_mice,num_sesh,nbins_delta);
pco_v_dint_all = nan(num_mice,num_sesh,nbins_delta);
pstaybec_v_dint_all = nan(num_mice,num_sesh,nbins_delta);
pco_v_p_all = nan(num_mice,num_sesh, 4, nbins_p);  % 2nd last dim: min(pLR, pLRxsector), psector, pspeed, pypos
pstaybec_v_p_all = nan(num_mice,num_sesh, 4,nbins_p); 
rely_bin_bool_all = false(num_mice,num_sesh,nbins_rely);
relym_bin_bool_all = false(num_mice,num_sesh,nbins_rely_mean);
dmax_bin_bool_all = false(num_mice,num_sesh,nbins_delta);
dnorm_bin_bool_all = false(num_mice,num_sesh,nbins_delta);
dint_bin_bool_all = false(num_mice,num_sesh,nbins_delta);
p_bin_bool_all = false(num_mice,num_sesh, 4, nbins_p);
nsesh = sum(cellfun(@length, good_seshs));
hw = waitbar(0, 'Calculating recurrence vs splitter values...');
n = 1;
for j = 1:num_mice
    seshs_use = good_seshs{j};
    sesh_temp = mice_sesh{j};
    for k = 1:size(seshs_use,1)
        [pco_v_rely_all(j,k,:), pstaybec_v_rely_all(j,k,:), ...
            pco_v_dmax_all(j,k,:), pstaybec_v_dmax_all(j,k,:),...
            pco_v_dnorm_all(j,k,:), pstaybec_v_dnorm_all(j,k,:), ...
            pco_v_dint_all(j,k,:), pstaybec_v_dint_all(j,k,:), ...
            rely_centers, delta_centers, rely_bin_bool_all(j,k,:), ...
            dmax_bin_bool_all(j,k,:), dnorm_bin_bool_all(j,k,:), ...
            dint_bin_bool_all(j,k,:), ...
            pco_v_relym_all(j,k,:), pstaybec_v_relym_all(j,k,:),...
            relym_bin_bool_all(j,k,:), relym_centers] = ...
            plot_split_v_recur(sesh_temp(seshs_use(k,1)), ...
            sesh_temp(seshs_use(k,2)),'plot_flag', false, ...
            'rely_edges', rely_edges, 'delta_edges', delta_edges,...
            'sigthresh', sigthresh, 'bin_num_thresh', bin_num_thresh,...
            'nthresh', ntrial_stem_thresh, 'splitters_only', splitters_only, ...
            'rely_mean_edges', rely_mean_edges);
        [pco_v_p_all(j,k,:,:), pstaybec_v_p_all(j,k,:,:), p_bin_bool_all(j,k,:,:)] = ...
            get_splitp_v_recur(sesh_temp(seshs_use(k,1)), ...
            sesh_temp(seshs_use(k,2)), 'nthresh', ntrial_stem_thresh, ...
            'bin_num_thresh', bin_num_thresh, 'edges', p_edges);
        waitbar(n/nsesh, hw);
        n = n + 1;
    end

end

close(hw);

rely_centers_all = shiftdim(repmat(rely_centers,num_sesh,1,num_mice),2);
relym_centers_all = shiftdim(repmat(relym_centers,num_sesh,1,num_mice),2);
delta_centers_all = shiftdim(repmat(delta_centers,num_sesh,1,num_mice),2);
p_centers = p_edges(1:end-1) + mean(diff(p_edges))/2;
p_centers_all = shiftdim(repmat(p_centers,num_sesh,1,num_mice),2);
%% Plot everything

if strcmpi(comp_type,'exact')
    comp_str = 'exactly';
elseif strcmpi(comp_type,'le')
    comp_str = '<=';
end

jit_r = 0.0025; % 0.0025
jit_d = 0.005; % 0.005

h = figure;
h.Position = [1936 305 1864 637];

subplot(2,5,1)
plot_fun(rely_centers_all(rely_bin_bool_all), pco_v_rely_all(rely_bin_bool_all),...
    'Stem splitter max reliability (1-p)', 'Reactivation prob', jit_r);
title(['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'])

subplot(2,5,6)
plot_fun(rely_centers_all(rely_bin_bool_all), pstaybec_v_rely_all(rely_bin_bool_all),...
    'Stem splitter max reliability (1-p)', 'Stay/Become splitter prob.', jit_r);
title(['ntrial\_thresh = ' num2str(ntrial_stem_thresh)])

subplot(2,5,2)
plot_fun(relym_centers_all(relym_bin_bool_all), pco_v_relym_all(relym_bin_bool_all),...
    'Stem splitter mean reliability (1-p)', 'Reactivation prob', jit_r);
title(['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'])

subplot(2,5,7)
[rdmax, pdmax] = plot_fun(relym_centers_all(relym_bin_bool_all), pstaybec_v_relym_all(relym_bin_bool_all),...
    'Stem splitter mean reliability (1-p)', 'Stay/Become splitter prob.', jit_r);

subplot(2,5,3)
plot_fun(delta_centers_all(dmax_bin_bool_all), pco_v_dmax_all(dmax_bin_bool_all),...
    'Stem splitter \Deltamax', 'Reactivation prob', jit_d);
title(['bin\_num\_thresh = ' num2str(bin_num_thresh)])

subplot(2,5,8)
plot_fun(delta_centers_all(dmax_bin_bool_all), pstaybec_v_dmax_all(dmax_bin_bool_all),...
    'Stem splitter \Deltamax', 'Stay/Become splitter prob.', jit_d);
title(['sigthresh = ' num2str(sigthresh)])

subplot(2,5,4)
[rdnorm, pdnorm] = plot_fun(delta_centers_all(dnorm_bin_bool_all), pco_v_dnorm_all(dnorm_bin_bool_all),...
    'Stem splitter \Deltamax_{norm}', 'Reactivation prob', jit_d);

subplot(2,5,9)
plot_fun(delta_centers_all(dnorm_bin_bool_all), pstaybec_v_dnorm_all(dnorm_bin_bool_all),...
    'Stem splitter \Deltamax_{norm}', 'Stay/Become splitter prob.', jit_d);

subplot(2,5,5)
[rdintn, pdintn] = plot_fun(delta_centers_all(dint_bin_bool_all), pco_v_dint_all(dint_bin_bool_all),...
    'Stem splitter \Sigma\Delta_{norm}', 'Reactivation prob', jit_d);

subplot(2,5,10)
plot_fun(delta_centers_all(dint_bin_bool_all), pstaybec_v_dint_all(dint_bin_bool_all),...
    'Stem splitter \Sigma\Deltamax_{norm}', 'Stay/Become splitter prob.', jit_d);

%% Plot again but split into 3 bins and run Kruskal-Wallis ANOVA and post-
% hoc Tukey tests...

if strcmpi(comp_type,'exact')
    comp_str = 'exactly';
elseif strcmpi(comp_type,'le')
    comp_str = '<=';
end


h(2) = figure;
h(2).Position = [1900 105 1864 637];

% Re-define to have only 3 bins that span the effective range of the data
nbins_new = 3;
rely_range_gross = [floor(min(rely_centers_all(rely_bin_bool_all))/rely_res)*rely_res, ...
    ceil(max(rely_centers_all(rely_bin_bool_all))/rely_res)*rely_res];
rely_bins3 = rely_range_gross(1):diff(rely_range_gross)/nbins_new:rely_range_gross(2);
relym_range_gross = [floor(min(relym_centers_all(relym_bin_bool_all))/rely_mean_res)*rely_mean_res, ...
    ceil(max(relym_centers_all(relym_bin_bool_all))/rely_mean_res)*rely_mean_res];
relym_bins3 = relym_range_gross(1):diff(relym_range_gross)/nbins_new:relym_range_gross(2);
delta_range_eff = [floor(min(delta_centers_all(dmax_bin_bool_all))/delta_res)*delta_res, ...
    ceil(max(delta_centers_all(dmax_bin_bool_all))/delta_res)*delta_res; ...
    floor(min(delta_centers_all(dnorm_bin_bool_all))/delta_res)*delta_res, ...
    ceil(max(delta_centers_all(dnorm_bin_bool_all))/delta_res)*delta_res];
delta_range_gross(1) = min(delta_range_eff(:)); delta_range_gross(2) = max(delta_range_eff(:));
d_bins3  = delta_range_gross(1):diff(delta_range_gross)/nbins_new:delta_range_gross(2);

try
    plot_fun2(rely_centers_all(rely_bin_bool_all), pco_v_rely_all(rely_bin_bool_all),...
        rely_bins3, 'Stem splitter max reliability (1-p)', 'Reactivation prob',...
        subplot(2,5,1))
    title(['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'])
    
    plot_fun2(rely_centers_all(rely_bin_bool_all), pstaybec_v_rely_all(rely_bin_bool_all),...
        rely_bins3, 'Stem splitter max reliability (1-p)', 'Stay/Become splitter prob.', ...
        subplot(2,5,6))
    title(['ntrial\_thresh = ' num2str(ntrial_stem_thresh)])
    
    plot_fun2(relym_centers_all(relym_bin_bool_all), pco_v_relym_all(relym_bin_bool_all),...
        relym_bins3, 'Stem splitter mean reliability (1-p)', 'Reactivation prob',...
        subplot(2,5,2))
    title(['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'])
    
    plot_fun2(relym_centers_all(relym_bin_bool_all), pstaybec_v_relym_all(relym_bin_bool_all),...
        relym_bins3, 'Stem splitter mean reliability (1-p)', 'Stay/Become splitter prob.', ...
        subplot(2,5,7))
    title(['ntrial\_thresh = ' num2str(ntrial_stem_thresh)])
    
    plot_fun2(delta_centers_all(dmax_bin_bool_all), pco_v_dmax_all(dmax_bin_bool_all),...
        d_bins3, 'Stem splitter \Deltamax', 'Reactivation prob', subplot(2,5,3))
    title(['bin\_num\_thresh = ' num2str(bin_num_thresh)])
    
    plot_fun2(delta_centers_all(dmax_bin_bool_all), pstaybec_v_dmax_all(dmax_bin_bool_all),...
        d_bins3, 'Stem splitter \Deltamax', 'Stay/Become splitter prob.', subplot(2,5,8))
    title(['sigthresh = ' num2str(sigthresh)])
    
    plot_fun2(delta_centers_all(dnorm_bin_bool_all), pco_v_dnorm_all(dnorm_bin_bool_all),...
        d_bins3, 'Stem splitter \Deltamax_{norm}', 'Reactivation prob', subplot(2,5,4))
    
    plot_fun2(delta_centers_all(dnorm_bin_bool_all), pstaybec_v_dnorm_all(dnorm_bin_bool_all),...
        d_bins3, 'Stem splitter \Deltamax_{norm}', 'Stay/Become splitter prob.', ...
        subplot(2,5,9))
    
    plot_fun2(delta_centers_all(dint_bin_bool_all), pco_v_dint_all(dint_bin_bool_all),...
        d_bins3, 'Stem splitter \Sigma\Delta_{norm}', 'Reactivation prob', subplot(2,5,5))
    
    plot_fun2(delta_centers_all(dint_bin_bool_all), pstaybec_v_dnorm_all(dint_bin_bool_all),...
        d_bins3, 'Stem splitter \Sigma\Delta_{norm}', 'Stay/Become splitter prob.', ...
        subplot(2,5,10))
catch
    disp('Error plotting gross plots...')
end

%% Plot p-values
h(3) = figure;
h(3).Position = [1934 210 850 640];

names_use = {'pLR_{ANOVA}', 'psector_{ANOVA}', 'pspeed_{ANOVA}', ...
    'pypos_{ANOVA}'};
titles_use = {['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'],...
    ['ntrial\_thresh = ' num2str(ntrial_stem_thresh)], ...
    ['bin\_num\_thresh = ' num2str(bin_num_thresh)],...
    ['sigthresh = ' num2str(sigthresh)]};
for j = 1:4
    subplot(2,2,j)
    pbool_use = squeeze(p_bin_bool_all(:,:,j,:));
    pco_use = squeeze(pco_v_p_all(:,:,j,:));
    plot_fun(p_centers_all(pbool_use), pco_use(pbool_use),...
        names_use{j}, 'Reactivation prob', jit_r)
    title(titles_use{j});
end
    

% plot_fun(p_centers_all(p_bin_bool_all(:,:,1,:), pco_v_p_all(p_bin_bool_all(:,:,1,:)),...
%     'pLR_{ANOVA}', 'Reactivation prob', jit_r))
% title(['Sessions ' comp_str ' ' num2str(day_lag) ' day(s) apart'])

% subplot(2,2,1)
% scatter(rely_centers_all(rely_bin_bool_all), pco_v_rely_all(rely_bin_bool_all),...
%     circleSize);
% xlabel('Stem splitter reliability (1-p)');
% ylabel('Reactivation prob');
% [r_co_rely, pval_co_rely] = corr(rely_centers_all(rely_bin_bool_all),...
%     pco_v_rely_all(rely_bin_bool_all),'type','Spearman');
% xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
% text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_co_rely,'%0.2f')])
% text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_co_rely,'%0.2d')])



% scatter(rely_centers_all(rely_bin_bool_all), pstaybec_v_rely_all(rely_bin_bool_all),...
%     circleSize)
% xlabel('Stem splitter reliability (1-p)');
% ylabel('Stay/Become splitter prob.');
% [r_sb_rely, pval_sb_rely] = corr(rely_centers_all(rely_bin_bool_all),...
%     pstaybec_v_rely_all(rely_bin_bool_all),'type','Spearman');
% xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
% text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_sb_rely,'%0.2f')])
% text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_sb_rely,'%0.2d')])

% subplot(2,2,3)
% scatter(delta_centers_all(delta_bin_bool_all), pco_v_dmax_all(delta_bin_bool_all),...
%     circleSize)
% xlabel('Stem splitter \Delta_{max}');
% ylabel('Reactivation prob');
% [r_co_delta, pval_co_delta] = corr(delta_centers_all(delta_bin_bool_all),...
%     pco_v_dmax_all(delta_bin_bool_all),'type','Spearman');
% xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
% text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_co_delta,'%0.2f')])
% text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_co_delta,'%0.2d')])
% 
% subplot(2,2,4)
% scatter(delta_centers_all(delta_bin_bool_all), pstaybec_v_dmax_all(delta_bin_bool_all),...
%     circleSize)
% xlabel('Stem splitter \Delta_{max}');
% ylabel('Stay/Become splitter prob.');
% [r_sb_delta, pval_sb_delta] = corr(delta_centers_all(delta_bin_bool_all),...
%     pstaybec_v_dmax_all(delta_bin_bool_all),'type','Spearman');
% xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
% text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_sb_delta,'%0.2f')])
% text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_sb_delta,'%0.2d')])

end

%% Plotting sub-function: more resolution with linear fit
function [r, p, pfit] = plot_fun(bin_centers, split_metric_by_bin, xtext, ...
    ytext, xjitter)
jitter_mat = randn(size(bin_centers))*xjitter;
circleSize = 10;
scatter(bin_centers + jitter_mat, split_metric_by_bin, circleSize);
xlabel(xtext);
ylabel(ytext);
[r, p] = corr(bin_centers, split_metric_by_bin, 'type','Spearman');
xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
text(xlims(1)+0.025, ylims(2)-0.1, ['r_{sp} = ' num2str(r,'%0.2f')]);
text(xlims(1)+0.025, ylims(2)-0.15, ['p_{sp} = ' num2str(p,'%0.2d')]);

% Add regression line
pfit = polyfit(bin_centers, split_metric_by_bin, 1);
hold on; plot(get(gca, 'xlim'), polyval(pfit, get(gca, 'xlim')), 'r--');

end

%% Plotting sub-function 2: less bin resolution with ANOVA
function [] = plot_fun2(bin_centers, split_metric_by_bin, xbin_lims, ...
    xtext, ytext, ha)

% Assign everything to new bins...
bin_centers_n = nan(size(bin_centers));
xlabels = cell(1, length(xbin_lims)-1);
for j = 1:length(xbin_lims)-1
    bin_centers_n(bin_centers >= xbin_lims(j) & ...
        bin_centers < xbin_lims(j+1)) = j; 
    xlabels{j} = [ '>=' num2str(xbin_lims(j), '%0.2f') ' & < ' ...
        num2str(xbin_lims(j+1), '%0.2f')];
end
scatterBox(split_metric_by_bin(~isnan(bin_centers_n)), ...
    bin_centers_n(~isnan(bin_centers_n)), 'h', ha, 'xLabels', xlabels);
xlabel(xtext); ylabel(ytext);

% Now run stats & label!!!
[pkw, ~, stats] = kruskalwallis(split_metric_by_bin, bin_centers_n, 'off');
c = multcompare(stats, 'display', 'off');
text(1.2, 1, ['p_{kw} = ' num2str(pkw, '%0.2g')])
text(1.2, 0.9, ['p_{tuk,1sided} = '])
text(1.2, 0.8, num2str(c(c(:,6) < 0.05 & c(:,3) < 0, 1:2)))
text(1.5, 0.8, num2str(c(c(:,6) < 0.05 & c(:,3) < 0, 6), '%0.2g'))

end
