% Script to take any number of movies you select and mean filter them

%% Filter Specifications
filter_type = 'circular';
filter_pixel_radius = 3;

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
        'filterSize',filter_pixel_radius*2);
    cd(file(j).folder);
    mosaic.saveOneObject(filterMovie,['ICmovie_smooth_' filter_type '_' num2str(filter_pixel_radius)]);
    
    clear inputMovie filterMovie
end

%% Terminate

mosaic.terminate();