function [ corrs, corrs_shuffle ] = corr_bw_sesh( session1, session2, neuron_map, num_shuffles )
% corr_bw_sesh( session1, session2, neuron_map, shuffle )
% Calculates all the TMap correlations (TMap_gauss) between sesh1 and sesh2
% based on the mapping from 1 to 2 in neuron_map.  Can add either
% neuron_map directly or batch_session_map (with .session and .map fields
% included).  If num_shuffle is 0 or omitted the real map is used.  If it is
% 1 or higher then that many shuffled comparisons are created using a
% random re-mapping of cells between sessions;

sesh(1) = session1; sesh(2) = session2;

if nargin < 4
    num_shuffles = 0;
end

%% Get appropriate map if required
if isstruct(neuron_map)
    batch_session_map = neuron_map;
    for j = 1:2
        sesh_index(j) = match_session(batch_session_map.session, sesh(j)); %#ok<AGROW>
    end
    map_use = get_neuronmap_from_batchmap(batch_session_map.map, ...
    sesh_index(1), sesh_index(2));
else
    map_use = neuron_map;
end

%% Load up TMaps
for j = 1:2
   dirstr = ChangeDirectory_NK(sesh(j),0);
   load(fullfile(dirstr,'Placefields.mat'),'TMap_gauss');
   sesh(j).TMap_use = TMap_gauss;
end

%% Get correlation
corrs = corr_bw_TMap(sesh(1).TMap_use,sesh(2).TMap_use, map_use);

%% Get shuffled correlations
corrs_shuffle = cell(1,num_shuffles);
for j = 1:num_shuffles
    good_ind = find(map_use);
    shuf_map = map_use;
    shuf_map(good_ind) = map_use(good_ind(randperm(length(good_ind))));
    corrs_shuffle{j} = corr_bw_TMap(sesh(1).TMap_use,sesh(2).TMap_use, shuf_map);
end
end

