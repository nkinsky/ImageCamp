function [ Tcentroid, TPixelList, TPixelList_all ] = TMap_centroid( TMap)
%[ xcm, ycm ] = TMap_centroid( TMap_use )
%   Takes TMap from CalculatePlaceFields and spits out the centroid of the
%   firing field.
% INPUT
%   TMap, a 1xnum_cells cell with firing rate maps
%
% OUTPUT
%   Tcentroid, an nx2 array with the first column xcentroid and the 2nd
%   column ycentroid.  Note that this currently only looks for the centroid
%   of the heat map with the highest average "firing" rate...
%   TPixelList is the list of pixels in TMap that are non-zero

%%
for j = 1:size(TMap,2)
    TMap_use = TMap{j};
    
    % Get stats on all the different place-fields for a given neuron
    stats = regionprops(make_binary_TMap(TMap_use),'all');
    mean_TR = 0;
    TPixelList_all{j} = [];
    TPixelList{j} = [];
    Tcentroid(j,:) = [nan nan];
    for k = 1:length(stats)
       % get mean of each place-field transient rate
       temp = nanmean(TMap_use(stats(k).PixelIdxList));
       % If multiple fields, only include the field with the highest mean
       % transient rate
       
       if temp > mean_TR 
           mean_TR = temp; % update mean transient rate
           Tcentroid(j,:) = stats(k).Centroid; % Assign centroid
           TPixelList{j} = stats(k).PixelList;
       end
       TPixelList_all{j} = [TPixelList_all{j} ; stats(k).PixelList]; % Get pixels for ALL placefields in TMap
    end
    
    %%% Old, inaccurate method %%%
%     [YDim XDim] = size(TMap_use);
%     % Create arrays with pixel values for X and Y, respectively
%     Xpix_wt = repmat(1:XDim,YDim,1);
%     Ypix_wt = repmat([1:YDim]',1,XDim);
%     
%     if isnan(sum(TMap_use(:)))
%         Tcentroid(j,1) = nan;
%         Tcentroid(j,2) = nan;
%     else
%         
%         ind_nz = TMap_use ~= 0; % Grab only pixels with non-zero values
%         
%         % Calc out the centroids
%         xcm = sum(Xpix_wt(ind_nz).*TMap_use(ind_nz))/sum(TMap_use(ind_nz));
%         ycm = sum(Ypix_wt(ind_nz).*TMap_use(ind_nz))/sum(TMap_use(ind_nz));
%         
%         Tcentroid(j,1) = xcm;
%         Tcentroid(j,2) = ycm;
%     end

end

% keyboard
end

