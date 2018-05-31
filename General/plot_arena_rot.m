function [ ] = plot_arena_rot(avi_path, rot_angle, h)
%plot_arena_rot(avi_path, rot_angle, h)
%   Take and AVI and plot it on axes h (or gca if left blank).  rot_angle =
%   90, 180, -90 and is the amount you want to rotate the image. avi_path
%   can either be the path to the AVI file or the folder containing the avi
%   file.

if ~exist('h','var')
    h = gca;
end

% Get file path if only the folder is specified
if isdir(avi_path)
    curr_dir = cd;
    cd(avi_path);
    avi_filename = ls('*.avi');
    avi_path = [avi_path '\' avi_filename];
    cd(curr_dir)
end

k = rot_angle/90;

obj = VideoReader(avi_path);
axes(h)
% imagesc(flipud(rot90(readFrame(obj),k))); 
% imagesc(rot90(readFrame(obj),k)); 
imagesc(rot90(flipud(readFrame(obj)),k));
set(h,'YDir','normal')

end

