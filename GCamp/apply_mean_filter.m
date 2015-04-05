function [] = apply_mean_filter( image_file,size )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


A = imread(image_file);
A = im2double(A);
fun = @(x) mean(x(:));
B = nlfilter(A,[size size],fun);

figure
subplot(1,3,1)
imagesc(A); colormap(gray);
subplot(1,3,2)
imagesc(B); colormap(gray)

end

