function [h, pval ] = twoenv_coh_sig( corr_mat, shuffle_mat2, alpha_corr )
% [h, pval ] = twoenv_coh_sig( corr_mat, shuffle_mat2, alpha_corr )
%   Test significance at level alpha_corr.  Compares the mean of the actual
%   correlations to that of shuffled.  Proportion of sessions greater than
%   shuffled must be > 1 - alpha_corr

corr_means = nanmean(corr_mat,1);
[corr_at_best, ~] = max(corr_means);

num_shuffles = size(shuffle_mat2,1)/size(corr_mat,1);
if isnan(num_shuffles); num_shuffles = 0; end
shuffle_chunk = size(corr_mat,1);
shuf_mean_corr = nan(num_shuffles,1);
shuf_mean_temp = nan(num_shuffles, size(shuffle_mat2,2));
for k = 1:num_shuffles
    ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk); % Get indices for each shuffled session
    shuf_mean_temp(k,:) = nanmean(shuffle_mat2(ind_use,:),1); % Get mean of shuffled sessions
    shuf_mean_corr(k,1) = max(shuf_mean_temp(k,:)); % Get mean at best rotation/highest corr
    shuf_mean_corr(k,2) = min(shuf_mean_temp(k,:)); % Get mean at worst rotation/lowest corr
end
pval = (1 - sum(corr_at_best > shuf_mean_corr(:,1))/num_shuffles);

if isnan(pval)
    h = nan;
elseif ~isnan(pval)
    h = pval < alpha_corr;
end

end

