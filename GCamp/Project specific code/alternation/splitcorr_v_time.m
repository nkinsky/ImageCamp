function [] = splitcorr_v_time(sessions, comp_type)
% splitcorr_v_time(sessions, forced_only)
%  Plots correlations between sessions for spliter tuning curves and place
%  field TMaps. Must include ALL sessions for a given animal as an input
%  (e.g. G30_alt).
%
%   comp_type:  types of session-pairs to consider: 
%       'forced_only', 'free_only', 'all'

if nargin < 2
    comp_type = 'all';
end

%% Get day lag between all sessions
tdiff_mat = make_timediff_mat(sessions);
% ID sessions that are exactly day_lag apart (or <= if 'le' specified)
% tdiff_bool = feval(compfun, tdiff_mat, day_lag);
% % Get hand_check_mat to grab only good sessions
[~, good_reg_mat_hand] = alt_hand_reg_order_check(sessions);
tdiff_mat(good_reg_mat_hand == 0) = nan;
% reject any sessions not meeting the hand check

% tdiff_bool(good_reg_mat_hand == 0) = false;
% [a,b] = find(tdiff_bool);
% good_seshs = [a,b];

%% Get values 
num_sessions = length(sessions);
PFcorrmat = nan(num_sessions);
curvecorrmat = nan(num_sessions);
PF_CI = nan(num_sessions, num_sessions, 3);
dcurve_CI = nan(num_sessions, num_sessions, 3);
hw = waitbar(0,'Getting correlation values and CIs...');
n = 1; ncomps = num_sessions*(num_sessions-1)/2;
for j = 1:(num_sessions-1)
    session1 = sessions(j);
    for k = (j+1):num_sessions
        session2 = sessions(k);
        [deltacurve_corr, PFcorr, deltacurve_corr_shuf, PFcorr_shuf] = ...
            split_tuning_corr(session1, session2, 'suppress_output', true);
        [PFcorrmat(j,k), PF_CI(j,k,:)] = get_mean_and_CI(PFcorr, PFcorr_shuf);
        [curvecorrmat(j,k), dcurve_CI(j,k,:)] = get_mean_and_CI(deltacurve_corr,...
            deltacurve_corr_shuf);
        waitbar(n/ncomps,hw);
        n = n + 1;
    end
end
close(hw)

[pmat_split, pmat_PF] = calc_split_pval_mat(sessions);
pmat_split_full = pmat_split;
pmat_PF_full = pmat_PF;

%% Identify forced vs. free and adjust matrices 
[loop_bool, forced_bool] = alt_id_sesh_type(sessions);

if ismember(comp_type, {'all', 'forced_only', 'free_only', 'no_loop', ...
        'no_forced', 'no_free'})
    switch comp_type
        case 'all'
            good_bool = true(size(loop_bool));
        case 'forced_only'
            good_bool = forced_bool;
        case 'free_only'
            good_bool = ~forced_bool & ~loop_bool;
        case 'no_loop'
            good_bool = forced_bool | ~loop_bool; % exclude looping only
        case 'no_forced'
            good_bool = loop_bool | ~forced_bool;
        case 'no_free'
            good_bool = loop_bool | forced_bool;
        otherwise
            error('comp_type variable value is invalid')
    end
    
    % grab only appropriate session comparisons
    PFcorrmat = PFcorrmat(good_bool, good_bool);
    PF_CI = PF_CI(good_bool, good_bool, :);
    curvecorrmat = curvecorrmat(good_bool, good_bool);
    dcurve_CI = dcurve_CI(good_bool, good_bool, :);
    pmat_split = pmat_split(good_bool, good_bool);
    pmat_PF = pmat_PF(good_bool, good_bool);
    tdiff_mat = tdiff_mat(good_bool, good_bool);
