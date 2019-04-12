function [corrmatmeans, corrmat, nexclude] = twoenv_PVconn_means(PVconns_cell, ...
    ncell_thresh)
% [corrmatmeans, corrmat, nexclude] = twoenv_PVconn_means(PVconns_cell, ncell_thresh)
%   One-off function used in twoenv_PVdiscr_support to get mean PV
%   correlations for all connected sessions on the same day. Sessions with
%   less than ncell_thresh cells active are excluded and output as nan. The
%   total number of sessions excluded is output in nexclude. Default = 1.

if nargin < 2
    ncell_thresh = 1;
end

% Grab only sessions with enough cells. 
PVconns_temp = PVconns_cell;
ncells = cellfun(@(a) size(a, 3), PVconns_cell); % get # cells in each session-pair
exclude_bool = (ncells < ncell_thresh) & ~cellfun(@isempty, PVconns_cell);
nexclude = sum(exclude_bool(:));
PVconns_cell = cell(size(PVconns_cell));
PVconns_cell(ncells >= ncell_thresh) = PVconns_temp(ncells >= ncell_thresh);

corrmat = cell(size(PVconns_cell));
corrmat(~cellfun(@isempty, PVconns_cell)) = cellfun(@(a) ...
    corr3d(squeeze(a(:,:,:,1)), squeeze(a(:,:,:,2))), ...
    PVconns_cell(~cellfun(@isempty, PVconns_cell)),'UniformOutput',false);
corrmatmeans = cellfun(@(a) nanmean(a(:)), corrmat);

end

