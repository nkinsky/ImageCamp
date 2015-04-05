function [freeze_ratio_k, avg_speed_k ] = freezing_f( filepath, frame_rate, threshold, pix_to_cm, plot_flag  )
%freezing_f Analysis of freezing behavior for fear conditioning
% INPUTS
%   filepath:       full pathname to DVT file to be analyzed
%   frame_rate:     in frames per second
%   theshold:       motion threshold (cm/s) below which an animal is
%                   considered to be freezing
%   

% Import DVT file info
dvt_file = importdata(filepath);

frame = dvt_file(:,1);
time = dvt_file(:,2);
Xpix = dvt_file(:,3);
Ypix = dvt_file(:,4);
if size(dvt_file,2) == 5
motion = dvt_file(:,5);
end

pix_calibration = 639/1023; %Conversion from DVT coordinates to pixels

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

Xcm = Xpix*pix_to_cm;
Ycm = Ypix*pix_to_cm;

%% Code to figure out arena extents for square arena %%
% % Not necessary with calibration already calculated
% min_cutoff = 0.05; max_cutoff = 0.95;
% 
% [f_x x_x] = ecdf(Xpix);
% [f_y x_y] = ecdf(Ypix);
% 
% xpix_index_min = max(find(f_x<=min_cutoff));
% xpix_index_max = min(find(f_x>=max_cutoff));
% ypix_index_min = max(find(f_y<=min_cutoff));
% ypix_index_max = min(find(f_y>=max_cutoff));
% 
% Xspan_square = x_x(xpix_index_max) - x_x(xpix_index_min);
% Yspan_square = x_y(ypix_index_max) - x_y(ypix_index_min);
% side_pix = mean([Xspan_square Yspan_square]);
% 
% pix_to_cm = side_length/side_pix; % Conversion from pixels to cm... Shouldn't the numerator be the length of the arena???
% 
if plot_flag == 1
    
    figure
    plot(Xpix,Ypix); xlabel('Pixels'); ylabel('Pixels'); title('Raw Pixel Plot')
    
end
% figure
% subplot(1,2,1); hist(Xpix,30); title('Raw X pixel histogram');
% subplot(1,2,2); hist(Ypix,30); title('Raw Y pixel histogram');
% 
% 
% % Xpix_max = max(Xpix); Xpix_min = min(Xpix(Xpix > 0));
% % Ypix_max = max(Ypix); Ypix_min = min(Ypix(Xpix > 0));
% % 
% % Xpix_dist = Xpix_max - Xpix_min;
% % Ypix_dist = Ypix_max - Ypix_min;
% 
%% Calculate Speed Data using basic derivatives and boxcar averages...
% OK approximation, Kalman filter method below is better...

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

%% Get occupancy data
npix_x = 50; npix_y = 50;

[ pix_x pix_y x_matrix y_matrix ] = pixel_time_spike_bin( Xcm, Ycm, npix_x, npix_y, frame_rate, plot_flag );


%% Freezing analysis

motion_thresh = threshold; % Motion threshold for freezing...

% freeze_index = (speed <= motion_thresh);
% freeze_index_smooth = (speed_smooth <= motion_thresh);
% freeze_index_smooth2 = (speed_smooth2 <= motion_thresh);
time_plot = time(1:end-1);
% time_smooth2_plot = time(smooth_window+1:end);

freeze_index_k = speed_k <= motion_thresh;
avg_speed_k = mean(speed_k);


%% Get actual freezing time 

buffer = 1.05; % round up exact frame rate because

%  First, get the difference in time between each velocity measure, then
%  sum up all those that are less than 1/frame_rate*buffer (those that are
%  larger indicate a period where the animal is

% freeze_time_diff = diff(time_plot(freeze_index));
% total_freeze_time = sum(freeze_time_diff(freeze_time_diff < buffer/frame_rate));
% 
% freeze_time_smooth_diff = diff(time_plot(freeze_index_smooth));
% total_freeze_time_smooth = sum(freeze_time_smooth_diff(freeze_time_smooth_diff < buffer/frame_rate));
% freeze_ratio_smooth = total_freeze_time_smooth/max(time_plot);
% 
% freeze_time_smooth2_diff = diff(time_smooth2_plot(freeze_index_smooth2));
% total_freeze_time_smooth2 = sum(freeze_time_smooth2_diff(freeze_time_smooth2_diff < buffer/frame_rate));
% freeze_ratio_smooth2 = total_freeze_time_smooth2/max(time_plot);

freeze_time_k_diff = diff(time(freeze_index_k));
total_freeze_time_k = sum(freeze_time_k_diff(freeze_time_k_diff < buffer/frame_rate));
freeze_ratio_k = total_freeze_time_k/max(time_plot);

%% Plots
% Plots a number of things for each file if you want to do some
% troubleshooting or get a better look at each session...

if plot_flag == 1
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
else
end

end

