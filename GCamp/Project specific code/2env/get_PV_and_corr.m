function [ PV, PV_corrs ] = get_PV_and_corr( session_struct, batch_session_map, varargin)
% [PV, PV_corrs ] = get_PV_and_corr( session_struct, batch_map, ... )
%   Will load 'PlaceMaps.mat' unless rot_to_std or use_trans are specified in
%   as 0 in varargins. NumXBins and NumYBins = 5 (default) unless specified in varargin.
%   'corr_type': default is Spearman, use varargin to change.  Accepts
%   anything in 'corr' function.  Must have run batch_align_pos and have
%   Pos_align that are aligned for each session.
%
%   Rather than taking all the placemaps for a given session and
%   concatenating them together into one long vector, then correlating that
%   with the same neurons on a subsequent session, this gets the firing
%   rate of each neuron in a given bin and then correlates each bin's FR
%   vector with the other session.  spits out a num_sessions x num_session
%   x num_Xbins x num_Ybins array of correlation values (PV_corrs). Also
%   spits out the raw population vectors (num_sessions x num_Xbins x
%   num_Ybins)

%%% NEED TO ADD IN ABILITY TO FILTER OUT NEURONS

%% Parse inputs

num_sessions = length(session_struct);

ip = inputParser;
ip.addRequired('session_struct',@isstruct);
ip.addRequired('batch_session_map',@isstruct);
ip.addParameter('rot_to_std', false, @(a) islogical(a) || a == 0 || a == 1);
ip.addParameter('use_trans', false, @(a) islogical(a) || a == 0 || a == 1);
ip.addParameter('NumXBins', 5, @(a) a > 0 && round(a) == a)
ip.addParameter('NumYBins', 5, @(a) a > 0 && round(a) == a)
ip.addParameter('corr_type', 'Spearman', @(a) strcmp('Spearman',a) || ...
    strcmp('Kendall',a) || strcmp('Pearson',a));
ip.addParameter('num_shuffles', 1, @(a) a > 0 && round(a) == a);
% ip.addParameter('disp_prog_bar', true, @(a) islogical(a) || a == 0 || a == 1);
ip.addParameter('calc_half', false, @(a) islogical(a) || a == 0 || a == 1);
ip.addParameter('alt_pos_file', 'Pos_align.mat', @(a) ischar(a) || iscell(a) && length(a) == num_sessions);
% ip.addParameter('neuron_filter', true(size(batch_map)), @islogical); %This is not finished yet - probably need some more fancy code to make it work
ip.addParameter('version_use', 'T4', @(a) strcmp('T2',a) || strcmp('T4',a));
ip.addParameter('minspeed', 1, @(a) isnumeric(a) && a >= 0);
ip.addParameter('exclude_frames', [], @(a) isempty(a) || iscell(a) && length(a) == num_sessions);
ip.addParameter('output_flag',true, @islogical)
ip.parse(session_struct, batch_session_map, varargin{:});

rot_to_std = ip.Results.rot_to_std;
use_trans = ip.Results.use_trans;
NumXBins = ip.Results.NumXBins;
NumYBins = ip.Results.NumYBins;
corr_type = ip.Results.corr_type;
num_shuffles = ip.Results.num_shuffles;
% disp_prog_bar = ip.Results.disp_prog_bar;
calc_half = ip.Results.calc_half;
pos_file = ip.Results.alt_pos_file;
% neuron_filter = ip.Results.neuron_filter;
version_use = ip.Results.version_use;
minspeed = ip.Results.minspeed;
exclude_frames = ip.Results.exclude_frames;
output_flag = ip.Results.output_flag;

% Make position file into a cell if applicable
if ischar(pos_file)
   pos_file_name = pos_file;
   clear pos_file
   pos_file = cell(1,num_sessions);
   [pos_file{:}] = deal(pos_file_name);
end

% Ditto for exclude_frames
if isempty(exclude_frames)
    clear exclude_frames
    exclude_frames = cell(1,num_sessions);
end

%Get appropriate session indices
session_map = nan(1, num_sessions);
batch_session_map = fix_batch_session_map(batch_session_map);
for j = 1:num_sessions
   session_ind(j) = find(arrayfun(@(a) strcmp(a.Animal, session_struct(j).Animal)...
       & strcmp(a.Date,session_struct(j).Date)...
       & a.Session == session_struct(j).Session, batch_session_map.session));
end

batch_map = batch_session_map.map;

%% Load required variables from session_struct
sesh = session_struct;

% Get appropriate PlaceMap and Pos file to load
% if ~use_alt_file
%     [PM_file, pos_file] = get_PM_name(rot_to_std, use_trans, version_use);
% elseif use_alt_file
%     PM_file = alt_PM_file;
%     pos_file = alt_pos_file;
% end

for j = 1:length(session_struct)
    
    % Load position data
    dirstr = ChangeDirectory(session_struct(j).Animal,session_struct(j).Date,...
        session_struct(j).Session,0);
    if strcmpi(version_use,'T2')
        load(fullfile(dirstr, pos_file{j}),'FT','x_adj_cm','y_adj_cm',...
            'speed','xmin','xmax','ymin','ymax');
        PSAbool = FT;
    elseif strcmpi(version_use,'T4')
        load(fullfile(dirstr, pos_file{j}),'PSAbool','x_adj_cm','y_adj_cm',...
            'speed','xmin','xmax','ymin','ymax')
    end
    x = x_adj_cm;
    y = y_adj_cm;
    
    % Get running epochs
    nFrames = size(PSAbool,2); 
    velocity = convtrim(speed,ones(1,2*20))./(2*20);    %Smooth velocity (cm/s).
    good = true(1,nFrames);                             %Frames that are not excluded.
    good(exclude_frames{j}) = false;                    %Exclude frames if indicated
    isrunning = good;                                   %Running frames that were not excluded. 
    isrunning(velocity < minspeed) = false;             %Exclude epochs when mouse was not running
    frames_include_log = x < xmax & x > xmin & y < ymax & y > ymin & isrunning;
    
    if calc_half
        xmin = min(x); xmax = max(x);
        ymin = min(y); ymax = max(y);
    end
    
    sesh(j).PSAbool = PSAbool(:,frames_include_log);
    sesh(j).frames_include_log = frames_include_log;
    sesh(j).x = x(frames_include_log); % Get rid of x and y coordinates that are either outside of the limits or when the mouse is not running
    sesh(j).y = y(frames_include_log);
    
