function [ output_args ] = browse_mouse_location( AVI, pos_file )
% browse_mouse_location( AVI, pos_file )
%   Unfinished, but intent is to use to check position tracking
%   correction...

PosSR = 30; % native sampling rate in Hz of position data (used only in smoothing)
aviSR = 30.0003; % the framerate that the .avi thinks it's at
imageSR = 20;

load(pos_file);

obj = VideoReader(avi_filepath);
obj.currentTime = framesToCorrect(i*2)/aviSR;
v = readFrame(obj);

end

