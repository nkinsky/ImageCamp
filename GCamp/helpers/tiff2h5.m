function [ ] = tiff2h5(tiffmovie)
% tiff2h5(tiffmovie)
%   takes a tiff and writes an h5 file of the same name in the same
%   directory

[path, name, ~] = fileparts(tiffmovie);
h5movie = fullfile(path,[name '.h5']);
tstack = TIFFStack(tiffmovie);
[Xdim, Ydim, NumFrames] = size(tstack);
h5create(h5movie,'/Object',[Xdim, Ydim, NumFrames, 1], 'ChunkSize',...
    [Xdim, Ydim, 1, 1], 'Datatype','single');

FrameChunkSize = min([1250 NumFrames]);
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

for i = 1:NumChunks
    FrameList = ChunkStarts(i):ChunkEnds(i);
    FrameChunk = tstack(:,:,FrameList);
    h5write(h5movie,'/Object',FrameChunk,[1 1 ChunkStarts(i) 1],...          
            [Xdim Ydim length(FrameList) 1]);
end

end

