function [ chi2stat_mat, p_mat, df ] = calc_coherency( best_angle_all, sesh_type, method )
% [ chi2stat, p, df ] = calc_coherency( best_angle_all, rot_bins, method )
%   Calculates if a session is coherent by performing a chi-squared
%   goodness-of-fit test for the distribution of rotation angles versus the
%   null distribution of global remapping (a uniform distribution).
%
%   INPUTS
%       best_angle_all: best rotation angle for all neurons, with NaNs for
%       ambiguous/silent cells in one session
%
%       rot_bins: rotation angles used with 360 included, e.g. 0:90:360 for 
%       square or 0:15:360 for circle or circ2square
%
%       method (optional): 1 = use rotatation angles directly, 2 = use
%       differences between rotation angles

% Get appropriate method
if nargin < 3
    method = 1;
end

% Identify sesh_type
sesh_log = cellfun(@(a) strcmpi(sesh_type,a),{'square','circle','circ2square'});

% Identify good sessions
[igood, jgood] = find(~(cellfun(@isempty, best_angle_all)));
num_sesh_pairs = length(igood);

% Pre-allocate
chi2stat_mat = nan(size(best_angle_all));
p_mat = nan(size(best_angle_all));
if method == 1
    rot_bins_cell = {0:90:360, 0:15:360, 0:15:360};
    rot_bins = rot_bins_cell{sesh_log}; % Get appropriate bins to use
    for k = 1:num_sesh_pairs
%         ind_use = igood(k);
        iuse = igood(k); juse = jgood(k);
        best_angle_use = best_angle_all{iuse, juse};
        num_reps = size(best_angle_use,2);
        
        for ll = 1:num_reps % will run through multiple repetitions if, say, you have shuffled data
            [p_mat(iuse,juse,ll), chi2stat_mat(iuse,juse,ll)] = ...
                calc_chi2(best_angle_use(:,ll), rot_bins);
        end
        
%         n = histcounts(best_angle_use, rot_bins);
%         e_unif = sum(n)/length(n);  % Expected count in each bin for uniform distribution
%         chi2stat_mat(ind_use) = sum((n-e_unif).^2/e_unif);
%         p_mat(ind_use) = chi2pdf(chi2stat_mat(ind_use),length(n)-1);
    end
elseif method == 2
    incr_mat = [90 15 15];
    incr_use = incr_mat(sesh_log); % Get appropriate increment
    rot_bins = -180:incr_use:180;
    for k = 1:num_sesh_pairs
%         ind_use = igood(k);
        iuse = igood(k); juse = jgood(k);
        best_angle_use = best_angle_all{iuse, juse};
        num_reps = size(best_angle_use,2);
        for ll = 1:num_reps
            rotd_use = calc_rotd(best_angle_use(:,ll));
            [p_mat(iuse,juse,ll), chi2stat_mat(iuse,juse,ll)] = calc_chi2(rotd_use, ...
                rot_bins);
        end
        
%         n = histcounts(rotd_use, rot_bins);
%         e_unif = sum(n)/length(n);  % Expected count in each bin for uniform distribution
%         chi2stat_mat(ind_use) = sum((n-e_unif).^2/e_unif);
%         p_mat(ind_use) = chi2pdf(chi2stat_mat(ind_use),length(n)-1);
    end
end

num_bins = length(rot_bins) - 1;
df = num_bins - 1;
end

%% Chi2stat and pval sub-function
function [pval, chi2stat_out] = calc_chi2(metric_use, bins_use)
n = histcounts(metric_use, bins_use);
e_unif = sum(n)/length(n);  % Expected count in each bin for uniform distribution
chi2stat_out = sum((n-e_unif).^2/e_unif);
pval = chi2pdf(chi2stat_out,length(n)-1);
end

