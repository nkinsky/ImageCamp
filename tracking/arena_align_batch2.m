function [cmperbin] = arena_align_batch2(working_dirs, calib_file, cmperbin, rot_overwrite)
% arena_align_batch2(cmperbin, rot_overwrite, files)
% Function to align multiple arenas to the base session using arena_align
% function
% working_dirs is a data structure of the structure working_dirs(n).folder to the
% working directory you wish to analyze
% calib_file is the directory in which you have the linear model data for
% correcting lens distortion for a given arena
% cmpberbin is the cm/bin to use for the occupancy grids
% rot_overwrite = 1 does NOT rotate any of the arenas back to the base
% configuration and thus should be run to check if they are using distal
% cues

%% Initial Variables
n = 1;
done = 0;


%% Get working folders to align
if ~isempty(working_dirs(1).folder)
    session = working_dirs;
elseif working_dirs == ''
    disp('Select Base session working directory followed by sessions which you want to align the base session to.')
    session = folder_select_batch;
    
end

%% Run alignment

if rot_overwrite == 0
    import_file = 'pos_corr_to_std.mat';
    save_file = 'occupancy_grid_info.mat';
elseif rot_overwrite == 1
    import_file = 'pos_corr_to_std_no_rotate.mat';
    save_file = 'occupancy_grid_info_no_rotate.mat';
end

for j = 2:size(session,2);
    arena_align(session(1).folder, session(j).folder, calib_file, rot_overwrite);
    cd(session(j).folder);
    session(j).pos_align = importdata(import_file);
    
end
cd(session(1).folder);
session(1).pos_align = importdata(import_file);

%% Compare occupancy grids

[session(1).grid_info] = assign_occupancy_grid(session(1).pos_align.x, ...
    session(1).pos_align.y, cmperbin, 0);
cmperbin = session(1).grid_info.cmperbin; % Update cmperbin if changed
grid_info = session(1).grid_info;
save(save_file, 'grid_info');

for j = 2:size(session,2)
    cd(session(j).folder);
    session(j).grid_info = session(1).grid_info;
    grid_info = session(j).grid_info;
    save(save_file, 'grid_info');
end

% Plot out to check!
figure
for j = 1:size(session,2)
    subplot(2,4,j)
    plot_occupancy_grid(session(j).pos_align.x, session(j).pos_align.y, ...
        session(j).grid_info.Xedges, session(j).grid_info.Yedges);
    title(['Session ' num2str(j) ' Occupancy Grid'])
end

end