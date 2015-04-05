function [ jumps ] = findjumps( x, y, pix2cm )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Fill in best guess for pix2cm if left blank
if nargin == 2
pix2cm = 0.15;
disp('pix2cm left blank.  0.15 assumed')
end

h1 = figure;
plot(x,y)

disp('Click to define outer limits of arena.  Right click to finish')
[ x_outer, y_outer ] = getpts(h1);

inner = input('Do you wish to add an inner area limit? (y/n): ','s');
j = 1;
while strcmpi(inner,'y')
    disp('Click to define inner limits of arena.  Right click to finish')
    [x_inner{j} y_inner{j}] = getpts(h1);
    j = j + 1;
    inner = input('Do you wish to add another inner area limit? (y/n): ','s');
end

keyboard

dist_raw = zeros(size(x,1)-1,1);
vel = zeros(size(x,1)-1,1);
for k = 1:size(x,1)-1
   dist_raw(k) = sqrt((x(k+1)-x(k))^2 + (y(k+1) - y(k))^2)*pix2cm;
   vel(k) = dist_raw(k)/(1/20);
end


end

