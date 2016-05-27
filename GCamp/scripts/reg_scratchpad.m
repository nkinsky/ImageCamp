% registration scratchpad

%% Get distribution of multiple mapping neurons across all sessions in batch_session map
name_append = '_updatemasks1';
batch_map = fix_batch_session_map(importdata('batch_session_map.mat'));
base_path = ChangeDirectory_NK(batch_map.session(1),0);

multi_overlaps = []; % all 
multi_overlaps2 = []; % only those that have 2 or more overlapping neurons
multi_overlaps3 = []; % 
for j = 2:length(batch_map.session)
    if j == 2
        name_append_use = '';
    else
        name_append_use = name_append;
    end
    unique_filename = fullfile(base_path,['neuron_map-' batch_map.session(j).Animal '-' ...
        batch_map.session(j).Date '-session' ...
        num2str(batch_map.session(j).Session) name_append_use '.mat']);
    neuronmap = importdata(unique_filename);
    [temp, temp2] = reg_calc_samemap_overlap( neuronmap,'batch_mode',1 );
    two_or_more = find(cellfun(@(a) ~isempty(a) && a ~= 0,temp(:,1)) & ...
        cellfun(@(a) ~isempty(a) && a ~= 0,temp(:,2))); % find legit multiple mapping neurons
    multi_overlaps = [multi_overlaps; cell2mat(temp(:))];
    multi_overlaps2 = [multi_overlaps2; cell2mat(temp(two_or_more,1))];
    multi_overlaps3 = [multi_overlaps3; cell2mat(temp2(two_or_more,1))];
end

%% Compare how well different image registrations map neurons

% Actual map file
map_file(1).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_26_2014-session2.mat');
% Comparison file
map_file(2).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_26_2014-session2_treg_minproj.mat');

compare_PF = 0; % 0 = don't compare PFs, 1 = compare PF locations

session = struct([]);
figure(100);
for j = 1:2
    % Load maps
    load(map_file(j).file);
    session(j).neuron_map = neuron_map;
    
    % Get image registration files
    reg_file{j} = regexprep(map_file(j).file,'neuron_map','RegistrationInfo');
    base_dir = ChangeDirectory(neuron_map.mouse,neuron_map.base_date,neuron_map.base_session,0);
    reg_dir = ChangeDirectory(neuron_map.mouse,neuron_map.reg_date,neuron_map.reg_session,0);
    load(reg_file{j});
    session(j).reginfo = RegistrationInfoX;
    
    % Get validly mapped neurons between sessions
    valid_base = find(cellfun(@(a) ~isempty(a) && ~isnan(a),neuron_map.neuron_id));
    valid_reg = cell2mat(neuron_map.neuron_id(valid_base));
    neuron_map_array = zeros(size(neuron_map.neuron_id));
    neuron_map_array(valid_base) = valid_reg;
    
    % Create allROImasks for base and reg sessions
    load(fullfile(base_dir,'MeanBlobs.mat'),'BinBlobs');
    BinBlobs_reg{1} = BinBlobs;
    session(j).allvalidROIs_base = create_AllICmask(BinBlobs(valid_base));
    load(fullfile(reg_dir,'MeanBlobs.mat'),'BinBlobs');
    temp = create_AllICmask(BinBlobs(valid_reg));
    session(j).allvalidROIs_reg = imwarp_quick(temp,RegistrationInfoX);
    
    % Get ROI metrics for registration quality
    BinBlobs_reg{2} = register_ROIs(BinBlobs, session(j).reginfo);
    [ mapped_ROIs, valid_neurons ] = map_ROIs( session(j).neuron_map.neuron_id, BinBlobs_reg{2} );
    [ ~, session(j).centroid_dist, ~, session(j).ratio_diff, ~, ...
        session(j).orientation_diff ] = dist_bw_reg_sessions( ...
        {BinBlobs_reg{1}(valid_neurons), mapped_ROIs(valid_neurons) });
    [ ROI_overlap,~, ~] = reg_calc_overlap( BinBlobs_reg{1}(valid_neurons),...
        mapped_ROIs(valid_neurons));
    
    % Get PF delta metrics!
    load(fullfile(base_dir,'PlaceMaps_rot_to_std.mat'),'TMap_gauss');
    base_centroid = get_PF_centroid(TMap_gauss,0.9);
    load(fullfile(reg_dir,'PlaceMaps_rot_to_std.mat'),'TMap_gauss');
    reg_centroid = get_PF_centroid(TMap_gauss,0.9);
    [ min_dist, ~] = get_PF_centroid_diff( base_centroid, reg_centroid, ...
        neuron_map_array, 1); % Get actual distance
    
    
    % Plot stuff
    subplot(2,2,(j-1)*2+1)
    imagesc(session(j).allvalidROIs_base)
    title('Base Session Valid Mapped Neurons')
    subplot(2,2,(j-1)*2+2)
    imagesc(session(j).allvalidROIs_base + 2*session(j).allvalidROIs_reg);
    title('Base Session + Reg Session Valid Mapped Neurons')
    colorbar
    
end

%% Plot differences from above
figure(101)
for j = 1:2
   subplot(2,2,1)
   hold on
   ecdf(squeeze(session(j).centroid_dist(1,2,:)));
   hold off
   
   subplot(2,2,2);
   hold on
   ecdf(abs(squeeze(session(j).ratio_diff(1,2,:))));
   hold off
   
end

subplot(2,2,1)
xlabel('Centroid dist (pixels)');
legend('Actual','Comparison')

subplot(2,2,2)
xlabel('Axis ratio diff');
legend('Actual','Comparison')
