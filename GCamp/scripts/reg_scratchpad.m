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
pval_thresh = 0.05;
num_shuffles = 100;
compare_sessions = 3;

if compare_sessions == 1
    % Actual map files
    map_file(1).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_26_2014-session2.mat');
    % Comparison file
    map_file(2).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_26_2014-session2_treg_minproj.mat');
    compare_PF = 0; % 0 = don't compare PFs, 1 = compare PF locations
elseif compare_sessions == 2
    map_file(1).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_25_2014-session1.mat');
    % Comparison file
    map_file(2).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_25_2014-session1_treg_minproj.mat');
    compare_PF = 1; % 0 = don't compare PFs, 1 = compare PF locations
elseif compare_sessions == 3
    % Actual map files
    map_file(1).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_19_2014-session2.mat');
    % Comparison file
    map_file(2).file = fullfile(MD(ref.G30.two_env(1)).Location,'neuron_map-GCamp6f_30-11_19_2014-session2_treg_minproj.mat');
    compare_PF = 1; % 0 = don't compare PFs, 1 = compare PF locations
    
end



session = struct([]);
figure(100);
reg_file = cell(1,2);
min_dist = cell(2,1);
min_dist_shuf = cell(2,1);
aratio_diff_shuf = cell(2,1);
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
    [ session(j).ROI_overlap,~, ~] = reg_calc_overlap( BinBlobs_reg{1}(valid_neurons),...
        mapped_ROIs(valid_neurons));
    
    p = ProgressBar(num_shuffles);
    disp('Shuffling neuron ids to get ROI orientation and overlap differences')
    for k = 1:num_shuffles
       [ ~, ~, ~, temp_ratio_diff, ~, temp_orient_diff ] = dist_bw_reg_sessions( ...
           {BinBlobs_reg{1}(valid_neurons), mapped_ROIs(valid_neurons(randperm(length(valid_neurons)))) });
       aratio_diff_shuf{j} = [aratio_diff_shuf{j}; squeeze(temp_ratio_diff(1,2,:))];
       p.progress;
    end
    p.stop;
    
    if compare_PF == 1
        % Get PF delta metrics!
        disp(['Comparing PF centroids for map ' num2str(j)])
        load(fullfile(base_dir,'PlaceMaps_rot_to_std.mat'),'TMap_gauss','pval');
        session(j).pval{1} = pval;
        base_centroid = get_PF_centroid(TMap_gauss,0.9);
        load(fullfile(reg_dir,'PlaceMaps_rot_to_std.mat'),'TMap_gauss','pval');
        reg_centroid = get_PF_centroid(TMap_gauss,0.9);
        session(j).pval{2} = pval;
        [ min_dist{j}, ~] = get_PF_centroid_diff( base_centroid, reg_centroid, ...
            neuron_map_array, 1); % Get actual distance
        
        % Shuffle to get chance centroid distances
        disp('Shuffling neuron ids to get chance PF centroid diffs')
        p = ProgressBar(num_shuffles);
        neuron_map_shuf = zeros(size(neuron_map.neuron_id));
        

        for k = 1:num_shuffles
            neuron_map_shuf(valid_base) = valid_reg(randperm(length(valid_reg)));
            [ temp, ~] = get_PF_centroid_diff( base_centroid, reg_centroid, ...
                neuron_map_shuf, 1);
            min_dist_shuf{j} = [min_dist_shuf{j}; temp];
            p.progress;
        
        end
        p.stop;
        
        % Get neurons that are validly mapped between sessions AND that
        % pass pval_thresh criteria in either session
        valid_log = zeros(size(session(j).pval{1}));
        valid_log(valid_neurons) = 1;
        sesh2_pass_log = zeros(size(session(j).pval{1}));
        sesh2_pass_log(valid_base) = session(j).pval{2}(valid_reg) > (1-pval_thresh);
        session(j).neurons_include = valid_log & session(j).pval{1} > (1-pval_thresh) | ...
            sesh2_pass_log;
    end
    
    
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
PF_hist_bins = 0:2.5:50;
aratio_bins = 0:0.025:0.7;
centroid_bins = 0:0.25:4;

