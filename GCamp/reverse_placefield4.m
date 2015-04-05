function [ ] = reverse_placefield4(folder, speed_thresh, grid_info, movie_type, rot_overwrite)
% reverse_placefield3(folder, speed_thresh, Xedges, Yedges, cmperbin)
% Version 4 - updated all the RVP plots and Occmap so that they match the
% occupancy grid when plotted next to it and doing things like rotating
% them 90 degrees works properly
% Version 3 - using tracking data that has already been sent to a standardized
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
pass_thresh = 4; % number of passes that the mouse needs to make through a given grid for it to be counted in the final RVP
smooth_adj = 1; % number of adjacent occupancy bins to include in average RVP during smoothing
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

%% Check if sll the necessary files are in the working directory

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
        
        if round(m/1000) == m/1000
            disp([ num2str(m - start_skip) ' frames out of ' num2str(ICmovieLength - start_skip) ' completed.'])
        end
        
    end
    F0 = F0/(ICmovieLength-start_skip);
    
    % Calculate Variance
    disp('Calculating Variance...')
    image_var = zeros(XDim,YDim);
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
        image_var = image_var + (temp - F0).^2 ;
        nn = nn + 1;
        
        if round(m/1000) == m/1000
            disp([ num2str(m - start_skip) ' frames out of ' num2str(ICmovieLength - start_skip) ' completed.'])
        end
        
    end
    image_var = image_var/(ICmovieLength-start_skip);
    
    
    save(F0_savefile, 'F0','image_var'); % Save F0 for future reference - this is the longest step!!
    
    end
    
    % set filter to artificially chop up 1st and 2nd halves of the movie
    first_half = zeros(1,FTLength); second_half = zeros(1,FTLength);
    first_half(1:floor(FTLength/2)) = ones(1,floor(FTLength/2));
    second_half(floor(FTLength/2)+1:FTLength) = ...
        ones(1,floor(length(floor(FTLength/2)+1:FTLength)));
    
    % Set counters
    n = 0; n1 = 0; n2 = 0; counter = 1;
    AvgFrame_tot = zeros(XDim,YDim);
    
    % Initialize z-score variables
    AvgFrame_z = cell(NumYBins, NumXBins);
    [AvgFrame_z{:}] = deal(zeros(size(F0)));
    AvgFrame_z_1st = AvgFrame_z;
    AvgFrame_z_2nd = AvgFrame_z;
    
    tic
    disp('Calculating reverse place-fields...')
    
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
            num_passes(j,i) = sum(diff(ActiveFrames) ~= 1) + 1;
            
            % Sum up active frames
%             temp_all = []; temp_1 = []; temp_2 = [];
                for k = 1:length(ActiveFrames)
                    
                    if strcmpi(movie_type,'ICmovie_smooth');
                        tempFrame = double(h5read('ICmovie_smooth.h5','/Object',...
                            [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1])); % m
                    elseif strcmpi(movie_type,'ChangeMovie');
                        tempFrame2 = double(h5read('ChangeMovie.h5','/Object',...
                            [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1]));
                        tempFrame = zeros(size(tempFrame2));
                        tempFrame(tempFrame2 >= 0) = tempFrame2(tempFrame2 >= 0); % Get only positive values for ChangeMovie
                    end
                    AvgFrame{j,i} = AvgFrame{j,i} + tempFrame;
%                     temp_all = [temp_all tempFrame(:)];
                    %                 tempFrame = double(h5read('ICmovie_smooth.h5','/Object',...
                    %                     [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1]));
                    %                 AvgFrame{j,i} = AvgFrame{j,i} + tempFrame;
                    if sum(ActiveFrames_1st == ActiveFrames(k)) == 1
                        AvgFrame_1st{j,i} = AvgFrame_1st{j,i} + tempFrame;
%                         temp_1 = [temp_1 tempFrame(:)];
                        n1 = n1 + 1;
                    elseif sum(ActiveFrames_2nd == ActiveFrames(k)) == 1
                        AvgFrame_2nd{j,i} = AvgFrame_2nd{j,i} + tempFrame;
