function [ comparison_comb, comparison_comb_no_rot] = get_grouped_corrs( Mouse, comparison_ind)
%Takes TMap correlation distributions from Mouse structure and pools all
%like comparisons, specified in comparison_ind, together and spits out both
%the rotated and non-rotated distributions
%
%   INPUTS
%   Mouse - see twoenv_batch_analysis
%
%   comparison_ind: a n x 1 array where each row is the comparisons you
%   wish to pool together from the matrix Mouse(i).corr_matrix.  E.g., if
%   comparison_ind is [1; 4 ; 7] then the function will pull the 1st, 4th,
%   and 7th entries in .corr_matrix.  Note that, because corr_matrix is
%   8x8xnum_neurons, the indices should be compatible with an 8x8 matrix.
%
%   OUTPUTS
%   comparison_comb: an n x 1 vector of ALL the correlations for each mouse
%   in .corr_matrix indicated in comparison_ind, rotated such that local
%   cues align
%
%   comparison_comb_no_rot: same as comparison_comb, but with no rotation
%   back (i.e. distal cues are aligned).

num_comparisons = size(comparison_ind,1);
num_animals = length(Mouse);

comparison_comb = [];
comparison_comb_no_rot = [];
for j = 1:num_animals
    for ll = 1:2
        for mm = 1:size(comparison_ind,1)
            comparison_comb_no_rot = [ comparison_comb_no_rot ; squeeze(Mouse(j).corr_matrix{1,ll}(comparison_ind(mm,1),comparison_ind(mm,2),...
                logical(squeeze(Mouse(j).pass_count{1,ll}(comparison_ind(mm,1),comparison_ind(mm,2),:)))))];
            comparison_comb = [ comparison_comb ; squeeze(Mouse(j).corr_matrix{2,ll}(comparison_ind(mm,1),comparison_ind(mm,2),...
                logical(squeeze(Mouse(j).pass_count{2,ll}(comparison_ind(mm,1),comparison_ind(mm,2),:)))))];
        end
    end
end
comp_mean = nanmean(comparison_comb);
comp_sem = nanstd(comparison_comb)/sqrt(length(comp));


end

