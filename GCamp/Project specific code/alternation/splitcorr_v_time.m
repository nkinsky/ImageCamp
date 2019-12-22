function [PFcorr_by_day_split, PFcorr_by_day_spc, PFcorr_by_day_apc, ...
    PFcorr_by_day_snpc, PFcorr_by_day_stem_nonsplit, unique_lags, ...
    pPF] = ...
    splitcorr_v_time(sessions, varargin)
% [PFcorr_by_day_split, PFcorr_by_day_spc, PFcorr_by_day_apc, ...
%     PFcorr_by_day_snpc, PFcorr_by_day_stem_nonsplit, unique_lags] = ...
%     splitcorr_v_time(sessions, varargin)
%  Plots correlations between sessions for splitter tuning curves and place
%  field TMaps. Must include ALL sessions for a given animal as an input
%  (e.g. G30_alt). Use comp_type parameter to designate what types of
%  sessions you want to include. Clunky but necessary to make sure we only
%  include session-pairs with good registrations by eye).
%
%   INPUTS:
%   sessions: session structures
%
%   PARAMETERS
%   comp_type:  types of session-pairs to consider: 
%       'forced_only', 'free_only', 'all'
%
%   pval_thresh, ntrans_thresh, sigthresh: max pvalue to be considered a place
%   cell (0.05 default), min #trans to be considered in analysis at all 
%   (5 default), min #bins that must have significant splitting to be 
%   considered a splitter (3 default).
%
%   debug: enter debugging mode (false)
%   

ip = inputParser;
ip.addRequired('sessions', @isstruct);
ip.addParameter('comp_type', 'all', @ischar);
ip.addParameter('pval_thresh', 0.05, @(a) a > 0 && a <= 1);
ip.addParameter('ntrans_thresh', 5, @(a) a >= 0 && round(a) == a);
ip.addParameter('sigthresh', 3, @(a) a >= 0 && round(a) == a);
ip.addParameter('debug', false, @islogical);
ip.parse(sessions, varargin{:});
comp_type = ip.Results.comp_type;
pval_thresh = ip.Results.pval_thresh;
ntrans_thresh = ip.Results.ntrans_thresh;
sigthresh = ip.Results.sigthresh;
debug = ip.Results.debug; 


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
PFcorrmat_split = nan(num_sessions);
PFcorrmat_apc = nan(num_sessions);
PFcorrmat_spc = nan(num_sessions);
PFcorrmat_snpc = nan(num_sessions);
PFcorrmat_stem_nonsplit = nan(num_sessions);
curvecorrmat = nan(num_sessions);
curvecorrmat_split = nan(num_sessions);
PF_CI = nan(num_sessions, num_sessions, 3);
dcurve_CI = nan(num_sessions, num_sessions, 3);
hw = waitbar(0,'Getting correlation values and CIs...');
n = 1; ncomps = num_sessions*(num_sessions-1)/2;
for j = 1:(num_sessions-1)
    session1 = sessions(j);
    for k = (j+1):num_sessions
        session2 = sessions(k);
        [deltacurve_corr, PFcorr, deltacurve_corr_shuf, PFcorr_shuf, split_ind] = ...
            split_tuning_corr(session1, session2, 'suppress_output', true);
        
        % Enter debugging for free sessions only here
        [~, ~, free_bool_check] = alt_id_sesh_type(session1);
        if debug && free_bool_check
            disp('debugging in splitcorr_v_time')
            keyboard
        end    
        
        % Identify different cell categories in booleans
        try
        [cats, cat_nums, cat_names] = alt_parse_cell_category(session1, ...
            pval_thresh, ntrans_thresh, sigthresh, 'Placefields_cm1.mat');
        armpc_bool = cats == cat_nums(strcmpi(cat_names, 'arm pcs'));
        stempc_bool = cats == cat_nums(strcmpi(cat_names, 'stem pcs'));
        stemnpc_bool = cats == cat_nums(strcmpi(cat_names, 'stem npcs'));
        split_bool = cats == cat_nums(strcmpi(cat_names, 'splitters'));
        [PFcorrmat(j,k), PF_CI(j,k,:)] = get_mean_and_CI(PFcorr, PFcorr_shuf);
        
        % grab PFcorrs for different cell categories
        PFcorrmat_split(j,k) = nanmean(PFcorr(split_bool));
        PFcorrmat_stem_nonsplit(j,k) = nanmean(PFcorr(stempc_bool | stemnpc_bool));
        PFcorrmat_apc(j,k) = nanmean(PFcorr(armpc_bool));
        PFcorrmat_spc(j,k) = nanmean(PFcorr(stempc_bool));
        PFcorrmat_snpc(j,k) = nanmean(PFcorr(stemnpc_bool));
        [curvecorrmat(j,k), dcurve_CI(j,k,:)] = get_mean_and_CI(deltacurve_corr,...
            deltacurve_corr_shuf);
        if ~isempty(deltacurve_corr)
            curvecorrmat_split(j,k) = nanmean(deltacurve_corr(split_ind));
        end
        catch ME
            if strcmpi(ME.identifier, 'MATLAB:load:couldNotReadFile')
                disp(['Can''t find wood_analysis.mat file for ' ...
                    session1.Animal ' ' session1.Date 's' ...
                    num2str(session1.Session) ' - leaving as all NaNs'])
            end
        end
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
    PFcorrmat_split = PFcorrmat_split(good_bool, good_bool);
    PFcorrmat_apc = PFcorrmat_apc(good_bool, good_bool);
    PFcorrmat_spc = PFcorrmat_spc(good_bool, good_bool);
    PFcorrmat_snpc = PFcorrmat_snpc(good_bool, good_bool);
    PFcorrmat_stem_nonsplit = PFcorrmat_stem_nonsplit(good_bool, good_bool);
    PF_CI = PF_CI(good_bool, good_bool, :);
    curvecorrmat = curvecorrmat(good_bool, good_bool);
    curvecorrmat_split = curvecorrmat_split(good_bool, good_bool);
    dcurve_CI = dcurve_CI(good_bool, good_bool, :);
    pmat_split = pmat_split(good_bool, good_bool);
    pmat_PF = pmat_PF(good_bool, good_bool);
    tdiff_mat = tdiff_mat(good_bool, good_bool);
