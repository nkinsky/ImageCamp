function [ AllMap ] = create_PFdensity_map( TMap )
% TMap_density = create_PFdensity_map( TMap )
%   Creates a map overlaying all the transient maps from a cell array of
%   TMaps


AllMap = zeros(size(TMap{1}));
for k = 1:length(TMap)
    AllMap(:) = nansum([AllMap(:), TMap{k}(:)],2);
end


end

