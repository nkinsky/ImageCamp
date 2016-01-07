% Two environment - script to scroll through and compare single cell
% responses between square and circle environments

%% Look for in future
% 1) Probability of path equivalent coding before, during, and after
% connection (both with local and distal cues aligned)
% 2) Distance between fields for each neuron
% 3) Conditional probability for path equivalent coding GIVEN a neuron
% exhibited path equivalence on days 5-6
% 4) Number of cells that are active in each arena for mouse AFTER
% separation

close all

%% Batch run parameters

% Enter sessions to look at here
sessions_use_cell = {G30_botharenas,G31_botharenas,G45_botharenas,G48_botharenas};

for zz = 1:length(sessions_use_cell)
    %% Parameters
    PF_thresh = 0.9;
    SR = 20; % sampling rate - shouldn't change from 20 most likely
    
    twoenv_reference; % Run this script to set everything up
    
    %%% Enter sessions to analyze here !!! %%%
    session_num_use = sessions_use_cell{zz}; %G31_botharenas;
    
    % Indicate if you want to rotate each arena back to the standard
    % configuration (1) or not (0) for all sessions
    rot_to_std = 0; % Rotate data back such that local cues align
    use_trans = 1; % Use circle->square transformed data.
    
    corr_type = 'Spearman'; % type of correlation to use for PV correlations
    
    num_shuffles = 10; % number of shuffles to perform where applicable
    %% Set up script
    
    curr_dir = cd;
    
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
    
    % Enter session reference from twoenv_reference here
    session_struct = MD(session_num_use); % Pull appropriate data from database
    sesh = session_struct;
    
    disp(['<<<<<<< RUNNING ANALYSIS FOR MOUSE ' session_struct(1).Animal ' >>>>>>>'])
    % Load batch_session_map
    ChangeDirectory_NK(session_struct(1));
    load('batch_session_map_botharenas.mat');
    batch_map = batch_session_map.map;
    num_neurons = size(batch_map,1);
    
    %% Scroll through each session and get tmaps
    disp('Loading TMaps for each session and getting their centroids')
    for j = 1:length(session_struct)
        ChangeDirectory_NK(session_struct(j)); % Change to appropriate directory
        load(map_load,'RunOccMap','TMap_gauss','FT','x','y');
        [~, sesh(j).TMap_nan] = cellfun(@(a) make_nan_TMap(RunOccMap,a),...
            TMap_gauss,'UniformOutput',0);
        load(pos_load,'xmin','xmax','ymin','ymax');
        % Get PF centroids
        sesh(j).PF_centroid = get_PF_centroid(TMap_gauss,PF_thresh);
        sesh(j).FT = FT;
        sesh(j).frames_include = find( x < xmax & x > xmin & y < ymax & y > ymin);
        sesh(j).x = x;
        sesh(j).y = y;
        sesh(j).xmin = xmin;
        sesh(j).xmax = xmax;
        sesh(j).ymin = ymin;
        sesh(j).ymax = ymax;
    end
    
    %% Plot out stuff!
    
    plot_this = 0;
    
    if plot_this == 1
        % Set up parameters for plotting with imagesc_nan
        cm = colormap('jet');
        nan_color = [1 1 1];
        
        % Set up plot
        figure(200);
        set(gcf, 'Position',[102, 344, 1784, 497]);
        TMap_invalid = nan(size(sesh(1).TMap_nan{1}));
        
        % Scroll through each neuron and plot
        neurons_use = 1:num_neurons; % same_5_6_master; %
        
        
        for m = 1:length(neurons_use)
            k = neurons_use(m);
            n_square = 1; % plot counters for each arena
            n_oct = 9;
            for j = 1:length(session_struct)
                % Figure out which arena the plot is for and update plot_index
                if sum(botharenas_square == j) == 1
                    n = n_square;
                    title_text = ['Square ' num2str(n_square)];
                    n_square = n_square + 1;
                elseif sum(botharenas_oct == j) == 1
                    n = n_oct;
                    title_text = ['Circle ' num2str(n_oct - 8)];
                    n_oct = n_oct + 1;
                end
                % Figure out neuron to use
                neuron_use = batch_map(k, j+1);
                
                % Replace an invalid mappings with all NaNs
                if neuron_use == 0
                    map_use = TMap_invalid;
                    neuron_text = 'N/A';
                elseif neuron_use ~= 0
                    map_use = sesh(j).TMap_nan{neuron_use};
                    neuron_text = num2str(neuron_use);
                end
                
                % Plot it!
                subplot(2,8,n)
                imagesc_nan(map_use,cm,nan_color)
                title(title_text)
                xlabel(['Neuron ' neuron_text]);
                if n == 1
                    ylabel('Square')
                elseif n == 9
                    ylabel('Circle')
                end
                
            end
            
            waitforbuttonpress
            
        end
    end
    
    %% Get distances between neurons in square v circle arena
    
    % Enter session indices for comparisons
    before_square = [1 2 7 8]';
    before_oct = [3 4 5 6]';
    before_both = [before_square before_oct];
    during_square = [9 12]';
    during_oct = [10 11]';
    during_both = [during_square during_oct];
    after_square = [13 14]';
    after_oct = [15 16]';
    after_both = [ after_square after_oct];
    all_both = [before_both; during_both; after_both];
    win_before = [1 2; 3 4; 5 6; 7 8];
    win_after = [13 14; 15 16];
    win_both = [win_before; win_after];
    
    disp('Getting Place Field centroid distances')
    min_dist = cell(1,size(all_both,1));
    min_dist_win = cell(1,size(win_both,1));
    min_dist_all = [];
    min_dist_win_all = [];
    min_dist_shuffle_all = [];
    for j = 1:size(all_both,1);
        % Get map between each session
        sesh_use = all_both(j,:);
        map_use = get_neuronmap_from_batchmap( batch_map, sesh_use(1),...
            sesh_use(2));
        
        % Get distance between centroids of PF in each session
        min_dist{j} = get_PF_centroid_diff( sesh(sesh_use(1)).PF_centroid, ...
            sesh(sesh_use(2)).PF_centroid, map_use, 1);
        min_dist_all = [min_dist_all; min_dist{j}];
        
        % Do the same but for shuffled second session
        min_dist_shuffle{j} = [];
        for k = 1:num_shuffles
            shuf_map_use = zeros(size(map_use));
            valid_logical = ~isnan(map_use) & map_use ~= 0; % logical of validly mapped neurons
            temp = unique(map_use(valid_logical)); % Get values of each of the above neurons
            shuf_map_use(valid_logical) = temp(randperm(length(temp))); % shuffle indices
            temp_dist_shuf = get_PF_centroid_diff( sesh(sesh_use(1)).PF_centroid, ...
                sesh(sesh_use(2)).PF_centroid, shuf_map_use, 1);
            min_dist_shuffle{j} = [min_dist_shuffle{j}; temp_dist_shuf]; % Add in each shuffle
        end
        min_dist_shuffle_all = [min_dist_shuffle_all; min_dist_shuffle{j}];
        
        % Get minimum distances between PFs within each day
        if j <=6
            sesh_win_use = win_both(j,:);
            map_win_use = get_neuronmap_from_batchmap( batch_map, sesh_win_use(1),...
                sesh_win_use(2));
            min_dist_win{j} = get_PF_centroid_diff( sesh(sesh_win_use(1)).PF_centroid, ...
                sesh(sesh_win_use(2)).PF_centroid, map_win_use, 1);
            min_dist_win_all = [min_dist_win_all; min_dist_win{j}]; % dump all into one array
        end
        
    end
    
    % Aggregate
    min_dist_before = [min_dist{1}; min_dist{2}; min_dist{3} ; min_dist{4}];
    min_dist_during = [min_dist{5}; min_dist{6}];
    min_dist_after = [min_dist{7}; min_dist{8}];
    
    figure(199)
    ecdf(min_dist_before); hold on;
    ecdf(min_dist_during);
    ecdf(min_dist_after);
    legend('Before','During','After')
    xlabel('Distance between Place Field centroid location in opposite arena')
    
    % Plot between shapes
    xlim_use(1) = 0; xlim_use(2) = round(max([min_dist_all; min_dist_win_all])) + 1;
    edges = xlim_use(1):diff(xlim_use)/30:xlim_use(2);
    figure(200);
    for j = 1:8
        subplot(2,4,j)
        nn = histc(min_dist{j},edges);
        bar(edges,nn,'histc')
        title(['Session ' num2str(j) ' b/w arenas'])
        xlabel('Min Dist b/w PF centroids')
        
    end
    
    % Plot within shapes
    edges = xlim_use(1):diff(xlim_use)/30:xlim_use(2);
    figure(201);
    for j = 1:6
        subplot(2,3,j)
        nn = histc(min_dist_win{j},edges);
        bar(edges,nn,'histc')
        title(['Session ' num2str(j) ' w/in arenas'])
        xlabel('Min Dist b/w PF centroids')
    end
    
    %% Find neurons with similar position fields on each day
    % Follow through with this!!! Plot out for each day?
    
    
    dist_thresh = 5; % Arbitrary distance for PFs being the "same"
    homotopic = cell(1,8);
    master_neuron_id = cell(1,8);
    for j = 1:8
        homotopic{j} = find(min_dist{j} < dist_thresh);
        % Get neurons that have similar positions on each day
        temp = arrayfun(@(a) find(batch_map(:,all_both(j,1)+1) == a),...
            homotopic{j},'UniformOutput',0);
        master_neuron_id{j} = make_cell_array(temp,0,nan);
    end
    
    % Find neurons that have the same PFs in both arenas in both session 5 and
    % session 6
    temp = arrayfun(@(a) find( (a ~= 0).*(a == master_neuron_id{6})),...
        master_neuron_id{5},'UniformOutput',0);
    same_5_6_indices = find(cellfun(@(a) ~isempty(a),temp));
    same_5_6_master = master_neuron_id{5}(same_5_6_indices);
    
    %% Get FR for each neuron in square and circle sessions
    FR_all_sessions = zeros(size(batch_map,1),size(batch_map,2)-1); % set all neuron base firing rates to 0.  Is this legit? probably should send multi-mapping ones to nans!!!
    FR_all_sessions_orig{j} = cell(1,length(sesh));
    % FR_all_sessions_orig = nan(size(batch_map,1),size(batch_map,2)-1);
    for j = 1:length(sesh)
        temp_FR = sum(sesh(j).FT(:,sesh(j).frames_include),2)/...
            (length(sesh(j).FT(:,sesh(j).frames_include))/20); % Firing rate in Hz for each neuron - using only frames_include makes sure that you only get points for square or circle during connected times
        map_use = batch_map(:,j+1);
        
        FR_all_sessions(:,j) = assign_FR( temp_FR, map_use );
        %     nan_neurons = find(isnan(batch_map));
        %
        %     temp = unique(map_use); % Get numbers of all neurons properly mapped in this session
        %     map_unique = temp(~isnan(temp) & temp ~= 0);
        %
        %     for k = map_unique % 1:max(map_use)
        %         neuron_id = find(map_use == k);
        %         FR_all_sessions(neuron_id,j) = temp_FR(k); % Assign FR for that session to appropriate master neuron number
        %
        %         %%%% Old code %%%%
        %         %        neuron_id = find(map_use == k);
        %         %        if ~isempty(neuron_id)
        %         %            FR_all_sessions(neuron_id,j) = temp_FR(k); % Assign FR for that session to appropriate master neuron number
        %         %        end
        %     end
        %
        %     % Put nans wherever the neuron is not properly mapped
        %     temp_FR(nan_neurons) = nan(length(nan_neurons),1);
        %
        FR_all_sessions_orig{j} = temp_FR;
    end
    
    square_sesh = [1 2 7 8 9 12 13 14];
    oct_sesh = [3 4 5 6 10 11 15 16];
    
    FR_square.all = nanmean(FR_all_sessions(:,square_sesh),2);
    FR_oct.all = nanmean(FR_all_sessions(:,oct_sesh),2);
    FR_square.before = nanmean(FR_all_sessions(:,before_square),2);
    FR_oct.before = nanmean(FR_all_sessions(:,before_oct),2);
    FR_square.during = nanmean(FR_all_sessions(:,during_square),2);
    FR_oct.during = nanmean(FR_all_sessions(:,during_oct),2);
    FR_square.after = nanmean(FR_all_sessions(:,after_square),2);
    FR_oct.after = nanmean(FR_all_sessions(:,after_oct),2);
    
    figure(202)
    subplot(2,2,1);
    plot(FR_square.all,FR_oct.all,'.');
    xlabel('Square FR'); ylabel('Circle FR'); title('All Sessions')
    subplot(2,2,2);
    plot(FR_square.before,FR_oct.before,'.');
    xlabel('Square FR'); ylabel('Circle FR'); title('Before Sessions')
    subplot(2,2,3);
    plot(FR_square.during,FR_oct.during,'.');
    xlabel('Square FR'); ylabel('Circle FR'); title('During Sessions')
    subplot(2,2,4);
    plot(FR_square.after,FR_oct.after,'.');
    xlabel('Square FR'); ylabel('Circle FR'); title('After Sessions')
    
    diff_all = FR_square.all - FR_oct.all;
    diff_before = FR_square.before - FR_oct.before;
    diff_during = FR_square.during - FR_oct.during;
    diff_after = FR_square.after - FR_oct.after;
    
    discr_all = (FR_square.all - FR_oct.all)./(FR_square.all + FR_oct.all);
    discr_before = (FR_square.before - FR_oct.before)./(FR_square.before + FR_oct.before);
    discr_during = (FR_square.during - FR_oct.during)./(FR_square.during + FR_oct.during);
    discr_after = (FR_square.after - FR_oct.after)./(FR_square.after + FR_oct.after);
    
    discr_by_sesh = nan(size(FR_all_sessions,1),8);
    for j = 1:8
        discr_by_sesh(:,j) = (FR_all_sessions(:,all_both(j,1)) - FR_all_sessions(:,all_both(j,2)))...
            ./(FR_all_sessions(:,all_both(j,1)) + FR_all_sessions(:,all_both(j,2)));
    end
    
    figure(203)
    ecdf(diff_before); hold on;
    ecdf(diff_during); hold on;
    ecdf(diff_after);
    legend('Before','During','After')
    title('Diff in FR')
    
    figure(204)
    ecdf(discr_before); hold on;
    ecdf(discr_during); hold on;
    ecdf(discr_after);
    legend('Before','During','After')
    title('Discr index')
    % plot(ones(size(diff_before)),diff_before,'.'); hold on;
    % plot(2*ones(size(diff_during)),diff_during,'.'); hold on;
    % plot(3*ones(size(diff_after)),diff_after,'.'); hold on;
    
    %% Plot out and look at neurons who have discr_ratio = +/-1
    plot_this_section = 0;
    
    if plot_this_section == 1
        discr_sesh = 5;
        temp = find(abs(discr_by_sesh(:,discr_sesh)) == 1);
        
        ChangeDirectory_NK(sesh(all_both(discr_sesh,1)));
        load('PlaceMaps.mat','x','y','FT');
        time = (1:length(x))/SR;
        
        figure(205)
        for j = 1:length(temp)
            neuron_orig = batch_map(temp(j),all_both(discr_sesh,1)+1); % Get the correct neuron in the actual session from the master list
            firing = logical(FT(neuron_orig,:));
            subplot(2,1,1)
            plot(time,x,'b',time(firing),x(firing),'r*')
            xlabel('time'); ylabel('X position (cm)')
            title(num2str(temp(j)));
            subplot(2,1,2)
            plot(time,y,'b',time(firing),y(firing),'r*')
            xlabel('time'); ylabel('Y position (cm)')
            
            waitforbuttonpress
        end
    end
    
    %% Get population vectors for a 5 x 5 grid for each arena
    
    % Specify number of bins
    NumXBins = 5;
    NumYBins = NumXBins;
    
    % Get PV for each bin in each session!!! array is 4D (session_num x Xbin x
    % YBin x master_neuron_num)
    PV = nan(16,NumXBins,NumYBins,num_neurons); % Pre-allocate
    disp('Getting PV for each bin in each session')
    for m = 1:length(sesh)
        
        % Get edges
        Xedges = sesh(m).xmin:(sesh(m).xmax-sesh(m).xmin)/NumXBins:sesh(m).xmax;
        Yedges = sesh(m).ymin:(sesh(m).ymax-sesh(m).ymin)/NumYBins:sesh(m).ymax;
        
        % Get bin for each x and y point
        [~,Xbin] = histc(sesh(m).x,Xedges);
        [~,Ybin] = histc(sesh(m).y,Yedges);
        
        % Fill in edge-cases
        %     Xbin(find(Xbin == (NumXBins+1))) = NumXBins;
        %     Ybin(find(Ybin == (NumYBins+1))) = NumYBins;
        %     Xbin(find(Xbin == 0)) = 1;
        %     Ybin(find(Ybin == 0)) = 1;
        
        for j = 1:NumXBins
            for k = 1:NumYBins
                temp_FR = sum(sesh(m).FT(:,Xbin == j & Ybin == k),2)/...
                    (length(sesh(m).FT(:,sesh(m).frames_include))/20); % Firing rate in Hz for each neuron - using only frames_include makes sure that you only get points for square or circle during connected times
                map_use = batch_map(:,m+1);
                
                PV(m,j,k,:) = assign_FR( temp_FR, map_use );
                %             for ll = 1:max(map_use)
                %                 neuron_id = find(map_use == ll);
                %                 if ~isempty(neuron_id)
                %                     PV(m,j,k,neuron_id) = temp_FR(ll); % Assign FR for that session to appropriate master neuron number
                %                 end
                %             end
                
            end
        end
    end
    
    %% Get PV correlations for all comparisons!
    
    disp('Calculating PV correlations across all arenas')
    PV_corr = nan(length(sesh),length(sesh),NumXBins,NumYBins);
    PV_corr_shuffle = nan(length(sesh),length(sesh),NumXBins,NumYBins);
    for m = 1:length(sesh)
        for ll = 1:length(sesh)
            for j = 1:NumXBins
                for k = 1:NumYBins
                    % Get neurons that are non nan in both session
                    % NOTE - need to make this an OR instead of an AND and make
                    % any nans go to zero to reflect a silent neuron!!!
                    
                    % Get population vectors for each session in the
                    % appropriate bin.
                    PV1 = squeeze(PV(m,j,k,:));
                    PV2 = squeeze(PV(ll,j,k,:));
                    
                    ind_use = ~isnan(PV1) & ~isnan(PV2); %Indices that are not NaN in both sessions
                    ind_use_both = ~isnan(PV1) | ~isnan(PV2); % Indices that are not NaN in either session
                    ind_only{1} = ~isnan(PV1) & ~ind_use; % Indices that are active in session 1 only
                    ind_only{2} = ~isnan(PV2) & ~ind_use; % Indices that are active in session 2 only
                    
                    % Change indices from NaN to zeros for those neurons that
                    % are active in the other session
                    PV1(ind_only{2}) = zeros(sum(ind_only{2}),1);
                    PV2(ind_only{1}) = zeros(sum(ind_only{1}),1);
                    
                    PV1_use = PV1(ind_use_both);
                    PV2_use = PV2(ind_use_both);
                    
                    % Create shuffled distribution - randomly switch neuron
                    % identity in second session
                    PV2_shuffle = PV2_use(randperm(length(PV2_use)));
                    %                 shuffle_ind = ind_use_both(randperm(length(PV2_use)));
                    
                    % Get correlations
                    PV_corr(m,ll,j,k) = corr(PV1_use,PV2_use,'type',corr_type);
                    PV_corr_shuffle(m,ll,j,k) = corr(PV1_use,PV2_shuffle,...
                        'type',corr_type);
                    temp = dist([ PV1_use, PV2_use]);
                    PV_dist(m,ll,j,k) = temp(1,2);
                    temp = dist([PV1_use, PV2_shuffle]);
                    PV_dist_shuffle(m,ll,j,k) = temp(1,2);
                    
                    %                 PV_corr(m,ll,j,k) = temp(1,2);
                    %                 PV_corr_shuffle(m,ll,j,k) = temp_shuffle(1,2);
                end
            end
        end
    end
    
    % Aggregate
    PV_corr_mean = zeros(length(sesh),length(sesh));
    PV_corr_shuffle_mean = zeros(length(sesh),length(sesh));
    PV_dist_mean = zeros(length(sesh),length(sesh));
    PV_dist_shuffle_mean = zeros(length(sesh),length(sesh));
    for ll = 1:length(sesh)
        for mm = 1:length(sesh)
            PV_corr_mean(ll,mm) = mean(squeeze(PV_corr(ll,mm,:)),1);
            PV_corr_shuffle_mean(ll,mm) = mean(squeeze(PV_corr_shuffle(ll,mm,:)),1);
            PV_dist_mean(ll,mm) = mean(squeeze(PV_dist(ll,mm,:)),1);
            PV_dist_shuffle_mean(ll,mm) = mean(squeeze(PV_dist_shuffle(ll,mm,:)),1);
        end
    end
    figure(206)
    imagesc(PV_corr_mean); colorbar
    title(['PV correlations between all sessions rot_to_std = ' num2str(rot_to_std)])
    
    figure(207)
    imagesc(PV_corr_mean-PV_corr_shuffle_mean); colorbar
    title(['PV correlations - shuffled correlations between all sessions rot_to_std = ' num2str(rot_to_std)])
    
    %% Comparisons
    % Separate arenas only
    win_day{1} = [1 2; 3 4; 5 6; 7 8; 13 14; 15 16];
    day{1} = [3 5; 3 6; 4 5; 4 6];
    day{3} = [1 7; 1 8; 2 7; 2 8; 7 13; 7 14; 8 13; 8 14];
    day{5} = [5 15; 5 16; 6 15; 6 16];
    day{6} = [1 13; 1 14; 2 13; 2 14; 3 15; 3 16; 4 15; 4 16];
    
    % With connected - need to double check
    day_conn{1} = [7 9; 8 9; 12 13; 12 14; 9 12; 10 11];
    day_conn{2} = [5 10; 6 10; 7 12; 8 12; 10 13; 10 14; 11 15; 11 16];
    day_conn{3} = [3 10; 4 10; 5 11; 6 11; 9 15; 9 16];
    day_conn{4} = [3 11; 4 11; 1 9; 2 9];
    day_conn{5} = [1 12; 2 12];
    day_conn{6} = [];
    
    day_all = cell(1,6);
    for j = 1:length(day)
        day_all{j} = [day{j}; day_conn{j}];
    end
    
    % day_sq{1} = [
    
    PV_across_days_sep = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, ...
        PV_corr, PV_corr_shuffle, day );
    PV_within_day = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, ...
        PV_corr, PV_corr_shuffle, win_day );
    PV_across_days_conn = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, ...
        PV_corr, PV_corr_shuffle, day_conn );
    PV_across_days_all = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, ...
        PV_corr, PV_corr_shuffle, day_all );
    
    PV_dist_across_days_sep = compare_PV_across_days( PV_dist_mean, PV_dist_shuffle_mean, ...
        PV_dist, PV_dist_shuffle, day );
    PV_dist_within_day = compare_PV_across_days( PV_dist_mean, PV_dist_shuffle_mean, ...
        PV_dist, PV_dist_shuffle, win_day );
    PV_dist_across_days_conn = compare_PV_across_days( PV_dist_mean, PV_dist_shuffle_mean, ...
        PV_dist, PV_dist_shuffle, day_conn );
    PV_dist_across_days_all = compare_PV_across_days( PV_dist_mean, PV_dist_shuffle_mean, ...
        PV_dist, PV_dist_shuffle, day_all );
    
    % Plot ecdfs for days of separation
    cmap_use = hsv(7);
    figure(402)
    days_bw = [1 2 3 4 5 6];
    [f0, x0] = ecdf(PV_within_day.all{1});
    plot(x0,f0,'Color',cmap_use(1,:));
    hold on
    for j = 1:6
        [ft, xt] = ecdf(PV_across_days_all.all{j});
        plot(xt,ft,'Color',cmap_use(j+1,:));
    end
    xlabel('PV correlations');
    legend('0 days', '1 day', '2 days', '3 days', '4 days', '5 days', '6 days')
    title('PV correlations across days')
    
    % day_comp = [0 1 3 5 6]; % Time (in days) between sessions
    %
    % PV_across_days = cell(1,length(day_comp));
    % PV_across_days_shuffle = cell(1,length(day_comp));
    % PV_across_days_mid = cell(1,length(day_comp));
    % PV_across_days_mid_shuffle = cell(1,length(day_comp));
    % for j = 1:length(day_comp)
    %     if day_comp(j) ~= 0
    %         compare_sesh = day{day_comp(j)};
    %     elseif day_comp(j) == 0
    %         compare_sesh = win_day;
    %     end
    %
    %     temp = [];
    %     temp_shuf = [];
    %     temp_mid = [];
    %     temp_mid_shuf = [];
    %     for k = 1:size(compare_sesh,1)
    %        temp = [ temp; PV_corr_mean(compare_sesh(k,1), compare_sesh(k,2))];
    %        temp_shuf = [ temp_shuf; PV_corr_shuffle_mean(compare_sesh(k,1), compare_sesh(k,2))];
    %        temp_mid = [ temp_mid; PV_corr(compare_sesh(k,1), compare_sesh(k,2),3,3)];
    %        temp_mid_shuf = [ temp_mid_shuf; PV_corr_shuffle(compare_sesh(k,1), compare_sesh(k,2),3,3)];
    %     end
    %     PV_across_days{j} = temp;
    %     PV_across_days_shuffle{j} = temp_shuf;
    %     PV_across_days_mid{j} = temp_mid;
    %     PV_across_days_mid_shuffle{j} = temp_mid_shuf;
    %
    % end
    
    %% Aggregate everything into Mouse variables
    num_sessions = length(sesh);
    Mouse(zz).Animal = sesh(1).Animal; 
    Mouse(zz).batch_map = batch_map;
    [Mouse(zz).sesh(1:num_sessions).Date] = deal(sesh(1:num_sessions).Date);
    [Mouse(zz).sesh(1:num_sessions).Session] = deal(sesh(1:num_sessions).Session);
    Mouse(zz).min_dist = min_dist;
    Mouse(zz).min_dist_win = min_dist_win;
    Mouse(zz).min_dist_all = min_dist_all;
    Mouse(zz).min_dist_win_all = min_dist_win_all;
    Mouse(zz).min_dist_before = min_dist_before;
    Mouse(zz).min_dist_during = min_dist_during;
    Mouse(zz).min_dist_after = min_dist_after;
    Mouse(zz).min_dist_shuffle_all = min_dist_shuffle_all;
    Mouse(zz).FR_square = FR_square;
    Mouse(zz).FR_oct = FR_oct;
    Mouse(zz).discr_before = discr_before;
    Mouse(zz).discr_during = discr_during;
    Mouse(zz).discr_after = discr_after;
    Mouse(zz).PV = PV;
    Mouse(zz).PV_corr = PV_corr;
    Mouse(zz).PV_corr_shuffle = PV_corr_shuffle;
    Mouse(zz).PV_corr_mean = PV_corr_mean;
    Mouse(zz).PV_corr_shuffle_mean = PV_corr_shuffle_mean;
    Mouse(zz).PV_across_days_sep = PV_across_days_sep;
    Mouse(zz).PV_within_day = PV_within_day;
    Mouse(zz).PV_across_days_conn = PV_across_days_conn;
    Mouse(zz).PV_across_days_all = PV_across_days_all;
    
    
    
