function [cmperbin] = arena_align_batch2(working_dirs, calib_file, cmperbin, rot_overwrite, auto_restrict, xrestrict, yrestrict, manual_enable)
% arena_align_batch2(cmperbin, rot_overwrite, files)
% Function to align multiple arenas to the base session using arena_align
% function
% working_dirs is a data structure of the structure working_dirs(n).folder to the
% working directory you wish to analyze and work_dirs(n).movie_folder to
% the brain imaging movie location
% calib_file is the directory in which you have the linear model data for
% correcting lens distortion for a given arena
% cmpberbin is the cm/bin to use for the occupancy grids
% rot_overwrite = 1 does NOT rotate any of the arenas back to the base
% configuration and thus should be run to check if they are using distal
% cues

%% To-do
% 1) Clarify use of xrestrict and yrestrict. 

%% Initial Variables
n = 1;
done = 0;

% auto_restrict = 1;
restrict_buffer = 0.5; % cm to add/subtract from session1 max/min to create position restriction limits

%% Get working folders to align
if ~isempty(working_dirs) %% || ~isempty(working_dirs(1).folder)
    session = working_dirs;
elseif isempty(working_dirs)
    disp('WARNING - THIS PROBABLY WON''T WORK.  Go back and specify working folders in arena_align_batch2')
%     disp('Select Base session working directory followed by sessions which you want to align the base session to.')
    session = folder_select_batch;
    for j = 1:size(session,2)
        
    end
    
end

%% Run alignment

if rot_overwrite == 0
    import_file = 'pos_corr_to_std.mat';
    save_file = 'occupancy_grid_info.mat';
elseif rot_overwrite == 1
    import_file = 'pos_corr_to_std_no_rotate.mat';
    save_file = 'occupancy_grid_info_no_rotate.mat';
end

try
    cd(session(1).folder)
    session(1).pos_align = importdata(import_file);
    xrestrict = [min(session(1).pos_align.x) - restrict_buffer ...
        max(session(1).pos_align.x) + restrict_buffer];
    yrestrict = [min(session(1).pos_align.y) - restrict_buffer...
        max(session(1).pos_align.y) + restrict_buffer]  ;
catch
    xrestrict = [];
    yrestrict = [];
end

for j = 2:size(session,2);
    try
        cd(session(j).folder); % Is this necessary?
        session(j).pos_align = importdata(import_file);
    catch
        arena_align(session(1).folder, session(j).folder, session(1).movie_folder,...
            session(j).movie_folder, calib_file, rot_overwrite, xrestrict, yrestrict, manual_enable);
        cd(session(j).folder); % Is this necessary?
        session(j).pos_align = importdata(import_file);
    end
end
cd(session(1).folder);
session(1).pos_align = importdata(import_file); 

%% Compare occupancy grids

[session(1).grid_info] = assign_occupancy_grid(session(1).pos_align.x, ...
    session(1).pos_align.y, cmperbin, auto_restrict);
cmperbin = session(1).grid_info.cmperbin; % Update cmperbin if changed
grid_info = session(1).grid_info;
save(save_file, 'grid_info');

% Assign the same grid to ALL sessions...
for j = 2:size(session,2)
    cd(session(j).folder);
    session(j).grid_info = session(1).grid_info;
    grid_info = session(j).grid_info;
    save(save_file, 'grid_info');
end

% Plot out to check!
figure
for j = 1:size(session,2)
    subplot(3,4,j)
    plot_occupancy_grid(session(j).pos_align.x, session(j).pos_align.y, ...
        session(j).grid_info.Xedges, session(j).grid_info.Yedges);
    title(['Session ' num2str(j) ' Occupancy Grid'])
end

% keyboard
end