function [ Tcentroid ] = TMap_centroid( TMap)
%[ xcm, ycm ] = TMap_centroid( TMap_use )
%   Takes TMap from CalculatePlaceFields and spits out the weighted center
%   of mass of the firing field.  NOTE: this is a very rough approximation
%   of placefield centroid, and does not eliminate multiple fields.  Will
%   need a better method eventually...
% INPUT
%   TMap, a 1xnum_cells cell with firing rate maps
%
% OUTPUT
%   Tcentroid, an nx2 array with the first column xcentroid and the 2nd
%   column ycentroid

for j = 1:size(TMap,2)
    TMap_use = TMap{j};
    [YDim XDim] = size(TMap_use);
    
    % Create arrays with pixel values for X and Y, respectively
    Xpix_wt = repmat(1:XDim,YDim,1);
    Ypix_wt = repmat([1:YDim]',1,XDim);
    
    if isnan(sum(TMap_use(:)))
        Tcentroid(j,1) = nan;
        Tcentroid(j,2) = nan;
    else
    
        ind_nz = TMap_use ~= 0; % Grab only pixels with non-zero values
        
        % Calc out the centroids
        xcm = sum(Xpix_wt(ind_nz).*TMap_use(ind_nz))/sum(TMap_use(ind_nz));
        ycm = sum(Ypix_wt(ind_nz).*TMap_use(ind_nz))/sum(TMap_use(ind_nz));
        
        Tcentroid(j,1) = xcm;
        Tcentroid(j,2) = ycm;
    end

end

end