end % End loop through each mouse

% Aggregate into one mega-variable
for zz = 1:length(sessions_use_cell)
    
    if zz == 1
        All.min_dist_before = Mouse(1).min_dist_before;
        All.min_dist_after = Mouse(1).min_dist_after;
        All.min_dist_during = Mouse(1).min_dist_during;
        All.min_dist_shuffle_all = Mouse(1).min_dist_shuffle_all;
        All.discr_before = Mouse(1).discr_before;
        All.discr_during = Mouse(1).discr_during;
        All.discr_after = Mouse(1).discr_after;
        All.PV_across_days_sep = Mouse(1).PV_across_days_sep;
        All.PV_within_day = Mouse(1).PV_within_day;
        All.PV_across_days_conn = Mouse(1).PV_across_days_conn;
        All.PV_across_days_all = Mouse(1).PV_across_days_all;
    elseif zz ~= 1
        All.discr_before = [All.discr_before ; Mouse(zz).discr_before ];
        All.discr_during = [All.discr_during ; Mouse(zz).discr_during ];
        All.discr_after = [All.discr_after ; Mouse(zz).discr_after ];
        All.min_dist_before = [All.min_dist_before; Mouse(zz).min_dist_before];
        All.min_dist_after = [All.min_dist_after; Mouse(zz).min_dist_after];
        All.min_dist_during = [All.min_dist_during; Mouse(zz).min_dist_during];
        All.min_dist_shuffle_all = [All.min_dist_shuffle_all; Mouse(zz).min_dist_shuffle_all];
        for mmm = 1:length(Mouse(zz).PV_across_days_all.mean);
            All.PV_across_days_all.mean{mmm} = [All.PV_across_days_all.mean{mmm} ;
                Mouse(zz).PV_across_days_all.mean{mmm}];
            All.PV_across_days_all.all{mmm} = [All.PV_across_days_all.all{mmm} ;
                Mouse(zz).PV_across_days_all.all{mmm}];
        end
        All.PV_within_day.all{1} = [All.PV_within_day.all{1} ;
                Mouse(zz).PV_within_day.all{1}];
    end
    
