function [ ] = plotcirc_pix(h, xc, yc, r)
% plot a circle with radius r & center (xc, yc), using one pixel as the
% step size.  h = figure handle to plot.

% Calculate circle
x = xc-r:1:xc + r;
y1 = yc + sqrt(r^2 - (x - xc).^2);
y2 = yc - sqrt(r^2 - (x - xc).^2);

figure(h)
hold on
plot(x,y1,'r',x,y2,'r')
hold off


end