%                         temp_2 = [temp_2 tempFrame(:)];
                        n2 = n2 + 1;
                    else
                        disp(['Error - frame '  num2str(ActiveFrames(k))...
                            ' apparently not in 1st or 2nd half of video!'])
                    end
                    n = n+1;
                    

                end

                % Get mean and variance out of this
%                 var_all = nanvar(temp')';
%                 AvgFrame_var{j,i} = zeros(size(tempFrame));
%                 AvgFrame_var{j,i}(:) = var_all; % for visualization only, may want to delete to save space!!!
%                 AvgFrame_meancheck{j,i} = zeros(size(tempFrame)); % For later comparison to AvgFrame...
%                 AvgFrame_meancheck{j,i}(:) = nanmean(temp')'; % 
%                 var_1st = nanvar(temp_1')';
%                 var_2nd = nanvar(temp_2')';
                % Calculate average frames
                AvgFrame_tot = AvgFrame_tot + AvgFrame{j,i};
                AvgFrame{j,i} = AvgFrame{j,i}/length(ActiveFrames);
                AvgFrame_1st{j,i} = AvgFrame_1st{j,i}/length(ActiveFrames_1st);
                AvgFrame_DF_1st{j,i} = (AvgFrame_1st{j,i} - F0)./F0;
                AvgFrame_2nd{j,i} = AvgFrame_2nd{j,i}/length(ActiveFrames_2nd);
                AvgFrame_DF_2nd{j,i} = (AvgFrame_2nd{j,i} - F0)./F0;
                AvgFrame_DF{j,i} = (AvgFrame{j,i} - F0)./F0;
                AvgFrame_DF2{j,i} = AvgFrame_DF2{j,i}/length(ActiveFrames);
                AvgFrame_z{j,i}(:) = (AvgFrame{j,i}(:) - F0(:))./sqrt(image_var(:));
                AvgFrame_z_1st{j,i}(:) = (AvgFrame_1st{j,i}(:) - F0(:))./sqrt(image_var(:));
                AvgFrame_z_2nd{j,i}(:) = (AvgFrame_2nd{j,i}(:) - F0(:))./sqrt(image_var(:));
        end
    end
    toc
    %% Smoothing!
    tic
    disp(['Smoothing Data based on the ' num2str(smooth_adj) ' closest bin(s).'])
    for i = 1:NumXBins
        for j = 1:NumYBins
            [ind_near_bins] = get_nearest_indices(j, i, ...
                NumYBins, NumXBins, smooth_adj);
            temp = zeros(size(AvgFrame_DF{j,i})); nn = 0; tempz = temp;
%             temp_check = temp;
            temp1 = temp; nn1 = 0; tempz1 = temp1;
            temp2 = temp; nn2 = 0; tempz2 = temp2;
            for k = 1:length(ind_near_bins)
               temp(:) = nansum([temp(:) AvgFrame_DF{ind_near_bins(k)}(:)],2);
               tempz(:) = nansum([temp(:) AvgFrame_z{ind_near_bins(k)}(:)],2);
%                temp_check = temp_check + AvgFrame_DF{ind_near_bins(k)};
               nn = nn + ~isnan(sum(AvgFrame_DF{ind_near_bins(k)}(:))); % Adds only if the RVP is not NaN
               temp1(:) = nansum([temp1(:) AvgFrame_DF_1st{ind_near_bins(k)}(:)],2);
               tempz1(:) = nansum([tempz1(:) AvgFrame_z_1st{ind_near_bins(k)}(:)],2);
               nn1 = nn1 + ~isnan(sum(AvgFrame_DF_1st{ind_near_bins(k)}(:)));
               temp2(:) = nansum([temp2(:) AvgFrame_DF_2nd{ind_near_bins(k)}(:)],2);
               tempz2(:) = nansum([tempz2(:) AvgFrame_z_2nd{ind_near_bins(k)}(:)],2);
               nn2 = nn2 + ~isnan(sum(AvgFrame_DF_2nd{ind_near_bins(k)}(:)));
            end
            
            AvgFrame_DF_smooth{j,i} = temp/nn;
            AvgFrame_z_smooth{j,i} = tempz/nn;
%             AvgFrame_DF_smooth_check{j,i} =
%             temp_check/length(ind_near_bins); % Used to verify everything
%             is running correctly
            AvgFrame_DF_1st_smooth{j,i} = temp1/nn1;
            AvgFrame_z_1st_smooth{j,i} = tempz1/nn1;
            AvgFrame_DF_2nd_smooth{j,i} = temp2/nn2;
            AvgFrame_z_2nd_smooth{j,i} = tempz2/nn2;
            
            % Make sure appropriate frames get sent back to NaN if they
            % started like that - don't let smoothing making them ok
            if isnan(sum(AvgFrame_DF{j,i}(:)))
                AvgFrame_DF_smooth{j,i}(:) = NaN*ones(size(AvgFrame_DF{j,i}(:)));
                AvgFrame_z_smooth{j,i}(:) = NaN*ones(size(AvgFrame_z{j,i}(:)));
            end
            if isnan(sum(AvgFrame_DF_1st{j,i}(:)))
                AvgFrame_DF_1st_smooth{j,i}(:) = NaN*ones(size(AvgFrame_DF_1st{j,i}(:)));
                AvgFrame_z_1st_smooth{j,i}(:) = NaN*ones(size(AvgFrame_z_1st{j,i}(:)));
            end
            if isnan(sum(AvgFrame_DF_2nd{j,i}(:)))
                AvgFrame_DF_2nd_smooth{j,i}(:) = NaN*ones(size(AvgFrame_DF_2nd{j,i}(:)));
                AvgFrame_z_2nd_smooth{j,i}(:) = NaN*ones(size(AvgFrame_z_2nd{j,i}(:)));
            end
            
        end
    end
    toc
    
    %% Calculate Occupancy in seconds
    Occmap = num_ActiveFrames/SR; % Note this is the VELOCITY-FILTERED Occupancy map
    
    % Assign nans to any frames that don't meet the require number of
    % passes criteria
    Occmap(num_passes(:) < pass_thresh) = nan*ones(sum(num_passes(:) < ...
        pass_thresh),1);
    
    %% Plot Stuff
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
    
    %% Save stuff
    % Flip everything to match Occmap and occupancy grids
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
    
    
    if strcmpi(movie_type,'ICmovie_smooth')
        savename = [ 'reverse_placefields' save_append '.mat'];
    elseif strcmpi(movie_type,'ChangeMovie')
        savename = [ 'reverse_placefields_ChangeMovie' save_append '.mat'];
    end

    save(savename, 'F0', 'image_var', 'AvgFrame_DF', 'AvgFrame_DF_smooth', ...
    'AvgFrame_DF_1st', 'AvgFrame_DF_1st_smooth', 'AvgFrame_DF_2nd', ...
    'AvgFrame_DF_2nd_smooth', 'AvgFrame_z_smooth', 'AvgFrame_z_1st_smooth', ...
    'AvgFrame_z_2nd_smooth', 'Occmap', 'cmperbin', 'Xedges', 'Yedges', ...
    'speed_thresh', 'x', 'y', 't', 'limits_percent','-v7.3');
    
    %% 5) Done! - then compare each between sessions for the first Nov19!!
%     disp([num2str(FTLength-total_frames) ' frames missing due to being outside the occupancy grid'])
%     disp('Here is your chance to mess around with the data before closing the function')
%     keyboard
    
end

%% TO-DO
% 1) Cut down on file size!!! calculate within session correlations in this
% function (use corr_bw_sessions and get appropriate region to exclude) and 
% just save those values -- don't save RVPs.  Also, only save the 
% AvgFrame_z_smooth and maybe AvgFrame_DF for now...


end