end

%% Plot stuff for all mice and each mouse individually

figure(345);
% subplot(2,3,1); ecdf(abs(All.discr_before)); hold on; 
% ecdf(abs(All.discr_during)); 
% ecdf(abs(All.discr_after)); 
% xlabel('Discrimination Ratio')
% legend('Before', 'During', 'After'); 
% title('All Mice Combined');
for j = 1:4; 
    subplot(2,2,j); 
    ecdf(abs(Mouse(j).discr_before)); hold on; 
    ecdf(abs(Mouse(j).discr_during)); 
    ecdf(abs(Mouse(j).discr_after)); 
    legend('Before', 'During', 'After'); 
    xlabel('Discrimination Ratio')
    % Construct proper name for the title
    title(mouse_name_title(Mouse(j).Animal));
end;

% Same but all mice only
figure(346)
ecdf(abs(All.discr_before)); hold on; 
ecdf(abs(All.discr_during)); 
ecdf(abs(All.discr_after)); 
xlabel('Discrimination Ratio')
legend('Before', 'During', 'After'); 
title('All Mice Combined');

% Same as above but for discrimination ratios
figure(347)
for j = 1:4; 
    
    discr_ratio_proportion = [sum(abs(Mouse(j).discr_before) == 1)/sum(~isnan(abs(Mouse(j).discr_before))),...
        sum(abs(Mouse(j).discr_during) == 1)/sum(~isnan(abs(Mouse(j).discr_during))), ...
        sum(abs(Mouse(j).discr_after) == 1)/sum(~isnan(abs(Mouse(j).discr_after)))];
    subplot(2,2,j); 
    plot([1 2 3],discr_ratio_proportion,'*-')
    xlim([0 4]); ylim([0.4 1])
    ylabel('Proportion of Cells with Discr Ratio = 1')
    set(gca,'XTick',[1 2 3],'XTickLabel',{'Before','During','After'})
    % Construct proper name for the title
    title(mouse_name_title(Mouse(j).Animal));
