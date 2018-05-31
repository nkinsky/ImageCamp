function [ xpos_interp, ypos_interp, time_interp ] = ff2pos( sesh_or_dir, ...
    fps_brainimage )
% [ x, y, time ] = ff2pos( sesh_or_dir, fps_brainimage )
%
% Converts freezeframe pos.csv file to pos.mat file compatible with
% Placefields.mat. fps_brainimage = 20 by default

%% 0) Get directory & file locations
if isstruct(sesh_or_dir)
    dir_use = ChangeDirectory_NK(sesh_or_dir,0);
elseif isdir(sesh_or_dir)
    dir_use = sesh_or_dir;
end

pos_path = fullfile(dir_use,'pos.csv');
time_file = ls(fullfile(dir_use,'*Index.csv'));
time_path = fullfile(dir_use,time_file);
save_path = fullfile(dir_use,'Pos.mat');
avifile = ls(fullfile(dir_use,'*.avi'));
avipath = fullfile(dir_use,avifile);

%% 1) Import csv file and time stamps, chop last time stamp to make them
% match - plot as a qc metric!
time = importdata(time_path);
time = time(:,1);
time = time(1:end-1);
bad_time = time;
pos = importdata(pos_path)';
obj = VideoReader(avipath);
aviSR = mean(diff(time))^-1;
aviSR_putative = obj.FrameRate;

% Plot out trajectory on maze as part of quality control
x = pos(:,1); y = obj.Height - pos(:,2);
figure; set(gcf,'Position',[1000 420 580 400]);
imagesc_gray(flipud(readFrame(obj))); 
set(gca,'YDir','normal');
hold on; 
plot(x,y,'b-')


%% 2) Make MoMtime = 1st frame timestamp
MouseOnMazeFrame = 1;
MoMtime = MouseOnMazeFrame/aviSR+time(1);

%% 3)Get start time
start_time = ceil(min(time)*fps_brainimage)/fps_brainimage;
max_time = floor(max(time)*fps_brainimage)/fps_brainimage;
time_interp = start_time:1/fps_brainimage:max_time; 

%% 4) Get pts where the mouse is a 0,0 and interpolate between them
bad_pts = all(pos == 0,2); 
if any(bad_pts)
    disp([num2str(sum(bad_pts)) ' point(s) detected at 0,0 in ' dir_use])
    disp('Be sure to check later')
    
    % interpolate values at 0,0
    x = arrayfun(@(a) lin_interp2(time(~bad_pts),x(~bad_pts),a),time);
    y = arrayfun(@(a) lin_interp2(time(~bad_pts),y(~bad_pts),a),time);
    
    figure
    hx = subplot(2,1,1); plot(time,x,'b-',time(bad_pts),x(bad_pts),'r*')
    xlabel('time'); ylabel('x position')
    title('bad pts interpolated in red')
    hy = subplot(2,1,2); plot(time,y,'b-',time(bad_pts),y(bad_pts),'r*')
    xlabel('time'); ylabel('y position')
    linkaxes(cat(1,hx,hy),'x')
    title(dir_use)
end
 
%% 4.1) Filter position data
Xpix_filt = NP_QuickFilt(x,0.0000001,1,aviSR);
Ypix_filt = NP_QuickFilt(y,0.0000001,1,aviSR);

AVIobjTime = zeros(1,length(time)); 
for i = 1:length(time)
    AVIobjTime(i) = i/aviSR_putative;
end

    %% 5) interpolate position data to brain imaging data
% Get appropriate time points to interpolate for each timestamp
time_index = arrayfun(@(a) [find(a >= time,1,'last') find(a < time,1,'first')],...
    time_interp,'UniformOutput',0);
time_test_cell = arrayfun(@(a) a,time_interp,'UniformOutput',0);

xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xpix_filt(a),...           %20 Hz timer starts when you hit record.
    b),time_index,time_test_cell);

ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ypix_filt(a),...           %20 Hz timer starts when you hit record.
    b),time_index,time_test_cell);  

AVItime_interp = cellfun(@(a,b) lin_interp(time(a), AVIobjTime(a),...       %20 Hz timer starts when you hit record.
    b),time_index,time_test_cell);

nframesinserted = round(length(AVItime_interp) - length(bad_time)*...
    fps_brainimage/aviSR);
%%
% time_index = arrayfun(@(a) [find(a >= time,1,'last') find(a < time,1,'first')],...
%     time_interp,'UniformOutput',0);
% time_test_cell = arrayfun(@(a) a,time_interp,'UniformOutput',0);

xpos_interp2 = cellfun(@(a,b) lin_interp2(time(a), Xpix_filt(a),...           %20 Hz timer starts when you hit record.
    b),time_index,time_test_cell);

ypos_interp2 = cellfun(@(a,b) lin_interp(time(a), Ypix_filt(a),...           %20 Hz timer starts when you hit record.
    b),time_index,time_test_cell);  

AVItime_interp2 = cellfun(@(a,b) lin_interp(time(a), AVIobjTime(a),...       %20 Hz timer starts when you hit record.
    b),time_index,time_test_cell);

nframesinserted2 = round(length(AVItime_interp) - length(bad_time)*...
    fps_brainimage/aviSR);
%%
Xpix = x; Ypix = y; xAVI = x; yAVI = y;

save(save_path, 'xpos_interp', 'ypos_interp', 'time_interp', 'start_time',...
    'MoMtime', 'Xpix', 'Ypix', 'xAVI', 'yAVI', 'MouseOnMazeFrame',...
    'AVItime_interp', 'nframesinserted');


end

