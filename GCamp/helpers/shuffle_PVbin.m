function [PVshuf] = shuffle_PVbin(PVin, exclude_zero_occ)
% PVshuf = shuffle_PVbin(PVin, exclude_zero_occ)
%
%   Takes a numBinsx x numBinsy x num_neurons population vector and
%   randomly permutes spatial bins. exclude_zeroocc (default = true)
%   exclude bins with no activity. set to true if you have small bins, but
%   generally set to false to exclude bins the animal did not visit.

[ny, nx, nn] = size(PVin); % Get num bins in each direction and num_neurons

% Reshape PVin to a num_bins x num_neurons array
PV2 = reshape(PVin, ny*nx, nn);

% First identify any bins with NO activity in any cells and exclude these
% from shuffling. 
if exclude_zero_occ
    goodbins_bool = nanmean(PV2,2) > 0;
    PVgood = PV2(goodbins_bool,:);
else 
    PVgood = PV2;
end
nbins = size(PVgood,1);

% Shuffle rows (spatial bins)
PVgood_shuf = PVgood(randperm(nbins),:);
PVshuf_temp = PV2;
PVshuf_temp(goodbins_bool,:) = PVgood_shuf; % Put shuffled bins back into full array

% Return to original shape with shuffled spatial bins
PVshuf = reshape(PVshuf_temp,size(PVin));

end
