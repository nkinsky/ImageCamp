%% Reverse placefield wrapper function

clear all
close all

start_time = tic;

%% Variables to tweak if necessary
speed_thresh = 5; % cm/s, speed threshold to use for both sessions
cmperbin = 1.2; % starting size of cmperbin to use
movie_type = 'ChangeMovie';
% Set to 1 if you wish to analyze data that has intentionally NOT been 
% rotated such that the local features align.
analysis_type = 2; % 1 if you want to used smoothed data, 0 if not
rot_overwrite = 0; 
num_shuffles = 100;

% Pixels to exclude from RVP analysis! (e.g. due to traveling waves, motion
% artifacts, etc.)
x_exclude = 325:num_x_pixels; % in pixels
y_exclude = 300:num_y_pixels;

smooth_type = {'_DF_no_smooth' '_DF_smooth', '_z_smooth'};
smooth_append = smooth_type{analysis_type + 1};


%%% Pixels to exclude due to edge of cannula, traveling waves, etc. - this
% will be mouse and session specific most likely! - may need to include
% this in a function where you draw on the image to get the excluded
% region(s)!
% Note that this is ok only for G30 on day 1!!! Need to do either for each
% session or correct each session back!
% NOTE THAT THIS OCCURS BELOW IN STEP 4 TO BE APPROXIMATELY OK FOR ALL SESSIONS FOR
% G30 BUT IS A HACK AND WILL NEED TO BE MORE PRECISE IN THE FUTURE!


if rot_overwrite == 0
    import_file = 'pos_corr_to_std.mat';
    grid_file = 'occupancy_grid_info.mat';
    rot_append = '';
    disp('Running with 2nd and greater session(s) rotated to align with 1st.')
elseif rot_overwrite == 1
    import_file = 'pos_corr_to_std_no_rotate.mat';
    grid_file = 'occupancy_grid_info_no_rotate.mat';
    rot_append = '_no_rotate';
    disp('Running with 2nd and greater session(s) NOT rotated to align with 1st.')
end

%% 1) Get working folder location for both sessions and load data in

sesh(1).folder = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\';
sesh(2).folder = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\';
calib_file = 'C:\Users\Nat\Dropbox\Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_hack.mat';

% sesh(1).folder = uigetdir('','Select Session 1 Working Directory:');
% sesh(2).folder = uigetdir(sesh(1).folder,'Select Session 2 Working Directory:');
% calib_file = uigetfile('*.mat','Select calibration file:');

%% 1.5) Load position data

for j = 1:2
   cd(sesh(j).folder);
   temp = importdata(import_file);
   sesh(j).x = temp.x;
   sesh(j).y = temp.y;
   
   
   
end

%% 2) run assign_occupancy_grid if not already done, plot for both sessions
% and compare to make sure same number of bins are in each.

cmperbin = arena_align_batch2(sesh, '', cmperbin, rot_overwrite);

for j = 1:2
    cd(sesh(j).folder);
    temp = importdata(grid_file);
    sesh(j).grid_info = temp;
end

% try 
%     for j = 1:2
%     cd(sesh(j).folder);
%     sesh(j).grid_info = importdata(grid_file); % load occupancy grid info
%     end
% catch
%     disp('Setting scaling based on user input.  NOTE - MAY NOT MATCH FROM SESSION TO SESSION')
%     
%     [sesh(1).grid_info] = assign_occupancy_grid(sesh(1).x,sesh(1).y, cmperbin, 0);
%     cmperbin = sesh(1).grid_info.cmperbin;
%     
%     sesh(2).grid_info = sesh(1).grid_info;
%     % [sesh(2).Xedges, sesh(2).Yedges, cmperbin] = assign_occupancy_grid(sesh(2).x,...
%     %     sesh(2).y, cmperbin, 1); % Don't allow adjust of grids for session 2...
% 
% end
% Plot out to check!
figure
for j = 1:2
    subplot(1,2,j)
    plot_occupancy_grid(sesh(j).x, sesh(j).y, sesh(j).grid_info.Xedges, ...
        sesh(j).grid_info.Yedges);
    title(['Session ' num2str(j) ' Occupancy Grid'])
end

disp('Here is your chance to compare occupancy grids')
keyboard

%% 3) run reverse_placefield4

for j = 1:2
    disp(['Running reverse_placefield for session ' num2str(j)]);
    cd(sesh(j).folder);
    reverse_placefield4(sesh(j).folder ,speed_thresh ,sesh(j).grid_info, ...
       movie_type, rot_overwrite);
end

%% 4) calculate intersession correlations and plot out for all!
% yup - need to add this in here...

disp('CALCULATING CORRELATIONS AND SHUFFLING DATA')

% Pixels to exclude
load([sesh(1).folder 'reverse_placefields_ChangeMovie' rot_append '.mat']);
num_x_pixels = size(AvgFrame_DF{1},2);
num_y_pixels = size(AvgFrame_DF{1},1);


exclude = zeros(size(AvgFrame_DF{1}));
exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));

[h, corrs] = shuffle_ratemaps2(sesh(1).folder, sesh(2).folder, analysis_type, ...
    num_shuffles, rot_overwrite, exclude);

corrs.cmperbin = cmperbin;

%% Save correlation data (& plots? - or just plot this all out at the end...)
disp('SAVING STUFF')
savename = [sesh(2).folder 'corrs' '_cmperbin' num2str(round(cmperbin,0)) rot_append smooth_append];
save([savename '.mat'],'corrs'); % Saves the correlation and shuffle data with cmperbin and rotation status appended to the end
set(h, 'Position', get(0,'Screensize')); % My attempt to maximize the figure before saving so that it doesn't look funny
export_fig(savename,'-jpg');
saveas(h, savename, 'fig'); % Need to save the plots to a figure also

%% Output TOTAL time to do analysis
finish_time = toc(start_time);
disp([ 'TOTAL run time for reverse_placefield_grouped2 is ' num2str(round(finish_time,0)) ' seconds'])
