function [ ] = compare_arena( folder1, folder2)
% compare_arena( folder1, folder2)
%   Quickly plot out a screenshot of both arenas to QC their relative
%   rotations, if any

if nargin == 0
    sesh(1).path = uigetdir('','Select the first session working directory');
    sesh(2).path = uigetdir(sesh(1).path,'Select the second session working directory');
elseif nargin == 2
    sesh(1).path = folder1;
    sesh(2).path = folder2;
end

figure
for j = 1:2
   cd(sesh(j).path);
   avi_file = ls('*.avi');
   obj = VideoReader([sesh(j).path '\' avi_file]);
   pFrame = readFrame(obj);
   subplot(1,2,j)
   imagesc(pFrame);
   title(['Session ' num2str(j)])
   
end


end

