function [ ] = plot_arena_rot(avi_path, rot_angle, h)
%plot_arena_rot(avi_path, rot_angle, h)
%   Take and AVI and plot it on axes h (or gca if left blank).  rot_angle =
%   90, 180, -90 and is the amount you want to rotate the image.

if ~exist('h','var')
    h = gca;
end

k = rot_angle/90;

obj = VideoReader(avi_path);
axes(h)
imagesc(flipud(rot90(readFrame(obj),k))); 


end

