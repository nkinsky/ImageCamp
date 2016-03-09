+% Mosaic Batch Pre-processing

close all
% clear all

%% Variables to tweak?
mic_per_pix = 1.16; % To match previously used values
spatial_ds = 2; % Factor to downsample
spatial_filt = 20; % Number of pixels to use when applying the spatial mean and subtracting it later on.
save_ds = 1; % enter if you want to save the down-sample movie before moving on (recommended for large movies)

curr_dir = cd;

%% Step 0: Initialize
mosaic.terminate(); % terminate any previous sessions
mosaic.initialize();

%% Step 1: Select Files to load, if multiple they will automatically be
% concatenated

[filename, pathname] = uigetfile({'*.txt;*.xml', 'Miniscope files'},'Select File(s) to load',...
    'MultiSelect','On');

if iscell(filename)
    num_files = size(filename,2);
    for j = 1:num_files
       fullpath{j} = fullfile(pathname,filename{j}); 
    end
else
    num_files = 1;
    fullpath = fullfile(pathname,filename); 
end

%% Step 1.32: Fix bad frames
if ~exist('skip_fix','var') || skip_fix ~= 1
    disp('Checking and fixing bad frames if necessary')
    for i=1:num_files
        if num_files > 1
            thisfile = fullpath{i}(1:end-4);
        elseif num_files == 1
            thisfile = fullpath(1:end-4);
        end
        chunks = dir([thisfile, '*.tif']);
        numchunks = length(chunks);
        
        for j=1:numchunks
           
            filetofix = fullfile(pathname,chunks(j).name);
            if ~exist([filetofix(1:end-4),'fixed.mat'],'file');
                disp(['Checking ', filetofix, ' for bad frames...']);
                FixFrames(filetofix);
            else
                disp('Using previously fixed files')
            end
            
        end
    end
end


%% Step 1.33: Load files

for j = 1:num_files
    if num_files > 1
        sesh(j).movie = mosaic.loadMiniscope(fullpath{j},'loadingOption','stream',...
            'pixelWidth', mic_per_pix, 'pixelHeight', mic_per_pix);
    else
      sesh(j).movie = mosaic.loadMiniscope(fullpath,'loadingOption','stream',...
            'pixelWidth', mic_per_pix, 'pixelHeight', mic_per_pix);
    end

end

%% Step 1.67: Downsample Files - note that this MUST happen before anything else
% since downsampling will fix any dropped frames!!!

% Check if TIFF filesize is less than or equal to 720 x 540 and spit out a
% warning that one must check MANUALLY for bad frames - do this here and at
% the end!

if num_files > 1
    samplefile = [fullpath{1}(1:end-4) '.tif'];
elseif num_files == 1
    samplefile = [fullpath(1:end-4) '.tif'];
end

temp2 = imread(samplefile,'TIFF','Index',1); % Get sample file
if size(temp2,1) <= 540 && size(temp2,2) <= 720
    dropped_frame_warn = 1;
    save_ds = 0;
    disp('DATA HAS ALREADY BEEN DOWN-SAMPLED.  IF YOU HAVE DROPPED FRAMES YOU MAY NEED TO FIX MANUALLY WITH fix_dropped_frames FUNCTION!')
else
    dropped_frame_warn = 0;
    for j = 1:num_files
    % Downsample
    disp(['Downsampling Movie file ' num2str(j) ' spatially.'])
    sesh(j).movie = mosaic.resampleMovie(sesh(j).movie, 'spatialReduction', spatial_ds,...
    'temporalReduction', 1, 'useParallelization', 1);
    end
end



%% Step  1.75: Concatenate files - note that this MUST happen after 

if num_files == 1
    movie_use = sesh(j).movie;
elseif num_files >= 1
    list = mosaic.List('mosaic.Movie');
    for j = 1:num_files
        list.add(sesh(j).movie);
    end
    movie_use = mosaic.concatenateMovies(list);
    save_ds = 1;
end

disp('Check if concatenation has happened properly!: view each movie independently, then check #frames total')
%% Step 2: Save
cd(pathname)

if save_ds == 1
    mosaic.saveOneObject(movie_use,'CatMovie_ds.mat');
end
% movie_ds = mosaic.resampleMovie(movie_use, 'spatialReduction', spatial_ds,...
%     'useParallelization', 1);

% % Save in case of a crash
% mosaic.saveOneObject(movie_use,'CatMovie_ds.mat');
%% Step 3 (USER INPUT): Crop movie - don't do this for now - screws up later cropping and isn't really worth it!!!
% [ rect_crop_mos, rect_crop ] = mos_cropmovie_gui( movie_use);
% 
% crop_use = rect_crop_mos/spatial_ds/mic_per_pix; % Adjustment to get crop coordinates correct...
% 
% frame_plot = mosaic.extractFrame(movie_use,'frame',100); % Get frame to compare cropping to later for QC check
% 
% movie_crop = mosaic.cropMovie(movie_use,crop_use(1), crop_use(4), ...
%     crop_use(3), crop_use(2)); % Crop movie
% 
% h = frame_plot.view();
% rectangle('Position', rect_crop)
% h2 = movie_crop.view();
% 
% disp('Does this look right?')
% keyboard
% 
% close(h,h2);
% 
% movie_use = movie_crop;
% clear('movie_crop')
%% Step 4 (USER INPUT): Get reference image for motion correction

