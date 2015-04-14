function [] = mos_trim_badframes(bad_frames, last_frame, movie_path)
% Chop up a file into pieces and re-combine to eliminate bad frames

%% Variables to set 
mic_per_pix = 1.16; % To match previously used values

% %% Specify frames to trim
% 
% bad_frames = [ 20 45 ]; % [2727 8007 20480 20884 22148 23618];
% last_frame = 66; % 25041; % Have to specify this, unfortunately...


%% Step 0: Initialize
mosaic.terminate(); % terminate any previous sessions
mosaic.initialize();


%% Step 1: Select Files to load, if multiple they will automatically be
% concatenated
if ~exist('movie_path', 'var')
    [filename, pathname] = uigetfile({'*.mat', 'Object Files'},'Select File to load');
    
    if iscell(filename)
        num_files = size(filename,2);
    else
        num_files = 1;
    end
    
    movie_path = [pathname filename];

end

%% Step 2: Load file

badframe_movie = mosaic.loadObjects(movie_path);

keyboard

%% Step 3: Trim Movie

% Get frames to trim
trim_frames = get_trim_frames( bad_frames, last_frame );
num_pieces = size(trim_frames,2);

% Perform trim and get movies
for j = 1:num_pieces
   movie_trim(j).piece = mosaic.trimMovie(badframe_movie, trim_frames{1,j}(1), ...
       trim_frames{1,j}(2));
end

% Make list of movies
trim_list = mosaic.List('mosaic.Movie');
for j = 1:num_pieces
    trim_list.add(movie_trim(j).piece);
end

%% Step 4: Concatenate Trimmed Movies and create minimum projection to check if bad 
% frames are fixed

% Concatenate
CatMovie_goodframes = mosaic.concatenateMovies(trim_list);

% Minimum Projection
min_proj_cattrimmovie = mosaic.projectMovie(CatMovie_goodframes,'projectionType','Minimum');
h = mos_tiff_to_fig(min_proj_cattrimmovie, [pathname 'TrimCatMovie_min_proj.tiff'], ...
    'Min Projection of Trimmed Concatenated Movie with bad frames replaced' );

%% Step 5: Save

disp('Here is your chance to check if this is ok.  Type "return" to save the updated movie as "TrimCatMovie.mat"')
keyboard

mosaic.saveOneObject(CatMovie_goodframes,[pathname 'TrimCatMovie.mat']);

end



