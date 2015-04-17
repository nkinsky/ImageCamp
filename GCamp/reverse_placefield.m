function [ ] = reverse_placefield(folder, speed_thresh, grid_info, movie_type, rot_overwrite, movie_loc, varargin)
% reverse_placefield3(folder, speed_thresh, grid_info, movie_type, rot_overwrite, movie_loc, ...)
% Calculate a reverse place field, that is, the average intensity
% of the brain image when a mouse is in a given area.
%
%
%   INPUTS
%   folder:   working directory where position data (in a file names
% pos_corr_to_std.mat or pos_corr_to_std_no_rotate.mat) and brain imaging
% movie (unless specified differently in movie_loc variable) reside
%
%   speed_thresh: speed threshold in cm/s to use, no data will be included
% when the mouse is moving slower than this threshold.
% grid_info is a data structure that contains info about the occupancy
% grid and is created by running the function "assign_occupancy_grid"
%
%   movie_type: either ICmovie_smooth or ChangeMovie (1st derivative movie).
% If left blank, ChangeMovie will be assumed
% 
%   rot_overwrite: 1 if you wish to analyze data that has NOT been rotated
% such that local features align, 0 or left blank otherwise
%   
%    movie_loc :   if specified, this points to the movie directory.
% Otherwise, it is assumed that the movie is located in the working
% directory with everything else.
%
% ADDITIONAL INPUT ARGUMENTS (mush be listed at end in the form
% "...,argument_name, argument_value, e.g. ...,general_filter,
% ones(1,1000))
% general_filter: general filter to exclude certain frames in the
% analysis!!!
% method: 'z_smooth' or 'DF_smooth' - if blank, z_smooth is default
% pass_thresh: number of passes that the mouse needs to make through a 
% given grid for it to be counted in the final RVP (default = 4)
% smooth_adj: number of adjacent occupancy bins to include in average RVP 
% during smoothing (default = 1)
% num_divs_contol:  Number of divisions to divide your data up to when 
% comparing 1st and 2nd session correlations... (default = 4)
% 
%   OUTPUTS
%   These are all saved to a file "reversep


