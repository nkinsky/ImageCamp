function [ stack_out, info ] = readtiff(file,frames,info)
% [ stack_out, info ] = readtiff(file,frames,info)
%   Detailed explanation goes here

if nargin < 3
    info = imfinfo(file);
end

if nargin < 2
    frames = 1:length(info);
end
nframes = length(frames);

% Use regular imread if file size is small
dim1 = info(1).Height;
dim2 = info(2).Width;
stack_out = nan(dim1,dim2,nframes);
if info(1).FileSize < 4e9
    for j = 1:nframes
        frame_load = frames(j);
        stack_out(:,:,frame_load) = imread(file, 'Info', info, ...
            'Index',frame_load);
    end
end

end