elseif ismember(comp_type, {'forced_v_free', 'forced_v_loop', 'free_v_not', ...
        'loop_v_free'})
    % Note - could just fold this into above and use the logic below to
    % make this less messy, probably better.
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
    PFcorrmat_split = PFcorrmat_split(good_bool);
    PFcorrmat_apc = PFcorrmat_apc(good_bool);
    PFcorrmat_spc = PFcorrmat_spc(good_bool);
    PFcorrmat_snpc = PFcorrmat_snpc(good_bool);
    PFcorrmat_stem_nonsplit = PFcorrmat_stem_nonsplit(good_bool);
    PF_CI = reshape(PF_CI(good_bool3),[],3);
    curvecorrmat = curvecorrmat(good_bool);
    curvecorrmat_split = curvecorrmat_split(good_bool);
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
PFcorr_by_day_split = cell(nlags,1);
PFcorr_by_day_apc = cell(nlags,1);
PFcorr_by_day_spc = cell(nlags,1);
PFcorr_by_day_snpc = cell(nlags,1);
PFcorr_by_day_stem_nonsplit = cell(nlags,1); 
PFCI_by_day = nan(nlags,3);
dcorr_by_day = cell(nlags,1);
dcorr_by_day_split = cell(nlags,1);
dCI_by_day = nan(nlags,3);
PFpval_by_day = cell(nlags,1);
dpval_by_day = cell(nlags,1);
daycount = nan(nlags,1);
for j = 1:nlags
    lag_bool = tdiff_mat(:) == unique_lags(j);
    PFcorr_by_day{j} = PFcorrmat(lag_bool);
    PFcorr_by_day_split{j} = PFcorrmat_split(lag_bool);
    PFcorr_by_day_apc{j} = PFcorrmat_apc(lag_bool);
    PFcorr_by_day_spc{j} = PFcorrmat_spc(lag_bool);
    PFcorr_by_day_snpc{j} = PFcorrmat_snpc(lag_bool);
    PFcorr_by_day_stem_nonsplit{j} = PFcorrmat_stem_nonsplit(lag_bool);
    dcorr_by_day{j} = curvecorrmat(lag_bool);
    dcorr_by_day_split{j} = curvecorrmat_split(lag_bool);
    PFCI_by_day(j,:) = nanmean(PF_CIrs(lag_bool,:),1);
    dCI_by_day(j,:) = nanmean(dcurve_CIrs(lag_bool,:),1);
    PFpval_by_day{j} = pmat_PF(lag_bool);
    dpval_by_day{j} = pmat_split(lag_bool);
    daycount(j) = sum(lag_bool);
end


%%% NRK - make below into a plot function so that you can run for ALL
%%% mice...
% Set up plots
figure; set(gcf, 'Position', [10 160 1900 800])
hPF = subplot(2,2,1);

% Get place field variables organized nicely
[PFout, PFdayout] = scatterbox_reshape(PFcorr_by_day, unique_lags); % All neurons
PFout_sp = scatterbox_reshape(PFcorr_by_day_split, unique_lags); % Splitters only
% Might need to bonferroni correct here for each days comparison - multiply
% value
[pPFout,~] = scatterbox_reshape(PFpval_by_day, unique_lags); % pvals to id gl. rmp. sessions

