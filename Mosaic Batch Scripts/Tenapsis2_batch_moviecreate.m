% Script to take any number of movies you select and create all the imaging
% files necessary to run Tenaspis V2: DFMovie.h5 and SLPDF.h5

%% Filter Specifications
filter_type = 'circular';
filter_pixel_radius = 3;
LPfilter_pixel_radius = 20;

curr_dir = cd;

%% Step 0: Initialize
mosaic.terminate(); % terminate any previous sessions
mosaic.initialize();

%% Step 1: Select Files to load

file = file_select_batch('*.mat');
num_files = length(file);

%% Step 2: Load files, mean filter, save them, and run TS_Lowpass_Divid on them

for j = 1:num_files
    
    % Load motion-corrected, cropped, but un-smoothed movie
    inputMovie = mosaic.loadObjects(file(j).path);
    
    % Perform 3-pixel radius disc filter and save
    disp(['Performing ' num2str(filter_pixel_radius) ' pixel disc smoothing of input movie']);
    filterMovie = mosaic.filterMovie(inputMovie,'filterType', filter_type,...
        'filterSize',filter_pixel_radius*2); % Perform filter
    filterMovie_savename = ['ICmovie_smooth_' filter_type '_' num2str(filter_pixel_radius)];
    cd(file(j).folder);
    mosaic.saveOneObject(filterMovie,filterMovie_savename); % Save file
    filterMovie_folder = fullfile(file(j).folder,[filterMovie_savename '-Objects']); % Folder containing the .h5 file
    cd(filterMovie_folder); %switch into folder containing filterMovie
    filterMovie_matfile = [filterMovie_folder(1:end-8) '.mat']; %.mat file pointing to Objects folder
    temp = ls('*.h5');
    filterMovie_fullpath_h5 = fullfile(file(j).folder,[filterMovie_savename '-Objects'],temp); % Full name to h5 file
    filterMovie_fullpath_mat = [filterMovie_fullpath_h5(1:end-3) '.mat']; % Full name to .mat file
    
    % Perform 3-pixel radius disc filter and save
    disp(['Performing ' num2str(LPfilter_pixel_radius) ' pixel disc smoothing of input movie for LPmovie']);
    LPMovie = mosaic.filterMovie(inputMovie,'filterType', filter_type,...
        'filterSize',LPfilter_pixel_radius*2); % Perform filter
    LPMovie_savename = ['LPmovie_' filter_type '_' num2str(LPfilter_pixel_radius)];
    cd(file(j).folder);
    mosaic.saveOneObject(LPMovie,LPMovie_savename); % Save file
    LPMovie_folder = fullfile(file(j).folder,[LPMovie_savename '-Objects']); % Folder containing the .h5 file
    cd(LPMovie_folder)
    temp = ls('*.h5');
    LPMovie_matfile = [LPMovie_folder(1:end-8) '.mat']; %.mat file pointing to Objects folder
    LPMovie_fullpath_h5 = fullfile(file(j).folder,[LPMovie_savename '-Objects'],temp); % Full name to h5 file
    LPMovie_fullpath_mat = [LPMovie_fullpath_h5(1:end-3) '.mat']; % Full name to .mat file
    clear LPMovie inputMovie
    
    % Get DF movie from 3-pixel movie
    disp('Creating DFmovie')
    DFMovie = mosaic.normalizeMovie(filterMovie, 'method', '(f-f0)/f0');
    cd(file(j).folder);
    mosaic.saveOneObject(DFMovie,'DFmovie');
    clear DFmovie filterMovie
    
    % Run TS_Lowpass_Divide
    %%
    disp('Creating TS Lowpass Divide movie')
    TS_Lowpass_Divide(filterMovie_fullpath_h5,LPMovie_fullpath_h5);
    
    keyboard
    
    % Cleanup everything
    disp(['Deleting smoothed movie 1: ' filterMovie_fullpath_h5]);
    delete(filterMovie_fullpath_h5);
    delete(filterMovie_fullpath_mat);
%     rmdir(filterMovie_folder); % Not deleting yet because LowPass movie
%     ends up here from TS_Lowpass_Divide...
    delete(filterMovie_matfile);
    
    disp(['Deleting smoothed movie 2: ' LPMovie_fullpath_h5]);
    delete(LPMovie_fullpath_h5);
    delete(LPMovie_fullpath_mat);
%     rmdir(LPMovie_folder); % Not deleting yet - need to clean up manually
    delete(LPMovie_matfile);
    
end

%% Terminate

mosaic.terminate();