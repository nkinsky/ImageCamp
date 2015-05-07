function [ TMap_bin ] = make_binary_TMap( TMap )
% [ TMap_bin ] = make_binary_TMap( TMap )
% Takes a heatmap (TMap) and turns it into a binary place-field map with
% ones in the placefield and zeros elsewhere

TMap_bin = zeros(size(TMap)); % Set it up
TMap_bin(TMap ~= 0 & ~isnan(TMap)) = ...
    ones(size(find(TMap ~= 0 & ~isnan(TMap)))); % Make all valid areas = 1
TMap_bin = logical(TMap_bin);
end

