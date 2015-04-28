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
auto_restrict = 0
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
    task = '2env'; % Specify task here for non-batch runs
    if strcmpi(task,'2env')
        analysis_day(1) = 1; analysis_session(1) = 1;
        analysis_day(2) = 6; analysis_session(2) = 1;
    elseif strcmpi(task,'alternation_laptop')
        analysis_day(1) = 1;
        analysis_day(2) = 3;
    end
end

% Hardcoded place where your reference files live...
session_ref_path = 'J:\GCamp Mice\Working\2env\session_ref.mat';
square_sesh_path = 'J:\GCamp Mice\Working\2env\square_sessions.mat';
octagon_sesh_path = 'J:\GCamp Mice\Working\2env\octagon_sessions.mat';
registration_file = 'J:\GCamp Mice\Working\2env\RegistrationInfoX.mat';
cell_mask_file = 'J:\GCamp Mice\Working\2env\11_19_2014\1 - 2env square left 201B\Working\AllNeuronMask.mat';
alternation_session_laptop = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\alternation_session.mat';
registration_file_laptop = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\RegistrationInfoX.mat';
cell_mask_file_laptop = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working\AllICmask.mat';


if strcmpi(task,'2env')
    load(session_ref_path); load(square_sesh_path); load(octagon_sesh_path);
    load(registration_file); load(cell_mask_file);
elseif strcmpi(task,'alternation_laptop')
    
    load(registration_file_laptop);
    load(alternation_session_laptop);
    load(cell_mask_file_laptop);
end

if exist('AllICMask','var');
    neuron_mask = AllICMask;
elseif exist('AllNeuronMask','var')
    neuron_mask = AllNeuronMask;
end

% <<< Incorporate flag for task here...choose between 2env and alternation
% for now, can incorporate others...

for j=1:2
    if strcmpi(task,'2env')
        [ sesh(j).folder, sesh(j).movie_folder ] = get_sesh_folders( ...
            day(analysis_day(j)).session(analysis_session(j)),...
            square_sessions, octagon_sessions );
    elseif strcmpi(task,'alternation_laptop')
        sesh(j).folder = alternation_session(analysis_day(j)).folder;
        sesh(j).movie_folder = alternation_session(analysis_day(j)).movie_folder;
    end
end


userprofile = getenv('USERPROFILE');
calib_file = [userprofile '\Dropbox\Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_hack.mat'];

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


%%
disp('CALCULATING CORRELATIONS AND SHUFFLING DATA')

% Pixels to exclude
% load([sesh(1).folder '\reverse_placefields_ChangeMovie' rot_append '.mat'],'AvgFrame_DF'); % Is this necessary?

% Pixels to exclude from RVP analysis! (e.g. due to traveling waves, motion
% artifacts, etc.)
AvgFrame_DF_reg = ones(tform(1).base_ref.ImageSize);
num_x_pixels = size(AvgFrame_DF_reg,2);
num_y_pixels = size(AvgFrame_DF_reg,1);
x_exclude = 325:num_x_pixels; % in pixels
y_exclude = 300:num_y_pixels;
exclude = zeros(size(AvgFrame_DF_reg));
exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));
% keyboard
% load(cell_mask_file);
exclude = ~(neuron_mask & ~exclude); 
% Exclude pixels due to registration
for j = 1:2
    if ~isempty(tform(j).reg_pix_exclude)
        exclude(:) = exclude(:) | tform(j).reg_pix_exclude;
    end
end

[h, corrs] = shuffle_ratemaps2(sesh(1).folder, sesh(2).folder, analysis_type, ...
    num_shuffles, rot_overwrite, exclude, tform);

load([sesh(1).folder '\' grid_file]);
corrs.cmperbin = grid_info.cmperbin;

%% Save correlation data (& plots? - or just plot this all out at the end...)
disp('SAVING STUFF')
savename = [sesh(2).folder '\corrs_cmperbin' num2str(round(cmperbin,0)) ...
    '_day' num2str(analysis_day(1)) '_sesh' num2str(analysis_session(1))...
    rot_append smooth_append];
save([savename '.mat'],'corrs'); % Saves the correlation and shuffle data with cmperbin and rotation status appended to the end

corrs.cmperbin = cmperbin;