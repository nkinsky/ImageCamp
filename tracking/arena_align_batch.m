% arena_align_batch

clear all
close all

n = 1;
done = 0;

%% Variables to set/tweak
cmperbin = 4.7;
rot_overwrite = 1; % set to 1 if you don't want to rotate the arenas such that the local cues align

%% Get working folders to align
while done ~= 1
    if n == 1
        session(n).folder = uigetdir('','Select base session');
        cd(session(n).folder);
%         session(n).pos_align = importdata('pos_corr_to_std.mat');
    else
        session(n).folder = uigetdir(session(n-1).folder,['Select Session number ' ...
            num2str(n) ' to align with session 1']);
        if session(n).folder == 0   
            done = 1;
        else
           cd(session(n).folder);
%            session(n).pos_align = importdata('pos_corr_to_std.mat');
        end
        
    end
    
    
    n = n + 1;
    
end

%% Run alignment

if rot_overwrite == 0
    import_file = 'pos_corr_to_std.mat';
    save_file = 'occupancy_grid_info.mat';
elseif rot_overwrite == 1
    import_file = 'pos_corr_to_std_no_rotate.mat';
    save_file = 'occupancy_grid_info_no_rotate.mat';
end

for j = 2:size(session,2)-1;
    arena_align(session(1).folder, session(j).folder, rot_overwrite);
    cd(session(j).folder);
    session(j).pos_align = importdata(import_file);
    
end
cd(session(1).folder);
session(1).pos_align = importdata(import_file);

%% Compare occupancy grids

[session(1).grid_info] = assign_occupancy_grid(session(1).pos_align.x,session(1).pos_align.y, cmperbin, 0);
cmperbin = session(1).grid_info.cmperbin;

for j = 1:size(session,2)-1;
    cd(session(j).folder);
    session(j).grid_info = session(1).grid_info;
    grid_info = session(j).grid_info;
    save(save_file, 'grid_info');
end

% Plot out to check!
figure
for j = 1:size(session,2)-1
    subplot(2,2,j)
    plot_occupancy_grid(session(j).pos_align.x, session(j).pos_align.y, session(j).grid_info.Xedges, ...
        session(j).grid_info.Yedges);
    title(['Session ' num2str(j) ' Occupancy Grid'])
end