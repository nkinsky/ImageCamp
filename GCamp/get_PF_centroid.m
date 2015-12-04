function [ PF_centroid ] = get_PF_centroid( PlaceMap, thresh )
% [ PF_centroid ] = get_PF_centroid( PlaceMap, thresh )
%   Gets the centroid(s) of neuron PlaceMaps.  PlaceMap is a cell with a
%   TMap for each neuron, and thresh is the cutoff from the ecdf that you
%   wish to use to define each field (e.g. thresh = 0.9 will define fields
%   where the smoothed firing rate is greater than 90% of the values in the
%   TMap).

%%
num_PFs = length(PlaceMap);
% nan_map = nan(size(PlaceMap{1}));

%% if only one value is entered and it is not a cell, make it a cell
if ~iscell(PlaceMap)
   temp = PlaceMap;
   clear PlaceMap;
   PlaceMap{1} = temp;
end
%% Make PlaceMaps binary 
PF_centroid = cell(num_PFs,1);
for j = 1:num_PFs
    if sum(~isnan(PlaceMap{j}(:))) > 0
        [f, x] = ecdf(PlaceMap{j}(:));
        thresh_binary = x(find(f > thresh,1,'first'));
        map_binary = make_binary_TMap(PlaceMap{j},thresh_binary);
        cc = bwconncomp(map_binary);
        stats = regionprops(cc,'Centroid');
        for k = 1:length(stats)
            PF_centroid{j,k} = stats(k).Centroid;
        end
    else
%         PF_centroid{j,1} = [];
    end
    
end

end

