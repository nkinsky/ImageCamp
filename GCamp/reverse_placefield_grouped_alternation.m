%% Reverse placefield wrapper function

%%% TO-DO
% 1) Create session database file for alternation sessions
% 2) Group register all sessions
% 3) Run arena_align_batch for all sessions
% 4) 

% Clear workspace if NOT running a batch script
if ~exist('batch_run','var') || batch_run == 0
% clear_all_s
close all
clearvars -except j ind_use
rot_overwrite = 0; % Specify here for non batch running
end

start_time = tic;

%% Variables to tweak if necessary
speed_thresh = 5; % cm/s, speed threshold to use for both sessions
cmperbin = 2.3; % starting size of cmperbin to use
movie_type = 'ChangeMovie';
auto_restrict = 1
manual_enable = 1
% Set to 1 if you wish to analyze data that has intentionally NOT been 
% rotated such that the local features align.
analysis_type = 2; % 1 if you want to used smoothed data, 0 if not
% rot_overwrite = 0; 
num_shuffles = 100;

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
% You can run this here using hardcoded sessions if you want...
if ~exist('batch_run','var') || batch_run == 0
    analysis_day(1) = 1; analysis_session(1) = 1;
    analysis_day(2) = 1; analysis_session(2) = 2;
end

% Hardcoded place where your reference files live...
session_ref_path = 'J:\GCamp Mice\Working\2env\session_ref.mat';
square_sesh_path = 'J:\GCamp Mice\Working\2env\square_sessions.mat';
octagon_sesh_path = 'J:\GCamp Mice\Working\2env\octagon_sessions.mat';
registration_file = 'J:\GCamp Mice\Working\2env\RegistrationInfoX.mat';
alternation_sesh_path = '';
load(session_ref_path); load(square_sesh_path); load(octagon_sesh_path);
load(registration_file);

for j=1:2
    [ sesh(j).folder, sesh(j).movie_folder ] = get_sesh_folders( ...
        day(analysis_day(j)).session(analysis_session(j)),...
         square_sessions, octagon_sessions );   
end

userprofile = getenv('USERPROFILE');
calib_file = [userprofile '\Dropbox\Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_hack.mat'];

% sesh(1).folder = uigetdir('','Select Session 1 Working Directory:');
% sesh(2).folder = uigetdir(sesh(1).folder,'Select Session 2 Working Directory:');
% sesh(1).movie_folder = uigetdir('','Select Session 1 Movie Directory:');
% sesh(2).movie_folder = uigetdir(sesh(1).folder,'Select Session 2 Movie Directory:');
% calib_file = uigetfile('*.mat','Select calibration file:');

for j = 1:2
    if ~isfield(sesh,'movie_folder') || isempty(sesh(j).movie_folder)
        sesh(j).movie_folder = sesh(j).folder;
    end
end

% Load Registration File if there
% tform = struct([]);
for j = 1:2
    if exist('registration_file','var')
        [tform_struct] = get_reginfo( sesh(j).folder, RegistrationInfoX );
    else
        tform_struct.RegistrationInfoX = [];
        tform_struct.tform_use = [];
        tform_struct.reg_pix_exclude = [];
    end
    tform(j) = tform_struct;
end
%% 2) run assign_occupancy_grid if not already done, plot for both sessions
% and compare to make sure same number of bins are in each.

try % Load previously aligned data
    for j = 1:2
        cd(sesh(j).folder);
        temp = importdata(grid_file);
        sesh(j).grid_info = temp;
    end
    
catch % Align arenas if not already done
    disp('Aligning arenas.  Type return to continue')
    cmperbin = arena_align_batch2(sesh, calib_file, cmperbin, rot_overwrite, auto_restrict, [], [], manual_enable);
    for j = 1:2
        cd(sesh(j).folder);
        temp = importdata(grid_file);
        sesh(j).grid_info = temp;
    end
    
end



%% 2.5) Load position data

