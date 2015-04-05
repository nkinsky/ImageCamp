function [ image_exc ] = image_exclude( image, exclude )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

image_exc = zeros(size(image));
image_exc(~exclude) = image(~exclude);

end

