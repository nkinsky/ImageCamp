%% Reverse placefield wrapper function

speed_thresh = 5; % cm/s, speed threshold to use for both sessions
cmperbin = 5; % starting size of cmperbin to use
movie_type = 'ChangeMovie';
% Set to 1 if you wish to analyze data that has intentionally NOT been 
% rotated such that the local features align.
rot_overwrite = 1; 

if rot_overwrite == 0
    import_file = 'pos_corr_to_std.mat';
    grid_file = 'occupancy_grid_info.mat';
    disp('Running with 2nd session rotated to align with 1st.')
elseif rot_overwrite == 1
    import_file = 'pos_corr_to_std_no_rotate.mat';
    grid_file = 'occupancy_grid_info_no_rotate.mat';
    disp('Running with 2nd session NOT rotated to align with 1st.')
end

%% 1) Get working folder location for both sessions and load data in

sesh(1).folder = uigetdir('','Select Session 1 Working Directory:');
sesh(2).folder = uigetdir(sesh(1).folder,'Select Session 2 Working Directory:');

%% 1.5) Load position data

for j = 1:2
   cd(sesh(j).folder);
   temp = importdata(import_file);
   sesh(j).x = temp.x;
   sesh(j).y = temp.y;
   
   
   
end

%% 2) run assign_occupancy_grid if not already done, plot for both sessions
% and compare to make sure same number of bins are in each.

try 
    for j = 1:2
    cd(sesh(j).folder);
    sesh(j).grid_info = importdata(grid_file); % load occupancy grid info
    end
catch
    disp('Setting scaling based on user input.  NOTE - MAY NOT MATCH FROM SESSION TO SESSION')
    
    [sesh(1).grid_info] = assign_occupancy_grid(sesh(1).x,sesh(1).y, cmperbin, 0);
    cmperbin = sesh(1).grid_info.cmperbin;
    
    sesh(2).grid_info = sesh(1).grid_info;
    % [sesh(2).Xedges, sesh(2).Yedges, cmperbin] = assign_occupancy_grid(sesh(2).x,...
    %     sesh(2).y, cmperbin, 1); % Don't allow adjust of grids for session 2...

end
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
   cd(sesh(j).folder);
   reverse_placefield4(sesh(j).folder ,speed_thresh ,sesh(j).grid_info, ...
       movie_type, rot_overwrite);
end

%% 4) calculate intersession correlations and plot out for all!
% yup - need to add this in here...