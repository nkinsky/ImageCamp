%Tristan Ursell
%Read large image stack (TIFF)
%Feb 2017
%
% This function can load image stacks larger than 4GB which is the typical
% limitation image files.  Designed to work with single-channel 
% uncompressed TIFF stacks.  Also works for files smaller than 4GB.
%
% [stack_out,Nframes]= imread_big(stack_name);
%
% stack_name = the path and file name to the image stack
%
% Nframes = number of frames as determined by total file size divided by
% estimated size of each frame data block
%
% stack_out = the output image stack of size [M N Nframes], where M x N is
% the size of each image.
%
% Mar 2018 - Nat Kinsky adjustments to load an arbitrary set of frames

function [stack_out,Nframes] = imread_big(stack_name, frames_load)
% NK add second variable to load subset of frames, and another to silence
% waitbar if desired

%get data block size
info1 = imfinfo(stack_name);
stripOffset = info1(1).StripOffsets;
stripByteCounts = info1(1).StripByteCounts;

%get image size
sz_x=info1(1).Width;
sz_y=info1(1).Height;
if length(info1)<2
    Nframes=floor(info1(1).FileSize/stripByteCounts);
else
    Nframes=length(info1);
end

if nargin < 2
    frames_load = 1:NFrames;
end
nframes_use = length(frames_load);

fID = fopen (stack_name, 'r');

if info1(1).BitDepth==16
    stack_out = zeros([sz_y sz_x nframes_use],'uint16');
else
    stack_out = zeros([sz_y sz_x nframes_use],'uint8');
end

start_point = stripOffset(1) + (0:1:(Nframes-1)).*stripByteCounts;


%% h = waitbar(Nframes);
h = waitbar(length(frames_load));
for i = 1:length(frames_load) %1:Nframes
    %fprintf ('loading image ... %d\n', i);
    frame_use = frames_load(i);
    fseek (fID, start_point(frame_use)+1, 'bof');
    
    if info1(1).BitDepth==16
        A = fread (fID, [sz_x sz_y], 'uint16=>uint16');
    else
        A = fread (fID, [sz_x sz_y], 'uint8=>uint8');
    end
    if isempty(A)
        disp(['Stopping import at frame ' num2str(i-1)]);
        break
    end
    stack_out(:,:,i) = A';
    waitbar(i/length(frames_load),h);
end
close(h)
%%
end