function [ TMap_maxPF ] = make_maxPF_TMap(PFpixels, MaxPF, TMap )
% TMap_maxPF  = make_maxPF_TMap(PFpixels, MaxPF )
%   Creates a transient heat map that includes ONLY the place field with
%   the maximum probability of transient occurrence and excludes all other
%   fields. PFpixels and MaxPF are taken from PFstats.mat (calculated using
%   PFstats), and TMap_size is taken from size(TMap), where TMap comes for 
%   PlaceMaps.mat (calculated using CalculatePlacefields).

num_PFs = length(MaxPF);

TMap_maxPF = cell(num_PFs,1);
for j = 1:num_PFs
   temp = zeros(size(TMap{1}));
   temp(PFpixels{j,MaxPF(j)}) = 1;
   TMap_maxPF{j} = temp.*TMap{j};
end

end

