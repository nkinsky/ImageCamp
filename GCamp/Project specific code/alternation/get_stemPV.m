function [ PV, PVz ] = get_stemPV( x, y, PSAbool, Alt )
% [PV, PVz] = get_stemPV( x, y, PSAbool )
%   Get a population vector for all points along the stem for L and R
%   trials. z-scored spit out also. Need to create a way

%% Step 1: Get stem occupancy
[ stemBinOccLRc, stemBinOccLRi ] = get_stem_occ( x , y, Alt );
unique_bins = unique(stemBinOccLRc(:));
unique_bins = unique_bins(~isnan(unique_bins));

%% Step 2: Get PVs for each occupancy bin
PV = nan(2,size(PSAbool,1),length(unique_bins));
PVz = PV;
for j = 1:2
    [PV(j,:,:), PVz(j,:,:) ] = getPV(PSAbool, stemBinOccLRc(j,:));
end


end

