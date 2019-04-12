function [PVz] = zscore_PV2d(PVin)
% PVz] = zscore_PV2d(PVin)
%   Takes a 2d population vector and z-scores its calcium event rate for
%   each spatial bin.

PVmean = nanmean(reshape(PVin,[],size(PVin,3)),1);
PVstd = nanmean(reshape(PVin,[],size(PVin,3)),1);
PVz = (reshape(PVin,[],size(PVin,3))-PVmean)./PVstd;
PVz = reshape(PVz, size(PVin));

end

