function [ TMap_fix ] = fix_nan_TMap( TMap_in, RunOccMap)
% TMap_gauss_fix = fix_nan_TMap( TMap_in, RunOccMap )
%   Takes TMap_gauss cell input and converts any all NaN maps (i.e. those
%   that have no firing above the speed threshold) and makes them the 0
%   where there is no firing

ZeroMap = RunOccMap;
ZeroMap(ZeroMap == 0) = nan;
ZeroMap(~isnan(ZeroMap) & ZeroMap ~= 0) = 0;

fix_ind = find(cellfun(@(a) all(isnan(a(:))),TMap_in));

TMap_fix = TMap_in;
for j = 1:length(fix_ind)
    TMap_fix{fix_ind(j)} = ZeroMap;
end


end

