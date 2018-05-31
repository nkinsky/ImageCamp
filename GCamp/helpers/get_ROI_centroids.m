function [ cent, wcent ] = get_ROI_centroids( ROIbool, ROIweighted)
% [ cent, wcent ] = get_ROI_centroids( ROIbool, ROIweighted)
%   Takes a cell array of ROImasks (ROIbool) and spits out their centroids
%   in an array. Optional argument ROIweighted also spits out weighted
%   centroids if input values are not binary. You also can get weighted
%   centroids by just inputting a non-boolean for ROIbool, which will
%   consider any non-zero pixels as belonging to the ROI.

n = length(ROIbool);
cent = nan(n,2);
wcent = nan(n,2);
if nargin < 2 && islogical(ROIbool{1})
    calc_weighted = false;
elseif nargin == 2
    calc_weighted = true;
elseif nargin < 2 && ~islogical(ROIbool{1})
    calc_weighted = true;
    ROIweighted = ROIbool;
    ROIbool = cellfun(@(a) a > 0, ROIweighted, 'UniformOutput', false);
end

if calc_weighted
    for j= 1:n
        temp = regionprops(ROIbool{j},ROIweighted{j}, ...
            'Centroid','WeightedCentroid');
        cent(j,:) = temp.Centroid;
        wcent(j,:) = temp.WeightedCentroid;
    end
else
    for j= 1:n
        temp = regionprops(ROIweighted{j},'Centroid');
        cent(j,:) = temp.Centroid;
    end
end

end

