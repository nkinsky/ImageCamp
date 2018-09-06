function [pval_reg] = reg_pvalue(reg_stats)
% pval_reg = reg_pvalue(reg_stats)
%   Calculates p-value compared to a shuffled distribution from a given
%   registration. Uses output of neuron_reg_qc or neuron_reg_qc2.
%   Calculates mean(abs(orient_diff)) for all neuron ROIs and compares to
%   shuffled values. p = sum(data > shuffled)/num_shuffles

nneurons = length(reg_stats.orient_diff);
if size(reg_stats.shuffle.orient_diff,2) == 1
    nshuffles = length(reg_stats.shuffle.orient_diff)/nneurons;
    shufr = reshape(reg_stats.shuffle.orient_diff, nneurons, nshuffles);
else
   shufr =  reg_stats.shuffle.orient_diff;
end

shufr_mean = nanmean(abs(shufr),1);
data_mean = nanmean(abs(reg_stats.orient_diff));

pval_reg = sum(data_mean > shufr_mean)/nshuffles;

end

