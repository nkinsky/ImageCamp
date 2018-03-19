function [ ] = check_pos( vid_file, xAVI, yAVI, ds )
% check_pos( vid_file, xAVI, yAVI, ds )
%   Takes vid_file and outputs xAVI and yAVI (from Pos.mat) on top of the 
%   mouse's expected position to check motion correction. ds specifies how 
%   much to downsample the data (default = 5). Always speeds up 4x...

%% 
if nargin < 4
    ds = 5;
end

obj = VideoReader(vid_file);
vid_length = round(obj.Duration*obj.FrameRate) - 1;
SRavi = obj.FrameRate;
marker_length = length(xAVI);

[dirstr, fname, ext] = fileparts(vid_file);

%% Start by grabbing only the window you want to
hfig = figure(253);
frame_test = readFrame(obj);
disp('Draw a rectangle around the area you want to include in the check video');
move_on = false;
while ~move_on
    imagesc(flipud(frame_test));
    hrect = imrect(gca);
    lims = hrect.getPosition;
    xlims = [lims(1) lims(1) + lims(3)];
    ylims = [lims(2) lims(2) + lims(4)];
    set(gca,'XLim',xlims,'YLim',ylims)
    move_str = input('Is this zoom ok? (y/n): ','s');
    move_on = strcmpi(move_str,'y');
end

%%

vid_file_out = fullfile(dirstr,[fname '_checkpos' ext]);
obj_out = VideoWriter(vid_file_out);
obj_out.FrameRate = obj.FrameRate/ds*4;
open(obj_out);
frames_to_plot = 1:ds:min([vid_length, marker_length]);

%%
for j = 1:length(frames_to_plot)
    frame_use = frames_to_plot(j);
    obj.CurrentTime = frame_use/SRavi;
    hold off
    imagesc(flipud(readFrame(obj)));
    hold on;
%     hdot = plot(xAVI(frame_use), yAVI(frame_use),'ro');
%     hold on
    hl = plot(xAVI(frames_to_plot(1:j)), yAVI(frames_to_plot(1:j)));
    hl.Color = [0 1 0 0.25];
    hsc = scatter(xAVI(frame_use), yAVI(frame_use));
    set(hsc,'LineWidth',2,'SizeData',100,'MarkerEdgeColor','r')
    set(gca,'XLim',xlims,'YLim',ylims);
    
    F = getframe(gcf);
    writeVideo(obj_out,F);
    
end

%%
close(obj_out);
close(hfig);


end

