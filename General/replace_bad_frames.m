function [] = replace_bad_frames(infile,outfile,bad_frames,replace_frames)
% replace_bad_frames(infile,outfile,bad_frames,replace_frames)
%
% Replaces bad_frames in infile with the frame(s) specified in
% replace_frames. replace_frames is either one frame or an array of frame
% indices that matches the length of bad_frames.  If it is just one frame,
% that frame will replace all the bad frames.

tic
info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

if length(bad_frames) ~= length(replace_frames)
    % If only one frame is entered, deal it out to every index in
    % replace_frames
    replace_frames(1:length(bad_frames)) = replace_frames;
end

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','uint16');

p = ProgressBar(NumFrames);
for i = 1:NumFrames
    
    if sum(i == bad_frames) > 0
        replace_ind = (i == bad_frames); % get index of bad frame to replace
        F{i} = h5read(infile,'/Object',[1 1 replace_frames(replace_ind) 1],[XDim YDim 1 1]);
        h5write(outfile,'/Object',uint16(F{i}),[1 1 i 1],[XDim YDim 1 1]);
    else
        F{i} = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]);
        h5write(outfile,'/Object',uint16(F{i}),[1 1 i 1],[XDim YDim 1 1]);
    end
    p.progress;

end
p.stop;

toc
end
