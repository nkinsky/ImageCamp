% Get points for arena arena and set up interpolation...

close all

dropbox_path = 'C:\Users\Nat\Dropbox\'; % Home

% arena_eff_length = 8; % for the arena

[filename, pathname] = uigetfile('*.avi','Select the AVI file to use:');

arena_avi = [pathname filename];

arena_avi_obj = VideoReader(arena_avi);

pFrame = readFrame(arena_avi_obj);

figure
imagesc(flipud(pFrame))

disp('zoom')
keyboard
disp('Click on all the grid intersections, bottom-to-top, -to-right, including the edges. Right click to finish')

[xgrid_avi, ygrid_avi] = getpts();

%% Shift to zero


xreal = [NaN NaN 0 0 0 0 NaN NaN; NaN 1.5 1.5 1.5 1.5 1.5 1.5 NaN; ...
    3 3 3 3 3 3 3 3; 4.5 4.5 4.5 4.5 4.5 4.5 4.5 4.5 ; 6 6 6 6 6 6 6 6 ; ...
    7.5 7.5 7.5 7.5 7.5 7.5 7.5 7.5; NaN 9 9 9 9 9 9 NaN ; ...
    NaN NaN 10.5 10.5 10.5 10.5 NaN NaN ];
    % 
% xreal = repmat([0 2.5 5 7.5 10],5,1); % square
% yreal= flipud(repmat([0 2.5 5 7.5 10]',1,5)); % square

x_orig = xgrid_avi - min(xgrid_avi);
y_orig = ygrid_avi - min(ygrid_avi);

figure
plot(x_orig,y_orig,'b*')

% save arena_coords x_orig y_orig xgrid_avi ygrid_avi

%% Define grids

ind = [1:5 ; 6:10; 11:15; 16:20; 21:25]';

[x_grid, y_grid] = deal_grid(x_orig, y_orig, ind);

[x_grid_avi, y_grid_avi] = deal_grid(xgrid_avi, ygrid_avi, ind);

x_edges = mean(x_grid,1);
y_edges = mean(y_grid,2);

figure
hold on
plot_occupancy_grid([],[],x_edges - min(x_edges),y_edges - min(y_edges),1,'r'); 
hold off

x_diff = abs(diff(x_edges));
y_diff = abs(diff(y_edges));

xl = mean(x_diff); yl = mean(y_diff);

xvar_l = var(x_diff); yvar_l = var(y_diff);

%% Fit lm to data (corrected back to origin)
modelspec = 'quadratic';

lm_x = fitlm(x_grid(:), xreal(:), modelspec);
lm_y = fitlm(y_grid(:), yreal(:), modelspec);

xscale = lm_x.Coefficients.Estimate(2);
yscale = lm_y.Coefficients.Estimate(2);

%% Fit lm directly to AVI coordinate data

lm_x_avi = fitlm(x_grid_avi(:), xreal(:), modelspec);
lm_y_avi = fitlm(y_grid_avi(:), yreal(:), modelspec);

%% Test linear models by plotting all the grid cross-sections and comparing to real values!

figure
plot(xreal(:),yreal(:),'k+',...
    predict(lm_x, x_grid(:)), predict(lm_y,y_grid(:)),'r.')
legend('Real',' Adjusted')

figure
plot(xreal(:),yreal(:),'k+',...
    predict(lm_x_avi, x_grid_avi(:)), predict(lm_y_avi,y_grid_avi(:)),'r.')
legend('Real',' Adjusted')

% Do the same thing as above but for edges and see how good it looks.

figure
subplot(2,2,1)
hold on
plot_occupancy_grid([],[],predict(lm_x, x_edges'),predict(lm_y,y_edges) ,1,'r'); 
hold off

subplot(2,2,2)
hold on
plot_occupancy_grid([],[],x_edges - min(x_edges),y_edges - min(y_edges),1,'k'); 
hold off

%% Put lm info into structure array to save
[pos_corr(1:3).arena] = deal('arena');
pos_corr(1).location = '';
[pos_corr.orientation] = deal('normal');

pos_corr(1).lm_x = lm_x_avi;
pos_corr(1).lm_y = lm_y_avi;

% save arena_distortion_correction pos_corr

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

