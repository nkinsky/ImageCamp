function [ std_frame, var_frame ] = make_std_frame( h5file, mean_frame, frames )
%[ std_frame, var_frame ] = make_std_frame( h5file, mean_frame, frames )
%   Detailed explanation goes here

if length(frames) <= 1000
    all_frames = loadframe(h5file,frames);
    
    var_frame = sum((all_frames-mean_frame).^2,3)/length(frames);
    std_frame = sqrt(var_frame);
elseif length(frames) > 1000 % Go through and load 1000 frames at a time, get mean and variance, then sum them up and divide later.
    
    % Pre-allocate
    frame1 = loadframe(h5file,frames(1));
    [num_rows,num_cols] = size(frame1);
    varsum_frames = zeros(num_rows,num_cols);
    
    % Start summing up.
    num_groups = ceil(length(frames)/1000);
    for j = 1:num_groups - 1
       frames_to_load = frames((j-1)*1000+1:j*1000);
       temp = loadframe(h5file,frames_to_load);
       temp = sum((double(temp)-repmat(mean_frame,1,1,1000)).^2,3);
       varsum_frames = varsum_frames + temp;
    end
    
    % Now sum last segment
    frames_to_load = frames((num_groups - 1)*1000:end);
    temp = loadframe(h5file,frames_to_load);
    temp = sum((double(temp)-repmat(mean_frame,1,1,length(frames_to_load))).^2,3);
    varsum_frames = varsum_frames + temp;
    
    var_frame = varsum_frames/length(frames);
    std_frame = sqrt(var_frame);


end