% Now plot all place field correlations
% Plot non-remapping days in black
[~, ~, hp1] = scatterBox(PFout(pPFout < alpha),PFdayout(pPFout < alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.3 0.3 0.3], 'transparency', 0.7, 'plotBox', false);
% Plot remapping days in red
[~, ~, hp2] = scatterBox(PFout(pPFout >= alpha),PFdayout(pPFout >= alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.8 0 0], 'transparency', 0.7, 'plotBox', false);
% Plot splitters with + 
[~, ~, hps1] = scatterBox(PFout_sp(pPFout < alpha),PFdayout(pPFout < alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.3 0.3 0.3], 'transparency', 0.7, 'plotBox', false);
set(hps1,'MarkerFaceColor','none','MarkerEdgeColor','flat','Marker','diamond');
[~, ~, hps2] =scatterBox(PFout_sp(pPFout >= alpha),PFdayout(pPFout >= alpha),'xLabels',...
    arrayfun(@num2str, PFdayout, 'UniformOutput', false),'h', hPF, ...
    'yLabel', 'mean \rho_{TMmap,smoothed}',...
    'circleColors', [0.8 0 0], 'transparency', 0.7, 'plotBox', false);
set(hps2,'MarkerFaceColor','none','MarkerEdgeColor','flat','Marker','diamond');
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags, PFCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')
title([mouse_name_title(session1.Animal) ' - ' mouse_name_title(comp_type)])

% Plot linear regression line
PFlm = fitlm(PFdayout,PFout);
PFslm = fitlm(PFdayout, PFout_sp);
day_bounds = [min(unique_lags), max(unique_lags)];
hbfp = plot(day_bounds, PFlm.Coefficients.Estimate(2)*day_bounds + ...
    PFlm.Coefficients.Estimate(1), 'g-');
hbfp_s = plot(day_bounds, PFslm.Coefficients.Estimate(2)*day_bounds + ...
    PFslm.Coefficients.Estimate(1), 'g--');
set(gca,'XLim', get(gca,'XLim') + [-1 1]) % make sure xlims fall below data limits
legend(cat(1, hp1, hp2, hps1, hps2, hbfp, hbfp_s), {'All Stem Neurons', ...
    'All Stem - Rmp. Sesh', 'Splitters', 'Splitters - Rmp. Sesh', ...
    'Best Fit - All Stem Neurons', 'Best Fit - Splitters Only'});

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
    PFlm.Coefficients.Estimate(1), 'g-');


% Now do the same as above but for delta tuning curve correlations
hsp = subplot(2,2,3);
[dout, ddayout] = scatterbox_reshape(dcorr_by_day, unique_lags);
dout_sp = scatterbox_reshape(dcorr_by_day_split, unique_lags);
[pdout,~] = scatterbox_reshape(dpval_by_day, unique_lags);
[~, ~, hst1] = scatterBox(dout(pdout < alpha), ddayout(pdout < alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.3 0.3 0.3], ...
    'transparency', 0.7, 'plotBox', false);
[~, ~, hst2] = scatterBox(dout(pdout >= alpha), ddayout(pdout >= alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.8 0 0], ...
    'transparency', 0.7, 'plotBox', false);
[~, ~, hst_sp1] = scatterBox(dout_sp(pdout < alpha), ddayout(pdout < alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.3 0.3 0.3], ...
    'transparency', 0.7, 'plotBox', false);
set(hst_sp1,'MarkerFaceColor','none','MarkerEdgeColor','flat','Marker','diamond');
[~, ~, hst_sp2] = scatterBox(dout_sp(pdout >= alpha), ddayout(pdout >= alpha), 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hsp, ...
    'yLabel', 'mean \rho_{\Delta_{curve}}', 'circleColors', [0.8 0 0], ...
    'transparency', 0.7, 'plotBox', false);
set(hst_sp2,'MarkerFaceColor','none','MarkerEdgeColor','flat','Marker','diamond');
xlabel('Lag (days)');
hold on; 
hCI = plot(unique_lags,dCI_by_day, 'k-'); set(hCI([1 3]),'LineStyle','--')

dlm = fitlm(ddayout, dout);
dslm = fitlm(ddayout, dout_sp);
hbfs = plot(day_bounds, dlm.Coefficients.Estimate(2)*day_bounds + ...
    dlm.Coefficients.Estimate(1), 'g-');
hbfs_sp = plot(day_bounds, dslm.Coefficients.Estimate(2)*day_bounds + ...
    dslm.Coefficients.Estimate(1), 'g--');
set(gca,'XLim', get(gca,'XLim') + [-1 1]) % make sure xlims fall below data limits
legend(cat(1, hst1, hst2, hst_sp1, hst_sp2, hbfs, hbfs_sp), ...
    {'All Stem Neurons', 'All Stem - Rmp. Sesh', 'Splitters', ...
    'Splitters - Rmp. Sesh', 'Best Fit - All Stem Neurons', ...
    'Best Fit - Splitters Only'});

hast_sp2 = subplot(2,2,4);
scatterBox(dout, ddayout, 'xLabels',...
    arrayfun(@num2str, ddayout, 'UniformOutput', false),'h', hast_sp2, ...
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

