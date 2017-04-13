function [ TMap_gauss_fixed ] = fix_nan_TMap(TMap_unsmoothed)
% TMap_gauss_fixed = fix_nan_TMap(TMap_unsmoothed)
% Function to fix edge bug in Placefields where an unsmoothed occupancy map
% with no transient firing (because the cell only fired when the mouse was
% below the speed threshold) ends up as all nans.
%   Detailed explanation goes here


end

