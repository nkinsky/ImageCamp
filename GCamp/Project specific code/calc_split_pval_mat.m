function [pmat_split, pmat_PF] = calc_split_pval_mat(sessions)
% [pmat_split, pmat_PF] = calc_split_pval_mat(sessions)
%   Calculates a pvalue matrix between all sessions in "sessions" for both
%   splitter cell correlations and TMap correlations

% pre-allocate
num_sessions = length(sessions);
pmat_split = nan(num_sessions);
pmat_PF = nan(num_sessions);

for j = 1:num_sessions - 1
    sesh1 = sessions(j);
    for k = (j+1):num_sessions
        sesh2 = sessions(k);
        [pmat_split(j,k), pmat_PF(j,k)] = get_split_pval(sesh1, sesh2);
    end
end

end

