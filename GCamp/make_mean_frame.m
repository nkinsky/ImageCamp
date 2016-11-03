function [ mean_frame] = make_mean_frame( h5file, frames )
% mean_frame = make_mean_frame( h5file, frames )
%   Detailed explanation goes here

if length(frames) <= 1000
    all_frames = loadframe(h5file,frames);
    
    mean_frame = mean(all_frames, 3);
elseif length(frames) > 1000 % Go through and load 1000 frames at a time, get mean and variance, then sum them up and divide later.
    
    % Pre-allocate
    frame1 = loadframe(h5file,frames(1));
    [num_rows,num_cols] = size(frame1);
    sum_frames = zeros(num_rows,num_cols);
    
    % Start summing up.
    num_groups = ceil(length(frames)/1000);
    for j = 1:num_groups - 1
       frames_to_load = frames((j-1)*1000+1:j*1000);
       temp = loadframe(h5file,frames_to_load);
       sum_frames = sum_frames + sum(temp,3);
    end
    
    % Now sum last segment
    frames_to_load = frames((num_groups - 1)*1000:end);
    temp = loadframe(h5file,frames_to_load);
    sum_frames = sum_frames + sum(temp,3);
    
    mean_frame = sum_frames/length(frames);
end


end

