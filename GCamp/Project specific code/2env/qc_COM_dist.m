sesh_compare = [1 2];
Mouse_comp = 1;
arena_use = 1; % 1 = square, 2 = circle
align_type = 1; % 1 = distal, 2 = local
PF_thresh = 0.9; % input value for get_PF_centroid

% Get batch_session_map to use
batch_map_use = fix_batch_session_map(Mouse(Mouse_comp).batch_session_map(arena_use));
vec_use = Mouse(Mouse_comp).vec_diff_matrix{arena_use,align_type}(sesh_compare(1),...
    sesh_compare(2));
PFfilename = {'PlaceMaps.mat','PlaceMaps_rot_to_std.mat'};

% Load TMaps
PF_centroid_plot = cell(2,1);
map_plot(2).TMap = [];
for j = 1:2
    load(fullfile(ChangeDirectory_NK(batch_map_use.session(sesh_compare(j))),...
        PFfilename{align_type}),'TMap_gauss','RunOccMap');
    [~, map_plot(j).TMap] = cellfun(@(a) make_nan_TMap(RunOccMap,a), ...
        TMap_gauss,'UniformOutput',0);
    [~,PF_centroid_plot{j}] = get_PF_centroid(TMap_gauss,PF_thresh);
end

%%
figure(124)
cm = colormap('jet');
for j = 1:size(batch_map_use.map,1)
    sesh_neuron(1) = batch_map_use.map(j,1 + sesh_compare(1)); % Get neuron number for each session
    sesh_neuron(2) = batch_map_use.map(j,1 + sesh_compare(2));
    if sesh_neuron(1) == 0 && sesh_neuron(2) == 0
        continue
    else
        for k = 1:2
            if sesh_neuron(k) ~= 0
                subplot(2,2,k)
                imagesc_nan(map_plot(k).TMap{sesh_neuron(k)},cm,[1 1 1]);
                set(gca,'YDir','Normal')
                hold on
                num_fields = sum(~cellfun(@isempty,PF_centroid_plot{k}(sesh_neuron(k),:))); % Get number of valid fields
                for ll = 1:num_fields % Plot centroids
                plot(PF_centroid_plot{k}{sesh_neuron(k),ll}(1),...
                    PF_centroid_plot{k}{sesh_neuron(k),ll}(2),'w*')
                end
                quiver(vec_use.xy(sesh_neuron(1),1),vec_use.xy(sesh_neuron(1),2),...
                    vec_use.uv(sesh_neuron(1),1),vec_use.uv(sesh_neuron(1),2),0,'r');
                title(['xy = ' num2str(vec_use.xy(sesh_neuron(1),:))])
                hold off
            end
        end
        subplot(2,2,3)
        h = quiver(vec_use.xy(:,1),vec_use.xy(:,2),vec_use.uv(:,1),vec_use.uv(:,2),0,'b');
        
    end
    
    
    waitforbuttonpress
end

