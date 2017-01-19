function [ buddybool ] = find_buddies(NeuronPixelIdxList )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NumNeurons = length(NeuronPixelIdxList);

buddybool = false(NumNeurons,NumNeurons);
for j = 1:NumNeurons
    buddies = [];
    Overlap = nan(1,NumNeurons);
    for i = 1:NumNeurons
        Overlap(i) = length(intersect(NeuronPixelIdxList{j},NeuronPixelIdxList{i}))./...
            min(length(NeuronPixelIdxList{j}),length(NeuronPixelIdxList{i}));
        
        if ((i ~= j)&& (Overlap(i) > 0))
            buddies = [buddies,i];
        end
    end
    buddybool(j,buddies) = true;
end

end

