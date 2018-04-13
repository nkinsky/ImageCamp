function [ delta_angle, delta_pos, pos1 ] = get_PF_angle_delta( sesh1, sesh2, ...
    batch_map, TMap_type, bin_size, PCfilter )
% delta_angle = get_PF_angle_delta( sesh1, sesh2, neuron_map, ... )
%   Gets the change in angle of place field centroids relative to the
%   center of the arena between two sessions.


% Should I do this for place fields only? 
% TMap_type = 'TMap_unsmoothed';
% bin_size = 4; % cm

sesh1 = complete_MD(sesh1); sesh2 = complete_MD(sesh2);

sessions = cat(1,sesh1,sesh2);
sesh_index = arrayfun(@(a) get_session_index(a, batch_map.session), sessions);
[~, PFrot_use] = arrayfun(@get_rot_from_db, sessions);

map_use = get_neuronmap_from_batchmap(batch_map.map, sesh_index(1), ...
    sesh_index(2));
valid_bool = ~isnan(map_use) & (map_use ~= 0); % Get validly mapped neurons
%%
for j = 1:2
    % Load in transient maps
    if bin_size == 4
        file_load = ['Placefields_cm4_rot' num2str(PFrot_use(j)) '.mat'];
    elseif bin_size == 1
        file_load = ['Placefields_rot' num2str(PFrot_use(j)) '.mat'];
    end
    temp = load(fullfile(sessions(j).Location,file_load), TMap_type,'pval');
    sessions(j).TMap = temp.(TMap_type);
    sessions(j).pf_bool = temp.pval < 0.05;
    
    % Get location of each neurons peak firing.
    map_dim = size(sessions(1).TMap{1});
    map_center = circshift(map_dim,1)/2;
    [~, imax] = cellfun(@(a) max(a(:)), sessions(j).TMap);
    [yi, xi] = ind2sub(map_dim, imax);
    sessions(j).PFpos = [xi', yi'];
    
    % Get angle from center
    sessions(j).PFangle = atan2d(yi-map_center(2), xi-map_center(1));
end



%% Calculate angle difference
angles = nan(sum(valid_bool),2);
angles(:,1) = sessions(1).PFangle(valid_bool)';
angles(:,2) = sessions(2).PFangle(map_use(valid_bool))';
delta_angle = diff(angles,1,2);
delta_angle(delta_angle < 0) = delta_angle(delta_angle < 0) + 360;

%% Calculate position difference 0 not vetted yet...
pos = nan(2,sum(valid_bool),2);
pos(1,:,1:2) = sessions(1).PFpos(valid_bool,:);
pos(2,:,1:2) = sessions(2).PFpos(map_use(valid_bool),:);
delta_pos = squeeze(diff(pos,1,1));
pos1 = squeeze(pos(1,:,:));
%%
if PCfilter
    % get filter out place fields
    pf_bool = false(sum(valid_bool),2);
    pf_bool(:,1) = sessions(1).pf_bool(valid_bool);
    pf_bool(:,2) = sessions(2).pf_bool(map_use(valid_bool));
    pf_either_bool = any(pf_bool,2);
    
    delta_angle = delta_angle(pf_either_bool);
    delta_pos = delta_pos(pf_either_bool);
    pos1 = pos1(pf_either_bool);

end

