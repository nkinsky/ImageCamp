function [ proj_out] = h5mov_proj( moviefile, proj_type)
% proj_out = h5mov_proj( moviefile, proj_type)
%   Create a 'max' or 'min' projection of an h5 movie

% Get movie information. 
info = h5info(moviefile,'/Object');
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);
NumFrames = info.Dataspace.Size(3);

FrameChunkSize = min([1250 NumFrames]);
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

if nargin < 2
    proj_type = input('What type of projection do you want to make (max/min)? ', 's');
end

switch proj_type
    case 'max'
        F = @max;
        bool_use = @gt;
        newproj = zeros(Xdim,Ydim); % start at 0 for max proj
    case 'min'
        F = @min;
        bool_use = @lt;
        newproj = inf(Xdim,Ydim); % Start at infinity for min proj
    otherwise
        disp('only ''min'' and ''max'' projections enabled currently')
end

p = ProgressBar(NumChunks);
for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    temp = LoadFrames(moviefile,FrameList);
    tempproj = feval(F,temp,[],3); % Get min/max
    newproj(feval(bool_use,tempproj,newproj)) = ...
        tempproj(feval(bool_use,tempproj,newproj));
    
    p.progress;
end
p.stop;

proj_out = newproj;

end