%%% To-do!!! - update this so that I ONLY save the rvps for the whole
%%% session and then do the correlations for each half within and spit out
%%% a single correlation value.  Also save the analysis type (smooth, DF,
%%% or z-smooth? Or save DF_smooth and variance...

%% Note that I need to set up 2ndary scaling empirically for each arena, and not calculate it based on every session...

close all

%% Variables and File locations
% cmperbin = 5.31; % cm per bin for calculating occupancy
SR = 20; % sample rate in fps
limits_percent = 15;

if ~exist('movie_type','var') || isempty(movie_type) % Assign movie_type if left blank
    movie_type = 'ChangeMovie';
end
movie_name = [movie_type '.h5'];

if ~exist('rot_overwrite','var') % Set rot_overwrite if not indicated
    rot_overwrite = 0; % No rotation of the data is assumed
end

% Set the appropriate location of the movie if it is different than the
% working directory for the session
if ~exist('movie_loc','var')
    movie_path = [folder '\' movie_name];
    movie_loc = folder;
elseif exist('movie_loc','var')
    movie_path = [movie_loc '\' movie_name];
end

% Load the appropriate position data
if rot_overwrite == 0
    save_append = '';
    pos_file = 'pos_corr_to_std.mat';
elseif rot_overwrite == 1
    pos_file = 'pos_corr_to_std_no_rotate.mat';
    save_append = '_no_rotate';
end

%%  Collect varargins and assign appropriate variables
% keyboard
if sum(cellfun(@(a) strcmpi(a,'method'),varargin)) == 1
    method = varargin{find(cellfun(@(a) strcmpi(a,'method'),varargin)) + 1};
else
    method = 'z_smooth';
end

if sum(cellfun(@(a) strcmpi(a,'pass_thresh'),varargin)) == 1
    pass_thresh = varargin{find(cellfun(@(a) strcmpi(a,'pass_thresh'),varargin)) + 1};
else
    pass_thresh = 4;
end

if sum(cellfun(@(a) strcmpi(a,'smooth_adj'),varargin)) == 1
    smooth_adj = varargin{find(cellfun(@(a) strcmpi(a,'smooth_adj'),varargin)) + 1};
else
    smooth_adj = 1;
end

if sum(cellfun(@(a) strcmpi(a,'num_divs_control'),varargin)) == 1
    num_divs_control = varargin{find(cellfun(@(a) strcmpi(a,'num_divs_control'),varargin)) + 1};
else
    num_divs_control = 1;
end

session_path = folder;

%% Check if sll the necessary files are in the working directory

Xedges = grid_info.Xedges;
Yedges = grid_info.Yedges;
NumXBins = grid_info.NumXBins;
NumYBins = grid_info.NumYBins;
cmperbin = grid_info.cmperbin;

cd(session_path)

if exist(pos_file,'file') ~= 2 % Get rid of this!! Just spit out a warning! or error out
    error('YOU NEED TO RUN arena_align before running this function!')
end
    
%% Load position data 
if rot_overwrite == 0
    load pos_corr_to_std.mat
    disp('Using position data aligned and rotated/scaled if necessary')
elseif rot_overwrite == 1
    load pos_corr_to_std_no_rotate.mat
    disp('Using position data that is INTENTIONALLY NOT ROTATED')
end

% Pull coordinates in cm with timestamps matching brain data timestamps
% from pos_corr_to_std.mat file
x = pos_align.x; % Send standardized tracking data to x and y
y = pos_align.y;
t = pos_align.time_interp; % Plexon time interpolated back to inscopix frame rate/timestamps
load('Pos.mat','MoMtime'); % Get time that mouse arrives on maze.

% Calculate speed from standardized tracking data
dx = diff(x);
dy = diff(y);
dt = diff(t);
speed = sqrt(dx.^2+dy.^2)./dt;
speed = [speed speed(end)];

%% Load appropriate movie files
try
    if strcmpi(movie_type,'ICmovie_smooth')
        h5info( movie_path,'/Object');
        F0_savefile = 'F0_ICmovie.mat';
    elseif strcmpi(movie_type,'ChangeMovie')
        h5info( movie_path,'/Object');
        F0_savefile = 'F0_ChangeMovie.mat';
    end
    
catch
    error('You need to have ICmovie_smooth.h5 or ChangeMovie.h5 in this directory')
end

%% 1) Set up speed threshold

if ~exist('speed_thresh','var')
    speed_thresh = 0; % Let everything through if nothing is specified!
    disp('No speed_thresh variable detected, so using zero')
end

%% 2) Align Inscopix and Plexon (tracking) data
% get index_scopix_valid - the indices to the frames that have tracking
% data that accompany them
[~, ~, ~, index_scopix_valid] = AlignImagingToTracking_NK(movie_path, ...
    SR, x, y, t, MoMtime); % Note that this is already run when aligning 
% arenas from one session to another using arena_align or arena_align_batch

% create general_filter to include all values if not added, otherwise
% use the specified one.
if sum(cellfun(@(a) strcmpi(a,'general_filter'),varargin)) == 1
    general_filter = varargin{find(cellfun(@(a) strcmpi(a,'general_filter'),varargin)) + 1};
else
    general_filter = ones(size(x));
end

%% 3) Go through frame by frame and figure out which part of the arena the
% mouse is in

[countsx,Xbin] = histc(x,Xedges);
[countsy,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumXBins+1))) = NumXBins;
Ybin(find(Ybin == (NumYBins+1))) = NumYBins;

Xbin(find(Xbin == 0)) = 1;
Ybin(find(Ybin == 0)) = 1;

% set up velocity filter
vel_filter = speed >= speed_thresh;

x_pos_valid = (x >= min(Xedges) & x <= max(Xedges));
y_pos_valid = (y >= min(Yedges) & y <= max(Yedges));
pos_valid = x_pos_valid & y_pos_valid & general_filter;

%% 4) For each area, add up all the active frames and average

info = h5info(movie_path,'/Object');
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);
F0 = zeros(XDim,YDim);
valid_length = length(index_scopix_valid);

try % Save a bunch of time by loading the mean projection
    load(F0_savefile)
    disp('Using previously saved Mean Projection (F0)')
