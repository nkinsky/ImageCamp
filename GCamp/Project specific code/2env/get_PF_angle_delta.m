function [ delta_angle, delta_pos, pos1, angles, delta_angle_shuf, neuronid, cdists1 ] = ...
    get_PF_angle_delta( sesh1, sesh2, batch_map, TMap_type, bin_size, ...
    PCfilter, plot_flag, nshuf, half_use )
% delta_angle = get_PF_angle_delta( sesh1, sesh2, neuron_map, ... )
%   Gets the change in angle of place field centroids relative to the
%   center of the arena between two sessions. delta_angle, pos1, and angles
%   outputs are vetted currently (2018APR19), delta_pos is not.  Nan values
%   in delta_angle indicate that that neuron was active in one session but
%   NOT above the speed threshold used to determine placefields. Inputs of
%   TMap_type are either 'TMap_gauss' or 'TMap_unsmoothed'. These should be
%   used with bin_size of 1 or 4 respectively. PCfilter is a boolean to
%   only include neurons that are considered place cells in either session
%   (p < 0.05).

if nargin < 9
    half_use = [nan nan];
    if nargin < 8
        nshuf = 0;
        if nargin < 7
            plot_flag = false;
        end
    end
end

sesh1 = complete_MD(sesh1); sesh2 = complete_MD(sesh2);

sessions = cat(1,sesh1,sesh2);
[~, PFrot_use] = arrayfun(@get_rot_from_db, sessions);
if ~isempty(batch_map)
    batch_map = fix_batch_session_map(batch_map);
    sesh_index = arrayfun(@(a) get_session_index(a, batch_map.session), sessions);
    map_use = get_neuronmap_from_batchmap(batch_map, sesh_index(1), ...
        sesh_index(2));
elseif isempty(batch_map)
    temp = neuron_registerMD(sesh1, sesh2);
    map_use = zeros(size(temp.neuron_id));
    map_use(cellfun(@(a) ~isempty(a) && ~isnan(a) && a ~= 0, temp.neuron_id)) = ...
        cell2mat(temp.neuron_id(cellfun(@(a) ~isempty(a) && ~isnan(a) && a ~= 0,...
        temp.neuron_id)));
end
valid_bool = ~isnan(map_use) & (map_use ~= 0); % Get validly mapped neurons
%%
% rot_to_match = 0; % How much to rotate TMap to match actual trajectory

% Check to see if sesh1 and sesh2 are the same
% same_sesh = all([sesh1.Date == sesh2.Date, sesh1.Session == sesh2.Session, ...
%     strcmpi(sesh1.Animal, sesh2.Animal)]);
for j = 1:2
    % Load in transient maps
    if bin_size == 4
        file_load = ['Placefields_cm4_rot' num2str(PFrot_use(j)) '.mat'];
        stats_load = ['PlacefieldStats_cm4_rot' num2str(PFrot_use(j)) '.mat'];
    elseif bin_size == 1
        file_load = ['Placefields_rot' num2str(PFrot_use(j)) '.mat'];
        stats_load = ['PlacefieldStats_rot' num2str(PFrot_use(j)) '.mat'];
    elseif isnan(bin_size)
        file_load = 'Placefields.mat'; % Unrotated, unaligned, 1cm per bin standard TMaps
        stats_load = 'PlacefieldStats.mat';
    elseif ischar(bin_size) % Allow user to append something to filename - hack, fix later
        file_load = ['Placefields' bin_size '.mat'];
        stats_load = ['PlacefieldStats' bin_size '.mat'];
    end
    
    if isnan(half_use(j))
    temp = load(fullfile(sessions(j).Location,file_load), TMap_type,'pval',...
        'x','y','PSAbool','cmperbin');
    load(fullfile(sessions(j).Location, stats_load),'PFcentroids')
    %     sessions(j).TMap = cellfun(@(a) rot90(a,rot_to_match)',temp.(TMap_type),...
    %         'UniformOutput',false);
    elseif ~isnan(half_use(j))
        load(fullfile(sessions(j).Location,file_load), 'Placefields_halves')
        temp = Placefields_halves{half_use(j)};
        load(fullfile(sessions(j).Location, stats_load),'Placefields_half_stats')
        PFcentroids = Placefields_half_stats{half_use(j)}.PFcentroids; %#ok<*USENS>
    end
    sessions(j).TMap = cellfun(@transpose, temp.(TMap_type),...
        'UniformOutput', false);
    num_trans = get_num_trans(temp.PSAbool);
    sessions(j).pf_bool = temp.pval' < 0.05 & num_trans >= 5;
    sessions(j).x = temp.x;
    sessions(j).y = temp.y;
    sessions(j).PSAbool = temp.PSAbool;
    sessions(j).cmperbin = temp.cmperbin;
    sessions(j).centroids = PFcentroids; 
    
    % Get location of each neuron's peak calcium activity bin
    map_dim = size(sessions(1).TMap{1});
    map_center = circshift(map_dim,1)/2;
    [~, imax] = cellfun(@(a) max(a(:)), sessions(j).TMap);
    [yi, xi] = ind2sub(map_dim, imax);
    sessions(j).PFpos = [xi', yi'];
    sessions(j).cdists = sqrt((sessions(j).PFpos(:,1) - map_center(2)).^2 + ...
        (sessions(j).PFpos(:,2) - map_center(2)).^2);
    
    % This method takes the placefield angle as the average of ALL its
    % fields in the case of multiple fields.
    sessions(j).PFangle2 = nan(length(sessions(j).TMap),1);
    for k = 1:length(sessions(j).TMap)
        cents = cat(1,PFcentroids{k,:});
        if isempty(cents)
            continue
        else
            sessions(j).PFangle2(k) = circ_rad2ang(circ_mean(circ_ang2rad(...
                atan2d(cents(:,1)-map_center(2),cents(:,2)-map_center(1)))));
