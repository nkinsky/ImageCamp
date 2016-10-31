function [ mean_frame ] = make_mean_frame( h5file, frames )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

all_frames = loadframe(h5file,frames);

mean_frame = mean(all_frames, 3);

end