catch
    
    % Calculate average frame for the movie
    disp('Calculating Mean Projection...')
    
    nn = 0; % Set counter
    for m = 1:length(index_scopix_valid) % This might need to include pos_valid to filter out any frames where the mouse is outside the arena...
        if strcmpi(movie_type,'ICmovie_smooth');
            temp = double(h5read(movie_path,'/Object',[1 1 index_scopix_valid(m) 1],...
                [XDim YDim 1 1]));
        elseif strcmpi(movie_type,'ChangeMovie');
            temp2 = double(h5read(movie_path,'/Object',[1 1 index_scopix_valid(m) 1],...
                [XDim YDim 1 1]));
            temp = zeros(size(temp2));
            temp(temp2 >= 0) = temp2(temp2 >= 0); % Get only positive values for ChangeMovie
        end
        F0 = F0 + temp;
        nn = nn + 1;
        
        if round(m/1000) == m/1000
            disp([ num2str(index_scopix_valid(m)) ' frames out of ' num2str(valid_length) ' completed.'])
        end
        
    end
    F0 = F0/valid_length;
    
    % Calculate Variance
    disp('Calculating Variance...')
    image_var = zeros(XDim,YDim);
    for m = 1:length(index_scopix_valid) % This might need to include pos_valid to filter out any frames where the mouse is outside the arena...
        if strcmpi(movie_type,'ICmovie_smooth');
            temp = double(h5read(movie_path,'/Object',[1 1 index_scopix_valid(m) 1],...
                [XDim YDim 1 1]));
        elseif strcmpi(movie_type,'ChangeMovie');
            temp2 = double(h5read(movie_path,'/Object',[1 1 index_scopix_valid(m) 1],...
                [XDim YDim 1 1]));
            temp = zeros(size(temp2));
            temp(temp2 >= 0) = temp2(temp2 >= 0); % Get only positive values for ChangeMovie
        end
        image_var = image_var + (temp - F0).^2 ;
        nn = nn + 1;
        
        if round(m/1000) == m/1000
            disp([ num2str(index_scopix_valid(m)) ' frames out of ' num2str(valid_length) ' completed.'])
        end
        
    end
    image_var = image_var/valid_length;
    
    
    save(F0_savefile, 'F0','image_var'); % Save F0 for future reference - this is the longest step!!
    
end

% set filter to artificially chop up 1st and 2nd halves of the movie
first_half = zeros(1,valid_length); second_half = zeros(1,valid_length);
first_half(1:floor(valid_length/2)) = ones(1,floor(valid_length/2)) & ...
    pos_valid(1:floor(valid_length/2));
second_half(floor(valid_length/2)+1:valid_length) = ...
    ones(1,floor(length(floor(valid_length/2)+1:valid_length))) & ...
    pos_valid(floor(valid_length/2)+1:valid_length);
[ control1, control2 ] = interleaved_filter( valid_length, num_divs_control );
% Set up control filters - interleaved values...

% Set counters
n = 0; n1 = 0; n2 = 0; counter = 1;
c1 = 0; c2 = 0;
AvgFrame_tot = zeros(XDim,YDim);

% Initialize z-score variables
AvgFrame_z = cell(NumYBins, NumXBins);
[AvgFrame_z{:}] = deal(zeros(size(F0)));
AvgFrame_z_1st = AvgFrame_z;
AvgFrame_z_2nd = AvgFrame_z;
AvgFrame_z_1c = AvgFrame_z;
AvgFrame_z_2c = AvgFrame_z;

tic
disp('Calculating reverse place-fields...')

