function [ pc_bool, ntrans_bool ] = pf_filter(MD, pval_thresh, ntrans_thresh, PFname)
% [pc_bool, ntrans_bool ] = pf_filter(MD, pval_thresh, ntrans_thresh)
%   Filters all cells in MD for pSI < pval_thresh and numtrans >
%   ntrans_thresh. Assumes everything is in Placefields.mat unless
%   alternate name is supplied.

if nargin < 4
    PFname = 'Placefields.mat';
end

dirstr = ChangeDirectory_NK(MD,0);
load(fullfile(dirstr,PFname),'pval','PSAbool')
ntrans_bool = (get_num_trans(PSAbool) > ntrans_thresh);
pc_bool = (pval < pval_thresh)';

end

