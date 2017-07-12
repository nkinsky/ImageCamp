function [ chi2stat_mat, p_mat, df ] = calc_coherency( best_angle_all, rot_bins )
% [ chi2stat, p, df ] = calc_coherency( best_angle_all. rot_bins )
%   Calculates if a session is coherent by performing a chi-squared
%   goodness-of-fit test for the distribution of rotation angles versus the
%   null distribution of global remapping (a uniform distribution).
%
%   INPUTS
%       best_angle_all: best rotation angle for all neurons, with NaNs for
%       ambiguous/silent cells in one session
%
%       rot_bins: rotatation angles used with 360 included, e.g. 0:90:360 for 
%       square or 0:15:360 for circle or circ2square

% Identify good sessions
igood = find(~(cellfun(@isempty, best_angle_all)));
num_pairs = length(igood);

chi2stat_mat = nan(size(best_angle_all));
p_mat = nan(size(best_angle_all));
for k = 1:num_pairs
    ind_use = igood(k);
    best_angle_use = best_angle_all{ind_use};
    n = histcounts(best_angle_use, rot_bins);
    e_unif = sum(n)/length(n);  % Expected count in each bin for uniform distribution
    chi2stat_mat(ind_use) = sum((n-e_unif).^2/e_unif);
    p_mat(ind_use) = chi2pdf(chi2stat_mat(ind_use),length(n)-1);
end

num_bins = length(rot_bins) - 1;
df = num_bins - 1;
end

