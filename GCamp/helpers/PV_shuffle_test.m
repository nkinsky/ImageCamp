function [ pval, shuf_means ] = PV_shuffle_test(PV_corr, PV_corr_shuffle )
%  pval = PV_shuffle_test(PV_corr_mean, PV_corr_shuffle )
%   Performs a shuffle test on a 2D population vector vs shuffle, checking
%   how many times the mean of the real data falls below the mean of the
%   shuffled data. num_shuffles must be the 3rd dim in the PV_corr_shuffle
%   matrix.

num_shuffles = size(PV_corr_shuffle,3);

mean_data = nanmean(PV_corr(:));
count = 0;
shuf_means = nan(1,num_shuffles);
for j = 1:num_shuffles
    shuf_use = PV_corr_shuffle(:,:,j);
    shuf_mean = nanmean(shuf_use(:));
    count = count + (shuf_mean >= mean_data);
    shuf_means(j) = shuf_mean;
end

pval = count/num_shuffles;

end

