% Script to take any number of movies you select and mean filter them

%% Filter Specifications
filter_type = 'circular';
filter_pixels = 3;

curr_dir = cd;

%% Step 0: Initialize
mosaic.terminate(); % terminate any previous sessions
mosaic.initialize();

%% Step 1: Select Files to load

file = file_select_batch('*.mat');
num_files = length(file);

%% Step 1.33: Load files, mean filter, and save them

for j = 1:num_files
    inputMovie = mosaic.loadObjects(file(j).path);
    filterMovie = mosaic.filterMovie(inputMovie,'filterType', filter_type,...
        'filterSize',filter_pixels);
    cd(file(j).folder);
    mosaic.saveOneObject(['ICmovie_smooth_' filtertype '_' num2str(filter_pixels)],filterMovie);
end

%% Terminate

mosaic.terminate();