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
ip.addParameter('NumXBins', 5, @(a) a > 0 && round(a) == a)
ip.addParameter('NumYBins', 5, @(a) a > 0 && round(a) == a)
ip.addParameter('corr_type', 'Spearman', @(a) strcmp('Spearman',a) || ...
    strcmp('Kendall',a) || strcmp('Pearson',a));
ip.addParameter('num_shuffles', 1, @(a) a > 0 && round(a) == a);
% ip.addParameter('disp_prog_bar', true, @(a) islogical(a) || a == 0 || a == 1);
ip.addParameter('calc_half', false, @(a) islogical(a) || a == 0 || a == 1);
ip.addParameter('alt_pos_file', 'Pos_align.mat', @(a) ischar(a) || ...
    iscell(a) && length(a) == num_sessions);
% ip.addParameter('neuron_filter', true(size(batch_map)), @islogical); %This is not finished yet - probably need some more fancy code to make it work
ip.addParameter('version_use', 'T4', @(a) strcmp('T2',a) || strcmp('T4',a));
ip.addParameter('minspeed', 1, @(a) isnumeric(a) && a >= 0);
ip.addParameter('exclude_frames', [], @(a) isempty(a) || iscell(a) && ...
    length(a) == num_sessions); % not necessary/used if use_TMap is true
ip.addParameter('output_flag',true, @islogical)
ip.addParameter('filter_type', 'all_cells', @(a) strcmpi(a, 'all_cells')...
    || strcmpi(a,'active_both') || strcmpi(a,'active_all') || ...
    strcmpi(a,'good_map') || strcmpi(a,'pval') || strcmpi(a,'custom')); % Cells to include - nan = all cells, 
ip.addParameter('custom_filter',nan, @isnumeric);
% active_both = only cells that are active in both sessions being compared,
% and active_all = only cells that are active in ALL sessions being
% considered
ip.addParameter('pval_thresh', 0.05, @(a) a > 0 && a <= 1); % pval thresh to use if specified above
ip.addParameter('use_TMap', '', @(a) isempty(a) || strcmpi(a,'gauss') || ...
    strcmpi(a,'unsmoothed')); % '' = don't use TMap
ip.addParameter('TMap_name_append', '', @(a) isempty(a) || iscell(a) || ischar(a));
ip.addParameter('ntrans_thresh', 5, @(a) a >= 0 && round(a) == a);
ip.addParameter('half_use',nan, @(a) all(isnan(a)) || all(a == 1 | a == 2)); % If non nan, specifies which half of PFhalf to use
ip.parse(session_struct, batch_session_map, varargin{:});

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
filter_type = ip.Results.filter_type;
use_TMap = ip.Results.use_TMap;
TMap_name_append = ip.Results.TMap_name_append;
pval_thresh = ip.Results.pval_thresh;
ntrans_thresh = ip.Results.ntrans_thresh;
custom_filter = ip.Results.custom_filter;
half_use = ip.Results.half_use;

half_flag = ~isnan(half_use);

silent_include = true;
if strcmpi(filter_type,'good_map')
    silent_include = false;
end

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

% Ditto for TMap_name_append
if ischar(TMap_name_append)
   temp = TMap_name_append;
   clear TMap_name_append
   TMap_name_append = cell(1,num_sessions);
   [TMap_name_append{:}] = deal(temp);
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

if isempty(use_TMap)
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
%         sesh(j).ntrans = get_num_trans(PSAbool)';
        
    end
else
    dirstr = ChangeDirectory(session_struct(1).Animal,session_struct(1).Date,...
        session_struct(1).Session,0);
    if ~half_flag
        load(fullfile(dirstr,['Placefields' TMap_name_append{1} '.mat']),'xEdges',...
            'yEdges')
    elseif half_flag
        load(fullfile(dirstr,['Placefields' TMap_name_append{1} '.mat']))
        xEdges = Placefields_halves{half_use(1)}.xEdges;
        yEdges = Placefields_halves{half_use(1)}.yEdges;
    end
    NumXBins = length(xEdges) - 1;
    NumYBins = length(yEdges) - 1;
end

