function [corr_mat, shuffle_mat, shuffle_mat2 ] = corr_rot_analysis( session1, session2, batch_session_map, rot_array, varargin )
% [corr_mat, shuffle_mat ] = corr_rot_analysis( session1, session2, batch_session_map, rot_array, num_shuffles)
%   
% Compares session1 TMaps to TMaps in session2 that have been rotated as
% specified in rot_array.  Requires running batch_rot_arena and
% PlaceFields/PlacefieldStats on the data first.
% Need to add in thresholding of some sort - currently ALL cells are
% included.

ip = inputParser;
ip.addRequired('session1', @isstruct);
ip.addRequired('session2', @isstruct);
ip.addRequired('batch_session_map', @isstruct);
ip.addRequired('rot_array', @isnumeric);
ip.addOptional('num_shuffles', 1, @(a) a >= 0 && round(a) == a);
ip.addParameter('trans', false, @islogical);
ip.addParameter('TMap_type', 'TMap_gauss', @(a) strcmpi(a,'TMap_gauss') || ...
    strcmpi(a,'TMap_unsmoothed'));
ip.addParameter('disp_progress', false, @islogical);
ip.parse(session1, session2, batch_session_map, rot_array, varargin{:});

num_shuffles = ip.Results.num_shuffles;
trans = ip.Results.trans;
TMap_type = ip.Results.TMap_type;
disp_progress = ip.Results.disp_progress;

if trans; trans_append = '_trans'; else; trans_append = ''; end

batch_session_map = fix_batch_session_map(batch_session_map);

[~, sesh] = ChangeDirectory(session1.Animal, session1.Date, session1.Session,0);
[~, sesh(2)] = ChangeDirectory(session2.Animal, session2.Date, session2.Session,0);

temp = load(fullfile(sesh(1).Location,['Placefields' trans_append '_rot0.mat']), TMap_type);
num_neurons = length(temp.(TMap_type));
sesh(1).TMap_use = temp.(TMap_type);

sesh_index = nan(1,2);
for j = 1:2
    sesh_index(j) = match_session(batch_session_map.session, sesh(j));
end

try
map_use = get_neuronmap_from_batchmap(batch_session_map.map, ...
    sesh_index(1), sesh_index(2));
catch
    keyboard
end

corr_mat = nan(num_neurons, length(rot_array));
for j = 1:length(rot_array)
    file_load = fullfile(sesh(2).Location,['Placefields' trans_append '_rot' num2str(rot_array(j)) '.mat']);
    if exist(file_load,'file')
        
        temp = load(file_load, TMap_type);
        TMap1_use = sesh(1).TMap_use;
        TMap2_use = temp.(TMap_type);
        
    elseif ~exist(file_load,'file') % If 2nd session rotation doesn't exist, send it to zero and rotate the other session
        
        rot_use = -rot_array(j) + 360;
        temp = load(fullfile(sesh(1).Location,['Placefields' trans_append '_rot' num2str(rot_use) '.mat']), TMap_type);
        TMap1_use = temp.(TMap_type);
        temp = load(fullfile(sesh(2).Location,['Placefields' trans_append '_rot0.mat']), TMap_type);
        TMap2_use = temp.(TMap_type);
        
    end
    corr_mat(:,j) = corr_bw_TMap(TMap1_use, TMap2_use, map_use);

end

shuffle_mat = [];

% [~, j] = max(nanmean(corr_mat,1)); % Get index of best correlation
% 
% % Shuffle neuron id in last session and get correlations
% good_ind = find(map_use);
% load(fullfile(sesh(2).Location,['Placefields' trans_append '_rot' num2str(rot_array(j)) '.mat']),'TMap_gauss');
% shuffle_mat = nan(num_neurons, num_shuffles);
% for j = 1:num_shuffles
%     shuf_map = map_use;
%     shuf_map(good_ind) = map_use(good_ind(randperm(length(good_ind))));
%     shuffle_mat(:,j) = corr_bw_TMap(sesh(1).TMap_gauss, TMap_gauss, shuf_map);
% 
% end

% Shuffle neuron id in last session and then perform rotation analysis.
% Best would be to do this, find the max value, then circularly shift each
% shuffle to align the shuffled tuning curves

shuffle_mat2 = [];
% if disp_progress
    
%     disp('Shuffling')
%     p = ProgressBar(num_shuffles);
% end
parfor k = 1:num_shuffles
    good_ind = find(map_use);
    shuf_map = map_use;
    shuf_map(good_ind) = map_use(good_ind(randperm(length(good_ind))));
    shuffle_mat2_temp = nan(num_neurons, length(rot_array));
    for j = 1:length(rot_array)
        file_load = fullfile(sesh(2).Location,['Placefields' trans_append '_rot' num2str(rot_array(j)) '.mat']);
        if exist(file_load,'file')
            
            temp = load(file_load,TMap_type);
            TMap1_use = sesh(1).TMap_use; %#ok<PFTIN>
            TMap2_use = temp.(TMap_type); %#ok<PFTIN>
            
        elseif ~exist(file_load,'file') % If 2nd session rotation doesn't exist, send it to zero and rotate the other session
            
            rot_use = -rot_array(j) + 360;
            temp = load(fullfile(sesh(1).Location,['Placefields' trans_append '_rot' num2str(rot_use) '.mat']), TMap_type);
            TMap1_use = temp.(TMap_type);
            temp = load(fullfile(sesh(2).Location,['Placefields' trans_append '_rot0.mat']), TMap_type);
            TMap2_use = temp.(TMap_type);
            
        end
        try
            shuffle_mat2_temp(:,j) = corr_bw_TMap(TMap1_use, TMap2_use, shuf_map);
        catch
            keyboard
        end
        
    end
    [~, imax] = max(nanmean(shuffle_mat2_temp,1));
    shuffle_mat2_temp = circshift(shuffle_mat2_temp,1-imax,2);
    shuffle_mat2 = [shuffle_mat2; shuffle_mat2_temp]; 
    
%     if disp_progress; p.progress; end
end

% if disp_progress; p.stop; end
    

end

