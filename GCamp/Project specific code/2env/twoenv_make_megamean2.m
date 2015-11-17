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
    for k = 1:size(indices_conflict,1)
        temp_distal{j} = [temp_distal ; squeeze(Mouse(j).corr_matrix{1,indices_conflict(k,1)}(...
            indices_conflict(k,2),indices_conflict(k,3),:))];
        temp_local{j} = [temp_local ; squeeze(Mouse(j).corr_matrix{2,indices_conflict(k,1)}(...
            indices_conflict(k,2),indices_conflict(k,3),:))];
    end
    distal_all = [distal_all; temp_distal]; distal_simple{j} = mean(distal_all);
    local_all = [local_all; temp_local]; local_simple{j} = mean(local_all);
    
    for k = 1:size(indices_aligned,1)
        temp_both{j} = [temp_both; squeeze(Mouse(j).corr_matrix{1,indices_aligned(k,1)}(...
            indices_aligned(k,2),indices_aligned(k,3),:))];
    end
    both_all = [both_all; temp_both]; both_simple{j} = mean(both_all);
    
end



end

