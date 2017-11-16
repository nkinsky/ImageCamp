function [ hout, unique_lags, mean_corr_cell, hmean_CI ] = twoenv_plot_PVcurve( PV_corrs, ...
    sesh_type, PV_corrs_shuffle, hin, plot_curves, filter )
% hout = twoenv_plot_PVcurve( PV_corrs, sesh_type, PV_corrs_shuffle, hin, plot_curves )
%  Plots PV vs time lag curves for 2env task.

% Set defaults for optional inputs
if nargin < 6
    filter = true(size(PV_corrs));
    if nargin < 5
        plot_curves = true;
        if nargin < 4
            figure;
            set(gcf,'Position',[2220 380 810 470]);
            hin = gca;
        end
    end
end

%% Determine days and session for each comparison

switch sesh_type
    case 'square'
        days_array = [1 1 4 4 5 6 7 7];
        env = ones(1,8);
        marker = 'bs';
        linetype = 'b-';
    case 'circle'
        days_array = [2 2 3 3 5 6 8 8];
        env = 2*ones(1,8);
        marker = 'ro';
        linetype = 'r-';
    case 'circ2square'
        days_array = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8];
        env =  [1 1 2 2 2 2 1 1 1 2 2 1 1 1 2 2];
        marker = 'gx';
        linetype = 'g--';
    otherwise
        error('sesh_type input is invalid')
end

num_sesh = length(days_array);
day_lag = abs(repmat(days_array, [num_sesh 1]) - repmat(days_array',[1 num_sesh]));

%Identify sessions that are from the same arena & exclude them from
%comparison
if strcmpi(sesh_type, 'circ2square')
    day_lag(logical(eye(16))) = nan;
    same_arena = repmat(env,[16,1]) == repmat(env',[1,16]);
    day_lag(same_arena) = nan;
    
end

% Grab only the upper diagonal part of the matrix to remove redundant
% sessions
temp = day_lag;
day_lag = nan(size(day_lag));
day_lag = tril(day_lag);
day_lag(~isnan(day_lag)) = temp(~isnan(day_lag));

%% Plot it
[hout,~,hmean_CI, unique_lags, mean_corr_cell] = plot_PVcurve(PV_corrs, day_lag, 'PV_corrs_shuffle', PV_corrs_shuffle,...
    'hin', hin, 'plot_curves', plot_curves, 'marker', marker,...
    'linetype', linetype, 'filter', filter);
xlabel('Days')
xlim([-0.5 7.5])
% make_plot_pretty(hout)
end


