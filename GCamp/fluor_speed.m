function [ ] = fluor_speed()
%fluor_speed Plot total fluorescence vs. running speed of mouse

SR_image = 20; % frames/sec for brain images
SR_track = 30; % frames/sec for video tracking
num_black_frames = 6; % number of black frames at beginning of DVT file

% 1: Load in movie frames from file (see Dave's updated script), get  total
% signal from each frame.

display('Loading movie data');
if exist('ICmovie.h5') == 2
    MovieData = h5read('ICmovie.h5','/Object'); % MovieData dims are X,Y,T
else
    [ movie_file movie_dir] = uigetfile('*.h5','Select movie file to load:');
    moviepath = [movie_dir movie_file];
    MovieData = h5read(moviepath,'/Object'); % MovieData dims are X,Y,T
end

% 2: Get signal from each frame


NumFrames = size(MovieData,3);
t = (1:NumFrames)/SR_image;

for j = 1:NumFrames
    tempFrame = double(squeeze(MovieData(:,:,j)));
    display(['Calculating F traces for movie frame ',int2str(j),' out of ',int2str(NumFrames)]);
    total_f(j) = sum(sum(tempFrame));
end
display(['Movie loaded successfully from ' moviepath])


% 2: Load in DVT file, get speed
display('Loading tracking data')
[track_file track_dir] = uigetfile('*.dvt','Select Video Tracking file to load:',moviepath);
track_path = [track_dir track_file];
DVTdata = importdata(track_path);
display(['Video tracking data loaded successfully from ' track_file])

DVT_time = DVTdata(:,2) - min(DVTdata(:,2)); % Subtract off lag hitting record to unpausing record
Xpos = DVTdata(:,3);
Ypos = DVTdata(:,4);

% 3: Get smoothed speed data using Kalman filters

[tk, xk, yk, vxk, yxk, axk, ayk] = KalmanVel_sam(Xpos, Ypos, DVT_time, 2);
speed_k = sqrt(vxk.^2 + axk.^2);

% 4: Interpolate Data points from tracking to imaging data timestamps

speed_interp = lin_interp_vec(tk,speed_k,t);

% 5: Adjust vectors for black frames at beginning of image file that need
% to be deleted
tadj = t(num_black_frames + 1:end);
speed_adj = speed_interp(num_black_frames + 1:end);
total_f_adj = total_f(num_black_frames + 1:end);

% 6: Plot it!
figure
plot(speed_adj, total_f_adj,'.')

% 7: Try smoothing speed data?
speed_smooth = smooth(speed_adj,101);

figure
plot(speed_smooth, total_f_adj, '.')





keyboard;



end