for i = 1:NumXBins
    for j = 1:NumYBins
        % Progress display
        disp(['Now analyzing bin ' num2str(counter) ' of ' num2str(NumXBins...
            *NumYBins) ' bins.'])
        counter = counter + 1;
        % Initialize Variables
        AvgFrame_1st{j,i} = zeros(XDim,YDim); % 1st half
        AvgFrame_DF_1st{j,i} = zeros(XDim,YDim); % first half DF
        AvgFrame_2nd{j,i} = zeros(XDim,YDim); % second half
        AvgFrame_DF_2nd{j,i} = zeros(XDim,YDim); % second half DF
        AvgFrame{j,i} = zeros(XDim,YDim); % Whole session
        AvgFrame_DF{j,i} = zeros(XDim,YDim); % Whole session DF
        AvgFrame_1c{j,i} = zeros(XDim,YDim); % interleaved control
        AvgFrame_DF_1c{j,i} = zeros(XDim,YDim); % interleaved control
        AvgFrame_2c{j,i} = zeros(XDim,YDim); % interleaved control
        AvgFrame_DF_2c{j,i} = zeros(XDim,YDim); % interleaved control
        
        % Define Active Frames
        ActiveFrames = find(Xbin == i & Ybin == j & vel_filter & pos_valid);
        ActiveFrames_1st = find(Xbin == i & Ybin == j & first_half & vel_filter & pos_valid); % with first half filter
        ActiveFrames_2nd = find(Xbin == i & Ybin == j & second_half & vel_filter & pos_valid);
        ActiveFrames_1c = find(Xbin == i & Ybin == j & control1 & vel_filter & pos_valid); % with first half filter
        ActiveFrames_2c = find(Xbin == i & Ybin == j & control2 & vel_filter & pos_valid);% with 2nd half filter
        num_ActiveFrames(j,i) = length(ActiveFrames); % get number of frames active in each bin
        num_passes(j,i) = sum(diff(ActiveFrames) ~= 1) + 1;
        
        % Select appropriate movie.  Can probably get rid of this in the
        % future and just find the .h5 file name and load it...
        for k = 1:length(ActiveFrames)
            
            if strcmpi(movie_type,'ICmovie_smooth');
                tempFrame = double(h5read(movie_path,'/Object',...
                    [1 1 index_scopix_valid(ActiveFrames(k)) 1],[XDim YDim 1 1])); % m
            elseif strcmpi(movie_type,'ChangeMovie');
                tempFrame2 = double(h5read(movie_path,'/Object',...
                    [1 1 index_scopix_valid(ActiveFrames(k)) 1],[XDim YDim 1 1]));
                tempFrame = zeros(size(tempFrame2));
                tempFrame(tempFrame2 >= 0) = tempFrame2(tempFrame2 >= 0); % Get only positive values for ChangeMovie
            end
            AvgFrame{j,i} = AvgFrame{j,i} + tempFrame;
            
            % Get 1st and 2nd half rvps for within session
            % comparison
            if sum(ActiveFrames_1st == ActiveFrames(k)) == 1
                AvgFrame_1st{j,i} = AvgFrame_1st{j,i} + tempFrame;
                
                n1 = n1 + 1;
            elseif sum(ActiveFrames_2nd == ActiveFrames(k)) == 1
                AvgFrame_2nd{j,i} = AvgFrame_2nd{j,i} + tempFrame;
                
                n2 = n2 + 1;
            else
                disp(['Error - frame '  num2str(ActiveFrames(k))...
                    ' apparently not in 1st or 2nd half of video!'])
            end
            
            % Get 1st and 2nd control session rvps for within
            % session comparison
            if sum(ActiveFrames_1c == ActiveFrames(k)) == 1
                AvgFrame_1c{j,i} = AvgFrame_1c{j,i} + tempFrame;
                
                c1 = c1 + 1;
            elseif sum(ActiveFrames_2c == ActiveFrames(k)) == 1
                AvgFrame_2c{j,i} = AvgFrame_2c{j,i} + tempFrame;
                
                c2 = c2 + 1;
            else
                disp(['Error - frame '  num2str(ActiveFrames(k))...
                    ' apparently not in 1st or 2nd half of control data!'])
            end
            
            n = n+1;
            
        end
        
        
        % Calculate average frames - take summed frames and divide by
        % number of frames
        AvgFrame_tot = AvgFrame_tot + AvgFrame{j,i}; % Not used later, just a check
        AvgFrame{j,i} = AvgFrame{j,i}/length(ActiveFrames);
        AvgFrame_1st{j,i} = AvgFrame_1st{j,i}/length(ActiveFrames_1st);
        AvgFrame_2nd{j,i} = AvgFrame_2nd{j,i}/length(ActiveFrames_2nd);
        % Subtract mean frame and divide by mean frame
        AvgFrame_DF{j,i} = (AvgFrame{j,i} - F0)./F0;
        AvgFrame_DF_1st{j,i} = (AvgFrame_1st{j,i} - F0)./F0;
        AvgFrame_DF_2nd{j,i} = (AvgFrame_2nd{j,i} - F0)./F0;
        % Subtract mean frame Divide by variance to z-score
        AvgFrame_z{j,i}(:) = (AvgFrame{j,i}(:) - F0(:))./sqrt(image_var(:));
        AvgFrame_z_1st{j,i}(:) = (AvgFrame_1st{j,i}(:) - F0(:))./sqrt(image_var(:));
        AvgFrame_z_2nd{j,i}(:) = (AvgFrame_2nd{j,i}(:) - F0(:))./sqrt(image_var(:));
        % Control data
        AvgFrame_1c{j,i} = AvgFrame_1c{j,i}/length(ActiveFrames_1c);
        AvgFrame_DF_1c{j,i} = (AvgFrame_1c{j,i} - F0)./F0;
        AvgFrame_2c{j,i} = AvgFrame_2c{j,i}/length(ActiveFrames_2c);
        AvgFrame_DF_2c{j,i} = (AvgFrame_2c{j,i} - F0)./F0;
        AvgFrame_z_1c{j,i}(:) = (AvgFrame_1c{j,i}(:) - F0(:))./sqrt(image_var(:));
        AvgFrame_z_2c{j,i}(:) = (AvgFrame_2c{j,i}(:) - F0(:))./sqrt(image_var(:));
        
    end
