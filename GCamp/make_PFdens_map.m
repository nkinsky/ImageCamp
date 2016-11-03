function [ PFdens_map ] = make_PFdens_map(TMap, varargin)
% PFdens_map = make_PFdens_map(TMap, ...)
%   DMakes a place field density map by combining all the TMaps in TMap
%   together.  If you add in an OccMap as an optional, 2nd argument,
%   PFdens_map will rhave NaNs wherever the mouse has no occupancy
p = inputParser;
p.addRequired('TMap', @(x) iscell(x));
p.addOptional('OccMap', nan,@(x) isnumeric(x));
p.parse(TMap,varargin{:})
OccMap = p.Results.OccMap;
%%
PFdens_map = zeros(size(TMap{1})); 
for j = 1:length(TMap)
    PFdens_map = nansum(cat(3,PFdens_map,TMap{j}),3); 
end

%% Make NaN TMap if OccMap is input
if nansum(OccMap(:)) ~= 0
    [~, PFdens_map] = make_nan_TMap(OccMap,PFdens_map);
end

end

