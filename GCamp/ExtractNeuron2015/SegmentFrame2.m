function [frame,cc] = SegmentFrame(frame,toplot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    toplot = 0;
end

inframe = frame;

x = 3;

frame = imopen(frame,strel('disk',2));

if (toplot) figure;subplot(x,x,1);imagesc(frame); title ('input');colormap(gray);end

frame = frame > 4*std(frame(:));

frame = bwareaopen(frame,40,8);

if (toplot) subplot(x,x,2);imagesc(frame); title('small guys removed');end

cc = bwconncomp(frame,8);
labeled = labelmatrix(cc);
rgb_label = label2rgb(labeled,@spring,'c','shuffle');

colormap gray;

if (toplot)
    figure;imshow(rgb_label);
end

