function [ ] = reverse_placefield(cmperbin, rot, speed_thresh)
%reverse_placefield(cmperbin, rot, speed_thresh)
% Calculate a reverse place field, that is, the average intensity
% of the brain image when a mouse is in a given area
% note that rot is the direction you want to rotate the data to get it BACK
% to normal orientation (e.g. if the arena was rotated 90 degrees CW for
% the recording session, you would want to rotate it 90 CCW to get it
% back)

%% Note that I need to set up 2ndary scaling empirically for each arena, and not calculate it based on every session...

close all

%% Variables and File locations
% cmperbin = 5.31; % cm per bin for calculating occupancy
SR = 20; % sample rate in fps
Pix2Cm = 0.15; % this is for 201b and is a hack until I get this saved in all the PlaceMaps.mat files
arena_effective_limits = [8 8];

global limits_percent % Ensures that if I miss this somewhere it carries through
limits_percent = 5; % input for get_occupancy_limits below.  Tweak to make sure your occupancy maps line up correctly.

% Adjust this appropriately if you aren't using dropbox to store all your
% files
dropbox_path = 'C:\Users\Nat\Dropbox\';
calibration_file = [dropbox_path 'Imaging Project\MATLAB\tracking\2env arena calibration\arena_distortion_correction.mat'];

session_path = uigetdir('','Select the Working directory for the session you wish to analyze:');

%% Check if Placemaps and FLmovie are in the correct spot

cd(session_path)

try
    load pos_corr_to_session1.mat
    disp('Using position data aligned/rotated with 1st session');
catch
    try
        load PlaceMaps.mat
        disp('Using original position data - no alignment or rotation applied. This should be session 1.')
    catch
        error('You need to have PlaceMaps.mat in this directory')
    end
end

%%% Don't thinks this is necessary %%%
% try
%     load Pos.mat
% catch
%     error('You need to have Pos.mat in this directory')
% end


try
    h5info('ICmovie_smooth.h5','/Object');
catch
    error('You need to have Icmovie_smooth.h5 in this directory')
end



%% 0) Get data into cm in the correct spot

load(calibration_file)

% Get appropriate index to use in calibration file (searches for correct
% arena type and location in the path
ind_use = arrayfun(@(a) ~isempty(regexpi(session_path,a.arena)),pos_corr) & ...
    arrayfun(@(a) ~isempty(regexpi(session_path,a.location)),pos_corr);

x_in = x; y_in = y;

% Scale data appropriately
[ x, y ] = tracking_to_cm_std(x_in, y_in, pos_corr(ind_use).lm_x,...
    pos_corr(ind_use).lm_y, Pix2Cm, 'cm', arena_effective_limits);

%% 1) Rotate x and y if applicable, set up speed thresh

if exist('rot','var') && rot ~= 0
    
    x_orig = x; y_orig = y;
    [x_rot, y_rot] = rotate_xy(x, y, rot, limits_percent);
    x = x_rot;
    y = y_rot;
    
else
    rot = 0;
end

if ~exist('speed_thresh','var')
   speed_thresh = 0; 
end
    
% Manually set outside boundaries in case any tracking jumps outside the
% arena
figure(1)
plot(x,y); 

disp('Left click to define outer limits or the arena.  Right click to finish')
[xarena, yarena] = getpts(1);

in = inpolygon(x,y,xarena,yarena);

in_index = find(in);
out_index = find(~in);
temp = []; replace = []; 
for j = 1:length(out_index)
    temp = findclosest(out_index(j),in_index); 
    replace(j) = in_index(temp);
end

xnew = x; ynew = y; 
for j = 1:length(out_index)
    xnew(out_index(j)) = x(replace(j)); 
    ynew(out_index(j)) = y(replace(j));
end

x = xnew; y = ynew;

%% 2) Divy up the arena into appropriate areas

% Set up binning and smoothers for place field analysis
% Dombeck used 2.5 cm bins
bin_ok = 'n';


figure(2)
while ~strcmpi(bin_ok,'y')
    
    close 2
    
    Xrange = max(x)-min(x);
    Yrange = max(y)-min(y);
    
    NumXBins = ceil(Xrange/cmperbin);
    NumYBins = ceil(Yrange/cmperbin);
    
    Xedges = (0:NumXBins)*cmperbin+min(x);
    Yedges = (0:NumYBins)*cmperbin+min(y);
    
    figure(2);hold on;plot(x,y);
    
    % draw all of the edges
    for i = 1:length(Xedges)
        z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
        set(z,'Color','r');
    end
    
    for i = 1:length(Yedges)
        z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
        set(z,'Color','r');
    end
    
    axis tight;
    
    bin_ok = input('Is this ok? Type y/n, or c to adjuste cmperbin: ','s');
    
    if strcmpi(bin_ok,'c')
        cmperbin = input('Enter new value for cmperbin: ');
        bin_ok = 'n';
    end
end

keyboard

%% 3) Go through frame by frame and figure out which part of the arena the
% mouse is in - this will be the tough part!!! steal a bunch of code from
% Dave's CalculatePlacefieldsDec

[counts,Xbin] = histc(x,Xedges);
[counts,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumXBins+1))) = NumXBins;
Ybin(find(Ybin == (NumYBins+1))) = NumYBins;

Xbin(find(Xbin == 0)) = 1;
Ybin(find(Ybin == 0)) = 1;

% set up velocity filter

vel_filter = speed >= speed_thresh;


%% 4) For each area, add up all the active frames and average

% Get number of frames to ignore from beginning of movie
info = h5info('ICmovie_smooth.h5','/Object');
ICmovieLength = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);
FTLength = size(FT,2);
start_skip = ICmovieLength - FTLength; % Need to verify if this is correct!

%%% ARE THESE CORRECT? DOES THIS FRAME ACTUALLY COINCIDE WITH THE MOUSE
%%% BEING IN THIS POSITION???


% Calculate average frame for the movie
disp('Calculating Mean Projection...')
F0 = zeros(XDim,YDim);
nn = 0; % Set counter
for m = 1+start_skip:ICmovieLength
    F0 = F0 + double(h5read('ICmovie_smooth.h5','/Object',[1 1 m 1],...
        [XDim YDim 1 1]));
    nn = nn + 1;
    
end
F0 = F0/(ICmovieLength-start_skip);

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
            tempFrame = double(h5read('ICmovie_smooth.h5','/Object',...
                [1 1 ActiveFrames(k) + start_skip 1],[XDim YDim 1 1]));
            AvgFrame{j,i} = AvgFrame{j,i} + tempFrame;
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

% Weighted correlation coefficient?

keyboard

% Calculate correlations between 1st and 2nd half of exploration...
for j=1:NumYBins
    for i = 1:NumXBins
        temp = corrcoef(AvgFrame_DF_1st{j,i},AvgFrame_DF_2nd{j,i});
        corr_1st_2nd(j,i) = temp(1,2);
    end
end

% Flip Occmap to match everything else
Occmap = flipud(Occmap);


save reverse_placefields.mat AvgFrame F0 AvgFrame_DF AvgFrame_1st ...
    AvgFrame_DF_1st AvgFrame_2nd AvgFrame_DF_2nd Occmap rot cmperbin Xedges ...
    Yedges speed_thresh x y t

%% 5) Done! - then compare each between sessions for the first Nov19!!



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


clear limits_percent

end

