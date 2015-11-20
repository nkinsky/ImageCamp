% Plot between two different sessions

session{1} = MD(132);
session{2} = MD(134);

map1_2_loc = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\1 - square right\Working\batch_session_map_bw_arenas.mat';

% Load map between sessions
load(map1_2_loc);
map_bw_sesh = batch_session_map.map(:,2:3); % Pull out only the relevant neuron columns

%% Load TMaps
for j = 1:length(session)
   ChangeDirectory_NK(session{j});
   load('PlaceMaps.mat','TMap_gauss','OccMap')
   [~, session{j}.TMap_distal_nan] = cellfun(@(a) make_nan_TMap(OccMap,a),...
       TMap_gauss,'UniformOutput',0);
   load('PlaceMaps_rot_to_std.mat','TMap_gauss','OccMap')
   [~, session{j}.TMap_local_nan] = cellfun(@(a) make_nan_TMap(OccMap,a),...
       TMap_gauss,'UniformOutput',0);
end

%% Plot side-by-side!

cmap = colormap(jet);
figure(157)
for j = 1:length(session{1}.TMap_distal_nan)
    neuron_use{1} = map_bw_sesh(j,1);
    neuron_use{2} = map_bw_sesh(j,2);
    
    for k = 1:2
        for ll = 1:2
            subplot(2,2,(k-1)*2+ll)
            if ll == 1
                map_use = session{k}.TMap_distal_nan{j};
                title_use = ['Neuron ' num2str(j) ' - Distal Aligned Session ' num2str(k)];
            elseif ll == 2
                map_use = session{k}.TMap_local_nan{j};
                title_use = ['Neuron ' num2str(j) ' - Local Aligned Session ' num2str(k)];
            end
            imagesc_nan(map_use,cmap,[1 1 1])
            title(title_use)
        end
    end

    waitforbuttonpress
end