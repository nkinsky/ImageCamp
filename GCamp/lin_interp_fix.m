function [  ] = lin_interp_fix()
%fixes wrongly interpolated xpos and ypos data in Pos.mat and adds a
%time_interp array and saves it.  Run in the working directory of a session
%to fix it!

fps_brainimage = 20; % frames/sec for brain image timestamps

load('Pos.mat');
save Pos_old.mat xpos_interp ypos_interp start_time MoMtime
DVT = importdata(ls('*.DVT'));
disp(['Loaded "' ls('*.DVT')]); 
    
h = figure;
plot(xpos_interp,ypos_interp,'bo-');

if exist('time_interp','var') % Abort if already correct
    return
end

Xpix = xpos_interp;
Ypix = ypos_interp;
time_proxy = DVT(:,2);
time = min(time_proxy):1/fps_brainimage:max(time_proxy); % Get original timestamps from linear interpolation

% Generate times to match brain imaging data timestamps

start_time = ceil(min(time)*fps_brainimage)/fps_brainimage;
max_time = floor(max(time)*fps_brainimage)/fps_brainimage;
time_interp = start_time:1/fps_brainimage:max_time;

if (max(time_interp) >= max_time)
    time_interp = time_interp(1:end-1);
end

%% Do Linear Interpolation

% Get appropriate time points to interpolate for each timestamp
time_index = arrayfun(@(a) [max(find(a >= time)) min(find(a < time))],...
    time_interp,'UniformOutput',0);
time_test_cell = arrayfun(@(a) a,time_interp,'UniformOutput',0);

xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xpix(a),...
    b),time_index,time_test_cell);

ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ypix(a),...
    b),time_index,time_test_cell);

figure(h);
hold on
plot(xpos_interp,ypos_interp,'r*')
hold off

keyboard

save Pos.mat xpos_interp ypos_interp time_interp start_time MoMtime


end

