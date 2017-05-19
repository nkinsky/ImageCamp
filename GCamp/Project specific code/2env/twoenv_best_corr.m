function [ corr_at_best, best_angle, sig_test ] = twoenv_best_corr( corr_means, shuffle_mat2, alpha_corr )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[corr_at_best, idx] = max(corr_means);
best_angle = rot_array(idx);

% Calculate Significance
num_shuffles = size(shuffle_mat2,1)/size(corr_mat,1);
shuffle_chunk = size(corr_mat,1);
% shuf_mean_corr = nan(num_shuffles,1);
shuf_mean_temp = nan(num_shuffles, size(corr_mat,2));
for k = 1:num_shuffles
    ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk); % Get indices for each shuffled session
    shuf_mean_temp(k,:) = nanmean(shuffle_mat2(ind_use,:),1); % Get mean of shuffled sessions
%     shuf_mean_corr(k,1) = max(shuf_mean_temp(k,:)); % Get mean at best rotation/highest corr
%     shuf_mean_corr(k,2) = min(shuf_mean_temp(k,:)); % Get mean at worst rotation/lowest corr
end
sig_test = (1 - sum(corr_at_best > shuf_mean_temp(:,1))/num_shuffles) < alpha_corr;


end