h2 = movie_use.view();
ii = input('Enter frame number to use as reference for motion correction: ');
ref_frame = mosaic.extractFrame(movie_use,'frame', ii);

%% Step 5 (USER INPUT): Apply mean filter, invert the image, and then mark 
% down the reference ROI for motion correction, display it on both the
% original image and the smoothed/inverted image

% Create a mean projection of the movie and filter it

mean_proj = mosaic.projectMovie(movie_use);
mean_proj_filter = mosaic.filterImage(mean_proj,'filterType','circular',...
    'filterSize', spatial_filt);

% Save file and get size for below
mosaic.saveImageTiff(mean_proj_filter,'mean_proj_filter.tif');
mean_proj_im = imread('mean_proj_filter.tif');
im_size = size(mean_proj_im);

% filter_movie = mosaic.filterMovie(movie_use,'filterType','circular',...
%     'filterSize', spatial_filt);
% mean_proj_filter2 = mosaic.projectMovie(filter_movie);

% Note that right now I am not messing with applying a mean filter,
% inverting the image, or subtracting the spatial mean

roi_ok = 'n';
disp('Draw a region to use as a reference for image registration. Right click when finished')
while strcmpi(roi_ok,'n')
    h = mean_proj_filter.view();
    rectangle('Position',[ spatial_filt, spatial_filt, im_size(2) - spatial_filt, ...
        im_size(1) - spatial_filt]*spatial_ds*mic_per_pix,'EdgeColor','r')
    [line_x, line_y] = getline();
    figure(h);
    line([line_x; line_x(1)], [line_y; line_y(1)]);
    roi_ok = input('Is this reference area ok (y/n): ','s');
end

close(h)

% Create roi
pointList = mosaic.List('mosaic.Point');
for j = 1:length(line_x)
    pointList.add(mosaic.Point(line_x(j), line_y(j)));
end
ref_roi = mosaic.PolygonRoi(pointList);
%% Step 6: Run Motion Correction

[mot_corr_movie, mc_parameters] = mosaic.motionCorrectMovie(movie_use,'referenceImage',ref_frame,...
    'motionType', 'Rigid', 'roi', ref_roi, 'speedWeight', 0, ...
    'parallelProcess', 1, 'warnThreshold', 20, 'invertImage', 1, ...
    'subtractSpatialMean', 1, 'subtractSpatialMeanPixels', spatial_filt, ...
    'applySpatialMean', 1, 'applySpatialMeanPixels', spatial_filt);

hmc = mot_corr_movie.view();
mosaic.saveOneObject(mc_parameters, 'MotCorrData.mat'); % Save Motion correction Data
disp('Here is your chance to check the motion correction');
% keyboard
close(hmc)

% NEED TO ADD STEP HERE TO PLOT OUT MOTCORRDATA!!!

%% Step 7; Save
% Annoying intermediate step - get maximum and minimum projections and save
% for easy cropping later in Mosaic
cd(pathname)
save_name = 'MotCorrMovie.tif';
title_label = 'Motion Correction Movie Minimum Projection';
min_proj_int = mosaic.projectMovie(mot_corr_movie,'projectionType','Minimum');
mosaic.saveOneObject(min_proj_int,'MotCorrMovie_min_proj.mat');
max_proj_int = mosaic.projectMovie(mot_corr_movie,'projectionType','Maximum');
mosaic.saveOneObject(max_proj_int,'MotCorrMovie_max_proj.mat');
h = mos_tiff_to_fig(min_proj_int, save_name, title_label );

% % Manually for now - get min rectangle
% [ rect_crop_mos, rect_crop ] = mos_cropmovie_gui( mot_corr_movie);
% 
% ICmovie = mosaic.cropMovie(mot_corr_movie, rect_crop_mos(1), rect_crop_mos(4), ...
%     rect_crop_mos(3), rect_crop_mos(2)); % Crop movie
%  % This isn't working for some reason - do in mosaic standalone?

%% Step 7.5: Save MotCorrMovie to be adjusted in Mosaic standalone until I
% 

disp('Saving MotCorrMovie for final editing')
mosaic.saveOneObject(mot_corr_movie,'MotCorrMovie.mat');

disp('Check for MotCorrMovie.mat.  If saved correctly, type "return" and then open Mosaic standalone to do your final editing');

% Display dropped-frame warning if applicable!
if dropped_frame_warn == 1
    disp('DATA HAS ALREADY BEEN DOWN-SAMPLED.  IF YOU HAVE DROPPED FRAMES YOU MAY NEED TO FIX MANUALLY WITH fix_dropped_frames FUNCTION!')
end
mosaic.terminate()
clear all;

% %% Step 8: Create min projection and display
% 
% min_proj = mosaic.projectMovie(ICmovie,'projectionType','Minimum');
% 
% % Save it, reload it, display as image, and tag it with the appropriate
% % title - SHOULD write a function for this! Put in while loop so that the
% % final product stays saved...
% 
% h = mos_tiff_to_fig(min_proj_int, save_name, title_label );
% 
% disp('Here is your chance to re-crop if you are not satisfied')
% keyboard
% 
% %% Step 8: Save it!
% 
% mosaic.saveOneObject(ICmovie,'ICmovie_comb.mat');
% 
% cd(curr_dir)

% mosaic.terminate()
