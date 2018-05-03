function [ rough_corrs ] = corrTMap(TMap1, TMap2, rotate2)
% rough_corrs = corrTMap(TMap1, TMap2, rotate2)
%   Performs a rough correlation between all the TMaps in TMap1 and TMap2
%   after rotating TMap2 as specified in rotate2 (90 degree increments,
%   default = 0).

%%
rot_use = rotate2/90;
rough_corrs = nan(length(TMap1),length(rotate2));
shape1 = size(TMap1{1});
for j = 1:length(rotate2)
    
    TMap2rot = cellfun(@(a) rot90(a,rot_use(j)), TMap2,...
        'UniformOutput', false);
    TMap2use = cellfun(@(a) resize(a,shape1), TMap2rot, ...
        'UniformOutput', false);
    rough_corrs(:,j) = cellfun(@(a,b) corr(a(:), b(:), 'type', 'Spearman',...
        'rows', 'complete'),TMap1, TMap2use);
    
end

%%
end

