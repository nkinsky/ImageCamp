function [xpos_interp,ypos_interp,time_interp,Xmin,Xmax,Ymin,Ymax] = PreProcessMousePosition(filepath)

try
    load Pos.mat
    return
catch 
    
    
% Script to take position data at given timestamps and output and interpolate 
% to any given timestamps.

PosSR = 30; % native sampling rate in Hz of position data

% Import position data from DVT file - note that if you add
try
pos_data = importdata(filepath);
%f_s = max(regexp(filepath,'\'))+1;
%mouse_name = filepath(f_s:f_s+2);
%date = [filepath(f_s+3:f_s+4) '-' filepath(f_s+5:f_s+6) '-' filepath(f_s+7:f_s+10)];

% Parse out into invididual variables
frame = pos_data(:,1);
time = pos_data(:,2); % time in seconds
Xpix = pos_data(:,3); % x position in pixels (can be adjusted to cm)
Ypix = pos_data(:,4); % y position in pixels (can be adjusted to cm)
catch
% Video.txt is there instead of Video.DVT
pos_data = importdata('Video.txt');
Xpix = pos_data(:,6);
Ypix = pos_data(:,7);
time = pos_data(:,4);
end

xAVI = Xpix*.6246;
yAVI = Ypix*.6246;

figure(777);plot(Xpix,Ypix);
figure(666);
hist(Xpix,300);
figure(555);
subplot(3,2,1:2);plot(Xpix);
subplot(3,2,3:4);plot(Ypix);
obj = VideoReader('Raw.AVI');
v0 = readFrame(obj);
MorePoints = 'y';
while (strcmp(MorePoints,'y'))
  subplot(3,2,1:2);plot(Xpix);%set(gca,'XLim',[xp(1) xp(2)]);
  subplot(3,2,3:4);plot(Ypix);%set(gca,'XLim',[xp(1) xp(2)]);
  MorePoints = input('Is there a flaw that needs to be corrected?','s');

  
  if strcmp(MorePoints,'y')
    
    display('zoom in, click on the good points around the flaw then hit enter');
    [xp,yp] = ginput(2);
    xp = ceil(xp);
    yp = ceil(yp);
    figure(555);
    
    obj.currentTime = time(xp(1));
    v = readFrame(obj);
    subplot(3,2,5);imagesc(flipud(v));hold on;
    %plot(xAVI,yAVI);hold on;
    plot(xAVI(xp(1):xp(2)),yAVI(xp(1):xp(2)),'LineWidth',1.5);hold off;
    timepoints = time(xp(1):xp(2));
    for i = 1:floor(length(timepoints)/2);
        subplot(3,2,6);
        obj.currentTime = timepoints(i*2);
        v = readFrame(obj);
        imagesc(flipud(v));
        hold on;plot(xAVI(xp(1)+i*2),yAVI(xp(1)+i*2),'o')
        display('click the mouses back');
        [xm,ym] = ginput(1);
        
        xAVI(xp(1)+i*2) = xm;
        yAVI(xp(1)+i*2) = ym;
        Xpix(xp(1)+i*2) = ceil(xm/0.6246);
        Ypix(xp(1)+i*2) = ceil(ym/0.6246);
        
        xAVI(xp(1)+i*2-1) = xAVI(xp(1)+i*2-2)+(xm-xAVI(xp(1)+i*2-2))/2;
        yAVI(xp(1)+i*2-1) = yAVI(xp(1)+i*2-2)+(ym-yAVI(xp(1)+i*2-2))/2;
        Xpix(xp(1)+i*2-1) = ceil(xAVI(xp(1)+i*2-1)/0.6246);
        Ypix(xp(1)+i*2-1) = ceil(yAVI(xp(1)+i*2-1)/0.6246);
        
        plot(xm,ym,'or','MarkerSize',4);hold off;
        subplot(3,2,1:2);plot(Xpix);set(gca,'XLim',[xp(1) xp(2)]);
        subplot(3,2,3:4);plot(Ypix);set(gca,'XLim',[xp(1) xp(2)]);
        subplot(3,2,5);
        imagesc(flipud(v));hold on;
        plot(xAVI(xp(1):xp(2)),yAVI(xp(1):xp(2)),'LineWidth',1.5);hold off;
        
    end


  end
end
Xmin = input('Enter X min ->>');
Xmax = input('Enter X max ->>');

Ymin = input('Enter Y min ->>');

Ymax = input('Enter Y max ->>');

Xpix(find(Xpix < Xmin)) = Xmin;
Xpix(find(Xpix > Xmax)) = Xmax;
Ypix(find(Ypix < Ymin)) = Ymin;
Ypix(find(Ypix > Ymax)) = Ymax;

e = NP_FindSupraThresholdEpochs(-1*Xpix,-1*Xmin-1);

for i = 1:size(e,1)
    Xpix(e(i,1):e(i,2)) = Xpix(e(i,1)-1);
end

e = NP_FindSupraThresholdEpochs(-1*Ypix,-1*Ymin-1);
for i = 1:size(e,1)
    Ypix(e(i,1):e(i,2)) = Ypix(e(i,1)-1);
end

Xpix = NP_QuickFilt(Xpix,0.0000001,1,PosSR);
Ypix = NP_QuickFilt(Ypix,0.0000001,1,PosSR);

if size(pos_data,2) == 5
    motion = pos_data(:,5);
end

frame_rate_emp = round(1/mean(diff(time))); % empirical frame rate (frames/sec)

% Get times to interpolate to...
% SHOULD ACTUALLY USE VALUES FROM IMAGING FILE...
fps_image = 20; % frames/sec for imaging data

% Get start and end time for interpolation of imaging data
time_interp_start = ceil(min(time)*fps_image)/fps_image;
time_interp_end = floor(max(time)*fps_image)/fps_image;

% start_time = min(time);
% max_time = max(time);
time_interp = time_interp_start:1/fps_image:time_interp_end;

%% Do Linear Interpolation

% Get appropriate time points to interpolate for each timestamp
time_index = arrayfun(@(a) [find(a >= time, 1, 'last' ) find(a < time, 1 )],...
    time_interp,'UniformOutput',0);
time_interp_cell = arrayfun(@(a) a,time_interp,'UniformOutput',0);

xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xpix(a),...
    b),time_index,time_interp_cell);

ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ypix(a),...
    b),time_index,time_interp_cell);

keyboard

%% Sanity Check
% figure
% subplot(2,1,1)
% plot(time,Xpix,'b-',time_test,xpos_interp,'rx')
% subplot(2,1,2)
% plot(time,Ypix,'b-',time_test,ypos_interp,'rx')

save Pos.mat xpos_interp ypos_interp time_interp Xmin Xmax Ymin Ymax

end





