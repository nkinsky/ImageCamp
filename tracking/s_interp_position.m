% Get points for square arena and set up interpolation...

close all


dropbox_path = 'C:\Users\Nat\Dropbox\'; % Home

arena_eff_length = 8; % for the square

square_left_avi = [ dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\2env_cal_square_left.AVI'];
square_mid_avi = [ dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\2env_cal_square_mid.AVI'];
square_right_avi = [ dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\2env_cal_square_right.AVI'];

square_left_avi_obj = VideoReader(square_left_avi);
square_mid_avi_obj = VideoReader(square_mid_avi);
square_right_avi_obj = VideoReader(square_right_avi);

pFrame = readFrame(square_left_avi_obj);

figure
imagesc(flipud(pFrame))

disp('zoom')
keyboard
disp('Click on all the grid intersections, bottom-to-top, left-to-right, including the edges. Right click to finish')

[xgrid_left_avi, ygrid_left_avi] = getpts();

pFrame2 = readFrame(square_right_avi_obj);
imagesc(flipud(pFrame2))

disp('zoom')
keyboard
disp('Click on all the grid intersections, bottom-to-top, left-to-right, including the edges. Right click to finish')

[xgrid_right_avi, ygrid_right_avi] = getpts();

pFrame3 = readFrame(flipud(square_mid_avi_obj));

imagesc(flipud(pFrame3))

disp('zoom')
keyboard
disp('Click on all the grid intersections, bottom-to-top, left-to-right, including the edges. Right click to finish')

[xgrid_mid_avi, ygrid_mid_avi] = getpts();

%% Shift to zero

xreal = repmat([0 2.5 5 7.5 10],5,1);
yreal= flipud(repmat([0 2.5 5 7.5 10]',1,5));

xleft_orig = xgrid_left_avi - min(xgrid_left_avi);
yleft_orig = ygrid_left_avi - min(ygrid_left_avi);

xright_orig = xgrid_right_avi - min(xgrid_right_avi);
yright_orig = ygrid_right_avi - min(ygrid_right_avi);

xmid_orig = xgrid_mid_avi - min(xgrid_mid_avi);
ymid_orig = ygrid_mid_avi - min(ygrid_mid_avi);

figure
plot(xleft_orig,yleft_orig,'b*',xright_orig,yright_orig,'rd',...
    xmid_orig,ymid_orig,'bo')
legend('Left','Right','Mid')

save square_coords xleft_orig yleft_orig xmid_orig ymid_orig xright_orig...
    yright_orig xgrid_left_avi ygrid_left_avi xgrid_mid_avi ygrid_mid_avi ...
    xgrid_right_avi ygrid_right_avi


%% Define grids

ind = [1:5 ; 6:10; 11:15; 16:20; 21:25]';

[xleft_grid, yleft_grid] = deal_grid(xleft_orig, yleft_orig, ind);
[xmid_grid, ymid_grid] = deal_grid(xmid_orig, ymid_orig, ind);
[xright_grid, yright_grid] = deal_grid(xright_orig, yright_orig, ind);

[xleft_grid_avi, yleft_grid_avi] = deal_grid(xgrid_left_avi, ygrid_left_avi, ind);
[xmid_grid_avi, ymid_grid_avi] = deal_grid(xgrid_mid_avi, ygrid_mid_avi, ind);
[xright_grid_avi, yright_grid_avi] = deal_grid(xgrid_right_avi, ygrid_right_avi, ind);

xleft_edges = mean(xleft_grid,1);
yleft_edges = mean(yleft_grid,2);

xmid_edges = mean(xmid_grid,1);
ymid_edges = mean(ymid_grid,2);

xright_edges = mean(xright_grid,1);
yright_edges = mean(yright_grid,2);

figure
hold on
plot_occupancy_grid([],[],xleft_edges - min(xleft_edges),yleft_edges - min(yleft_edges),1,'r'); 
plot_occupancy_grid([],[],xmid_edges - min(xmid_edges) ,ymid_edges - min(ymid_edges),1,'g');
plot_occupancy_grid([],[],xright_edges - min(xright_edges),yright_edges - min(yright_edges),1,'b');
hold off

xleft_diff = abs(diff(xleft_edges));
yleft_diff = abs(diff(yleft_edges));

xmid_diff = abs(diff(xmid_edges));
ymid_diff = abs(diff(ymid_edges));

xright_diff = abs(diff(xright_edges));
yright_diff = abs(diff(yright_edges));

xl = mean(xleft_diff); yl = mean(yleft_diff);
xm = mean(xmid_diff); ym = mean(ymid_diff);
xr = mean(xright_diff); yr = mean(yright_diff);

xvar_l = var(xleft_diff); yvar_l = var(yleft_diff);
xvar_m = var(xmid_diff); yvar_m = var(ymid_diff);
xvar_r = var(xright_diff); yvar_r = var(yright_diff);

%% Fit lm to data (corrected back to origin)
modelspec = 'quadratic';

lm_xleft = fitlm(xleft_grid(:), xreal(:), modelspec);
lm_yleft = fitlm(yleft_grid(:), yreal(:), modelspec);

lm_xmid = fitlm(xmid_grid(:),xreal(:), modelspec);
lm_ymid = fitlm(ymid_grid(:),yreal(:), modelspec);

lm_xright = fitlm(xright_grid(:),xreal(:), modelspec);
lm_yright = fitlm(yright_grid(:),yreal(:), modelspec);

xscale_left = lm_xleft.Coefficients.Estimate(2);
yscale_left = lm_yleft.Coefficients.Estimate(2);

xscale_mid = lm_xmid.Coefficients.Estimate(2);
yscale_mid = lm_ymid.Coefficients.Estimate(2);

xscale_right = lm_xright.Coefficients.Estimate(2);
yscale_right = lm_yright.Coefficients.Estimate(2);

%% Fit lm directly to AVI coordinate data

lm_xleft_avi = fitlm(xleft_grid_avi(:), xreal(:), modelspec);
lm_yleft_avi = fitlm(yleft_grid_avi(:), yreal(:), modelspec);

lm_xmid_avi = fitlm(xmid_grid_avi(:),xreal(:), modelspec);
lm_ymid_avi = fitlm(ymid_grid_avi(:),yreal(:), modelspec);

lm_xright_avi = fitlm(xright_grid_avi(:),xreal(:), modelspec);
lm_yright_avi = fitlm(yright_grid_avi(:),yreal(:), modelspec);


%% Test linear models by plotting all the grid cross-sections and comparing to real values!

figure
plot(xreal(:),yreal(:),'k+',...
    predict(lm_xleft, xleft_grid(:)), predict(lm_yleft,yleft_grid(:)),'r.',...
    predict(lm_xmid, xmid_grid(:)), predict(lm_ymid,ymid_grid(:)),'gd',...
    predict(lm_xright, xright_grid(:)), predict(lm_yright,yright_grid(:)),'b*');
legend('Real','Left Adjusted', 'Mid Adjusted', 'Right Adjusted')

figure
plot(xreal(:),yreal(:),'k+',...
    predict(lm_xleft_avi, xleft_grid_avi(:)), predict(lm_yleft_avi,yleft_grid_avi(:)),'r.',...
    predict(lm_xmid_avi, xmid_grid_avi(:)), predict(lm_ymid_avi,ymid_grid_avi(:)),'gd',...
    predict(lm_xright_avi, xright_grid_avi(:)), predict(lm_yright_avi,yright_grid_avi(:)),'b*');
legend('Real','Left Adjusted', 'Mid Adjusted', 'Right Adjusted')

% Do the same thing as above but for edges and see how good it looks.

figure
subplot(2,2,1)
hold on
plot_occupancy_grid([],[],predict(lm_xleft, xleft_edges'),predict(lm_yleft,yleft_edges) ,1,'r'); 
plot_occupancy_grid([],[],predict(lm_xmid, xmid_edges'),predict(lm_ymid,ymid_edges) ,1,'g'); 
plot_occupancy_grid([],[],predict(lm_xleft, xleft_edges'),predict(lm_yleft,yleft_edges) ,1,'b'); 
hold off

subplot(2,2,2)
hold on
plot_occupancy_grid([],[],xleft_edges - min(xleft_edges),yleft_edges - min(yleft_edges),1,'k'); 
plot_occupancy_grid([],[],xmid_edges - min(xmid_edges) ,ymid_edges - min(ymid_edges),1,'c');
plot_occupancy_grid([],[],xright_edges - min(xright_edges),yright_edges - min(yright_edges),1,'y');
hold off

%% Put lm info into structure array to save
[pos_corr(1:3).arena] = deal('square');
pos_corr(1).location = 'left';
pos_corr(2).location = 'mid';
pos_corr(3).location = 'right';
[pos_corr.orientation] = deal('normal');

pos_corr(1).lm_x = lm_xleft_avi;
pos_corr(1).lm_y = lm_yleft_avi;

pos_corr(2).lm_x = lm_xmid_avi;
pos_corr(2).lm_y = lm_ymid_avi;

pos_corr(3).lm_x = lm_xright_avi;
pos_corr(3).lm_y = lm_yright_avi;

save arena_distortion_correction pos_corr

%% Work flow for reverse_placefields

% 0) Run the below on data in qc_arena align to see if you can get it
% working properly!

% 1) Get conversion from avi coordinates or dvt coordinates to undistorted
% coordinates via above which range from 0 to 10.  Send any coordinates
% measured outside of these edges back to the neares valid point.

% 2) if rotated, rotate back appropriately.

% 3) Do your thang!

% *) Slightly better method will be to draw a finer grid, find the two
% nearest neighbors between the two points, and then interpolate between
% them.  Worth it?  Probably not

% ***) Note that eventually this will need to be folded into all position
% calculations BEFORE any smoothing or runs through velocity happen.  For
% now, though, it is probably ok to just do this part afterward