if strcmpi(filter_type,'pval')
    for j = 1:length(session_struct)
        dirstr = ChangeDirectory(session_struct(j).Animal,session_struct(j).Date,...
            session_struct(j).Session,0);
        if ~half_flag
            load(fullfile(dirstr,['Placefields' TMap_name_append{j} '.mat']),...
                'pval','PSAbool');
        elseif half_flag
            load(fullfile(dirstr,['Placefields' TMap_name_append{j} '.mat']))
            pval = Placefields_halves{half_use(j)}.pval;
            PSAbool = Placefields_halves{half_use(j)}.PSAbool;
        end
            
        sesh(j).pval_filt = pval < pval_thresh;
        sesh(j).ntrans_filt = get_num_trans(PSAbool)' >= ntrans_thresh;
    end
end

%% Get population vectors for a NumXBins x NumYBins grid for each arena

num_neurons = size(batch_map,1);
% Get PV for each bin in each session!!! array is 4D (session_num x Xbin x
% YBin x master_neuron_num)
PV = nan(length(sesh),NumXBins,NumYBins,num_neurons); % Pre-allocate
dispNK('Getting PV for each bin in each session', output_flag)

if isempty(use_TMap)
    % Get edges
    Xedges = xmin:(xmax-xmin)/NumXBins:xmax;
    Yedges = ymin:(ymax-ymin)/NumYBins:ymax;
    
    for m = 1:length(sesh)
        
        % Get bin for each x and y point
        [~,Xbin] = histc(sesh(m).x,Xedges);
        [~,Ybin] = histc(sesh(m).y,Yedges);
        
        map_use = batch_map(:,session_ind(m)+1);
        for j = 1:NumXBins
            for k = 1:NumYBins
                temp_FR = sum(sesh(m).PSAbool(:,Xbin == j & Ybin == k),2)/...
                    (length(sesh(m).x)/20); % Firing rate in Hz for each neuron - this only includes times when the mouse is running for calculating rate - is this legit?
                
                PV(m,j,k,:) = assign_FR( temp_FR, map_use, silent_include );
                
            end
        end 
    end
else
    for m = 1:length(sesh)
        map_use = batch_map(:,session_ind(m)+1);
        temp_FR = get_PV_from_TMap(session_struct(m),...
            'PFname_append', TMap_name_append{m},'TMap_use', use_TMap, ...
            'half_flag', half_flag);
        if half_flag % Grab approriate half if specified
            temp_FR = squeeze(temp_FR(half_use(m),:,:,:));
        end
        sesh(m).PV_TMap = temp_FR;
        for j = 1:NumXBins
            for k = 1:NumYBins
                PV(m,j,k,:) = assign_FR( squeeze(temp_FR(j,k,:)), map_use,...
                    silent_include );
            end
        end
    end
end

%% Get PV correlations for all comparisons!

dispNK('Calculating PV correlations between all sessions', output_flag);
PV_corr = nan(length(sesh),length(sesh),NumXBins,NumYBins);
PV_corr_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);
PV_corr_binshuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);
PV_dist = nan(length(sesh),length(sesh),NumXBins,NumYBins);
PV_dist_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);
PV_dist_binshuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins,num_shuffles);

if output_flag
    p = ProgressBar(length(sesh)^2);
end

rows_param = 'all'; % for later correlation calculations
if strcmpi(filter_type, 'all_cells')
    PV_use = PV;
elseif strcmpi(filter_type, 'active_all') % Get PV for cells that are active in ALL sessions
    PV_collapse = squeeze(sum(sum(PV,2),3));
    active_all_log = sum(PV_collapse > 0) == num_sessions;
    PV_use = PV(:,:,:,active_all_log);
elseif strcmpi(filter_type, 'good_map')
    PV_use = PV;
    rows_param = 'complete';
elseif strcmpi(filter_type, 'pval')
    rows_param = 'pairwise';
elseif strcmpi(filter_type, 'custom')
    PV_use = PV(:,:,:,custom_filter);
end

