% Test import of CinePlex file

clear all
close all

uiimport = 0; % 0 = hardcoded input, 1 = import through GUI

if uiimport == 0
% configfile = importdata('C:\Users\kinsky.AD\Documents\Imaging\Videos\CinePlex\nat_mfp5.txt');
dvt_file = importdata('C:\Users\kinsky.AD\Documents\Imaging\Videos\CinePlex\2014JAN27_S04_square.dvt'); % 2014JAN27_S04_square.dvt

elseif uiimport == 1
% UI Import
[ filename pathname ] = uigetfile('*.dvt','Select DVT file for import');
dvt_file = importdata([pathname filename]);

end

frame = dvt_file(:,1);
time = dvt_file(:,2);
Xpix = dvt_file(:,3);
Ypix = dvt_file(:,4);
if size(dvt_file,2) == 5
motion = dvt_file(:,5);
end

frame_rate = 30; % Frame rate from CinePlex, frames/sec

pix_calibration = 639/1025; %Conversion from DVT coordinates to pixels

% Discard zeros - is this necessary?  How can I avoid this?
keep_index = Xpix > 0 & Ypix > 0;
Xpix = Xpix(keep_index);
Ypix = Ypix(keep_index);
frame = frame(keep_index);
time = time(keep_index);
if exist('motion','var')
    motion = motion(keep_index);
end

Xpix = pix_calibration*Xpix;
Ypix = pix_calibration*Ypix;

%% Code to figure out arena extents for square arena %%
side_length = 25.4; % square arena size in centimeters
min_cutoff = 0.05; max_cutoff = 0.95;

[f_x x_x] = ecdf(Xpix);
[f_y x_y] = ecdf(Ypix);

xpix_index_min = max(find(f_x<=min_cutoff));
xpix_index_max = min(find(f_x>=max_cutoff));
ypix_index_min = max(find(f_y<=min_cutoff));
ypix_index_max = min(find(f_y>=max_cutoff));

Xspan_square = x_x(xpix_index_max) - x_x(xpix_index_min);
Yspan_square = x_y(ypix_index_max) - x_y(ypix_index_min);
side_pix = mean([Xspan_square Yspan_square]);

pix_to_cm = side_length/side_pix; % Conversion from pixels to cm... Shouldn't the numerator be the length of the arena???

figure
plot(Xpix,Ypix); xlabel('Pixels'); ylabel('Pixels'); title('Raw Pixel Plot') 

figure
subplot(1,2,1); hist(Xpix,30); title('Raw X pixel histogram');
subplot(1,2,2); hist(Ypix,30); title('Raw Y pixel histogram');


% Xpix_max = max(Xpix); Xpix_min = min(Xpix(Xpix > 0));
% Ypix_max = max(Ypix); Ypix_min = min(Ypix(Xpix > 0));
% 
% Xpix_dist = Xpix_max - Xpix_min;
% Ypix_dist = Ypix_max - Ypix_min;


Xcm = Xpix*pix_to_cm;
Ycm = Ypix*pix_to_cm;

%% Calculate Speed Data using basic derivatives and boxcar averages...

smooth_window = 5; % number of frames over which to smooth
distance = (diff(Xcm).^2 + diff(Ycm).^2).^0.5;
speed = distance./diff(time);
speed_smooth = smooth(speed,smooth_window);

distance_smooth = smooth(distance,smooth_window);
distance_smooth = distance_smooth(smooth_window:end);
time_interval_smooth = time - circshift(time,smooth_window);
time_interval_smooth = time_interval_smooth(smooth_window+1:end); 
speed_smooth2 = distance_smooth./time_interval_smooth;

%% Use Kalman filter to get velocity data %%

[tk, xk, yk, vxk, yxk, axk, ayk] = KalmanVel_sam(Xcm, Ycm, time, 2);
speed_k = sqrt(vxk.^2 + axk.^2);


% Freezing analysis

threshold = 0.6 ; % Freezing speed threshold, cm/s (From Wang et al. 2012)
motion_thresh = 1; % Motion threshold for freezing...

freeze_index = (speed <= motion_thresh);
freeze_index_smooth = (speed_smooth <= motion_thresh);
freeze_index_smooth2 = (speed_smooth2 <= motion_thresh);
time_plot = time(1:end-1);
time_smooth2_plot = time(smooth_window+1:end);

freeze_index_k = speed_k <= motion_thresh;

% How to get actual freezing time...
freeze_time_diff = diff(time_plot(freeze_index));
total_freeze_time = sum(freeze_time_diff(freeze_time_diff < 1.1/frame_rate));

freeze_time_smooth_diff = diff(time_plot(freeze_index_smooth));
total_freeze_time_smooth = sum(freeze_time_smooth_diff(freeze_time_smooth_diff < 1.1/frame_rate));

freeze_time_smooth2_diff = diff(time_smooth2_plot(freeze_index_smooth2));
total_freeze_time_smooth2 = sum(freeze_time_smooth2_diff(freeze_time_smooth2_diff < 1.1/frame_rate));

freeze_time_k_diff = diff(time(freeze_index_k));
total_freeze_time_k = sum(freeze_time_k_diff(freeze_time_k_diff < 1.1/frame_rate));

figure
subplot(3,1,1); plot(time(1:end-1), speed,time_plot(freeze_index),speed(freeze_index),'r.'); 
xlabel('Time (s)'); ylabel('Speed(cm/s)');
subplot(3,1,2); plot(time(1:end-1), speed_smooth,time_plot(freeze_index_smooth),speed_smooth(freeze_index_smooth),'r.'); 
xlabel('Time (s)'); ylabel('Speed(cm/s)');
subplot(3,1,3); plot(time_smooth2_plot, speed_smooth2,time_smooth2_plot(freeze_index_smooth2),speed_smooth2(freeze_index_smooth2),'r.'); 
xlabel('Time (s)'); ylabel('Speed(cm/s)');

figure
subplot(3,1,1); plot(time(1:end-1), speed_smooth,time_plot(freeze_index_smooth),speed_smooth(freeze_index_smooth),'r.'); 
xlabel('Time (s)'); ylabel('Speed(cm/s)'); title('Speed Smooth')
subplot(3,1,2); plot(time, speed_k, 'b', time(freeze_index_k), speed_k(freeze_index_k), 'r.')
xlabel('Time (s)'); ylabel('Speed(cm/s)'); title('KL Speed')
subplot(3,1,3); plot(time(1:end-1), speed_smooth,'b',...
    time_plot(freeze_index_smooth),speed_smooth(freeze_index_smooth),'r.',...
    time, speed_k, 'b--', time(freeze_index_k), speed_k(freeze_index_k), 'g.');
xlabel('Time (s)'); ylabel('Speed(cm/s)');
legend('Speed Smooth','Speed Smooth','Speed KL','Speed KL');



figure
plot(Xcm,Ycm); xlabel('Xpos (cm)'); ylabel('Ypos (cm)');

figure
subplot(3,1,1); hist(speed,30); title('Speed Histogram')
subplot(3,1,2); hist(speed_smooth,30); title('Smoothed Speed Histogram');
subplot(3,1,3); hist(speed_smooth2,30); title('Smoothed Speed2 Histogram')