end

% Split up session appropriately if calc_half is flagged.
% if calc_half
%     if length(sesh) > 1
%         error('Within session correlations only work for one session at at time.')
%     end
%     sesh(2) = sesh(1);
%     for j = 1:2
%         sesh(j).PSAbool = sesh(j).PSAbool(:,half_indices{j});
%         sesh(j).frames_include = true(1,length(half_indices{j}));
%         sesh(j).x = sesh(j).x(half_indices{j});
%         sesh(j).y = sesh(j).y(half_indices{j});
%     end
%     batch_map = repmat((1:size(FT,1))',1,3); % Make mapping the exact same for each half.
% end

%% Get population vectors for a 5 x 5 grid for each arena

num_neurons = size(batch_map,1);
% Get PV for each bin in each session!!! array is 4D (session_num x Xbin x
% YBin x master_neuron_num)
PV = nan(length(sesh),NumXBins,NumYBins,num_neurons); % Pre-allocate
dispNK('Getting PV for each bin in each session', output_flag)

% Get edges
Xedges = xmin:(xmax-xmin)/NumXBins:xmax;
Yedges = ymin:(ymax-ymin)/NumYBins:ymax;
    
for m = 1:length(sesh)
    
    % Get bin for each x and y point
    [~,Xbin] = histc(sesh(m).x,Xedges);
    [~,Ybin] = histc(sesh(m).y,Yedges);
    
    for j = 1:NumXBins
        for k = 1:NumYBins
            temp_FR = sum(sesh(m).PSAbool(:,Xbin == j & Ybin == k),2)/...
                (length(sesh(m).x)/20); % Firing rate in Hz for each neuron
            map_use = batch_map(:,session_ind(m)+1);
            
            PV(m,j,k,:) = assign_FR( temp_FR, map_use );
         
        end
    end
end

%% Get PV correlations for all comparisons!

dispNK('Calculating PV correlations between all sessions', output_flag);
PV_corr = nan(length(sesh),length(sesh),NumXBins,NumYBins);
PV_corr_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);
PV_dist = nan(length(sesh),length(sesh),NumXBins,NumYBins);
PV_dist_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);

if output_flag
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
                
                ind_use = ~isnan(PV1) & ~isnan(PV2); %Indices of neurons that are not NaN in both sessions
%                 ind_use_both = ~isnan(PV1) | ~isnan(PV2); % Indices of neurons that are not NaN in either session
%                 ind_only{1} = ~isnan(PV1) & ~ind_use; % Indices of neurons that are active in session 1 only
%                 ind_only{2} = ~isnan(PV2) & ~ind_use; % Indices of neurons that are active in session 2 only
%                 
%                 % Change indices from NaN to zeros for those neurons that
%                 % are active in the other session
%                 PV1(ind_only{2}) = zeros(sum(ind_only{2}),1);
%                 PV2(ind_only{1}) = zeros(sum(ind_only{1}),1);
                
                PV1_use = PV1(ind_use);
                PV2_use = PV2(ind_use);
                
                % Get correlations and distances
                if isempty(PV1_use) || isempty(PV2_use)
                    PV_corr(m,ll,j,k) = nan;
                else
                    PV_corr(m,ll,j,k) = corr(PV1_use,PV2_use,'type',corr_type);
%                     PV_corr(m,ll,j,k) = corr(PV1_use, PV2_use,'type', corr_type, 'rows', 'complete');
                end
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
                    
                    if isempty(PV1_use) || isempty(PV2_shuffle)
                        PV_corr_shuffle(m,ll,j,k,zzz) = nan;
                    else
                        PV_corr_shuffle(m,ll,j,k,zzz) = corr(PV1_use,PV2_shuffle,...
                            'type',corr_type);
                    end
                    temp = dist([PV1_use, PV2_shuffle]);
                    PV_dist_shuffle(m,ll,j,k,zzz) = temp(1,2);
                end
            end
        end
    end
    if output_flag
        p.progress;
    end
end

if output_flag
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

%% Sub-function - shouldn't really be used though except for legacy to T2 purposes!
function [map_load, pos_load] = get_PM_name(rot_to_std,use_trans,Tversion)
switch Tversion
    case 'T2'
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
    case 'T4'
        if use_trans == 0
            if rot_to_std == 1
                map_load = 'Placefields_rot_to_std.mat';
                pos_load = 'Pos_align_std_corr.mat';
            elseif rot_to_std == 0
                map_load = 'Placefields.mat';
                pos_load = 'Pos_align.mat';
            end
        elseif use_trans == 1
            if rot_to_std == 1
                map_load = 'Placefields_rot_to_std_trans.mat';
                pos_load = 'Pos_align_std_corr_trans.mat';
            elseif rot_to_std == 0
                map_load = 'Placefields_trans.mat';
                pos_load = 'Pos_align_trans.mat';
            end
        end
    otherwise
end
end

