function [ ] = reverse_placefield3(folder, speed_thresh, grid_info, movie_type, rot_overwrite)
% reverse_placefield3(folder, speed_thresh, Xedges, Yedges, cmperbin)
% Version using tracking data that has already been sent to a standardized
% location in centimeters using the function "arena_align"
% Calculate a reverse place field, that is, the average intensity
% of the brain image when a mouse is in a given area
% speed_thresh is speed threshold in cm/s to use, no data will be included
% when the mouse is moving slower than this threshold.
%
% working directory: NEED TO HAVE: ICmovie_smooth.h5, PlaceMaps.mat, and 
% pos_corr_to_std.mat in the directory .
% grid_info is a data structure that contains info about the occupancy
% grid:
% cmperbin is not really used, but required as an input so that it gets
% saved in the end.
% Xedges and Yedges are the limits for the occupancy grid calculated using
% the function "assign_occupancy_grid"
% movie_type: either ICmovie_smooth or ChangeMovie (1st derivative movie).
% If left blank, ICmovie_smooth will be assumed
% rot_overwrite: 1 if you wish to analyze data that has NOT been rotated
% such that local features align, 0 or left blank otherwise

%% Note that I need to set up 2ndary scaling empirically for each arena, and not calculate it based on every session...

close all

%% Variables and File locations
% cmperbin = 5.31; % cm per bin for calculating occupancy
SR = 20; % sample rate in fps
Pix2Cm = 0.15; % this is for 201b and is a hack until I get this saved in all the PlaceMaps.mat files
% arena_effective_limits = [8 8];

% global limits_percent % Ensures that if I miss this somewhere it carries through
limits_percent = 5; % input for get_occupancy_limits below.  Tweak to make sure your occupancy maps line up correctly.

if ~exist('movie_type','var') % Assign movie_type if left blank
    movie_type = 'ICmovie_smooth';
end
movie_name = [movie_type '.h5'];

if ~exist('rot_overwrite','var') % Set rot_overwrite if not indicated
    rot_overwrite = 0;
end

if rot_overwrite == 0
    save_append = '';
    pos_file = 'pos_corr_to_std.mat';
elseif rot_overwrite == 1
    pos_file = 'pos_corr_to_std_no_rotate.mat';
    save_append = '_no_rotate';
end
% Adjust this appropriately if you aren't using dropbox to store all your
% % files
% dropbox_path = 'C:\Users\Nat\Dropbox\';
% calibration_file = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_correction.mat'];

session_path = folder; % uigetdir('','Select the Working directory for the session you wish to analyze:');

%% Check if Placemaps and FLmovie are in the correct spot

Xedges = grid_info.Xedges;
Yedges = grid_info.Yedges;
NumXBins = grid_info.NumXBins;
NumYBins = grid_info.NumYBins;
cmperbin = grid_info.cmperbin;

cd(session_path)

if exist(pos_file,'file') ~= 2
    disp('YOU NEED TO RUN arena_align before running this function!')
else
    
    if rot_overwrite == 0
        load pos_corr_to_std.mat
        disp('Using position data aligned and rotated/scaled if necessary')
    elseif rot_overwrite == 1
        load pos_corr_to_std_no_rotate.mat
        disp('Using position data that is INTENTIONALLY NOT ROTATED')
    end
    
    x = pos_align.x; % Send standardized tracking data to x and y
    y = pos_align.y;
    
    disp('Loading PlaceMaps data for FT size');
    load('PlaceMaps.mat','FT','speed','t')

    %%% Don't thinks this is necessary %%%
    % try
    %     load Pos.mat
    % catch
    %     error('You need to have Pos.mat in this directory')
    % end
    
    
    try
        if strcmpi(movie_type,'ICmovie_smooth')
            h5info('ICmovie_smooth.h5','/Object');
            F0_savefile = 'F0_ICmovie.mat';
        elseif strcmpi(movie_type,'ChangeMovie')
            h5info('ChangeMovie.h5','/Object');
            F0_savefile = 'F0_ChangeMovie.mat';
        end
        
    catch
        error('You need to have Icmovie_smooth.h5 or ChangeMovie.h5 in this directory')
    end
    
    %% 1) Set up speed thresh
    
    if ~exist('speed_thresh','var')
        speed_thresh = 0;
        disp('No speed_thresh variable detected, so using zero')
    end
    
    %%% NRK - WILL WANT TO USE THIS TO ADJUST SESSION 2 INFO if necessary
    % % Manually set outside boundaries in case any tracking jumps outside the
    % % arena
    % figure(1)
    % plot(x,y);
    %
    % disp('Left click to define outer limits or the arena.  Right click to finish')
    % [xarena, yarena] = getpts(1);
    %
    % in = inpolygon(x,y,xarena,yarena);
    %
    % in_index = find(in);
    % out_index = find(~in);
    % temp = []; replace = [];
    % for j = 1:length(out_index)
    %     temp = findclosest(out_index(j),in_index);
    %     replace(j) = in_index(temp);
    % end
    %
    % xnew = x; ynew = y;
    % for j = 1:length(out_index)
    %     xnew(out_index(j)) = x(replace(j));
    %     ynew(out_index(j)) = y(replace(j));
    % end
    %
    % x = xnew; y = ynew;
    
    %% 2) Divy up the arena into appropriate areas - NOT DONE HERE IN THIS FUNCTION, DONE AHEAD OF TIME!
    %%% NRK NOTE - this is done ahead of time in wrapper function
    %%% to keep this the same between sessions 1 and 2.
    
    % Set up binning and smoothers for place field analysis
    % Dombeck used 2.5 cm bins
    
    
    % Should plot out BOTH grids and paths if this is the 2nd session!
    
    %% 3) Go through frame by frame and figure out which part of the arena the
    % mouse is in - this will be the tough part!!! steal a bunch of code from
    % Dave's CalculatePlacefieldsDec
    
    [countsx,Xbin] = histc(x,Xedges);
    [countsy,Ybin] = histc(y,Yedges);
    
    Xbin(find(Xbin == (NumXBins+1))) = NumXBins;
    Ybin(find(Ybin == (NumYBins+1))) = NumYBins;
    
    Xbin(find(Xbin == 0)) = 1;
    Ybin(find(Ybin == 0)) = 1;
    
