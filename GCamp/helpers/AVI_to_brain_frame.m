function [ brainframes_out ] = AVI_to_brain_frame(AVIframes_in, AVItime_interp)
% AVIframes_out = AVI_to_brain_frame(AVIframes_in, AVItime_interp)
%   Converts AVI frame numbers into brain imaging frames based on
%   AVItime_interp.

SRavi = 30.0003; % AVI frame rate
AVItime_in = AVIframes_in/SRavi; % Convert AVI frames to AVI time

brainframes_out = arrayfun(@(a) findclosest(a,AVItime_interp),AVItime_in);

end

