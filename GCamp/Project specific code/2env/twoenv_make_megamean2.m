function [ distal_all, local_all, both_all, distal_simple, local_simple, both_simple] = twoenv_make_megamean2(Mouse,indices_conflict, indices_aligned )
% [ distal_all, local_all, both_all, distal_simple, local_simple, both_simple] = twoenv_make_megamean2(Mouse,indices_conflict, indices_aligned )
%   For use in twoenv_batch_analysis only.  Pulls appropriate correlation
%   values from Mouse variable.

num_animals = length(Mouse);

distal_all = []; % ALL correlation values for every animal
local_all = [];
both_all = [];
for j = 1:num_animals
    temp_distal = []; % one mean for each session for each animal
    temp_local = [];
    temp_both = [];
    for k = 1:size(indices_conflict{j},1)
        temp_distal = [temp_distal ; squeeze(Mouse(j).corr_matrix{1,indices_conflict{j}(k,1)}(...
            indices_conflict{j}(k,2),indices_conflict{j}(k,3),:))];
        temp_local = [temp_local ; squeeze(Mouse(j).corr_matrix{2,indices_conflict{j}(k,1)}(...
            indices_conflict{j}(k,2),indices_conflict{j}(k,3),:))];
    end
    distal_all = [distal_all; temp_distal]; distal_simple{j} = nanmean(distal_all);
    local_all = [local_all; temp_local]; local_simple{j} = nanmean(local_all);
    
    for k = 1:size(indices_aligned{j},1)
        temp_both = [temp_both; squeeze(Mouse(j).corr_matrix{1,indices_aligned{j}(k,1)}(...
            indices_aligned{j}(k,2),indices_aligned{j}(k,3),:))];
    end
    both_all = [both_all; temp_both]; both_simple{j} = nanmean(both_all);
    
end



end

