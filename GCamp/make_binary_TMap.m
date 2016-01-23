function [ TMap_bin ] = make_binary_TMap( TMap, thresh )
% [ TMap_bin ] = make_binary_TMap( TMap )
% Takes a heatmap (TMap) and turns it into a binary place-field map with
% ones in the placefield and zeros elsewhere.  thresh is the value of the
% TMap above which you wish to make ones.  Everything below thresh will go
% to zeros.

% sets threshold to 0 if not specified
if nargin < 2
    thresh = 0;
end

TMap_bin = zeros(size(TMap)); % Set it up
TMap_bin(TMap > thresh & ~isnan(TMap)) = ...
    ones(size(find(TMap > thresh & ~isnan(TMap)))); % Make all valid areas = 1
TMap_bin = logical(TMap_bin);
end

