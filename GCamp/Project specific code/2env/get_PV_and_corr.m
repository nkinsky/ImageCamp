function [ PV, PV_corrs ] = get_PV_and_corr( session_struct, batch_map, varargin)
% [PV, PV_corrs ] = get_PV_and_corr( session_struct, batch_map, ... )
%   Will load 'PlaceMaps.mat' unless rot_to_std or use_trans are specified in
%   as 0 in varargins. NumXBins and NumYBins = 5 (default) unless specified in varargin.
%   'corr_type': default is Spearman, use varargin to change.  Accepts
%   anything in 'corr' function.

%%% NEED TO ADD IN ABILITY TO FILTER OUT NEURONS

%% Pull varargins
rot_to_std = 0; % default
use_trans = 0; % default
corr_type = 'Spearman'; % default
num_shuffles = 1;
% Specify default number of bins
NumXBins = 5;
NumYBins = NumXBins;
disp_prog_bar = 1;
for j = 1:length(varargin)
    if strcmpi(varargin{j},'rot_to_std')
        rot_to_std = varargin{j+1};
    end
    if strcmpi(varargin{j},'use_trans')
        use_trans = varargin{j+1};
    end
    if strcmpi(varargin{j},'NumXBins')
       NumXBins = varargin{j+1};
    end
    if strcmpi(varargin{j},'NumYBins')
       NumYBins = varargin{j+1};
    end
    if strcmpi(varargin{j},'corr_type')
       corr_type = varargin{j+1};
    end
    if strcmpi(varargin{j},'num_shuffles')
       num_shuffles = varargin{j+1};
    end
    if strcmpi(varargin{j},'disp_prog_bar')
       disp_prog_bar = varargin{j+1};
    end
end

%% Load required variables from session_struct
sesh = session_struct;

% Get appropriate PlaceMap and Pos file to load
[PM_file, pos_file] = get_PM_name(rot_to_std,use_trans);

curr_dir = cd;
for j = 1:length(session_struct)
   ChangeDirectory(session_struct(j).Animal,session_struct(j).Date,...
       session_struct(j).Session);
   load(PM_file,'FT','x','y');
   load(pos_file,'xmin','xmax','ymin','ymax');
   sesh(j).FT = FT;
   sesh(j).frames_include = find( x < xmax & x > xmin & y < ymax & y > ymin);
   sesh(j).x = x;
   sesh(j).y = y;
   sesh(j).xmin = xmin;
   sesh(j).xmax = xmax;
   sesh(j).ymin = ymin;
   sesh(j).ymax = ymax;
end
cd(curr_dir)

%% Get population vectors for a 5 x 5 grid for each arena

num_neurons = size(batch_map,1);
% Get PV for each bin in each session!!! array is 4D (session_num x Xbin x
% YBin x master_neuron_num)
PV = nan(length(sesh),NumXBins,NumYBins,num_neurons); % Pre-allocate
disp('Getting PV for each bin in each session')
for m = 1:length(sesh)
    
    % Get edges
    Xedges = sesh(m).xmin:(sesh(m).xmax-sesh(m).xmin)/NumXBins:sesh(m).xmax;
    Yedges = sesh(m).ymin:(sesh(m).ymax-sesh(m).ymin)/NumYBins:sesh(m).ymax;
    
    % Get bin for each x and y point
    [~,Xbin] = histc(sesh(m).x,Xedges);
    [~,Ybin] = histc(sesh(m).y,Yedges);
    
    for j = 1:NumXBins
        for k = 1:NumYBins
            temp_FR = sum(sesh(m).FT(:,Xbin == j & Ybin == k),2)/...
                (length(sesh(m).FT(:,sesh(m).frames_include))/20); % Firing rate in Hz for each neuron - using only frames_include makes sure that you only get points for square or circle during connected times
            map_use = batch_map(:,m+1);
            
            PV(m,j,k,:) = assign_FR( temp_FR, map_use );
         
        end
    end
end

%% Get PV correlations for all comparisons!

disp('Calculating PV correlations between all sessions')
PV_corr = nan(length(sesh),length(sesh),NumXBins,NumYBins);
PV_corr_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);
PV_dist = nan(length(sesh),length(sesh),NumXBins,NumYBins);
PV_dist_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);

if disp_prog_bar == 1
    p = ProgressBar(length(sesh));