for j = 1:2
   cd(sesh(j).folder);
   temp = importdata(import_file);
   sesh(j).x = temp.x;
   sesh(j).y = temp.y;
end

%% 2.75) Check your work
figure
for j = 1:2
    subplot(2,2,j)
    plot_occupancy_grid(sesh(j).x, sesh(j).y, sesh(j).grid_info.Xedges, ...
        sesh(j).grid_info.Yedges);
    xlim([min(sesh(j).grid_info.Xedges) max(sesh(j).grid_info.Xedges)]);
    ylim([min(sesh(j).grid_info.Yedges) max(sesh(j).grid_info.Yedges)]);
    title(['Session ' num2str(j) ' Occupancy Grid'])
    if exist('analysis_day','var') && exist('analysis_session','var')
        title(['Day ' num2str(analysis_day(j)) ' Session ' num2str(analysis_session(j))])
    end
            
    %%% PLOT AVIs here for checking!
end
for j = 1:2
   subplot(2,2,j+2)
   rot_use = get_rot_from_path(sesh(j).folder, rot_overwrite);
   plot_arena_rot(sesh(j).folder,rot_use)
end

disp('Here is your chance to compare occupancy grids')
% keyboard

%% 3) run reverse_placefield4

for j = 1:2
    disp(['Running reverse_placefield for session ' num2str(j)]);
    cd(sesh(j).folder);
    reverse_placefield4(sesh(j).folder , speed_thresh, sesh(j).grid_info,...
        movie_type, rot_overwrite, sesh(j).movie_folder,...
        'num_divs_control',8);
end

%% 4) calculate intersession correlations and plot out for all!

close all
disp('CALCULATING CORRELATIONS AND SHUFFLING DATA')

% Pixels to exclude
% load([sesh(1).folder '\reverse_placefields_ChangeMovie' rot_append '.mat'],'AvgFrame_DF'); % Is this necessary?

% Pixels to exclude from RVP analysis! (e.g. due to traveling waves, motion
% artifacts, etc.)
AvgFrame_DF_reg = ones(tform(1).base_ref.ImageSize);
num_x_pixels = size(AvgFrame_DF_reg,2);
num_y_pixels = size(AvgFrame_DF_reg,1);
x_exclude = 325:num_x_pixels; % in pixels - note this is for area of traveling waves in G30... may need to make a specific one for each mouse!!!
y_exclude = 300:num_y_pixels;
exclude = zeros(size(AvgFrame_DF_reg));
exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));
keyboard
load(cell_mask_file);
exclude = ~(AllICmask & ~exclude); 
% Exclude pixels due to registration
for j = 1:2
    if ~isempty(tform(j).reg_pix_exclude)
        exclude(:) = exclude(:) | tform(j).reg_pix_exclude;
    end
end

[h, corrs] = shuffle_ratemaps2(sesh(1).folder, sesh(2).folder, analysis_type, ...
    num_shuffles, rot_overwrite, exclude, tform);

corrs.cmperbin = cmperbin;

%% Save correlation data (& plots? - or just plot this all out at the end...)
disp('SAVING STUFF')
savename = [sesh(2).folder '\corrs_cmperbin' num2str(round(cmperbin,0)) ...
    '_day' num2str(analysis_day(1)) '_sesh' num2str(analysis_session(1))...
    rot_append smooth_append];
save([savename '.mat'],'corrs'); % Saves the correlation and shuffle data with cmperbin and rotation status appended to the end
set(h, 'Position', get(0,'Screensize')); % My attempt to maximize the figure before saving so that it doesn't look funny
export_fig(savename,'-jpg');
saveas(h, savename, 'fig'); % Need to save the plots to a figure also

%% Output TOTAL time to do analysis
finish_time = toc(start_time);
disp([ 'TOTAL run time for reverse_placefield_grouped2 is ' num2str(round(finish_time,0)) ' seconds'])