end

% Discrimination Ratios for all mice
figure(348)
discr_ratio_proportion = [sum(abs(All.discr_before) == 1)/sum(~isnan(abs(All.discr_before))),...
    sum(abs(All.discr_during) == 1)/sum(~isnan(abs(All.discr_during))), ...
    sum(abs(All.discr_after) == 1)/sum(~isnan(abs(All.discr_after)))];
plot([1 2 3],discr_ratio_proportion,'*-')
xlim([0 4]); ylim([0.4 0.8])
ylabel('Proportion of Cells with Discr Ratio = 1')
set(gca,'XTick',[1 2 3],'XTickLabel',{'Before','During','After'})
% Construct proper name for the title
title('All Mice');

%% Between shape firing comparisons

figure(350)
ecdf(All.min_dist_before); hold on;
ecdf(All.min_dist_during);
ecdf(All.min_dist_after);
ecdf(All.min_dist_shuffle_all);
legend('Before','During','After','Shuffled')
xlabel('Distance between Place Field centroid location in opposite arena')

%% QC discriminating neurons by plotting them on the appropriate all_ICmask - this lets
% you step through each neuron that appears only in the second session and
% overlay it on all the first session neurons
plot_this = 0;

mouse_num = 2;
compare_sesh = [13 15];

% Get neurons that fire in one arena but not the other between the two
% sessions above
discr_neurons1 = find(Mouse(mouse_num).discr_after == -1 & ...
    Mouse(mouse_num).batch_map(:,compare_sesh(2)+1) ~= 0 &...
    ~isnan(Mouse(mouse_num).batch_map(:,compare_sesh(2) + 1)));

