% Script to take position data at given timestamps and output and interpolate 
% to any given timestamps.

clear all
close all

% Input timestamps at which you require position data
frame_rate_test = 20; % frames/sec

% Import position data from DVT file
filepath = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_17\G1704282014001.DVT';
pos_data = importdata(filepath);
f_s = max(regexp(filepath,'\'))+1;
mouse_name = filepath(f_s:f_s+2);
date = [filepath(f_s+3:f_s+4) '-' filepath(f_s+5:f_s+6) '-' filepath(f_s+7:f_s+10)];

% Parse out into invididual variables
frame = pos_data(:,1);
time = pos_data(:,2); % time in seconds
Xpix = pos_data(:,3); % x position in pixels (can be adjusted to cm)
Ypix = pos_data(:,4); % y position in pixels (can be adjusted to cm)
if size(pos_data,2) == 5
    motion = pos_data(:,5);
end

frame_rate_emp = round(1/mean(diff(time))); % empirical frame rate (frames/sec)

% Conjure up set of times to test script
fps_test = 20; % frames/sec for dummy timestamps

start_time = min(time);
max_time = max(time);
time_test = start_time:1/fps_test:max_time;

%% Do Linear Interpolation

% Get appropriate time points to interpolate for each timestamp
time_index = arrayfun(@(a) [max(find(a >= time)) min(find(a < time))],...
    time_test); %'UniformOutput',0);
time_test_cell = arrayfun(@(a) a,time_test,'UniformOutput',0);

xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xpix(a),...
    b),time_index,time_test_cell);

ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ypix(a),...
    b),time_index,time_test_cell);

%% Sanity Check
% figure
% subplot(2,1,1)
% plot(time,Xpix,'b-',time_test,xpos_interp,'rx')
% subplot(2,1,2)
% plot(time,Ypix,'b-',time_test,ypos_interp,'rx')




