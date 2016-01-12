function [ h, p, mean_val ] = twoenv_kstest( Mouse, shuffle_comb, comp_vec_local, comp_vec_distal, varargin)
% Performs a k-s test between distributions of correlations aligned to
% local cues (vs chance), aligned to distal cues (vs chance), and versus
% each other
%
% Mouse: variable that contains all the correlations for each mouse, see
% twoenv_batch_analysis script
%
% shuffle_comb: contains shuffled correlations
%
% comp_vec_local: an nx2 array containing all the pairs of comparisons
% between sessions you wish to make with local cues aligned
%
% comp_vec_distal: same as above but for distal cues aligned

plot_flag = 0; % default
for j = 1:length(varargin)
    if strcmpi(varargin{j},'plot_ecdf')
        plot_flag = 1;
        plot_title = varargin{j+1};
    end
end


num_animals = length(Mouse);

comp_comb_local = [];
comp_comb_distal = [];
shuffle_comb_local = [];
shuffle_comb_distal = [];
for j = 1:num_animals
    for ll = 1:2
        for mm = 1:size(comp_vec_local,1)
            comp_comb_local = [ comp_comb_local ; squeeze(Mouse(j).corr_matrix{2,ll}(comp_vec_local(mm,1),comp_vec_local(mm,2),...
                logical(squeeze(Mouse(j).pass_count{2,ll}(comp_vec_local(mm,1),comp_vec_local(mm,2),:)))))];
            shuffle_comb_local = [shuffle_comb_local ; squeeze(Mouse(j).shuffle_matrix{2,ll}(1,comp_vec_local(mm,1),comp_vec_local(mm,2),:))];
        end
        for mm = 1:size(comp_vec_distal,1)
            comp_comb_distal = [ comp_comb_distal ; squeeze(Mouse(j).corr_matrix{1,ll}(comp_vec_distal(mm,1),comp_vec_distal(mm,2),...
                logical(squeeze(Mouse(j).pass_count{1,ll}(comp_vec_distal(mm,1),comp_vec_distal(mm,2),:)))))];
            shuffle_comb_distal = [shuffle_comb_distal ; squeeze(Mouse(j).shuffle_matrix{1,ll}(1,comp_vec_distal(mm,1),comp_vec_distal(mm,2),:))];
        end
        
    end
end

[h.local, p.local] = kstest2(comp_comb_local,shuffle_comb_local,'tail','smaller');
[h.distal, p.distal] = kstest2(comp_comb_distal, shuffle_comb_distal,'tail','smaller');
[h.loc_to_dist, p.loc_to_dist] = kstest2(comp_comb_local, comp_comb_distal);
mean_val.local = nanmean(comp_comb_local);
mean_val.distal = nanmean(comp_comb_distal);
mean_val.shuffle = nanmean([shuffle_comb_distal; shuffle_comb_local]);

if plot_flag == 1
figure
ecdf(comp_comb_local); hold on;
ecdf(comp_comb_distal);
ecdf(shuffle_comb_local);
ecdf(shuffle_comb_distal);
hold off
legend('Local aligned','Distal Aligned','Local Shuffled','Distal Shuffled')
title(plot_title)
end

end