end
toc
%% Smoothing! - NRK NOTE: insert smooth_rvp here

keyboard
tic
disp(['Smoothing Data based on the ' num2str(smooth_adj) ' closest bin(s).'])

AvgFrame_DF_smooth = smooth_rvp( AvgFrame_DF, smooth_adj );
AvgFrame_z_smooth = smooth_rvp( AvgFrame_z, smooth_adj );
AvgFrame_DF_1st_smooth = smooth_rvp( AvgFrame_DF_1st, smooth_adj );
AvgFrame_z_1st_smooth = smooth_rvp( AvgFrame_z_1st, smooth_adj );
AvgFrame_DF_2nd_smooth = smooth_rvp( AvgFrame_DF_2nd, smooth_adj );
AvgFrame_z_2nd_smooth = smooth_rvp( AvgFrame_z_2nd, smooth_adj );
% Control data
AvgFrame_DF_1c_smooth = smooth_rvp( AvgFrame_DF_1c, smooth_adj );
AvgFrame_z_1c_smooth = smooth_rvp( AvgFrame_z_1c, smooth_adj );
AvgFrame_DF_2c_smooth = smooth_rvp( AvgFrame_DF_2c, smooth_adj );
AvgFrame_z_2c_smooth = smooth_rvp( AvgFrame_z_2c, smooth_adj );

toc


%% Calculate Occupancy in seconds
Occmap = num_ActiveFrames/SR; % Note this is the VELOCITY-FILTERED Occupancy map

% Assign nans to any frames that don't meet the require number of
% passes criteria
Occmap(num_passes(:) < pass_thresh) = nan*ones(sum(num_passes(:) < ...
    pass_thresh),1);