%     total_frames = sum(countsx) + sum(countsy);
    
    % set up velocity filter
    
    vel_filter = speed >= speed_thresh;
    
    
    %% 4) For each area, add up all the active frames and average
    
    % Get number of frames to ignore from beginning of movie
    info = h5info(movie_name,'/Object');
    ICmovieLength = info.Dataspace.Size(3);
    XDim = info.Dataspace.Size(1);
    YDim = info.Dataspace.Size(2);
    FTLength = size(FT,2);
    start_skip = ICmovieLength - FTLength; % Need to verify if this is correct!
    
    %%% ARE THESE CORRECT? DOES THIS FRAME ACTUALLY COINCIDE WITH THE MOUSE
    %%% BEING IN THIS POSITION???
    
    try % Save a bunch of time by loading the mean projection
        load(F0_savefile)
        disp('Using previously save Mean Projection (F0)')
    catch
    % Calculate average frame for the movie
    disp('Calculating Mean Projection...')
    F0 = zeros(XDim,YDim);
    nn = 0; % Set counter
    for m = 1+start_skip:ICmovieLength
        if strcmpi(movie_type,'ICmovie_smooth');
            temp = double(h5read('ICmovie_smooth.h5','/Object',[1 1 m 1],...
                [XDim YDim 1 1]));
        elseif strcmpi(movie_type,'ChangeMovie');
            temp2 = double(h5read('ChangeMovie.h5','/Object',[1 1 m 1],...
                [XDim YDim 1 1]));
            temp = zeros(size(temp2));
            temp(temp2 >= 0) = temp2(temp2 >= 0); % Get only positive values for ChangeMovie 
        end
        F0 = F0 + temp;
        nn = nn + 1;
        
    end
    F0 = F0/(ICmovieLength-start_skip);
    
    save(F0_savefile, 'F0'); % Save F0 for future reference - this is the longest step!!
    
    end
    
    % set filter to artificially chop up 1st and 2nd halves of the movie
    first_half = zeros(1,FTLength); second_half = zeros(1,FTLength);
    first_half(1:floor(FTLength/2)) = ones(1,floor(FTLength/2));
    second_half(floor(FTLength/2)+1:FTLength) = ...
        ones(1,floor(length(floor(FTLength/2)+1:FTLength)));
    
    % Set counters
    n = 0; n1 = 0; n2 = 0; counter = 1;
    AvgFrame_tot = zeros(XDim,YDim);
    for i = 1:NumXBins
        for j = 1:NumYBins
            % Progress display
            disp(['Now analyzing bin ' num2str(counter) ' of ' num2str(NumXBins...
                *NumYBins) ' bins.'])
            counter = counter + 1;
            % Initialize Variables
            AvgFrame_1st{j,i} = zeros(XDim,YDim);
            AvgFrame_DF_1st{j,i} = zeros(XDim,YDim);
            AvgFrame_2nd{j,i} = zeros(XDim,YDim);
            AvgFrame_DF_2nd{j,i} = zeros(XDim,YDim);
            AvgFrame{j,i} = zeros(XDim,YDim);
            AvgFrame_DF{j,i} = zeros(XDim,YDim);
            AvgFrame_DF2{j,i} = zeros(XDim,YDim);
            
            % Define Active Frames
            ActiveFrames = find(Xbin == i & Ybin == j & vel_filter);
            ActiveFrames_1st = find(Xbin == i & Ybin == j & first_half & vel_filter); % with first half filter
            ActiveFrames_2nd = find(Xbin == i & Ybin == j & second_half & vel_filter); % with 2nd half filter
            num_ActiveFrames(j,i) = length(ActiveFrames); % get number of frames active in each bin
            
            % Sum up active frames
            for k = 1:length(ActiveFrames)
                if strcmpi(movie_type,'ICmovie_smooth');
                    tempFrame = double(h5read('ICmovie_smooth.h5','/Object',...
                    [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1]));
                elseif strcmpi(movie_type,'ChangeMovie');
                    tempFrame2 = double(h5read('ChangeMovie.h5','/Object',...
                    [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1]));
                    tempFrame = zeros(size(tempFrame2));
                    tempFrame(tempFrame2 >= 0) = tempFrame2(tempFrame2 >= 0); % Get only positive values for ChangeMovie
                end
                AvgFrame{j,i} = AvgFrame{j,i} + tempFrame;
