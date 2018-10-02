function [] = splitcorr_v_time(sessions)
% splitter_stability(sessions)
%   Detailed explanation goes here

% %% Get appropriate comparison type
% switch comp_type
%     case 'exact'
%         compfun = @eq;
%     case 'le'
%         compfun = @le;
%     otherwise
%         error('Must specify either ''exact'' or ''le'' for 2nd arg')
% end

%% Get day lag between all sessions
tdiff_mat = make_timediff_mat(sessions);
% ID sessions that are exactly day_lag apart (or <= if 'le' specified)
% tdiff_bool = feval(compfun, tdiff_mat, day_lag);
% % Get hand_check_mat to grab only good sessions
[~, good_reg_mat_hand] = alt_hand_reg_order_check(sessions);
% reject any sessions not meeting the hand check
tdiff_bool(good_reg_mat_hand == 0) = false;
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
%% Plot
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

figure; set(gcf, 'Position', [50 100 1000 800])
hPF = subplot(2,1,1);
[PFout, PFdayout] = scatterbox_reshape(PFcorr_by_day, unique_lags);
% Might need to bonferroni correct here for each days comparison - multiply
% value
[pPFout,~] = scatterbox_reshape(PFpval_by_day, unique_lags);
scatterBox(PFout(pPFout < alpha),PFdayout(pPFout < alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', '\rho_{TMmap,smoothed}',...
    'circleColors', [0.3 0.3 0.3], 'transparency', 0.7, 'plotBox', false);
scatterBox(PFout(pPFout >= alpha),PFdayout(pPFout >= alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', '\rho_{TMmap,smoothed}',...
    'circleColors', [0.8 0 0], 'transparency', 0.7, 'plotBox', false);
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags, PFCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')
title(mouse_name_title(session1.Animal))

PFlm = fitlm(PFdayout,PFout);
day_bounds = [min(unique_lags), max(unique_lags)];
plot(day_bounds, PFlm.Coefficients.Estimate(2)*day_bounds + ...
    PFlm.Coefficients.Estimate(1), 'g-')

hsp = subplot(2,1,2);
[dout, ddayout] = scatterbox_reshape(dcorr_by_day, unique_lags);
[pdout,~] = scatterbox_reshape(dpval_by_day, unique_lags);
scatterBox(dout(pdout < alpha), ddayout(pdout < alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', '\rho_{\Delta_{curve}}', 'circleColors', [0.3 0.3 0.3], ...
    'transparency', 0.7, 'plotBox', false);
scatterBox(dout(pdout >= alpha), ddayout(pdout >= alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', '\rho_{\Delta_{curve}}', 'circleColors', [0.8 0 0], ...
    'transparency', 0.7, 'plotBox', false);
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags,dCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')

dlm = fitlm(ddayout,dout);
plot(day_bounds, dlm.Coefficients.Estimate(2)*day_bounds + ...
    dlm.Coefficients.Estimate(1), 'g-')

%% Stats? Slope of line? days above chance?

end

