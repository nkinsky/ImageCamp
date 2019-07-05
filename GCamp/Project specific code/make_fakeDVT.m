function [ ] = make_fakeDVT( vidfilename )
% make_fakeDVT( vidfilename )
%   Makes a fake DVT file for using with ff_video_fixer in python

[~, base_name] = fileparts(vidfilename);
vidobj = VideoReader(vidfilename);
num_frames = vidobj.Duration*vidobj.FrameRate;
fakeDVT = zeros(num_frames, 5);
fakeDVT(1:num_frames,1) = 1:num_frames;
fakeDVT(1:num_frames,2) = (1:num_frames)/vidobj.FrameRate;

csvwrite([base_name '.DVT'],fakeDVT);

end

