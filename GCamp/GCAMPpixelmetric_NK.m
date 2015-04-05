%Kinsky Lab - Function to Convert Pixels to Centimeters
function [pixmetRATIO, varargout] = GCAMPpixelmetric(file, varargin)
%{
Function Format
GCAMPpixelmetric will take the Cineplex DVT file in sting format and give
a vector for the ratio of x cm/pixel and y cm/pixel.

You may use one additional input as the percent cutoff used to remove
largest x,y values. If no input is passed, 5% will be used.

By calling to outputs, you may also choose to receive the metricMAT, the DVT matrix with where x,y
columns correspond to cm values.
%}

profile on

n = nargin;
percent = 0.05;
if n == 2
    percent = varargin{1}/100;
elseif n > 2
    disp('ERROR: You are not using this function correctly. Please review viable input arguments.')
end

%Open
file = load(file);

%remove x,y zeros
xPIXnozero = ne(0,file(:,3));
yPIXnozero = ne(0,file(:,4));
nonzeroMAT = file(xPIXnozero + yPIXnozero == 2,:);

% NK edit - get array of usable x and y values
x_use = file(xPIXnozero,3);
y_use = file(xPIXnozero,4);

%remove percent% of largest and smallest x,y values
% avgXY = [mean([mean(nonzeroMAT(:,3)),...
%                median(nonzeroMAT(:,3)),...
%                mode(nonzeroMAT(:,3))]);
%          mean([mean(nonzeroMAT(:,4)),...
%                median(nonzeroMAT(:,4)),...
%                mode(nonzeroMAT(:,4))])];
           
% xPIXremove = le(percent*avgXY(1),nonzeroMAT(:,3)) & ge((1-percent)*avgXY(1),nonzeroMAT(:,3));
% yPIXremove = le(percent*avgXY(2),nonzeroMAT(:,4)) & ge((1-percent)*avgXY(2),nonzeroMAT(:,4));

% NK edits to above
% Get empirical cdf of pixel occupancy
[f_x, xe_x] = ecdf(x_use);
[f_y, xe_y] = ecdf(y_use);
% Find limits, cutting bottom percent/2 and top percent/2 of pixels out.
xpix_lim(1) = xe_x(find(f_x > percent/2, 1 ));
xpix_lim(2) = xe_x(find(f_x < (1 - percent/2), 1, 'last' ));
ypix_lim(1) = xe_y(find(f_y > percent/2, 1 ));
ypix_lim(2) = xe_y(find(f_y < (1 - percent/2), 1, 'last' ));

xdist = xpix_lim(2) - xpix_lim(1);
ydist = ypix_lim(2) - ypix_lim(1);

xPIXremove = ge(x_use,xpix_lim(1)) & le(x_use,xpix_lim(2));
yPIXremove = ge(y_use,ypix_lim(1)) & le(y_use,ypix_lim(2));

petitePIXMAT = nonzeroMAT(xPIXremove + yPIXremove == 2,:);
%Convert to Metrics
    %Maze = [ x-width, y-length, z-height], units in cm
    alternationV3 = [64.1, 29.2, 126.5];
[mm,~] = size(petitePIXMAT);
metricMAT =  petitePIXMAT - repmat([0 0 min(petitePIXMAT(:,3)) min(petitePIXMAT(:,4)) 0], mm, 1);
pixmetRATIO = [alternationV3(1)/max(metricMAT(:,3)) alternationV3(2)/max(metricMAT(:,4))];
metricMAT(:,3) = pixmetRATIO(1) * metricMAT(:,3);
metricMAT(:,4) = pixmetRATIO(2) * metricMAT(:,4);

% NK edits to above
pixmetRATIO_check = [alternationV3(1)/xdist alternationV3(2)/ydist];

if nargout == 2
    varargout{2} = metricMAT;
elseif nargout > 2
    disp('ERROR: You are not using this function correctly. Please review viable output arguments.')
end

profile viewer


% figure
% plot( nonzeroMAT(:, 3), nonzeroMAT(:, 4))
% figure
% plot( petitePIXMAT(:, 3), petitePIXMAT(:, 4))
% figure
% plot( metricMAT(:, 3), metricMAT(:, 4))
% 
% 
% figure
% hist(nonzeroMAT(:, 3), max(nonzeroMAT(:,3)))
% figure
% hist(petitePIXMAT(:, 3), max(petitePIXMAT(:,3)))
% figure
% hist(metricMAT(:, 3), max(metricMAT(:,3)))
% 
% figure
% hist(nonzeroMAT(:, 4), max(nonzeroMAT(:,4)))
% figure
% hist(petitePIXMAT(:, 4), max(petitePIXMAT(:,4)))
% figure
% hist(metricMAT(:, 4), max(metricMAT(:,4)))

keyboard
end