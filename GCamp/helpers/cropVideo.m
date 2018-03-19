function [ ] = cropVideo( vid_file )
% cropVideo( vid_file )
%   Takes an existing video and crops it down to eliminate any extraneous
%   pixels.

[p,f,ext] = fileparts(vid_file);
file_out = fullfile(p,[f '_crop' ext]);
obj = VideoReader(vid_file);
obj_out = VideoWriter(file_out);

%% ID region to crop

frame = readFrame(obj);
obj.CurrentTime = 0;
h = figure; imagesc(frame);

ok = 'n';
while ~strcmpi(ok,'y')
    disp('Drag a rectangle around the region you want to keep');
    imagesc(frame);
    crop_rect = getrect(h);
    crop_rect = round(crop_rect);
    hold on
    rectangle('pos',crop_rect,'EdgeColor','red');
    hold off
    ok = input('Is this ok? (y/n): ','s');
end
close(h)

crop_ind = [crop_rect(1) crop_rect(1)+crop_rect(3); ...
    crop_rect(2) crop_rect(2) + crop_rect(4)];
%%
numFrames = round(obj.Duration*obj.FrameRate);
open(obj_out);

hwb = waitbar(0,'Writing Cropped Video');
for j = 1:numFrames
   frame_in = readFrame(obj);
   frame_crop = frame_in(crop_ind(2,1):crop_ind(2,2),...
       crop_ind(1,1):crop_ind(1,2));
   writeVideo(obj_out,frame_crop);
   waitbar(j/numFrames,hwb);
end

close(obj_out);
close(hwb);


end

