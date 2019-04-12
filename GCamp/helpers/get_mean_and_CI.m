function [data_mean, shuf_CI] = get_mean_and_CI(data, shuffled, pct)
% [data_mean, shuf_CI] = get_mean_and_CI(data, shuffled, pct)
%   Gets mean and shuffled confidence intervals (2 sided) at pct (default =
%   95) -> 95% CI. shuffled data must be in the format of rows =
%   neurons and columns = shuffles.

if nargin < 3
    pct = 95;
end

% Calculate everything
data_mean = nanmean(data);
shuf_CI = quantile(nanmean(shuffled,1),...
    [(100-pct)/2/100, 0.5, 1 - (100-pct)/2/100]);

end