%% Plot Stuff - Uncomment if you need to check how everything looks
%     % Plot Reverse Place-field
%     figure(10)
%     for i = 1:NumYBins
%         for j = 1:NumXBins
%             subplot(NumYBins,NumXBins,(i-1)*NumXBins+j)
%             imagesc(AvgFrame{i,j}); colormap(gray);colorbar
%
%         end
%     end
%
%     % Corners only
%     figure(100)
%     x2 = [1 NumXBins];
%     y2 = [1 NumYBins];
%     for i = 1:length(y2)
%         for j = 1:length(x2)
%             subplot(length(y2),length(x2),(i-1)*length(x2)+j)
%             imagesc(AvgFrame{y2(i),x2(j)}); colormap(gray);colorbar
%
%         end
%
%     end
%
%     % Plot DF/F place-field
%     figure(11)
%     for i = 1:NumYBins
%         for j = 1:NumXBins
%             subplot(NumYBins,NumXBins,(i-1)*NumXBins+j)
%             imagesc(AvgFrame_DF{i,j}); colormap(gray); colorbar
%
%         end
%     end
%
%     % Corners only
%     figure(111)
%     x2 = [1 NumXBins];
%     y2 = [1 NumYBins];
%     for i = 1:length(y2)
%         for j = 1:length(x2)
%             subplot(length(y2),length(x2),(i-1)*length(x2)+j)
%             imagesc(AvgFrame_DF{y2(i),x2(j)}); colormap(gray);colorbar
%
%         end
%     end
%
%% Calculate correlations between 1st and 2nd half of exploration...
for j=1:NumYBins
    for i = 1:NumXBins
        temp = corrcoef(AvgFrame_DF_1st_smooth{j,i},AvgFrame_DF_2nd_smooth{j,i});
        corr_1st_2nd(j,i) = temp(1,2);
        tempz = corrcoef(AvgFrame_z_1st_smooth{j,i},AvgFrame_z_2nd_smooth{j,i});
        corr_1st_2nd_z(j,i) = tempz(1,2);
        temp_c = corrcoef(AvgFrame_DF_1c_smooth{j,i},AvgFrame_DF_2c_smooth{j,i});
        corr_1st_2ndc(j,i) = temp_c(1,2);
        tempz_c = corrcoef(AvgFrame_z_1c_smooth{j,i},AvgFrame_z_2c_smooth{j,i});
        corr_1st_2nd_zc(j,i) = tempz_c(1,2);
    end
end

% Stuff these all correlations into one structure
corrs.use_1_2_DF = nanmean(corr_1st_2nd(:));
corrs.use_1_2_z = nanmean(corr_1st_2nd_z(:));
corrs.control_1_2_DF = nanmean(corr_1st_2ndc(:));
corrs.control_1_2_z = nanmean(corr_1st_2nd_zc(:));

%     keyboard

%% Save stuff
% Flip everything to match Occmap and occupancy grids - stupid MATLAB
% plotting convention makes this necessary
disp('Saving Data to .mat file')
AvgFrame = flipud(AvgFrame);
AvgFrame_DF = flipud(AvgFrame_DF);
AvgFrame_1st = flipud(AvgFrame_1st);
AvgFrame_2nd = flipud(AvgFrame_2nd);
AvgFrame_DF_1st = flipud(AvgFrame_DF_1st);
AvgFrame_DF_2nd = flipud(AvgFrame_DF_2nd);
AvgFrame_DF_smooth = flipud(AvgFrame_DF_smooth);
AvgFrame_DF_1st_smooth = flipud(AvgFrame_DF_1st_smooth);
AvgFrame_DF_2nd_smooth = flipud(AvgFrame_DF_2nd_smooth);
AvgFrame_z_smooth = flipud(AvgFrame_z_smooth);
AvgFrame_z_1st_smooth = flipud(AvgFrame_z_1st_smooth);
AvgFrame_z_2nd_smooth = flipud(AvgFrame_z_2nd_smooth);

% Set savenames for data
if strcmpi(movie_type,'ICmovie_smooth')
    savename = [ 'reverse_placefields' save_append '.mat'];
elseif strcmpi(movie_type,'ChangeMovie')
    savename = [ 'reverse_placefields_ChangeMovie' save_append '.mat'];
end

% Save data, but ONLY specified method to save space!!!
if strcmpi(method,'z_smooth')
    save(savename, 'F0', 'image_var', ...
        'AvgFrame_z_smooth', 'AvgFrame_z_1st_smooth', ...
        'AvgFrame_z_2nd_smooth', 'Occmap', 'cmperbin', 'Xedges', 'Yedges', ...
        'speed_thresh', 'x', 'y', 't', 'limits_percent','corrs','-v7.3');
elseif strcmpi(method,'DF_smooth')
    save(savename, 'F0', 'image_var', 'AvgFrame_DF_smooth', ...
        'AvgFrame_DF_1st_smooth', 'AvgFrame_DF_2nd_smooth', ...
        'Occmap', 'cmperbin', 'Xedges', 'Yedges', ...
        'speed_thresh', 'x', 'y', 't', 'limits_percent','corrs','-v7.3');
end

%% TO-DO
% 1) Cut down on file size!!! calculate within session correlations in this
% function (use corr_bw_sessions and get appropriate region to exclude) and 
% just save those values -- don't save RVPs.  Also, only save the 
% AvgFrame_z_smooth and maybe AvgFrame_DF for now...


end

