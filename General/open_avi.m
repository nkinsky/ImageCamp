function [ ] = open_avi( )
% open_avi()
%   Opens an AVI so that you can scroll through it

[filename, pathname] = uigetfile('*.avi', 'Select AVI file to scroll through: ');
avi_filepath = fullfile(pathname,filename);

h1 = implay(avi_filepath);
disp(['Using ' avi_filepath ])
obj = VideoReader(avi_filepath);


end