ChangeDirectory(Mouse(mouse_num).Animal,Mouse(mouse_num).sesh(1).Date,...
    Mouse(mouse_num).sesh(1).Session);

for j = 1:2
    load(['RegistrationInfo-' Mouse(mouse_num).Animal '-' ...
        Mouse(mouse_num).sesh(compare_sesh(j)).Date '-session' ...
        num2str(Mouse(mouse_num).sesh(compare_sesh(j)).Session) '.mat']);
    reginfo{j} = RegistrationInfoX;
end

ChangeDirectory(Mouse(mouse_num).Animal,Mouse(mouse_num).sesh(compare_sesh(1)).Date,...
    Mouse(mouse_num).sesh(compare_sesh(1)).Session);
load('ProcOut.mat', 'NeuronImage','InitPixelList','Xdim','Ydim','cTon');
AllICmask = create_AllICmask(NeuronImage);
AllICmask_reg = imwarp_quick(AllICmask,reginfo{1});

% Steal code from PlotNeuronOutlines to only draw the neuron outlines, or
% even the Transient outlines, but without using bwboundaries


ChangeDirectory(Mouse(mouse_num).Animal,Mouse(mouse_num).sesh(compare_sesh(2)).Date,...
    Mouse(mouse_num).sesh(compare_sesh(2)).Session);
load('ProcOut.mat', 'NeuronImage');
figure(100);
for j = 1:length(discr_neurons1)
    neuron_use = discr_neurons1(j);
    neuron_reg = imwarp_quick(NeuronImage{Mouse(mouse_num).batch_map(neuron_use,...
        compare_sesh(2)+1)}, reginfo{2});
    imagesc(AllICmask_reg + 2*neuron_reg)
    waitforbuttonpress
end


