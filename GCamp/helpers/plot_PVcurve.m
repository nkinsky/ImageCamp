function [hout, hmean_shuf, hmean_CI, unique_lags, mean_corr_cell, CI,...
    hcurve, mean_corr_shuffle] = plot_PVcurve(PV_corrs, lag, varargin)
% [hout, hmean_shuf, hmean_CI, unique_lags, mean_corr_cell, CI,...
%     hcurve] = plot_PVcurve(PV_corrs, lag,...)
%   Plots data in PV_corrs vs lags.  If PV_corrs_shuffle are non-NaN it also
%   plots 95% CIs for shuffled data.  plot_curves = true plots mean curve.

%% Parse Inputs
ip = inputParser;
ip.addRequired('PV_corrs',@isnumeric);
ip.addRequired('lag', @(a) all(size(a) == size(PV_corrs)));
ip.addParameter('PV_corrs_shuffle', [], @(a) isempty(a) || (~isempty(a) && ...
    (size(a,1) == size(PV_corrs,1) &&...
    size(a,2) == size(PV_corrs,2))));
ip.addParameter('hin', nan, @(a) all(ishandle(a)) || all(isnan(a)) || strcmpi(a,'dont_plot'));
ip.addParameter('plot_curves', true, @islogical); % plot curves over ind points
ip.addParameter('CI_level', 0.95, @(a) a >= 0 && a <= 1);
ip.addParameter('marker', 'b.', @ischar);
ip.addParameter('linetype','b-', @ischar);
ip.addParameter('filter', true(size(PV_corrs)),@(a) all(size(a) == ...
    size(PV_corrs)));
ip.addParameter('dont_plot',false,@islogical); % Don't plot anything
ip.parse(PV_corrs,lag,varargin{:});

PV_corrs_shuffle = ip.Results.PV_corrs_shuffle;
hin = ip.Results.hin;
plot_curves = ip.Results.plot_curves;
CI_level = ip.Results.CI_level;
marker = ip.Results.marker;
linetype = ip.Results.linetype;
filter = ip.Results.filter;
dont_plot = ip.Results.dont_plot;

if ~all(ishandle(hin)) && ~strcmpi(hin,'dont_plot'); figure; hin = gca; end

num_shuffles = 0;
if ~isempty(PV_corrs_shuffle)
    num_shuffles = size(PV_corrs_shuffle,3);
end

% Filter out sessions
% PV_corrs = PV_corrs(filter);
% lag = lag(filter);

%% Distribute PV_corrs and PV_corrs_shuffle by day lag
[mean_corr_cell, mean_mean_array, unique_lags] = arrange_means(PV_corrs(filter),...
    lag(filter));

mean_corr_shuffle = cell(size(mean_corr_cell));
for j = 1:num_shuffles
    shuf_use = squeeze(PV_corrs_shuffle(:,:,j));
    shuf_temp = arrange_means(shuf_use(filter), lag(filter));
%     shuf_temp = get_means(squeeze(PV_corrs_shuffle(:,:,j)), lag);
    mean_corr_shuffle = cellfun(@(a,b) cat(1,a,b), mean_corr_shuffle, shuf_temp,...
        'UniformOutput', false);
end

%% Calculate 95% CIs on shuffled data if specified
if num_shuffles > 0
    CI = cellfun(@(a) get_CI(a,CI_level), mean_corr_shuffle,...
        'UniformOutput',false);
    CI = cell2mat(CI);
else
    CI = nan;
end

%% Loop through and plot each
if ~dont_plot
    axes(hin)
    hpts = scatter(lag(~isnan(lag) & filter), PV_corrs(~isnan(lag) & filter), marker);
    hpts.MarkerEdgeAlpha = 0.2;
    hold on
    if plot_curves
        hcurve = plot(unique_lags,mean_mean_array,linetype);
    else
        hcurve = nan;
    end
    
    if num_shuffles > 0 && plot_curves
        hmean_shuf = plot(unique_lags,cellfun(@nanmean,mean_corr_shuffle),'-');
        hmean_shuf.Color = [1 0 1 0.7];
        hmean_CI = plot(unique_lags,CI,'--');
        arrayfun(@(a) set(a,'Color',[1 0 1 0.7]),hmean_CI);
    else
        hmean_shuf = nan;
        hmean_CI = nan;
    end
    
    xlabel('Lag')
    ylabel('Mean PV Correlation')
    hold off
elseif dont_plot
    hmean_shuf = nan;
    hmean_CI = nan;
    hcurve = nan;
end

hout = hin;
    
end

%% Sub-function to get means of correlations at different lags
function [mean_corr_cell, mean_mean_array, unique_lags] = ...
    arrange_means(corrs_in, lag)

unique_lags = unique(lag(~isnan(lag)));

mean_corr_cell = arrayfun(@(a) corrs_in(lag == a), unique_lags,....
    'UniformOutput',false);
mean_mean_array = cellfun(@(a) nanmean(a), mean_corr_cell);

end

%% Get CI - level = 0 to 1 (e.g. 0.95 gives 95% CI)
function [CI] = get_CI(data_in, level)
data_in = data_in(~isnan(data_in));
num_shuffles = length(data_in);
top_cutoff = 1 - (1-level)/2;
bot_cutoff = (1-level)/2;
shuf_mean_sort = sort(data_in);
CI(1,1) = shuf_mean_sort(round(top_cutoff*num_shuffles),:);
CI(1,2) = shuf_mean_sort(max([round(bot_cutoff*num_shuffles),1]),:);
end