%                 tempFrame = double(h5read('ICmovie_smooth.h5','/Object',...
%                     [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1]));
%                 AvgFrame{j,i} = AvgFrame{j,i} + tempFrame;
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
                AvgFrame_DF2{j,i} = AvgFrame_DF2{j,i} + (tempFrame - F0)./F0;
                n = n+1;
            end
            
            % Calculate average frames
            AvgFrame_tot = AvgFrame_tot + AvgFrame{j,i};
            AvgFrame{j,i} = AvgFrame{j,i}/length(ActiveFrames);
            AvgFrame_1st{j,i} = AvgFrame_1st{j,i}/length(ActiveFrames_1st);
            AvgFrame_DF_1st{j,i} = (AvgFrame_1st{j,i} - F0)./F0;
            AvgFrame_2nd{j,i} = AvgFrame_2nd{j,i}/length(ActiveFrames_2nd);
            AvgFrame_DF_2nd{j,i} = (AvgFrame_2nd{j,i} - F0)./F0;
            AvgFrame_DF{j,i} = (AvgFrame{j,i} - F0)./F0;
            AvgFrame_DF2{j,i} = AvgFrame_DF2{j,i}/length(ActiveFrames);
        end
        
    end
    
    % Calculate Occupancy in seconds
    
    Occmap = num_ActiveFrames/SR; % Note this is the VELOCITY-FILTERED Occupancy map
    
    % Plot Reverse Place-field
    figure(10)
    for i = 1:NumYBins
        for j = 1:NumXBins
            subplot(NumYBins,NumXBins,(i-1)*NumXBins+j)
            imagesc(AvgFrame{i,j}); colormap(gray);colorbar
            
        end
    end
    
    % Corners only
    figure(100)
    x2 = [1 NumXBins];
    y2 = [1 NumYBins];
    for i = 1:length(y2)
        for j = 1:length(x2)
            subplot(length(y2),length(x2),(i-1)*length(x2)+j)
            imagesc(AvgFrame{y2(i),x2(j)}); colormap(gray);colorbar
            
        end
        
    end
    
    % Plot DF/F place-field
    figure(11)
    for i = 1:NumYBins
        for j = 1:NumXBins
            subplot(NumYBins,NumXBins,(i-1)*NumXBins+j)
            imagesc(AvgFrame_DF{i,j}); colormap(gray); colorbar
            
        end
    end
    
    % Corners only
    figure(111)
    x2 = [1 NumXBins];
    y2 = [1 NumYBins];
    for i = 1:length(y2)
        for j = 1:length(x2)
            subplot(length(y2),length(x2),(i-1)*length(x2)+j)
            imagesc(AvgFrame_DF{y2(i),x2(j)}); colormap(gray);colorbar
            
        end
    end
    
    % Calculate correlations between 1st and 2nd half of exploration...
    for j=1:NumYBins
        for i = 1:NumXBins
            temp = corrcoef(AvgFrame_DF_1st{j,i},AvgFrame_DF_2nd{j,i});
            corr_1st_2nd(j,i) = temp(1,2);
        end
    end
    
    % Flip Occmap to match everything else
    Occmap = flipud(Occmap);
    
    if strcmpi(movie_type,'ICmovie_smooth')
        savename = [ 'reverse_placefields' save_append '.mat'];
    elseif strcmpi(movie_type,'ChangeMovie')
        savename = [ 'reverse_placefields_ChangeMovie' save_append '.mat'];
    end
    save(savename, 'AvgFrame', 'F0', 'AvgFrame_DF', 'AvgFrame_1st', ...
        'AvgFrame_DF_1st', 'AvgFrame_2nd', 'AvgFrame_DF_2nd', 'Occmap',...
        'cmperbin', 'Xedges', 'Yedges', 'speed_thresh', 'x', 'y', 't', ...
        'limits_percent');
    
    %% 5) Done! - then compare each between sessions for the first Nov19!!
%     disp([num2str(FTLength-total_frames) ' frames missing due to being outside the occupancy grid'])
%     disp('Here is your chance to mess around with the data before closing the function')
%     keyboard
    
end

%% From Dave for neuron specific reverse place fields

% for i = 1:NumNeurons
%     AvgFrame{i} = zeros(Xdim,Ydim);
%
%     ActiveFrames = find(poopsioutput(i,:) == 1);
%
%     for j = 1:length(ActiveFrames)
%         tempFrame = loadFrame(j)
%         AvgFrame{i} = AvgFrame{i} + tempFrame;
%     end
%     AvgFrame{i} = AvgFrame{i}./length(ActiveFrames);
% end


end

