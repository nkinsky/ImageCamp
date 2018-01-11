function [group_means,  unique_groups, mat_in_ind] = group_mat(mat_in, group_mat)
% [group_means,  unique_groups, mat_in_ind] = group_mat(mat_in, group_mat)
%
% Takes data in mat_in and organizes into a cell based on its group
% membership in group_means.  Also spits out indices for the grouped data in
% mat_in_ind
%
% Example:
% x = [1 2; 3 4]; groups = [ 0 0; 1 2];
% [group_means,  unique_groups, mat_in_ind] = group_mat(x, groups);
% groups_means = { [1 2], 3, 4}
% unique_groups = [0 1 2]'
% mat_in_ind = {[1 3], 2 4}

unique_groups = unique(group_mat(~isnan(group_mat)));

group_means = arrayfun(@(a) mat_in(group_mat == a),unique_groups,...
    'UniformOutput',false);
mat_in_ind = arrayfun(@(a) find(group_mat == a),unique_groups,...
    'UniformOutput',false);

end


