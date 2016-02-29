function [ ] = h5_dispframe(infile,frame)
% h5_dispframe(infile,frame)
%   Quickly display a frame from the desired h5 file noted in 'infile'

info = h5info(infile,'/Object');
% NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

frame = h5read(infile,'/Object',[1 1 frame 1],[XDim YDim 1 1]);
imagesc(frame);
colormap(gray);

end