figure(101)
for j = 1:2
   subplot(3,2,1)
   hold on
   ecdf(squeeze(session(j).centroid_dist(1,2,:)));
   hold off
   
   subplot(3,2,2)
   hold on
   histogram(squeeze(session(j).centroid_dist(1,2,:)), centroid_bins, ....
       'Normalization','probability');
   hold off
   
   subplot(3,2,3);
   hold on
   ecdf(abs(squeeze(session(j).ratio_diff(1,2,:))));
   hold off
   
   subplot(3,2,4)
   hold on
   histogram(abs(squeeze(session(j).ratio_diff(1,2,:))), aratio_bins, ....
       'Normalization','probability');
   hold off
   
   if compare_PF == 1
       
       subplot(3,2,5)
       hold on
       ecdf(min_dist{j}(session(j).neurons_include)); %(session(j).pval{1} > (1-pval_thresh)));
       hold off
       
       subplot(3,2,6)
       hold on
       histogram(min_dist{j}(session(j).neurons_include), PF_hist_bins,...
           'Normalization','probability');
       hold off
       
   end
   
end

subplot(3,2,1)
xlabel('Centroid dist (pixels)');
ylabel('Probability')
legend('Actual','Comparison')
subplot(3,2,2)
xlabel('Centroid dist (pixels)');
ylabel('Probability')
legend('Actual','Comparison')

subplot(3,2,3)
hold on
ecdf(abs(cat(1,aratio_diff_shuf{:})))
hold off
xlabel('Axis ratio diff');
ylabel('Probability')
legend('Actual','Comparison','Shuffled')

subplot(3,2,4)
hold on
histogram(abs(cat(1,aratio_diff_shuf{:})), aratio_bins,'Normalization','probability',...
    'DisplayStyle','stairs')
hold off
xlabel('Axis ratio diff');
ylabel('Probability')
legend('Actual','Comparison','Shuffled')

if compare_PF == 1
    subplot(3,2,5)
    hold on
    ecdf(cat(1,min_dist_shuf{:})); 
    hold off
    xlabel('PF centroid distance')
    ylabel('Probability')
    legend('Actual','Comparison','Shuffle')
    
    subplot(3,2,6)
    hold on
    histogram(cat(1,min_dist_shuf{:}), PF_hist_bins,'Normalization','probability',...
        'DisplayStyle','stairs')
    hold off
    xlabel('PF centroid distance')
    ylabel('Probability')
    legend('Actual','Comparison','Shuffle')
end

%% Quantify vs ziv style reg with neurons
dir_use{1} = 'F:\GCamp6f_30\11_19_2014_nb\1 - 2env square left 201B\Working\Ziv reg to near session';
base_file{1} = 'RegistrationInfo-GCamp6f_30-11_19_2014-session2_ziv_reg';
dir_use{2} = 'F:\GCamp6f_30\11_19_2014_nb\1 - 2env square left 201B\Working\Ziv to far session 2';
base_file{2} = 'RegistrationInfo-GCamp6f_30-11_26_2014-session2_ziv_reg';
dir_use{3} = 'F:\GCamp6f_30\11_19_2014_nb\1 - 2env square left 201B\Working\Ziv reg to far session';
base_file{3} = 'RegistrationInfo-GCamp6f_30-11_26_2014-session2_ziv_reg';

t_temp = [];
t_ziv_mean = nan(3,3);
t_ziv_std = nan(3,3);

for k = 1:length(dir_use)
    cd(dir_use{k})
    disp(['Calculating ziv style reg by neurons mean and std #' num2str(k) ' of ' num2str(length(dir_use))])
    p = ProgressBar(1000);
    for j = 1:1000
        load([base_file{k} num2str(j) '.mat']);
        t_temp = cat(3,t_temp,RegistrationInfoX.tform.T);
        p.progress;
    end
    ziv_session(k).tform_T = t_temp;
    t_ziv_mean(:,:,k) = mean(t_temp,3);
    t_ziv_std(:,:,k) = std(t_temp,1,3);
end
p.stop;