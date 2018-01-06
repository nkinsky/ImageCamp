function [ hval_mat, pval_mat] = twoenv_PVshuftest( PV_corr, PV_corr_shuffle, alpha)
%  [ hval_mat, pval_mat] = twoenv_PVshuftest( PV_corr, PV_corr_shuffle, alpha)
%   Performs shuffle test on each session-pair in the 4D PV_corr mat (
%   session1 x session2 x xbins x ybins) vs shuffled (5D, last dim =
%   #shuffles) at alpha significance level.

if nargin < 3
    alpha = 0.05;
end
npairs1 = size(PV_corr,1);
npairs2 = size(PV_corr,2);

for j= 1:npairs1
    for k = 1:npairs2
        corr_use = squeeze(PV_corr(j,k,:,:));
        shuf_use = squeeze(PV_corr_shuffle(j,k,:,:,:));
        pval_mat(j,k) = PV_shuffle_test(corr_use, shuf_use);
    end
end
hval_mat = pval_mat < alpha;

end