%             sessions(j).cdists(k) = sqrt((cents(:,1)-map_center(2)).^2 + ...
%                 (cents(:,2)-map_center(1)).^2); % Get distance from center too
        end
    end
    sessions(j).PFangle2(sessions(j).PFangle2 < 0) = ...
        sessions(j).PFangle2(sessions(j).PFangle2 < 0) + 360;
    
    % Get angle from center - max field only. Less reliable.
    sessions(j).PFangle = atan2d(yi-map_center(2), xi-map_center(1));
    sessions(j).PFangle(sessions(j).PFangle < 0) = ...
        sessions(j).PFangle(sessions(j).PFangle < 0) + 360;

    sessions(j).map_center = map_center;
end

if sessions(1).cmperbin ~= sessions(2).cmperbin
    error('cmperbin does not match between sessions')
end


%% Calculate angle difference
neuronid(:,1) = find(valid_bool);
neuronid(:,2) = map_use(valid_bool);
angles = nan(sum(valid_bool),2);
angles(:,1) = sessions(1).PFangle2(valid_bool)';
angles(:,2) = sessions(2).PFangle2(map_use(valid_bool))';
cdists1 = sessions(1).cdists(valid_bool);
delta_angle = diff(angles,1,2);
delta_angle(delta_angle < 0) = delta_angle(delta_angle < 0) + 360;
% Nan-value debugging - uncomment to examine why any NaN's are popping up.
% if any(isnan(delta_angle))
%     keyboard
% end

%% Calculate position difference 0 not vetted yet...
pos = nan(2,sum(valid_bool),2);
pos(1,:,1:2) = sessions(1).PFpos(valid_bool,:);
pos(2,:,1:2) = sessions(2).PFpos(map_use(valid_bool),:);
delta_pos = squeeze(diff(pos,1,1));
pos1 = squeeze(pos(1,:,:));
pos2 = squeeze(pos(2,:,:));

%% Filter out place cells
if PCfilter
    % get filter out place fields
    pf_bool = false(sum(valid_bool),2);
    pf_bool(:,1) = sessions(1).pf_bool(valid_bool);
    pf_bool(:,2) = sessions(2).pf_bool(map_use(valid_bool));
    pf_either_bool = any(pf_bool,2);
    
    delta_angle = delta_angle(pf_either_bool);
    delta_pos = delta_pos(pf_either_bool,:);
    pos1 = pos1(pf_either_bool,:);
    pos2 = pos2(pf_either_bool,:);
    angles = angles(pf_either_bool,:);
    cdists1 = cdists1(pf_either_bool);
    neuronid = neuronid(pf_either_bool,:);

end

%% Last but not least, filter out any nan values (neurons that weren't active
% above speed threshold in one session)
nan_bool = isnan(delta_angle);
delta_angle = delta_angle(~nan_bool);
delta_pos = delta_pos(~nan_bool,:);
pos1 = pos1(~nan_bool,:);
pos2 = pos2(~nan_bool,:);
angles = angles(~nan_bool,:);
cdists1 = cdists1(~nan_bool);
neuronid = neuronid(~nan_bool,:);

pos_all = cat(3,pos1,pos2);

%% Get shuffled delta_values
delta_angle_shuf = nan(size(delta_angle,1),nshuf);
ngood = size(angles,1);
ang2 = angles(:,2);
ang1 = angles(:,1);
parfor j = 1:nshuf
   ang2shuf = ang2(randperm(ngood)); %#ok<PFBNS>
   delta_shuf_temp = ang1 - ang2shuf;
   delta_shuf_temp(delta_shuf_temp < 0) = ...
       delta_shuf_temp(delta_shuf_temp  < 0) + 360;
   delta_angle_shuf(:,j) = delta_shuf_temp;
end
%% Plot to check if needed
if plot_flag
    figure
    h(1,1) = subplot(2,2,1); h(1,2) = subplot(2,2,2);
    h(2,1) = subplot(2,2,3); h(2,2) = subplot(2,2,4);
    
    neurons_all{1} = find(valid_bool);
    neurons_all{1} = neurons_all{1}(~nan_bool);
    neurons_all{2} = map_use(valid_bool);
    neurons_all{2} = neurons_all{2}(~nan_bool);
    for j=1:length(delta_angle)
        
        for k = 1:2
            subplot(h(1,k))
            imagesc_nan(sessions(k).TMap{neurons_all{k}(j)},'parula')
            set(gca,'YDir','normal')
            hold on
            plot(pos_all(j,1,k),pos_all(j,2,k),'r*')
            plot([sessions(k).map_center(1), pos_all(j,1,k)], ...
                [sessions(k).map_center(2), pos_all(j,2,k)],'r-')
            hold off
            title(['Sesh ' num2str(k) ' neuron']); 
            xlabel(['angle = ' num2str(angles(j,k),'%0.1f')]);
            
            subplot(h(2,k))
            act_bool = sessions(k).PSAbool(neurons_all{k}(j),:);
            plot(sessions(k).x,sessions(k).y,'b-', ...
                sessions(k).x(act_bool), sessions(k).y(act_bool),'r*')
            title(['\Delta_{angle} = ' num2str(delta_angle(j), '%0.1f')])
            
        end
        
        waitforbuttonpress
        
    end
    
end




end