for m = 1:length(sesh)
    for ll = 1:length(sesh)
        
        % Get PV for cells active in sesh m AND sesh ll based on inclusion
        % criteria
        if strcmpi(filter_type, 'active_both')
            PV_collapse = squeeze(sum(sum(PV([m,ll],:,:,:),2),3));
            active_both_log = sum(PV_collapse > 0) == 2;
            PV_use = PV([m,ll],:,:,active_both_log);
        elseif strcmpi(filter_type, 'pval') % || strcmpi(filter_type,'no_coherent'
            
            % Get cells that are active in both sessions and pass pval
            % thresh in at least ONE session
            
            %%% Easier way might be to just do pairwise comparisons...
            % Get map from sesh ll to sesh m
            map_use = get_neuronmap_from_batchmap(batch_map,session_ind(m),...
                session_ind(ll));
            % fix potential bug in neuron_reg_batch by doing registration
            % directly
            if length(map_use) ~= length(sesh(m).pval_filt)
                map_temp = neuron_register(sesh(m).Animal, sesh(m).Date, ...
                    sesh(m).Session, sesh(ll).Date, sesh(ll).Session,...
                    'suppress_output', true);
                map_use = nan(size(map_temp.neuron_id));
                ind_use = cellfun(@(a) ~isempty(a) && ~isnan(a), map_temp.neuron_id);
                map_use(ind_use) = cell2mat(map_temp.neuron_id(ind_use));
            end
            valid_ind = ~isnan(map_use) & map_use ~= 0; % Identify cells active in both sessions!
            % make 2-column vector - 1st column is FR from 1st sesh, 2nd
            % column is FR from second sesh.
            PV_use = nan([2,size(sesh(m).PV_TMap)]);
            PV_use(1,:,:,:) = sesh(m).PV_TMap;
            PV_use(2,:,:,valid_ind) = sesh(ll).PV_TMap(:,:,map_use(valid_ind));
            % make 2-column inclusion boolean for p-val and num_trans
%             ppass_either = sesh(m).pval_filt & assignPV(ppass, map_use)
            ppass1 = sesh(m).pval_filt & sesh(m).ntrans_filt;
            ppass2 = assignPV(sesh(ll).pval_filt & sesh(ll).ntrans_filt,...
                map_use)';
            ppass2(isnan(ppass2)) = false;
            ppass_either = (ppass1 | ppass2) & valid_ind'; % Include cells that pass inclusion criteria in EITHER session and that are active in both
            % Set everything that passes as PV_use.
            PV_use = PV_use(:,:,:,ppass_either);
%             if m == 1 && ll == 2
%                 keyboard
%                 disp('keyboard in get_PV_and_corr')
%             end
            
            %% Older more complicated way using full PV
%             ppass1 = assignPV(sesh(m).pval_filt & sesh(m).ntrans_filt, ...
%                 get_neuronmap_from_batchmap(batch_map, 0, session_ind(m)));
%             ppass2 = assignPV(sesh(ll).pval_filt & sesh(ll).ntrans_filt, ...
%                 get_neuronmap_from_batchmap(batch_map, 0, session_ind(ll)));
%             silent_cells = isnan(ppass1) | isnan(ppass2);
%             ppass1(isnan(ppass1)) = false; % Mark no/sketchy mapped neurons
%             ppass2(isnan(ppass2)) = false;
%             ppass_either =  ppass1 | ppass2;
%             ppass_either(silent_cells) = false; % Get rid of silent cells
%             PV_use = PV([m,ll],:,:,ppass_either);
        else
            PV_use = PV([m,ll],:,:,:);
        end
        PV_use1 = squeeze(PV_use(1,:,:,:)); % Slicing and dicing to help out parfor loop
        PV_use2 = squeeze(PV_use(2,:,:,:));
        for j = 1:NumXBins
            for k = 1:NumYBins             
                % Get population vectors for each session in the
                % appropriate bin.
                PV1 = squeeze(PV_use1(j,k,:));
                PV2 = squeeze(PV_use2(j,k,:));
               [PV_corr(m,ll,j,k), PV_dist(m,ll,j,k)] = ...
                    calc_corr_and_dist(PV1, PV2, corr_type, rows_param, false);
%                 ind_use = ~isnan(PV1) & ~isnan(PV2); %Indices of neurons that are not NaN in both sessions
% %                 ind_use_both = ~isnan(PV1) | ~isnan(PV2); % Indices of neurons that are not NaN in either session
% %                 ind_only{1} = ~isnan(PV1) & ~ind_use; % Indices of neurons that are active in session 1 only
% %                 ind_only{2} = ~isnan(PV2) & ~ind_use; % Indices of neurons that are active in session 2 only
% %                 
% %                 % Change indices from NaN to zeros for those neurons that
% %                 % are active in the other session
% %                 PV1(ind_only{2}) = zeros(sum(ind_only{2}),1);
% %                 PV2(ind_only{1}) = zeros(sum(ind_only{1}),1);
%                 
%                 PV1_use = PV1(ind_use);
%                 PV2_use = PV2(ind_use);
%                 
%                 % Get correlations and distances
%                 if isempty(PV1_use) || isempty(PV2_use)
%                     PV_corr(m,ll,j,k) = nan;
%                 else
%                     PV_corr(m,ll,j,k) = corr(PV1_use,PV2_use,'type',corr_type,...
%                         'rows',rows_param);
% %                     PV_corr(m,ll,j,k) = corr(PV1_use, PV2_use,'type', corr_type, 'rows', 'complete');
%                 end
% %                 if isnan(PV_corr(m,ll,j,k))
% %                     disp('Getting a NaN correlation - error catching')
% %                     keyboard
% %                 end
%                 temp = dist([ PV1_use, PV2_use]);
%                 if isempty(temp)
%                     PV_dist(m,ll,j,k) = nan;
%                 else
%                     PV_dist(m,ll,j,k) = temp(1,2);
%                 end            
               
                % Shuffle cell identity
                parfor zzz = 1:num_shuffles
                    % Create shuffled distribution - randomly switch neuron
                    % identity in second session
%                     PV2_shuffle = PV2_use(randperm(length(PV2_use))); 
                    
                    [PV_corr_shuffle(m,ll,j,k,zzz), PV_dist_shuffle(m,ll,j,k,zzz)] = ...
                        calc_corr_and_dist(PV1,PV2,corr_type,rows_param,true);
                    
%                     if isempty(PV1_use) || isempty(PV2_shuffle)
%                         PV_corr_shuffle(m,ll,j,k,zzz) = nan;
%                     else
%                         PV_corr_shuffle(m,ll,j,k,zzz) = corr(PV1_use,PV2_shuffle,...
%                             'type',corr_type,'rows',rows_param);
%                     end
%                     temp = dist([PV1_use, PV2_shuffle]);
%                     PV_dist_shuffle(m,ll,j,k,zzz) = temp(1,2);
                        
                end
            end
        end
        
        % Shuffle spatial bin
        parfor zzz = 1:num_shuffles
            PV1a = PV_use1;
            % Shuffle here
            PV2_binshuf = shuffle_bin(PV_use2);
            for j = 1:NumXBins
                for k = 1:NumYBins
                    % Get population vectors for each session in the
                    % appropriate bin.
                    PV1 = squeeze(PV1a(j,k,:));
                    PV2 = squeeze(PV2_binshuf(j,k,:));
                    [PV_corr_binshuffle(m,ll,j,k,zzz), ...
                        PV_dist_binshuffle(m,ll,j,k,zzz)] = calc_corr_and_dist(...
                        PV1, PV2, corr_type, rows_param, false);
                end
            end
        end
        if output_flag
            p.progress;
        end
    end
end

if output_flag
    p.stop;
end

% Aggregate
PV_corr_mean = zeros(length(sesh),length(sesh));
PV_corr_shuffle_mean = zeros(length(sesh),length(sesh));
PV_corr_binshuffle_mean = zeros(length(sesh),length(sesh));
PV_dist_mean = zeros(length(sesh),length(sesh));
PV_dist_shuffle_mean = zeros(length(sesh),length(sesh));
PV_dist_binshuffle_mean = zeros(length(sesh),length(sesh));
for ll = 1:length(sesh)
    for mm = 1:length(sesh)
        PV_corr_mean(ll,mm) = nanmean(squeeze(PV_corr(ll,mm,:)),1);
        PV_corr_shuffle_mean(ll,mm) = nanmean(squeeze(PV_corr_shuffle(ll,mm,:)),1);
        PV_corr_binshuffle_mean(ll,mm) = nanmean(squeeze(PV_corr_binshuffle(ll,mm,:)),1);
        PV_dist_mean(ll,mm) = nanmean(squeeze(PV_dist(ll,mm,:)),1);
        PV_dist_shuffle_mean(ll,mm) = nanmean(squeeze(PV_dist_shuffle(ll,mm,:)),1);
        PV_dist_binshuffle_mean(ll,mm) = nanmean(squeeze(PV_dist_binshuffle(ll,mm,:)),1);
    end
end

PV_corrs.PV_corr = PV_corr;
PV_corrs.PV_corr_mean = PV_corr_mean;
PV_corrs.PV_corr_shuffle = PV_corr_shuffle;
PV_corrs.PV_corr_shuffle_mean = PV_corr_shuffle_mean;
PV_corrs.PV_corr_shuffle = PV_corr_shuffle;
PV_corrs.PV_corr_shuffle_mean = PV_corr_shuffle_mean;
PV_corrs.PV_corr_binshuffle = PV_corr_binshuffle;
PV_corrs.PV_corr_binshuffle_mean = PV_corr_binshuffle_mean;
PV_corrs.PV_dist = PV_dist;
PV_corrs.PV_dist_mean = PV_dist_mean;
PV_corrs.PV_dist_shuffle_mean = PV_dist_shuffle_mean;
PV_corrs.PV_dist_binshuffle_mean = PV_dist_binshuffle_mean;
PV_corrs.num_shuffles = num_shuffles;
end

% %% Sub-function - shouldn't really be used though except for legacy to T2 purposes!
% function [map_load, pos_load] = get_PM_name(rot_to_std,use_trans,Tversion)
% switch Tversion
%     case 'T2'
%         if use_trans == 0
%             if rot_to_std == 1
%                 map_load = 'PlaceMaps_rot_to_std.mat';
%                 pos_load = 'Pos_align_std_corr.mat';
%             elseif rot_to_std == 0
%                 map_load = 'PlaceMaps.mat';
%                 pos_load = 'Pos_align.mat';
%             end
%         elseif use_trans == 1
%             if rot_to_std == 1
%                 map_load = 'PlaceMaps_rot_to_std_trans.mat';
%                 pos_load = 'Pos_align_std_corr_trans.mat';
%             elseif rot_to_std == 0
%                 map_load = 'PlaceMaps_trans.mat';
%                 pos_load = 'Pos_align_trans.mat';
%             end
%         end
%     case 'T4'
%         if use_trans == 0
%             if rot_to_std == 1
%                 map_load = 'Placefields_rot_to_std.mat';
%                 pos_load = 'Pos_align_std_corr.mat';
%             elseif rot_to_std == 0
%                 map_load = 'Placefields.mat';
%                 pos_load = 'Pos_align.mat';
%             end
%         elseif use_trans == 1
%             if rot_to_std == 1
%                 map_load = 'Placefields_rot_to_std_trans.mat';
%                 pos_load = 'Pos_align_std_corr_trans.mat';
%             elseif rot_to_std == 0
%                 map_load = 'Placefields_trans.mat';
%                 pos_load = 'Pos_align_trans.mat';
%             end
%         end
%     otherwise
% end
% end

%% Sub-function to calculate correlation and distance between PVs 
function [corr_out, dist_out] = calc_corr_and_dist(PV1, PV2, corr_type, ...
    rows_param, shuffle_cells)

if nargin < 5
    shuffle_cells = false;
end
           
ind_use = ~isnan(PV1) & ~isnan(PV2); %Indices of neurons that are not NaN in both sessions
PV1_use = PV1(ind_use);
PV2_use = PV2(ind_use);
if shuffle_cells
    PV2_use = PV2_use(randperm(length(PV2_use)));
end

% Get correlation
if isempty(PV1_use) || isempty(PV2_use)
    corr_out = nan;
else
    corr_out = corr(PV1_use,PV2_use,'type',corr_type,...
        'rows',rows_param);
end

% Get distance
temp = dist([ PV1_use, PV2_use]);
if isempty(temp)
    dist_out = nan;
else
    dist_out = temp(1,2);
end
end

%% Spatial bin shuffle function for nx x ny x nneurons PV
function [PVshuf] = shuffle_bin(PVin)

% Reshape PV so each column is a neuron and each ro is a spatial bin
PVtemp = reshape(PVin,size(PVin,1)*size(PVin,2),size(PVin,3)); 

% Shuffle rows (spatial bins)
PVtemp = PVtemp(randperm(size(PVtemp,1)),:);

% Return to original shape with shuffled spatial bin
PVshuf = reshape(PVtemp,size(PVin));

end



