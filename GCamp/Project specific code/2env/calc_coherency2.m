function [ p_mat, chi2_real, chi2_shuf, df ] = calc_coherency2( best_angle_all, ...
    best_angle_shuf_all, comp_type, method )
%  [ p_mat, chi2_mat, chi2_mat_shuf ] = calc_coherency2( best_angle_all, ...
%       best_angle_shuf_all, method )
%   Calculates coherency by comparing chi-squared stat for real data to
%   shuffled.  Wrapper function for calc_coherency.

% % Identify sesh_type
% sesh_log = cellfun(@(a) strcmpi(sesh_type,a),{'square','circle','circ2square'});

% Get real stats
[ chi2_real, ~, df ] = calc_coherency( best_angle_all, ...
    comp_type, method );

% Get shuffled stats
[ chi2_shuf, ~, ~] = calc_coherency( best_angle_shuf_all, ...
    comp_type, method );

[igood, jgood] = find(~(cellfun(@isempty, best_angle_all))); % Get valid session-pairs

p_mat = nan(size(chi2_real));
for k = 1:length(igood)
    chi2shuf_use = squeeze(chi2_shuf(igood(k),jgood(k),:));
    p_mat(igood(k),jgood(k)) = sum(chi2shuf_use > chi2_real(igood(k),jgood(k)))/...
        length(chi2shuf_use);
end


end

