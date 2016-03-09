function [ TMap_bin ] = make_binary_TMap( TMap, thresh )
% [ TMap_bin ] = make_binary_TMap( TMap, thresh )
% Takes a heatmap (TMap) and turns it into a binary place-field map with
% ones in the placefield and zeros elsewhere.  thresh is the cutoff from the ecdf that you
% wish to use to set values to 1 (e.g. thresh = 0.9 will set pixels
% where the smoothed firing rate is greater than 90% of the values in the
% TMap to 1).  Everything below thresh will go
% to zeros.  If thresh is NOT specified, it will be auto-selected as 0.9.

% automatically sets threshold if not specified
if nargin < 2
    thresh = 0.9;
end

TMap_bin = zeros(size(TMap)); % Set it up
try
    [f, x] = ecdf(TMap(:));
    thresh_binary = x(find(f > thresh,1,'first'));
    TMap_bin(TMap > thresh_binary & ~isnan(TMap)) = ...
        ones(size(find(TMap > thresh_binary & ~isnan(TMap)))); % Make all valid areas = 1
    TMap_bin = logical(TMap_bin);
catch % If there is an error of some sort, just leave TMap_bin as zeros.
end
    
end