elseif ismember(comp_type, {'forced_v_free', 'forced_v_loop', 'free_v_not', ...
        'loop_v_free'})
    % Note - could just fold this into above and use the logic below to
    % make this less messy
    free_bool = ~forced_bool & ~loop_bool;
    notfree_bool = forced_bool | loop_bool;
    switch comp_type
        case 'forced_v_free'
            good_bool = logical(double(forced_bool)'*double(free_bool) + ...
                double(free_bool)'*double(forced_bool));
        case 'forced_v_loop'
            good_bool = logical(double(forced_bool)'*double(loop_bool) + ...
                double(free_bool)'*double(loop_bool));
        case 'free_v_not'
            good_bool = logical(double(notfree_bool)'*double(free_bool) + ...
                double(free_bool)'*double(notfree_bool));
        case 'loop_v_free'
            good_bool = logical(double(loop_bool)'*double(free_bool) + ...
                double(loop_bool)'*double(forced_bool));
        otherwise
            error('comp_type variable value is invalid')
    end
    good_bool3 = repmat(good_bool,1,1,3);
    
    % grab only appropriate session comparisons
    PFcorrmat = PFcorrmat(good_bool);
    PF_CI = reshape(PF_CI(good_bool3),[],3);
    curvecorrmat = curvecorrmat(good_bool);
    dcurve_CI = reshape(dcurve_CI(good_bool3),[],3);
    pmat_split = pmat_split(good_bool);
    pmat_PF = pmat_PF(good_bool);
    tdiff_mat = tdiff_mat(good_bool);
    
else
    error('comp_type variable value is invalid')
    
end
    
 
%% Plot
if ~isempty(tdiff_mat) % Only try to plot stuff if you have actual values
alpha = 0.05;
unique_lags = unique(tdiff_mat(~isnan(tdiff_mat))); % Get unique lags

% reshape CI mats to make life easier below
PF_CIrs = reshape(PF_CI,[],3);
dcurve_CIrs = reshape(dcurve_CI,[],3);

% pre-allocate
nlags = length(unique_lags);
PFcorr_by_day = cell(nlags,1);
PFCI_by_day = nan(nlags,3);
dcorr_by_day = cell(nlags,1);
dCI_by_day = nan(nlags,3);
PFpval_by_day = cell(nlags,1);
dpval_by_day = cell(nlags,1);
daycount = nan(nlags,1);
for j = 1:nlags
    lag_bool = tdiff_mat(:) == unique_lags(j);
    PFcorr_by_day{j} = PFcorrmat(lag_bool);
    dcorr_by_day{j} = curvecorrmat(lag_bool);
    PFCI_by_day(j,:) = nanmean(PF_CIrs(lag_bool,:),1);
    dCI_by_day(j,:) = nanmean(dcurve_CIrs(lag_bool,:),1);
    PFpval_by_day{j} = pmat_PF(lag_bool);
    dpval_by_day{j} = pmat_split(lag_bool);
    daycount(j) = sum(lag_bool);
end

% NRK - add in something to get pval and plot those in red?

% figure; set(gcf, 'Position', [50 100 1000 800])
figure; set(gcf, 'Position', [10 160 1900 800])
% hPF = subplot(2,1,1);
hPF = subplot(2,2,1);
[PFout, PFdayout] = scatterbox_reshape(PFcorr_by_day, unique_lags);
% Might need to bonferroni correct here for each days comparison - multiply
% value
[pPFout,~] = scatterbox_reshape(PFpval_by_day, unique_lags);
scatterBox(PFout(pPFout < alpha),PFdayout(pPFout < alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.3 0.3 0.3], 'transparency', 0.7, 'plotBox', false);
scatterBox(PFout(pPFout >= alpha),PFdayout(pPFout >= alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.8 0 0], 'transparency', 0.7, 'plotBox', false);
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags, PFCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')
title([mouse_name_title(session1.Animal) ' - ' mouse_name_title(comp_type)])

% Plot linear regression line
PFlm = fitlm(PFdayout,PFout);
day_bounds = [min(unique_lags), max(unique_lags)];
plot(day_bounds, PFlm.Coefficients.Estimate(2)*day_bounds + ...
    PFlm.Coefficients.Estimate(1), 'g-')
set(gca,'XLim', get(gca,'XLim') + [-1 1]) % make sure xlims fall below data limits

% Plot with boxes
hPF2 = subplot(2,2,2);
scatterBox(PFout,PFdayout,'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF2, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.3 0.3 0.3], 'transparency', 0.7, 'plotBox', true);
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags, PFCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')
PFlm = fitlm(PFdayout,PFout);
day_bounds = [min(unique_lags), max(unique_lags)];
plot(day_bounds, PFlm.Coefficients.Estimate(2)*day_bounds + ...
    PFlm.Coefficients.Estimate(1), 'g-')

hsp = subplot(2,2,3);
[dout, ddayout] = scatterbox_reshape(dcorr_by_day, unique_lags);
[pdout,~] = scatterbox_reshape(dpval_by_day, unique_lags);
scatterBox(dout(pdout < alpha), ddayout(pdout < alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.3 0.3 0.3], ...
    'transparency', 0.7, 'plotBox', false);
scatterBox(dout(pdout >= alpha), ddayout(pdout >= alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.8 0 0], ...
    'transparency', 0.7, 'plotBox', false);
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags,dCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')

dlm = fitlm(ddayout,dout);
plot(day_bounds, dlm.Coefficients.Estimate(2)*day_bounds + ...
    dlm.Coefficients.Estimate(1), 'g-')
set(gca,'XLim', get(gca,'XLim') + [-1 1]) % make sure xlims fall below data limits

hsp2 = subplot(2,2,4);
scatterBox(dout, ddayout, 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp2, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.3 0.3 0.3], ...
    'transparency', 0.7, 'plotBox', true);
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags,dCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')

dlm = fitlm(ddayout,dout);
plot(day_bounds, dlm.Coefficients.Estimate(2)*day_bounds + ...
    dlm.Coefficients.Estimate(1), 'g-')

else % print out a figure letting you know that nothing happened
    figure; set(gcf, 'Position', [1100 420 750 230])
    text(0, 0.5, ['No sessions meet the comp\_type = ' ...
        mouse_name_title(comp_type) ' criteria for '...
        mouse_name_title(sessions(1).Animal)])
    axis off
end
%% Stats? Slope of line? days above chance?

end

