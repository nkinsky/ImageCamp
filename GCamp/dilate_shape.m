function [ xnew, ynew ] = dilate_shape(x,y,delta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xm = mean(x);
ym = mean(y);

for j = 1:length(x)
    
   dx = x(j) - xm;
   dy = y(j) - ym;
   theta = atan2(dy,dx);
   r = sqrt(dx^2+dy^2);
   
   xnew(j) = xm + (r + delta)*cos(theta);
   ynew(j) = ym + (r + delta)*sin(theta);
   
end


end

