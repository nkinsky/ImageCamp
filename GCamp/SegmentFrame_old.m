function [bw,cc] = SegmentFrame(frame,toplot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    toplot = 0;
end

bg = imopen(frame,strel('disk',15));
frame = frame-bg;
frame = imadjust(frame);
level = graythresh(frame);
bw = im2bw(frame,level);
bw = bwareaopen(bw,100,8);

cc = bwconncomp(bw,8);
labeled = labelmatrix(cc);
rgb_label = label2rgb(labeled,@spring,'c','shuffle');

if (toplot)
    figure;imshow(rgb_label);
end