end

for m = 1:length(sesh)
    for ll = 1:length(sesh)
        for j = 1:NumXBins
            for k = 1:NumYBins             
                % Get population vectors for each session in the
                % appropriate bin.
                PV1 = squeeze(PV(m,j,k,:));
                PV2 = squeeze(PV(ll,j,k,:));
                
                ind_use = ~isnan(PV1) & ~isnan(PV2); %Indices that are not NaN in both sessions
                ind_use_both = ~isnan(PV1) | ~isnan(PV2); % Indices that are not NaN in either session
                ind_only{1} = ~isnan(PV1) & ~ind_use; % Indices that are active in session 1 only
                ind_only{2} = ~isnan(PV2) & ~ind_use; % Indices that are active in session 2 only
                
                % Change indices from NaN to zeros for those neurons that
                % are active in the other session
                PV1(ind_only{2}) = zeros(sum(ind_only{2}),1);
                PV2(ind_only{1}) = zeros(sum(ind_only{1}),1);
                
                PV1_use = PV1(ind_use_both);
                PV2_use = PV2(ind_use_both);
                
                % Get correlations and distances
                PV_corr(m,ll,j,k) = corr(PV1_use,PV2_use,'type',corr_type);
%                 if isnan(PV_corr(m,ll,j,k))
%                     disp('Getting a NaN correlation - error catching')
%                     keyboard
%                 end
                temp = dist([ PV1_use, PV2_use]);
                PV_dist(m,ll,j,k) = temp(1,2);
                
                % Get shuffled correlations and distances
                for zzz = 1:num_shuffles
                    % Create shuffled distribution - randomly switch neuron
                    % identity in second session
                    PV2_shuffle = PV2_use(randperm(length(PV2_use)));
                    
                    PV_corr_shuffle(m,ll,j,k,zzz) = corr(PV1_use,PV2_shuffle,...
                        'type',corr_type);
                    temp = dist([PV1_use, PV2_shuffle]);
                    PV_dist_shuffle(m,ll,j,k,zzz) = temp(1,2);
                end
            end
        end
    end
    if disp_prog_bar == 1
        p.progress;
    end
end

if disp_prog_bar == 1
    p.stop;
end

% Aggregate
PV_corr_mean = zeros(length(sesh),length(sesh));
PV_corr_shuffle_mean = zeros(length(sesh),length(sesh));
PV_dist_mean = zeros(length(sesh),length(sesh));
PV_dist_shuffle_mean = zeros(length(sesh),length(sesh));
for ll = 1:length(sesh)
    for mm = 1:length(sesh)
        PV_corr_mean(ll,mm) = nanmean(squeeze(PV_corr(ll,mm,:)),1);
        PV_corr_shuffle_mean(ll,mm) = nanmean(squeeze(PV_corr_shuffle(ll,mm,:)),1);
        PV_dist_mean(ll,mm) = nanmean(squeeze(PV_dist(ll,mm,:)),1);
        PV_dist_shuffle_mean(ll,mm) = nanmean(squeeze(PV_dist_shuffle(ll,mm,:)),1);
    end
end

PV_corrs.PV_corr = PV_corr;
PV_corrs.PV_corr_mean = PV_corr_mean;
PV_corrs.PV_corr_shuffle_mean = PV_corr_shuffle_mean;
PV_corrs.PV_dist = PV_dist;
PV_corrs.PV_dist_mean = PV_dist_mean;
PV_corrs.PV_dist_shuffle_mean = PV_dist_shuffle_mean;
end

%% Sub-function
function [map_load, pos_load] = get_PM_name(rot_to_std,use_trans)
if use_trans == 0
    if rot_to_std == 1
        map_load = 'PlaceMaps_rot_to_std.mat';
        pos_load = 'Pos_align_std_corr.mat';
    elseif rot_to_std == 0
        map_load = 'PlaceMaps.mat';
        pos_load = 'Pos_align.mat';
    end
elseif use_trans == 1
    if rot_to_std == 1
        map_load = 'PlaceMaps_rot_to_std_trans.mat';
        pos_load = 'Pos_align_std_corr_trans.mat';
    elseif rot_to_std == 0
        map_load = 'PlaceMaps_trans.mat';
        pos_load = 'Pos_align_trans.mat';
    end
end
end

