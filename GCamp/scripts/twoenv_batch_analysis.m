% Batch script for two-env experiment
close all

%% Filtering variables
trans_rate_thresh = 0.005; % Hz
pval_thresh = 0.5; % don't include ANY TMaps with p-values above this
within_session = 1;
num_shuffles = 1; 
days_active_use = 2; % Do same plots using only neurons that are active this number of days
file_append = ''; % If using archived PlaceMaps, this will be appended to the end of the Placemaps files
num_grids_PFdens = 3; % Number of grids to use when dividing up arena for PFdensity analysis

%% Other variables
PV_corr_bins = 5; % Number of bins to use for arenas when calculating PV correlations

%% Set up mega-variable - note that working_dir 1 = square sessions and 2 = octagon sessions (REQUIRED)
[MD, ref] = MakeMouseSessionList('Nat');

Mouse(1).Name = 'G30';
Mouse(1).working_dirs{1} = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working';
Mouse(1).working_dirs{2} = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working';
Mouse(1).square_base_sesh = MD(ref.G30.two_env(1));

Mouse(2).Name = 'G31';
Mouse(2).working_dirs{1} = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
Mouse(2).working_dirs{2} = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\1 - 2env octagon left\Working';
Mouse(2).square_base_sesh = MD(ref.G31.two_env(1));

Mouse(3).Name = 'G45';
Mouse(3).working_dirs{1} = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\1 - square right\Working';
Mouse(3).working_dirs{2} = 'J:\GCamp Mice\Working\G45\2env\08_29_2015\1 - oct right\Working';
Mouse(3).square_base_sesh = MD(ref.G45.twoenv(1));

Mouse(4).Name = 'G48';
Mouse(4).working_dirs{1} = 'E:\GCamp Mice\G48\2env\08_29_2015\1 - square right\Working';
Mouse(4).working_dirs{2} = 'E:\GCamp Mice\G48\2env\08_30_2015\1 - oct mid\Working';
Mouse(4).square_base_sesh = MD(ref.G48.twoenv(1));

num_animals = length(Mouse);

for j = 1:num_animals
    Mouse(j).key = '1,1 = square distal cues aligned, 1,2 = octagon distal cues aligned, 2,1 = square local cues aligned, 2,2 = octagon local cues aligned';
end

%% Check for already run instances of the above and load to save time

cd(Mouse(1).working_dirs{1});
[exist_logical, dirstr] = exist_saved_workspace('workspace','trans_rate_thresh',trans_rate_thresh,...
        'pval_thresh',pval_thresh,'within_session',within_session,...
        'num_shuffles',num_shuffles,'PV_corr_bins',PV_corr_bins,...
        'num_grids_PFdens',num_grids_PFdens);
% Don't save if it already exists
if exist_logical == 1
    disp('Previously ran workspace found - loading and skipping running most stuff')
    load(dirstr)
    exist_logical = 1;
    start_ticker = tic;
else % Run everything and save at end.
    start_ticker = tic;

%% Run tmap_corr_across_days for all conditions
curr_dir = cd;
for j = 1:num_animals
    disp(['>>>>>>>>> MOUSE ' num2str(j) ' <<<<<<<<<<<'])
    for k = 1:length(Mouse(j).working_dirs)
        cd(Mouse(j).working_dirs{k});
        load batch_session_map.mat
        Mouse(j).batch_session_map(k) = batch_session_map;
        Mouse(j).days_active{k} = sum(batch_session_map.map(:,2:end) > 0,2); % Get #days active for each neuron
        tt = tic;
        for m = 0:1
            [Mouse(j).corr_matrix{m+1,k}, pop_struct_temp, Mouse(j).min_dist_matrix{m+1,k}, ...
                Mouse(j).vec_diff_matrix{m+1,k}, Mouse(j).pass_count{m+1,k},...
                Mouse(j).within_corr{m+1,k}, Mouse(j).shuffle_matrix{m+1,k}, Mouse(j).dist_shuffle_matrix{m+1,k},...
                Mouse(j).pop_corr_shuffle_matrix{m+1,k}] = ...
                tmap_corr_across_days(Mouse(j).working_dirs{k},...
                'rotate_to_std',m,'population_corr',1,'trans_rate_thresh', ...
                trans_rate_thresh, 'pval_thresh',pval_thresh,...
                'archive_name_append',file_append,'within_session',within_session,...
                'num_shuffles',num_shuffles);
            Mouse(j).pop_corr_matrix{m+1,k} = pop_struct_temp.r;
            disp(['tmap_corr_across_days took ' num2str(toc(tt)) ' seconds to run'])
        end

    end
    Mouse(j).trans_rate_thresh = trans_rate_thresh;
end
cd(curr_dir)

%% Create PF density maps
disp('Creating PF density maps')
for j = 1:num_animals
    for k = 1:2
       batch_map_use = fix_batch_session_map(Mouse(j).batch_session_map(k));
       for ll = 1:8
           dirstr = ChangeDirectory_NK(batch_map_use.session(ll),0); % Get base directory
           load(fullfile(dirstr,'PlaceMaps_rot_to_std.mat'),'TMap_gauss',...
               'RunOccMap'); % Load TMaps and Occupancy map
           temp = create_PFdensity_map(cellfun(@(a) ...
               make_binary_TMap(a),TMap_gauss,'UniformOutput',0)); % create density map from binary TMaps
           [~, Mouse(j).PFdens_map{k,ll}] = make_nan_TMap(RunOccMap,temp); % Make non-occupied pixels white
           Mouse(j).PFdensity_analysis(k).RunOccMap{ll} = RunOccMap; % save RunOccMaps for future analysis
       end
    end
end

%% Dump means into a mega-matrix (combine ALL correlation values here also to get a mega cdf for each session?)

num_sessions = size(Mouse(1).corr_matrix{1},1);
% mega_mean(1).matrix = cell(num_sessions,num_sessions); % No rotate
% mega_mean(2).matrix = cell(num_sessions,num_sessions); % rotate

% Get individual neuron mean correlation matrices

count = 1; % Start counter
for j = 1:num_animals
    for k = 1:2
        mega_mean_local_align_temp = nanmean(Mouse(j).corr_matrix{2,k},3);
        mega_mean_distal_align_temp = nanmean(Mouse(j).corr_matrix{1,k},3);
        
        mega_mean(1).matrix(:,:,count) = mega_mean_distal_align_temp; % [mega_mean(1).matrix(ll,mm) mega_mean_no_rot_temp];
        mega_mean(2).matrix(:,:,count) = mega_mean_local_align_temp; % [mega_mean(2).matrix(ll,mm) mega_mean_rot_temp];
        count = count + 1;
    end
end

% Do this with criteria for # days active
for ll = 2:8
    count = 1; % Start counter
    for j = 1:num_animals
        for k = 1:2
            mega_mean_local_align_temp = nanmean(Mouse(j).corr_matrix{2,k}(:,:,Mouse(j).days_active{k} == ll),3);
            mega_mean_distal_align_temp = nanmean(Mouse(j).corr_matrix{1,k}(:,:,Mouse(j).days_active{k} == ll),3);
            
            mega_mean_byday(ll).mega_mean(1).matrix(:,:,count) = mega_mean_distal_align_temp; % [mega_mean(1).matrix(ll,mm) mega_mean_no_rot_temp];
            mega_mean_byday(ll).mega_mean(2).matrix(:,:,count) = mega_mean_local_align_temp; % [mega_mean(2).matrix(ll,mm) mega_mean_rot_temp];
            count = count + 1;
        end
    end
end

% Get population correlation matrices

for ll = 1:num_sessions
    for mm = 1:num_sessions
        count = 1; % Start counter
        for j = 1:num_animals
            for k = 1:2
                mega_mean_pop_local_align_temp = Mouse(j).pop_corr_matrix{2,k}(ll,mm,:);
                mega_mean_pop_distal_align_temp = Mouse(j).pop_corr_matrix{1,k}(ll,mm,:);
                
                mega_mean(1).pop_matrix(ll,mm,count) = mega_mean_pop_distal_align_temp; % [mega_mean(1).matrix(ll,mm) mega_mean_no_rot_temp];
                mega_mean(2).pop_matrix(ll,mm,count) = mega_mean_pop_local_align_temp; % [mega_mean(2).matrix(ll,mm) mega_mean_rot_temp];
                count = count + 1;
            end
        end
    end
end

% Get shuffled distributions
shuffle_comb = Mouse(1).shuffle_matrix{1,1}; % Hacked for now
for j = 2:num_animals
   shuffle_comb = cat(4,shuffle_comb,Mouse(j).shuffle_matrix{1,1}); % Hacked for now
end


%% Run PV correlations

for j = 1:num_animals
    disp(['RUNNING SECOND PV ANALYSIS FOR MOUSE ' num2str(j)])
    for arena_counter = 1:2
        for rot_counter = 0:1
            temp = fix_batch_session_map(Mouse(j).batch_session_map(arena_counter));
            [PV2, PV_corrs2] = get_PV_and_corr(temp.session,...
                Mouse(j).batch_session_map(arena_counter).map,'rot_to_std',rot_counter,...
                'use_trans',0,'NumXBins',PV_corr_bins,'NumYBins',PV_corr_bins);
            Mouse(j).PV_corrs2{rot_counter+1,arena_counter} = PV_corrs2;
        end
    end
end
%% Mega-matrix2 - dump ALL neuron correlations together into appropriate matrices
% simple version = only look at mean values for each animal
% [ before_win2.distal_all, before_win2.local_all, before_win2.both_all, ...
%     before_win2.distal_simple, before_win2.local_simple, before_win2.both_simple] = ...
%     twoenv_make_megamean2(Mouse, before_win_conflict, before_win_aligned );

%% Get basic stats - not done for population correlations yet

exclude_G48 = 0; % Use if you want to exclude G48 due to high remapping within session
% and/or different behavior from other mice (very low velocity and poor
% coverage of the arena). 2 = exclude G45 AND G48

% Better way to do things in the future is to get values for ALL neuron correlations in
% each session and group them together somehow after classifying them due
% to the various comparisons below
if exclude_G48 == 0
    mean_simple_distal_align = mean(mega_mean(1).matrix,3);
    mean_simple_local_align = mean(mega_mean(2).matrix,3);
elseif exclude_G48 == 1
    mean_simple_distal_align = mean(mega_mean(1).matrix(:,:,1:6),3);
    mean_simple_local_align = mean(mega_mean(2).matrix(:,:,1:6),3);
elseif exclude_G48 == 2
    mean_simple_distal_align = mean(mega_mean(1).matrix(:,:,1:4),3);
    mean_simple_local_align = mean(mega_mean(2).matrix(:,:,1:4),3);
end
if isnan(sum(mean_simple_local_align(:))) || isnan(sum(mean_simple_distal_align(:)))
    disp('Note - some sessions have NO good correlations due to not meeting the threshold - be sure to check!')
    mean_simple_distal_align = nanmean(mega_mean(1).matrix,3);
    mean_simple_local_align = nanmean(mega_mean(2).matrix,3);
end

% Population Simple Means
mean_simple_pop_distal_align = mean(mega_mean(1).pop_matrix,3);
mean_simple_pop_local_align = mean(mega_mean(2).pop_matrix,3);

% Shuffled Simple means
mean_shuffle_simple = nanmean(squeeze(nanmean(shuffle_comb,1)),3);
shuffle_mean = nanmean(shuffle_comb(:));

% Indices for various comparisons - wow, that's a lot of work
before_win_local = [1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4]; before_win_local_ind = sub2ind([8 8],before_win_local(:,1), before_win_local(:,2));
before_win_distal = [1 2; 1 4; 2 4; 3 4]; before_win_distal_ind = sub2ind([8 8],before_win_distal(:,1), before_win_distal(:,2));
after_win_local = [7 8]; after_win_local_ind = sub2ind([8 8],after_win_local(:,1), after_win_local(:,2));
after_win_distal = [7 8]; after_win_distal_ind = sub2ind([8 8],after_win_distal(:,1), after_win_distal(:,2));
before_after_local = [1 7; 2 7; 3 7; 4 7; 1 8; 2 8 ;3 8; 4 8]; before_after_local_ind = sub2ind([8 8],before_after_local(:,1), before_after_local(:,2));
before_after_distal = [2 7; 4 7; 1 8; 2 8 ; 3 8]; before_after_distal_ind = sub2ind([8 8],before_after_distal(:,1), before_after_distal(:,2));
before_5_local = [1 5; 2 5; 3 5; 4 5]; before_5_local_ind = sub2ind([8 8],before_5_local(:,1), before_5_local(:,2));
before_5_distal = [2 5; 4 5]; before_5_distal_ind = sub2ind([8 8],before_5_distal(:,1), before_5_distal(:,2));
before_6_local = [1 6; 2 6 ; 3 6; 4 6]; before_6_local_ind = sub2ind([8 8],before_6_local(:,1), before_6_local(:,2));
before_6_distal = [1 6; 2 6; 3 6; 4 6]; before_6_distal_ind = sub2ind([8 8],before_6_distal(:,1), before_6_distal(:,2));
after_5_local = [5 7; 5 8]; after_5_local_ind = sub2ind([8 8],after_5_local(:,1), after_5_local(:,2));
after_5_distal = [5 8]; after_5_distal_ind = sub2ind([8 8],after_5_distal(:,1), after_5_distal(:,2));
after_6_local = [6 7; 6 8]; after_6_local_ind = sub2ind([8 8],after_6_local(:,1), after_6_local(:,2));
after_6_distal = [6 7; 6 8]; after_6_distal_ind = sub2ind([8 8],after_6_distal(:,1), after_6_distal(:,2));
conn1_conn2_local = [5 6]; conn1_conn2_local_ind = sub2ind([8 8],conn1_conn2_local(:,1), conn1_conn2_local(:,2));
conn1_conn2_distal = [5 6]; conn1_conn2_distal_ind = sub2ind([8 8],conn1_conn2_distal(:,1), conn1_conn2_distal(:,2));

% Mean of individual correlations
before_win_local_mean = mean(mean_simple_local_align(before_win_local_ind));
before_win_local_sem = std(mean_simple_local_align(before_win_local_ind))/sqrt(length(before_win_local_ind));
before_win_distal_mean = mean(mean_simple_distal_align(before_win_distal_ind));
before_win_distal_sem = std(mean_simple_distal_align(before_win_distal_ind))/sqrt(length(before_win_distal_ind));
before_win_shuffle_mean = mean(mean_shuffle_simple(before_win_local_ind));
before_win_shuffle_sem = std(mean_shuffle_simple(before_win_local_ind))/sqrt(length(before_win_local_ind));

before_after_local_mean = mean(mean_simple_local_align(before_after_local_ind));
before_after_local_sem = std(mean_simple_local_align(before_after_local_ind))/sqrt(length(before_after_local_ind));
before_after_distal_mean = mean(mean_simple_distal_align(before_after_distal_ind));
before_after_distal_sem = std(mean_simple_distal_align(before_after_distal_ind))/sqrt(length(before_after_distal_ind));
before_after_shuffle_mean = mean(mean_shuffle_simple(before_after_local_ind));
before_after_shuffle_sem = std(mean_shuffle_simple(before_after_local_ind))/sqrt(length(before_after_local_ind));

before_5_local_mean = mean(mean_simple_local_align(before_5_local_ind));
before_5_local_sem = std(mean_simple_local_align(before_5_local_ind))/sqrt(length(before_5_local_ind));
before_5_distal_mean = mean(mean_simple_distal_align(before_5_distal_ind));
before_5_distal_sem = std(mean_simple_distal_align(before_5_distal_ind))/sqrt(length(before_5_distal_ind));
before_5_shuffle_mean = mean(mean_shuffle_simple(before_5_local_ind));
before_5_shuffle_sem = std(mean_shuffle_simple(before_5_local_ind))/sqrt(length(before_5_local_ind));

before_6_local_mean = mean(mean_simple_local_align(before_6_local_ind));
before_6_local_sem = std(mean_simple_local_align(before_6_local_ind))/sqrt(length(before_6_local_ind));
before_6_distal_mean = mean(mean_simple_distal_align(before_6_distal_ind));
before_6_distal_sem = std(mean_simple_distal_align(before_6_distal_ind))/sqrt(length(before_6_distal_ind));
before_6_shuffle_mean = mean(mean_shuffle_simple(before_6_local_ind));
before_6_shuffle_sem = std(mean_shuffle_simple(before_6_local_ind))/sqrt(length(before_6_local_ind));

after_5_local_mean = mean(mean_simple_local_align(after_5_local_ind));
after_5_local_sem = std(mean_simple_local_align(after_5_local_ind))/sqrt(length(after_5_local_ind));
after_5_distal_mean = mean(mean_simple_distal_align(after_5_distal_ind));
after_5_distal_sem = std(mean_simple_distal_align(after_5_distal_ind))/sqrt(length(after_5_distal_ind));
after_5_distal_sem = after_5_local_sem; % Fake it for now...only have one sample currently
after_5_shuffle_mean = mean(mean_shuffle_simple(after_5_local_ind));
after_5_shuffle_sem = std(mean_shuffle_simple(after_5_local_ind))/sqrt(length(after_5_local_ind));

after_6_local_mean = mean(mean_simple_local_align(after_6_local_ind));
after_6_local_sem = std(mean_simple_local_align(after_6_local_ind))/sqrt(length(after_6_local_ind));
after_6_distal_mean = mean(mean_simple_distal_align(after_6_distal_ind));
after_6_distal_sem = std(mean_simple_distal_align(after_6_distal_ind))/sqrt(length(after_6_distal_ind));
after_6_shuffle_mean = mean(mean_shuffle_simple(after_6_local_ind));
after_6_shuffle_sem = std(mean_shuffle_simple(after_6_local_ind))/sqrt(length(after_6_local_ind));

% Mean of population correlations
pop_before_win_local_mean = mean(mean_simple_pop_local_align(before_win_local_ind));
pop_before_win_local_sem = std(mean_simple_pop_local_align(before_win_local_ind))/sqrt(length(before_win_local_ind));
pop_before_win_distal_mean = mean(mean_simple_pop_distal_align(before_win_distal_ind));
pop_before_win_distal_sem = std(mean_simple_pop_distal_align(before_win_distal_ind))/sqrt(length(before_win_distal_ind));

pop_before_after_local_mean = mean(mean_simple_pop_local_align(before_after_local_ind));
pop_before_after_local_sem = std(mean_simple_pop_local_align(before_after_local_ind))/sqrt(length(before_after_local_ind));
pop_before_after_distal_mean = mean(mean_simple_pop_distal_align(before_after_distal_ind));
pop_before_after_distal_sem = std(mean_simple_pop_distal_align(before_after_distal_ind))/sqrt(length(before_after_distal_ind));

pop_before_5_local_mean = mean(mean_simple_pop_local_align(before_5_local_ind));
pop_before_5_local_sem = std(mean_simple_pop_local_align(before_5_local_ind))/sqrt(length(before_5_local_ind));
pop_before_5_distal_mean = mean(mean_simple_pop_distal_align(before_5_distal_ind));
pop_before_5_distal_sem = std(mean_simple_pop_distal_align(before_5_distal_ind))/sqrt(length(before_5_distal_ind));

pop_before_6_local_mean = mean(mean_simple_pop_local_align(before_6_local_ind));
pop_before_6_local_sem = std(mean_simple_pop_local_align(before_6_local_ind))/sqrt(length(before_6_local_ind));
pop_before_6_distal_mean = mean(mean_simple_pop_distal_align(before_6_distal_ind));
pop_before_6_distal_sem = std(mean_simple_pop_distal_align(before_6_distal_ind))/sqrt(length(before_6_distal_ind));

pop_after_5_local_mean = mean(mean_simple_pop_local_align(after_5_local_ind));
pop_after_5_local_sem = std(mean_simple_pop_local_align(after_5_local_ind))/sqrt(length(after_5_local_ind));
pop_after_5_distal_mean = mean(mean_simple_pop_distal_align(after_5_distal_ind));
pop_after_5_distal_sem = std(mean_simple_pop_distal_align(after_5_distal_ind))/sqrt(length(after_5_distal_ind));
pop_after_5_distal_sem = pop_after_5_local_sem; % Fake it for now...only have one sample currently

pop_after_6_local_mean = mean(mean_simple_pop_local_align(after_6_local_ind));
pop_after_6_local_sem = std(mean_simple_pop_local_align(after_6_local_ind))/sqrt(length(after_6_local_ind));
pop_after_6_distal_mean = mean(mean_simple_pop_distal_align(after_6_distal_ind));
pop_after_6_distal_sem = std(mean_simple_pop_distal_align(after_6_distal_ind))/sqrt(length(after_6_distal_ind));

% Attempt to get more legit statistics - get mean of ALL comparisons
% across all mice, not mean of means...confusing, I know, but more legit
if exclude_G48 == 0
    mega_size = [8 8 8]; % mega_size = size(mega_mean(2).matrix);
elseif exclude_G48 == 1
    mega_size = [8 8 6];
elseif exclude_G48 == 2
    mega_size = [8 8 4];
end

before_win_local_ind = make_mega_sub2ind(mega_size, before_win_local(:,1), before_win_local(:,2)); 
before_win_distal_ind = make_mega_sub2ind(mega_size, before_win_distal(:,1), before_win_distal(:,2));
before_after_local_ind = make_mega_sub2ind(mega_size, before_after_local(:,1), before_after_local(:,2)); 
before_after_distal_ind = make_mega_sub2ind(mega_size, before_after_distal(:,1), before_after_distal(:,2)); 
before_5_local_ind = make_mega_sub2ind(mega_size, before_5_local(:,1), before_5_local(:,2)); 
before_5_distal_ind = make_mega_sub2ind(mega_size, before_5_distal(:,1), before_5_distal(:,2));
after_5_local_ind = make_mega_sub2ind(mega_size, after_5_local(:,1), after_5_local(:,2)); 
after_5_distal_ind = make_mega_sub2ind(mega_size, after_5_distal(:,1), after_5_distal(:,2));
before_6_local_ind = make_mega_sub2ind(mega_size, before_6_local(:,1), before_6_local(:,2)); 
before_6_distal_ind = make_mega_sub2ind(mega_size, before_6_distal(:,1), before_6_distal(:,2));
after_6_local_ind = make_mega_sub2ind(mega_size, after_6_local(:,1), after_6_local(:,2)); 
after_6_distal_ind = make_mega_sub2ind(mega_size, after_6_distal(:,1), after_6_distal(:,2));
conn1_conn2_local_ind = make_mega_sub2ind(mega_size, conn1_conn2_local(:,1), conn1_conn2_local(:,2)); 
conn1_conn2_distal_ind = make_mega_sub2ind(mega_size, conn1_conn2_distal(:,1), conn1_conn2_distal(:,2));

% Combined groupings (separate, connected day 1, connected day 2)
separate_win_local = [before_win_local; before_after_local]; % Should include after_win also!!!
separate_win_local_ind = [before_win_local_ind; before_after_local_ind];
separate_win_local_mean = mean(mega_mean(2).matrix(separate_win_local_ind));
separate_win_local_sem = std(mega_mean(2).matrix(separate_win_local_ind))/sqrt(length(separate_win_local_ind));
separate_win_distal = [before_win_distal; before_after_distal];
separate_win_distal_ind = [before_win_distal_ind; before_after_distal_ind];
separate_win_distal_mean = mean(mega_mean(1).matrix(separate_win_distal_ind));
separate_win_distal_sem = std(mega_mean(1).matrix(separate_win_distal_ind))/sqrt(length(separate_win_distal_ind));

sep_conn1_local = [before_5_local; after_5_local];
sep_conn1_local_ind = [before_5_local_ind; after_5_local_ind];
sep_conn1_local_mean = mean(mega_mean(2).matrix(sep_conn1_local_ind));
sep_conn1_local_sem = std(mega_mean(2).matrix(sep_conn1_local_ind))/sqrt(length(sep_conn1_local_ind));
sep_conn1_distal = [before_5_distal; after_5_distal];
sep_conn1_distal_ind = [before_5_distal_ind; after_5_distal_ind];
sep_conn1_distal_mean = mean(mega_mean(1).matrix(sep_conn1_distal_ind));
sep_conn1_distal_sem = std(mega_mean(1).matrix(sep_conn1_distal_ind))/sqrt(length(sep_conn1_distal_ind));

sep_conn2_local = [before_6_local; after_6_local];
sep_conn2_local_ind = [before_6_local_ind; after_6_local_ind];
sep_conn2_local_mean = mean(mega_mean(2).matrix(sep_conn2_local_ind));
sep_conn2_local_sem = std(mega_mean(2).matrix(sep_conn2_local_ind))/sqrt(length(sep_conn2_local_ind));
sep_conn2_distal = [before_6_distal; after_6_distal];
sep_conn2_distal_ind = [before_6_distal_ind; after_6_distal_ind];
sep_conn2_distal_mean = mean(mega_mean(1).matrix(sep_conn2_distal_ind));
sep_conn2_distal_sem = std(mega_mean(1).matrix(sep_conn2_distal_ind))/sqrt(length(sep_conn2_distal_ind));

conn1_conn2_local_mean = mean(mega_mean(2).matrix(conn1_conn2_local_ind));
conn1_conn2_local_sem = std(mega_mean(2).matrix(conn1_conn2_local_ind))/sqrt(length(conn1_conn2_local_ind));
conn1_conn2_distal_mean = mean(mega_mean(1).matrix(conn1_conn2_distal_ind));
conn1_conn2_distal_sem = std(mega_mean(1).matrix(conn1_conn2_distal_ind))/sqrt(length(conn1_conn2_distal_ind));

before_after_local_mean2 = mean(mega_mean(2).matrix(before_after_local_ind));
before_after_local_sem2 = std(mega_mean(2).matrix(before_after_local_ind))/sqrt(length(before_after_local_ind));
before_after_distal_mean2 = mean(mega_mean(1).matrix(before_after_distal_ind));
before_after_distal_sem2 = std(mega_mean(1).matrix(before_after_distal_ind))/sqrt(length(before_after_distal_ind));

%% Do Above for individual mice
for j = 1:length(Mouse)
    [ Mouse(j).local_stat.separate_win, Mouse(j).distal_stat.separate_win ] = ...
        twoenv_get_ind_mean(Mouse(j), separate_win_local, separate_win_distal);
    [ Mouse(j).local_stat.sep_conn1, Mouse(j).distal_stat.sep_conn1 ] = ...
        twoenv_get_ind_mean(Mouse(j), sep_conn1_local, sep_conn1_distal);
    [ Mouse(j).local_stat.sep_conn2, Mouse(j).distal_stat.sep_conn2 ] = ...
        twoenv_get_ind_mean(Mouse(j), sep_conn2_local, sep_conn2_distal);
    [ Mouse(j).local_stat.before_after, Mouse(j).distal_stat.before_after ] = ...
        twoenv_get_ind_mean(Mouse(j), before_after_local, before_after_distal);
end

% For all mice combined
[ local_stat_all.separate_win, distal_stat_all.separate_win ] = ...
    twoenv_get_ind_mean(Mouse, separate_win_local, separate_win_distal);
[ local_stat_all.sep_conn1, distal_stat_all.sep_conn1 ] = ...
    twoenv_get_ind_mean(Mouse, sep_conn1_local, sep_conn1_distal);
[ local_stat_all.sep_conn2, distal_stat_all.sep_conn2 ] = ...
    twoenv_get_ind_mean(Mouse, sep_conn2_local, sep_conn2_distal);
[ local_stat_all.before_after, distal_stat_all.before_after ] = ...
    twoenv_get_ind_mean(Mouse, before_after_local, before_after_distal);

%% Do above but with better indices

twoenv_betterindices; % Run script to get better indices
separate_conflict = cellfun(@(a,b) [a; b],before_win_conflict, after_win_conflict,'UniformOutput',0);
separate_aligned = cellfun(@(a,b) [a; b],before_win_aligned, after_win_aligned,'UniformOutput',0);

sep_conn1_conflict = cellfun(@(a,b) [a; b],before_5_conflict, after_5_conflict,'UniformOutput',0);
sep_conn1_aligned = cellfun(@(a,b) [a; b],before_5_aligned, after_5_aligned,'UniformOutput',0);

sep_conn2_conflict = cellfun(@(a,b) [a; b],before_6_conflict, after_6_conflict,'UniformOutput',0);
sep_conn2_aligned = cellfun(@(a,b) [a; b],before_6_aligned, after_6_aligned,'UniformOutput',0);


for j = 1:length(Mouse)
    [ Mouse(j).local_stat2.separate_win, Mouse(j).distal_stat2.separate_win,  ...
        Mouse(j).both_stat2.separate_win] = twoenv_get_ind_mean(Mouse(j), ...
        separate_conflict{j}, separate_conflict{j}, 'both_sub_use',separate_aligned{j});
    [ Mouse(j).local_stat2.sep_conn1, Mouse(j).distal_stat2.sep_conn1,  ...
        Mouse(j).both_stat2.sep_conn1] = twoenv_get_ind_mean(Mouse(j), ...
        sep_conn1_conflict{j}, sep_conn1_conflict{j}, 'both_sub_use',sep_conn1_aligned{j});
    [ Mouse(j).local_stat2.sep_conn2, Mouse(j).distal_stat2.sep_conn2,  ...
        Mouse(j).both_stat2.sep_conn2] = twoenv_get_ind_mean(Mouse(j), ...
        sep_conn2_conflict{j}, sep_conn2_conflict{j}, 'both_sub_use',sep_conn2_aligned{j});
    [ Mouse(j).local_stat2.before_after, Mouse(j).distal_stat2.before_after,  ...
        Mouse(j).both_stat2.before_after] = twoenv_get_ind_mean(Mouse(j), ...
        before_after_conflict{j}, before_after_conflict{j}, 'both_sub_use',before_after_aligned{j});
    
    [ Mouse(j).local_stat2.before_5, Mouse(j).distal_stat2.before_5,  ...
        Mouse(j).both_stat2.before_5] = twoenv_get_ind_mean(Mouse(j), ...
        before_5_conflict{j}, before_5_conflict{j}, 'both_sub_use',before_5_aligned{j});
    [ Mouse(j).local_stat2.before_6, Mouse(j).distal_stat2.before_6,  ...
        Mouse(j).both_stat2.before_6] = twoenv_get_ind_mean(Mouse(j), ...
        before_6_conflict{j}, before_6_conflict{j}, 'both_sub_use',before_6_aligned{j});
    [ Mouse(j).local_stat2.after_5, Mouse(j).distal_stat2.after_5,  ...
        Mouse(j).both_stat2.after_5] = twoenv_get_ind_mean(Mouse(j), ...
        after_5_conflict{j}, after_5_conflict{j}, 'both_sub_use',after_5_aligned{j});
    [ Mouse(j).local_stat2.after_6, Mouse(j).distal_stat2.after_6,  ...
        Mouse(j).both_stat2.after_6] = twoenv_get_ind_mean(Mouse(j), ...
        after_6_conflict{j}, after_6_conflict{j}, 'both_sub_use',after_6_aligned{j});
    
    Mouse(j).both_stat2.separate_win_time = get_time_from_session(separate_aligned{j},...
        time_index);
    Mouse(j).both_stat2.before_after_time = get_time_from_session(before_after_aligned{j},...
        time_index);
    
    % Get other version of population vector correlations
    
     [temp_local_PV, temp_distal_PV, ~] = twoenv_get_ind_mean(Mouse(j), ...
         separate_conflict{j}, separate_conflict{j}, 'metric_type', 'pop_corr_matrix');
     Mouse(j).local_stat2.separate_win.PV_stat_orig = temp_local_PV;
     Mouse(j).distal_stat2.separate_win.PV_stat_orig = temp_distal_PV;
     
     
     % Shift number shuffles to 3rd dimension to keep compatible with
     % twoenv_get_ind_mean
     for kk = 1:4
         size_shuf_mat = size(Mouse(j).pop_corr_shuffle_matrix{kk});
         size_shuf_check = size_shuf_mat == [num_sessions, num_sessions, num_shuffles];
         if sum(size_shuf_check) ~= length(size_shuf_check) % Only shift dimension if it doesn't match
             Mouse(j).pop_corr_shuffle_matrix{kk} = shiftdim(Mouse(j).pop_corr_shuffle_matrix{kk},1);
         end
     end
     
     [temp_local_PV_shuffle, ~, ~] = twoenv_get_ind_mean(Mouse(j), ...
         separate_conflict{j}, separate_conflict{j}, 'metric_type', 'pop_corr_shuffle_matrix');
     
     Mouse(j).local_stat2.separate_win.PV_stat_orig_shuffle = temp_local_PV_shuffle;
end

end

%% Plot stability over time

% Load control data
[control_dir, ~] = ChangeDirectory('GCamp6f_45','08_05_2015',3,0);
time_control = load(fullfile(control_dir, 'control_time_data.mat'));

% Add in plot of stability for each arena
corrs_all = [];
corrs_all2 = [];
shuffle_all = [];
shuffle_all2 = [];

PV_corrs_all = [];
PV_corrs_all2 = [];
PV_shuffle_all = [];
PV_shuffle_all2 = [];

time_all = [];
for j = 1:num_animals

    corrs_all = [corrs_all; Mouse(j).both_stat2.separate_win.all_means; ...
        Mouse(j).both_stat2.before_after.all_means]; 
    corrs_all2 = [corrs_all2; Mouse(j).both_stat2.separate_win.all_out2; ...
        Mouse(j).both_stat2.before_after.all_out2];
    shuffle_all = [shuffle_all; Mouse(j).both_stat2.separate_win.shuffle_stat.all_means; ...
        Mouse(j).both_stat2.before_after.shuffle_stat.all_means]; 
    shuffle_all2 = [shuffle_all2; Mouse(j).both_stat2.separate_win.shuffle_stat.all_out2; ...
        Mouse(j).both_stat2.before_after.shuffle_stat.all_out2];
    time_all = [time_all; Mouse(j).both_stat2.separate_win_time; ...
        Mouse(j).both_stat2.before_after_time]; 
    
    PV_corrs_all = [PV_corrs_all; Mouse(j).both_stat2.separate_win.PV_stat.all_means; ...
        Mouse(j).both_stat2.before_after.PV_stat.all_means]; 
    PV_corrs_all2 = [PV_corrs_all2; Mouse(j).both_stat2.separate_win.PV_stat.all_out2; ...
        Mouse(j).both_stat2.before_after.PV_stat.all_out2];
    PV_shuffle_all = [PV_shuffle_all; Mouse(j).both_stat2.separate_win.PV_stat.shuffle_stat.all_means; ...
        Mouse(j).both_stat2.before_after.PV_stat.shuffle_stat.all_means]; 
    PV_shuffle_all2 = [PV_shuffle_all2; Mouse(j).both_stat2.separate_win.PV_stat.shuffle_stat.all_out2; ...
        Mouse(j).both_stat2.before_after.PV_stat.shuffle_stat.all_out2];

    
end

days_plot = [0 1 2 3 4 5 6]; % Days between sessions to plot

corrs_mean_by_day = arrayfun(@(a) mean(corrs_all(time_all == a)),days_plot);
corrs_sem_by_day = arrayfun(@(a) std(corrs_all(time_all == a))/...
    sum(time_all == a),days_plot);
shuffle_mean_by_day = arrayfun(@(a) mean(shuffle_all(time_all == a)),days_plot);

PV_corrs_mean_by_day = arrayfun(@(a) mean(PV_corrs_all(time_all == a)),days_plot);
PV_corrs_sem_by_day = arrayfun(@(a) std(PV_corrs_all(time_all == a))/...
    sum(time_all == a),days_plot);
PV_shuffle_mean_by_day = arrayfun(@(a) mean(PV_shuffle_all(time_all == a)),days_plot);

% Calculate control sessions
tcontrol_corrs = arrayfun(@(a) nanmean(a.corrs_half(a.pval > 0.95)), time_control(1).session);
tcontrol_mean = mean(tcontrol_corrs);
tcontrol_sem = std(tcontrol_corrs)/length(tcontrol_corrs);

tcontrol_PV_corrs = arrayfun(@(a) nanmean(a.PVcorr(:)),session);
tcontrol_PV_corr_mean = mean(tcontrol_PV_corrs);
tcontrol_PV_corr_sem = std(tcontrol_PV_corrs)/length(tcontrol_PV_corrs);

to_plot = ~isnan(corrs_mean_by_day);
figure(501)
% Individual TMap correlations
subplot(2,1,1)
plot(days_plot(to_plot),corrs_mean_by_day(to_plot),'k.-',days_plot(to_plot),...
shuffle_mean_by_day(to_plot),'r--', 0, tcontrol_mean, 'g.') % time_all,corrs_all,'r*'
hold on
errorbar(days_plot(to_plot),corrs_mean_by_day(to_plot),corrs_sem_by_day(to_plot),'k');
errorbar(days_plot(to_plot),[tcontrol_mean -1 -1 -1 -1],[tcontrol_sem 0 0 0 0],'g.')
xlabel('Days between session'); ylabel('Mean correlation')
title('Stability - Individual Neurons Transient Map Correlations')
xlim([-0.5 6.5]); ylim([0 0.6]); set(gca,'XTick',[0 1 2 3 4 5 6])
legend('Actual','Shuffled','Continuous Session Control (1st v 2nd half)')
hold off
% Population Correlations
subplot(2,1,2)
plot(days_plot(to_plot),PV_corrs_mean_by_day(to_plot),'k.-',days_plot(to_plot),...
PV_shuffle_mean_by_day(to_plot),'r--',0,tcontrol_PV_corr_mean,'g.') % time_all,corrs_all,'r*'
hold on
ht1 = errorbar(days_plot(to_plot),PV_corrs_mean_by_day(to_plot),PV_corrs_sem_by_day(to_plot),'k');
ht2 = errorbar(days_plot(to_plot),[tcontrol_PV_corr_mean -1 -1 -1 -1],[tcontrol_PV_corr_sem 0 0 0 0],'g.');
xlabel('Days between session'); ylabel('Mean correlation')
title('Stability - Population Vector Correlations')
xlim([-0.5 6.5]); ylim([-0.1 0.4]); set(gca,'XTick',[0 1 2 3 4 5 6])
legend('Actual','Shuffled','Continuous Session Control (1st v 2nd half)')
hold off

% figure(499)
% plot(time_all,corrs_all,'r*')
% xlabel('Days between session'); ylabel('Mean correlation - individual TMaps')
% xlim([-0.5 6.5]); set(gca,'XTick',[0 1 2 3 4 5 6])

% Do this but in ecdf format - that is, group ALL TMap individual
% correlations for a given day together
hide_ecdf = 1;
if hide_ecdf == 0
    figure(502)
    corrs_all_by_day = arrayfun(@(a) cat(1,corrs_all2{time_all == a}),...
        days_plot,'UniformOutput',0);
    shuffle_all_comb = cat(1,shuffle_all2{:});
    
    cmap_use = hsv(7);
    days_plot_ind = find(to_plot);
    days_plot2 = days_plot(days_plot_ind);
    for j = 1:length(days_plot2)
        [ft, xt] = ecdf(corrs_all_by_day{days_plot_ind(j)});
        plot(xt,ft,'Color',cmap_use(j,:));
        hold on
    end
    [fshuf, xshuf] = ecdf(shuffle_all_comb);
    plot(xshuf,fshuf,'Color',cmap_use(7,:));
    xlabel('Individual TMap Correlation Value');
    legend([cellfun(@(a) [num2str(a) ' Days'], num2cell(days_plot2),'UniformOutput',0), ...
        'Shuffle']);
    
    % Similar to above but for Population Vectors
    figure(503)
    PV_corrs_all_by_day = arrayfun(@(a) cat(1,PV_corrs_all2{time_all == a}),...
        days_plot,'UniformOutput',0);
    PV_shuffle_all_comb = cat(1,PV_shuffle_all2{:});
    
    cmap_use = hsv(7);
    days_plot_ind = find(to_plot);
    days_plot2 = days_plot(days_plot_ind);
    for j = 1:length(days_plot2)
        [ft, xt] = ecdf(PV_corrs_all_by_day{days_plot_ind(j)});
        plot(xt,ft,'Color',cmap_use(j,:));
        hold on
    end
    [fshuf, xshuf] = ecdf(PV_shuffle_all_comb);
    plot(xshuf,fshuf,'Color',cmap_use(7,:));
    xlabel('Population Vector Correlation Value');
    legend([cellfun(@(a) [num2str(a) ' Days'], num2cell(days_plot2),'UniformOutput',0), ...
    'Shuffle']);
end

% 3 Day correlations are very low for some reason (yet still higher than
% chance).  Most likely reason is that they include sessions right
% before/after connection, whereas there are more sessions for the 5/6 day
% comparisons that occur after at least one session back in the single
% arenas.  GLM could maybe pull this apart...
% Could do the same for the local individual correlations after showing
% that rotating typically does not induce a remapping relative to the local
% cues - maybe this will pull more together...

%% Remapping due to local cue rotation

% Day lookup table - first column = arena, second column = session, third
% column = day
day_table = [1 1 1; 1 2 1; 2 1 2; 2 2 2; 2 3 3; 2 4 3; 1 3 4; 1 4 4; 1 5 5; ...
    2 5 5; 1 6 6; 2 6 6; 1 7 7; 1 8 7; 2 7 8; 2 8 8];

% Need to add in PV correlations also

local_rot_corrs_all = [];
distal_rot_corrs_all = [];
shuf_corrs_all = [];
means_sameday_day_all = [];
means_sameday_arena_all = [];
local_rot_PV_corrs_all = [];
distal_rot_PV_corrs_all = [];
local_rot_PV_orig_corrs_all = [];
distal_rot_PV_orig_corrs_all = [];
shuf_PV_corrs_all = [];
shuf_PV_orig_all = [];
PV_means_sameday_day_all = [];
PV_means_sameday_arena_all = [];
for j = 1:num_animals
    % Get indices for sessions that occur on the same day
    same_day_indices = (separate_conflict{j}(:,2) == 1 & separate_conflict{j}(:,3) == 2) | ...
        (separate_conflict{j}(:,2) == 3 & separate_conflict{j}(:,3) == 4) | ...
        (separate_conflict{j}(:,2) == 7 & separate_conflict{j}(:,3) == 8);
    
    % Individual Stats
    temp_local = Mouse(j).local_stat2.separate_win.all_means(same_day_indices);
    local_rot_corrs_all = [local_rot_corrs_all; temp_local];
    Mouse(j).local_stat2.separate_win.means_sameday = temp_local;
    Mouse(j).local_stat2.separate_win.means_sameday_day = lookup_day(separate_conflict{j}...
        (same_day_indices,1),separate_conflict{j}(same_day_indices,2));
    means_sameday_day_all = [ means_sameday_day_all; ...
        Mouse(j).local_stat2.separate_win.means_sameday_day];
    means_sameday_arena_all = [ means_sameday_arena_all; ...
        separate_conflict{j}(same_day_indices,1)];
    
    temp_distal = Mouse(j).distal_stat2.separate_win.all_means(same_day_indices);
    distal_rot_corrs_all = [distal_rot_corrs_all; temp_distal];
    Mouse(j).distal_stat2.separate_win.means_sameday = temp_distal;
    
    temp_shuf = Mouse(j).local_stat2.separate_win.shuffle_stat.all_means(same_day_indices);
    shuf_corrs_all = [shuf_corrs_all; temp_shuf];
    Mouse(j).local_stat2.separate_win.shuffle_stat.means_sameday = temp_shuf;
    
    % PV stats
    temp_local = Mouse(j).local_stat2.separate_win.PV_stat.all_means(same_day_indices);
    local_rot_PV_corrs_all = [local_rot_PV_corrs_all; temp_local];
    Mouse(j).local_stat2.separate_win.PV_stat.means_sameday = temp_local;
    Mouse(j).local_stat2.separate_win.PV_stat.means_sameday_day = lookup_day(separate_conflict{j}...
        (same_day_indices,1),separate_conflict{j}(same_day_indices,2));
    
    temp_distal = Mouse(j).distal_stat2.separate_win.PV_stat.all_means(same_day_indices);
    distal_rot_PV_corrs_all = [distal_rot_PV_corrs_all; temp_distal];
    Mouse(j).distal_stat2.separate_win.PV_stat.means_sameday = temp_distal;
    
    temp_shuf = Mouse(j).local_stat2.separate_win.PV_stat.shuffle_stat.all_means(same_day_indices);
    shuf_PV_corrs_all = [shuf_PV_corrs_all; temp_shuf];
    Mouse(j).local_stat2.separate_win.PV_stat.shuffle_stat.means_sameday = temp_shuf;
    
    % Original PV stats for comparison
    temp_local = Mouse(j).local_stat2.separate_win.PV_stat_orig.all_means(same_day_indices);
    local_rot_PV_orig_corrs_all = [local_rot_PV_orig_corrs_all; temp_local];
    temp_distal = Mouse(j).distal_stat2.separate_win.PV_stat_orig.all_means(same_day_indices);
    distal_rot_PV_orig_corrs_all = [distal_rot_PV_orig_corrs_all; temp_distal];
    
    % Original PV shuffled stats
    temp_shuffle = Mouse(j).local_stat2.separate_win.PV_stat_orig_shuffle.all_means;
    shuf_PV_orig_all = [shuf_PV_orig_all; temp_shuffle];
    
end

% Plot of everything - 1) overall mean correlation for local cues or distal
% cues aligned, 2) Same plot by with x-axis as day of comparison, and 3) 
% square vs. circle .  PV and individual vectors.

% Group all individual correlations together
local_rot_corrs_all_mean = mean(local_rot_corrs_all);
local_rot_corrs_all_sem = std(local_rot_corrs_all)/sqrt(length(local_rot_corrs_all));
distal_rot_corrs_all_mean = mean(distal_rot_corrs_all);
distal_rot_corrs_all_sem = std(distal_rot_corrs_all)/sqrt(length(distal_rot_corrs_all));
shuf_corrs_all_mean = mean(shuf_corrs_all);
shuf_corrs_all_sem = std(shuf_corrs_all)/sqrt(length(shuf_corrs_all));

% Group all population correlations together
local_rot_PV_corrs_all_mean = mean(local_rot_PV_corrs_all);
local_rot_PV_corrs_all_sem = std(local_rot_PV_corrs_all)/sqrt(length(local_rot_PV_corrs_all));
distal_rot_PV_corrs_all_mean = mean(distal_rot_PV_corrs_all);
distal_rot_PV_corrs_all_sem = std(distal_rot_PV_corrs_all)/sqrt(length(distal_rot_PV_corrs_all));
shuf_PV_corrs_all_mean = mean(shuf_PV_corrs_all);
shuf_PV_corrs_all_sem = std(shuf_PV_corrs_all)/sqrt(length(shuf_PV_corrs_all));

% Group all original population correlations together
local_rot_PV_orig_corrs_all_mean = mean(local_rot_PV_orig_corrs_all);
local_rot_PV_orig_corrs_all_sem = std(local_rot_PV_orig_corrs_all)/sqrt(length(local_rot_PV_orig_corrs_all));
distal_rot_PV_orig_corrs_all_mean = mean(distal_rot_PV_orig_corrs_all);
distal_rot_PV_orig_corrs_all_sem = std(distal_rot_PV_orig_corrs_all)/sqrt(length(distal_rot_PV_orig_corrs_all));
shuf_PV_orig_all_mean = mean(shuf_PV_orig_all);
shuf_PV_orig_all_sem = std(shuf_PV_orig_all)/sqrt(length(shuf_PV_orig_all));

% Aggregate by day
[day_plot, means_by_day] = aggregate_by_group( local_rot_corrs_all, ...
    means_sameday_day_all);
means_by_day_plot = cellfun(@mean, means_by_day);
means_by_day_sem = cellfun(@(a) std(a)/sqrt(length(a)), means_by_day);

[~, PV_means_by_day] = aggregate_by_group( local_rot_PV_corrs_all, ...
    means_sameday_day_all);
PV_means_by_day_plot = cellfun(@mean, PV_means_by_day);
PV_means_by_day_sem = cellfun(@(a) std(a)/sqrt(length(a)), PV_means_by_day);


% Aggregate by arena
[arena_plot, means_by_arena] = aggregate_by_group( local_rot_corrs_all, ...
    means_sameday_arena_all);
means_by_arena_plot = cellfun(@mean, means_by_arena);
means_by_arena_sem = cellfun(@(a) std(a)/sqrt(length(a)), means_by_arena);

[~, PV_means_by_arena] = aggregate_by_group( local_rot_PV_corrs_all, ...
    means_sameday_arena_all);
PV_means_by_arena_plot = cellfun(@mean, PV_means_by_arena);
PV_means_by_arena_sem = cellfun(@(a) std(a)/sqrt(length(a)), PV_means_by_arena);


%% Local rotation effect plots

%%% !!! Why are distal aligned individual correlations close to shuffled
%%% but PV correlations are well above chance, and even close to local
%%% aligned PV correlations?  Would this drop if I used the same size grid
%%% that I do for individual TMaps?

%%% NEED to look at middle of arena PV correlations to possibly explain why
%%% local aligned correlations are low - if it is truly a global remapping
%%% then this shold be low/equal to the mean for each session.  However, if
%%% it is due to mis-orientation by the mouse (that is, the map rotates in
%%% a fashion different than the arena has rotated due to the mouse using a
%%% different cue) then the correlation should be very high.  Need to make
%%% sure this doesn't happen anyway, and if it does, that might be
%%% interesting anyway - could follow up by identifying sessions with high
%%% mid PV correlations but low mean values and look for the rotation that
%%% gives high correlations with the original to prove the mis-orientation.
%%%  
plot_all_rot = 0;
if plot_all_rot == 1
figure(600)

% Local aligned v Distal aligned Corrs - maybe add in both_aligned here
% just as a reference?
subplot(2,2,1)
bar_w_err([corrs_mean_by_day(1), local_rot_corrs_all_mean, distal_rot_corrs_all_mean, shuf_corrs_all_mean;...
    PV_corrs_mean_by_day(1), local_rot_PV_corrs_all_mean, distal_rot_PV_corrs_all_mean, shuf_PV_corrs_all_mean],... %... %nan, local_rot_PV_orig_corrs_all_mean, distal_rot_PV_orig_corrs_all_mean, shuf_PV_orig_all_mean],...
    [ corrs_sem_by_day(1), local_rot_corrs_all_sem, distal_rot_corrs_all_sem, shuf_corrs_all_sem;...
    PV_corrs_sem_by_day(1), local_rot_PV_corrs_all_sem, distal_rot_PV_corrs_all_sem, shuf_PV_corrs_all_sem]); %...
%     nan, local_rot_PV_orig_corrs_all_sem, distal_rot_PV_orig_corrs_all_sem, shuf_PV_orig_all_sem])
xlim([0 3]); ylim([-0.10 0.5]); 
set(gca,'XTick',[1 2],'XTickLabel',{'Ind. Neurons','Population'})% ,'Original Population Calc'})
ylabel('Mean correlations')
title('Mean TMap Correlations by cue alignment - same day')
legend('No rotation', 'Local Cues Aligned','Distal Cues Aligned','Shuffled')

% Local Correlations by day
subplot(2,2,2)
% for j = 1:num_animals
%     plot(Mouse(j).local_stat2.separate_win.means_sameday_day,...
%         Mouse(j).local_stat2.separate_win.means_sameday,'*');
%     hold on
% end
errorbar(day_plot,means_by_day_plot, means_by_day_sem);
hold on
errorbar(day_plot, PV_means_by_day_plot, PV_means_by_day_sem);
xlim([0.5 9.5]); ylim([-0.2 0.4])
xlabel('Day of comparison'); ylabel('Mean TMap Correlation')
legend('Individual Neurons','Population')
title('Correlations by Day for Local Cue Rotations')

% Local rotation correlations by arena
subplot(2,2,3)
bar_w_err([means_by_arena_plot; PV_means_by_arena_plot], ...
    [means_by_arena_sem; PV_means_by_arena_sem])
xlim([0 3]); ylim([0 0.4]); 
set(gca,'XTick',[1 2],'XTickLabel',{'Ind. Neurons','Population'})
ylabel('Mean correlations with local cues aligned')
title('Mean TMap Correlations by arena')
legend('Square','Circle')
end

figure(601)

% Local aligned v Distal aligned Corrs - maybe add in both_aligned here
% just as a reference?
bar_w_err([corrs_mean_by_day(1), local_rot_corrs_all_mean, distal_rot_corrs_all_mean, shuf_corrs_all_mean;...
    PV_corrs_mean_by_day(1), local_rot_PV_corrs_all_mean, distal_rot_PV_corrs_all_mean, shuf_PV_corrs_all_mean],... %... %nan, local_rot_PV_orig_corrs_all_mean, distal_rot_PV_orig_corrs_all_mean, shuf_PV_orig_all_mean],...
    [ corrs_sem_by_day(1), local_rot_corrs_all_sem, distal_rot_corrs_all_sem, shuf_corrs_all_sem;...
    PV_corrs_sem_by_day(1), local_rot_PV_corrs_all_sem, distal_rot_PV_corrs_all_sem, shuf_PV_corrs_all_sem]); %...
%     nan, local_rot_PV_orig_corrs_all_sem, distal_rot_PV_orig_corrs_all_sem, shuf_PV_orig_all_sem])
xlim([0 3]); ylim([-0.10 0.5]); 
set(gca,'XTick',[1 2],'XTickLabel',{'Ind. Neurons','Population'})% ,'Original Population Calc'})
ylabel('Mean correlations')
title('Mean TMap Correlations by cue alignment - same day')
legend('No rotation', 'Local Cues Aligned','Distal Cues Aligned','Shuffled')

% Do above but aggregate for all days of separation

%%% Are the low BUT above chance correlations being driven by a handful of
%%% cells that have high corrs?

%%% WHY ARE THE PV CORRELATIONS FOR DISTAL ALIGNED ABOVE CHANCE BUT NOT THE
%%% INDIVIDUAL MEAN CORRELATIONS?

%% Combine all stats
local_stat2_all = twoenv_combine_stats('local_stat2',Mouse(1),Mouse(2),...
    Mouse(3),Mouse(4));
distal_stat2_all = twoenv_combine_stats('distal_stat2',Mouse(1),Mouse(2),...
    Mouse(3),Mouse(4));
both_stat2_all = twoenv_combine_stats('both_stat2',Mouse(1),Mouse(2),...
    Mouse(3),Mouse(4));

local_stat2_all_noG48 = twoenv_combine_stats('local_stat2',Mouse(1),Mouse(2),...
    Mouse(3));
distal_stat2_all_noG48 = twoenv_combine_stats('distal_stat2',Mouse(1),Mouse(2),...
    Mouse(3));
both_stat2_all_noG48 = twoenv_combine_stats('both_stat2',Mouse(1),Mouse(2),...
    Mouse(3));

local_stat2_all_noG45G48 = twoenv_combine_stats('local_stat2',Mouse(1),Mouse(2));
distal_stat2_all_noG45G48 = twoenv_combine_stats('distal_stat2',Mouse(1),Mouse(2));
both_stat2_all_noG45G48 = twoenv_combine_stats('both_stat2',Mouse(1),Mouse(2));

%% Attempt to do above for day restricted data
% for ll = 2:8
%    twoenv_bars( mega_mean_byday(ll).mega_mean, shuffle_comb, ll) 
% end

%% First attempt to get real stats

% Should probably write below into a simple function and then call it
% repeatedly

after_5_local_comb = [];
after_5_distal_comb = [];
for j = 1:num_animals
    for ll = 1:2
        for mm = 1:size(after_5_local,1)
            after_5_local_comb = [ after_5_local_comb ; squeeze(Mouse(j).corr_matrix{1,ll}(after_5_local(mm,1),after_5_local(mm,2),...
                logical(squeeze(Mouse(j).pass_count{ll,1}(after_5_local(mm,1),after_5_local(mm,2),:)))))];
        end
        for mm = 1:size(after_5_distal,1)
            after_5_distal_comb = [ after_5_distal_comb ; squeeze(Mouse(j).corr_matrix{2,ll}(after_5_distal(mm,1),after_5_distal(mm,2),...
                logical(squeeze(Mouse(j).pass_count{ll,2}(after_5_distal(mm,1),after_5_distal(mm,2),:)))))];
        end
    end
end
nanmean(after_5_local_comb);
nanstd(after_5_local_comb);

% First stab
[ statss.after_5.h, statss.after_5.p ] = twoenv_kstest( Mouse, shuffle_comb, after_5_local, after_5_distal);
[ statss.sep_win.h, statss.sep_win.p, statss.sep_win.mean ] = twoenv_kstest( Mouse, shuffle_comb, ...
    separate_win_local, separate_win_distal); %,'plot_ecdf','separate');
[ statss.sep_conn1.h, statss.sep_conn1.p, statss.sep_conn1.mean ] = twoenv_kstest( Mouse, shuffle_comb, ...
    sep_conn1_local, sep_conn1_distal); %,'plot_ecdf','sep_conn1');
[ statss.sep_conn2.h, statss.sep_conn2.p , statss.sep_conn2.mean] = twoenv_kstest( Mouse, shuffle_comb, ...
    sep_conn2_local, sep_conn2_distal); %,'plot_ecdf','sep_conn2');
[ statss.before_after.h, statss.before_after.p, statss.before_after.mean] = twoenv_kstest( Mouse, shuffle_comb, ...
    before_after_local, before_after_distal); %,'plot_ecdf','before_after');

%% Second stab - includes both aligned data!

compare_types = {'separate_win','sep_conn1','sep_conn2','before_after'};
plot_title = {'Separate','Separate - Connected Day 1','Separate - Connected Day 2',...
    'Before - After'};
figure(400)
for j = 1:4
subplot(2,2,j)
[f1, x1] = ecdf(local_stat2_all.(compare_types{j}).all);
[f2, x2] = ecdf(distal_stat2_all.(compare_types{j}).all);
if ~isempty(both_stat2_all.(compare_types{j}).all) % don't plot if empty
    [f3, x3] = ecdf(both_stat2_all.(compare_types{j}).all);   
end
[fshuf, xshuf] = ecdf(shuffle_comb(:));

if ~isempty(both_stat2_all.(compare_types{j}).all)
    plot(x1,f1,'b',x2,f2,'y',x3,f3,'r',xshuf,fshuf,'k-.')
    legend('Local Cues aligned','Distal Cues Aligned','Both Cues Aligned','Shuffled')
else
    plot(x1,f1,'b',x2,f2,'y',xshuf,fshuf,'k-.')
    legend('Local Cues Aligned','Distal Cues Aligned','Shuffled')
end
title(plot_title{j});
xlabel('TMap correlations')
end


%% Plot individual neuron summaries
hide_section1 = 1; % 1 = don't plot this section, 0 = do plot it
error_on = 1; % Plot error bars on all bar plots
    
if hide_section1 == 0
    figure(10)
    h = bar([before_win_local_mean, before_win_distal_mean;  ...
        before_5_local_mean, before_5_distal_mean; after_5_local_mean, after_5_distal_mean; ...
        before_6_local_mean, before_6_distal_mean; after_6_local_mean, after_6_distal_mean; ...
        before_after_local_mean, before_after_distal_mean;]);
    hold on
    if error_on == 1
        errorbar(h(1).XData + h(1).XOffset, [before_win_local_mean, ...
            before_5_local_mean, after_5_local_mean, before_6_local_mean, after_6_local_mean, before_after_local_mean], [before_win_local_sem, ...
            before_5_local_sem, after_5_local_sem, before_6_local_sem, after_6_local_sem, before_after_local_sem],...
            '.')
        errorbar(h(2).XData + h(2).XOffset, [before_win_distal_mean, ...
            before_5_distal_mean, after_5_distal_mean, before_6_distal_mean, after_6_distal_mean, before_after_distal_mean], [before_win_distal_sem, ...
            before_5_distal_sem, after_5_distal_sem, before_6_distal_sem, after_6_distal_sem, before_after_distal_sem],...
            '.')
    end
    h2 = plot(get(gca,'XLim'),[shuffle_mean shuffle_mean],'r--');
    set(gca,'XTickLabel',{'Before within','Before-Day5','After-Day5',...
        'Before-Day6','After-Day6', 'Before-After'})
    ylabel('Transient Map Mean Correlations - Individual Neurons')
    h_legend = legend([h(1) h(2) h2],'Rotated (local cues align)','Not-rotated (distal cues align)','Chance (Shuffled Data)');
    hold off
    ylims_given = get(gca,'YLim');
    
    % Simplified
    figure(110)
    set(gcf,'Position',[1988 286 1070 477])
    h = bar([separate_win_local_mean, separate_win_distal_mean;  ...
        sep_conn1_local_mean, sep_conn1_distal_mean; sep_conn2_local_mean, sep_conn2_distal_mean;...
        before_after_local_mean2, before_after_distal_mean2]);
    hold on
    if error_on == 1
        errorbar(h(1).XData + h(1).XOffset, [separate_win_local_mean, ...
            sep_conn1_local_mean, sep_conn2_local_mean, before_after_local_mean2], [separate_win_local_sem, ...
            sep_conn1_local_sem, sep_conn2_local_sem, before_after_local_sem2],'.')
        errorbar(h(2).XData + h(2).XOffset, [separate_win_distal_mean, ...
            sep_conn1_distal_mean, sep_conn2_distal_mean, before_after_distal_mean2], [separate_win_distal_sem, ...
            sep_conn1_distal_sem, sep_conn2_distal_sem, before_after_distal_sem2],'.')
    end
    
    h2 = plot(get(gca,'XLim'),[shuffle_mean shuffle_mean],'r--');
    set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
        'Separate - Connected Day 2','Before - After'})
    ylabel('Transient Map Mean Correlations - Individual Neurons')
    h_legend = legend([h(1) h(2) h2],'Local cues aligned','Distal cues aligned','Chance (Shuffled Data)');
    hold off
    ylims_given = get(gca,'YLim');
    % ylim([ylims_given(1)-0.1, ylims_given(2)+0.1]);
end

%% Similar to above but with "both" alignment included
hide_subsets = 1; % 1 = don't plot these for subsets of mice in 112 and 113

figure(111)
plot_simplified_summary(local_stat2_all, distal_stat2_all, 'both_stat',...
    both_stat2_all)
ylabel('Transient Map Mean Correlations - Individual Neurons')
set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
    'Separate - Connected Day 2','Before - After'})
title('All Mice');

if hide_subsets == 0
    figure(112)
    plot_simplified_summary(local_stat2_all_noG48, distal_stat2_all_noG48, 'both_stat',...
        both_stat2_all_noG48)
    ylabel('Transient Map Mean Correlations - Individual Neurons')
    set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
        'Separate - Connected Day 2','Before - After'})
    title('No G48');
    
    figure(113)
    plot_simplified_summary(local_stat2_all_noG45G48, distal_stat2_all_noG45G48, 'both_stat',...
        both_stat2_all_noG45G48)
    ylabel('Transient Map Mean Correlations - Individual Neurons')
    set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
        'Separate - Connected Day 2','Before - After'})
    title('G30 and G31 only');
end

%% Simplified for all Animals
% figure(115)
% for j = 1:length(Mouse)
%    subplot(4,1,j)
%    plot_simplified_summary(Mouse(j).local_stat,Mouse(j).distal_stat)
%    title(Mouse(j).Name)
% end

% Divided into distal aligned, local aligned, and both aligned groups
figure(116)
for j = 1:length(Mouse)
   subplot(4,1,j)
   plot_simplified_summary(Mouse(j).local_stat2,Mouse(j).distal_stat2,...
       'both_stat',Mouse(j).both_stat2)
   title(Mouse(j).Name)
end

%% Plot population correlation summary
hide_old_PV = 1;

if hide_old_PV == 0
    figure(11)
    h = bar([pop_before_win_local_mean, pop_before_win_distal_mean; ...
        pop_before_5_local_mean, pop_before_5_distal_mean; pop_after_5_local_mean, pop_after_5_distal_mean; ...
        pop_before_6_local_mean, pop_before_6_distal_mean; pop_after_6_local_mean, pop_after_6_distal_mean; ...
        pop_before_after_local_mean, pop_before_after_distal_mean]);
    hold on
    if error_on == 1
        errorbar(h(1).XData + h(1).XOffset, [pop_before_win_local_mean, ...
            pop_before_5_local_mean, pop_after_5_local_mean, pop_before_6_local_mean, pop_after_6_local_mean, pop_before_after_local_mean],...
            [pop_before_win_local_sem, pop_before_5_local_sem, pop_after_5_local_sem, pop_before_6_local_sem, pop_after_6_local_sem,pop_before_after_local_sem],...
            '.')
        errorbar(h(2).XData + h(2).XOffset, [pop_before_win_distal_mean, ...
            pop_before_5_distal_mean, pop_after_5_distal_mean, pop_before_6_distal_mean, pop_after_6_distal_mean, pop_before_after_distal_mean], [pop_before_win_distal_sem, ...
            pop_before_5_distal_sem, pop_after_5_distal_sem, pop_before_6_distal_sem, pop_after_6_distal_sem, pop_before_after_distal_sem],...
            '.')
    end
    set(gca,'XTickLabel',{'Before within','Before-Day5','After-Day5',...
        'Before-Day6','After-Day6','Before-After'})
    ylabel('Transient Map Mean Population Correlations')
    legend('Rotated (local cues align)','Not-rotated (distal cues align)')
    hold off
    ylims_given = get(gca,'YLim');
    % ylim([ylims_given(1)-0.1, ylims_given(2)+0.1]);
end

%% Get example plots of rotated versus non-rotated correlation histograms and hopefully example neurons
hide_example_hists = 1;

session_distal = squeeze(Mouse(1).corr_matrix{1,2}(1,4,:));
session_local = squeeze(Mouse(1).corr_matrix{2,2}(1,4,:));
session2_distal = squeeze(Mouse(1).corr_matrix{1,2}(6,8,:));
session2_local = squeeze(Mouse(1).corr_matrix{2,2}(6,8,:));
centers = -0.2:0.05:0.9;

if hide_example_hists == 0
    % Before - Separate
    figure(300)
    set(gcf,'Position', [2121, 482, 500, 370]);
    subplot(1,2,1)
    hist(session_distal,centers);
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'y';
    mean_distal = nanmean(session_distal);
    ylim_use = get(gca,'YLim');
    hold on;
    plot([mean_distal, mean_distal],[ylim_use(1), ylim_use(2)],'r--')
    hold off;
    title(char('     Separate','Distal cues aligned'))
    xlabel('Calcium Transient Heat Map Correlation'); ylabel('Count')
    
    subplot(1,2,2)
    hist(session_local,centers);
    mean_local = nanmean(session_local);
    % ylim_use = get(gca,'YLim');
    hold on;
    plot([mean_local, mean_local],[ylim_use(1), ylim_use(2)],'r--')
    hold off;
    title(char('     Separate','Local cues aligned'))
    xlabel('Calcium Transient Heat Map Correlation'); ylabel('Count')
    set(gca,'YLim',ylim_use);
    % ylim([0 80])
    
    % Separate-Connected
    figure(301)
    
    subplot(1,2,2)
    hist(session2_local,centers);
    mean_local2 = nanmean(session2_local);
    ylim_use = get(gca,'YLim');
    hold on;
    plot([mean_local2, mean_local2],[ylim_use(1), ylim_use(2)],'r--')
    hold off;
    title(char('Separate-Connected Day 2','Local cues aligned'))
    xlabel('Calcium Transient Heat Map Correlation'); ylabel('Count')
    
    set(gcf,'Position', [2600, 482, 500, 370]);
    subplot(1,2,1)
    hist(session2_distal,centers);
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'y';
    mean_distal2 = nanmean(session2_distal);
    % ylim_use = get(gca,'YLim');
    hold on;
    plot([mean_distal2, mean_distal2],[ylim_use(1), ylim_use(2)],'r--')
    hold off;
    title(char('Separate-Connected Day 2','Distal cues aligned'))
    xlabel('Calcium Transient Heat Map Correlation'); ylabel('Count')
    set(gca,'YLim',ylim_use);

end

%% Get and plot numbers of cells that pass criteria for each session
hide_cell_pass_hist = 1;

num_pass_comb = [];
for j = 1:num_animals
    for k = 1:2
        num_neurons = size(Mouse(j).pass_count{2,k},3);
        num_pass = zeros(1,num_neurons);
        for ll = 1:num_neurons
            % Sum up number of sessions each neuron passed the criteria for
            % spatial information as well as transient rate
            num_pass(ll) = nansum(Mouse(j).pass_count{2,k}(...
                sub2ind([num_sessions,num_sessions,num_neurons],...
                1:num_sessions,1:num_sessions,ll*ones(1,num_sessions))));
        end
        Mouse(j).num_pass{k} = num_pass;
        num_pass_comb = [num_pass_comb num_pass];
    end
end

if hide_cell_pass_hist == 0
    nn = histc(num_pass_comb,0.5:8.5);
    figure(25)
    bar(0.5:8.5,nn,'histc')
    xlim([0.5 8.5])
    xlabel('Number of Sessions Passing Criteria')
    ylabel('Neuron Count')
    title('Histogram - neurons passing inclusion criteria')
end

%% Remapping between sessions analysis - plot correlations between designated
% sessions in circle vs. square
sessions_compare = [1 4; 4 7; 3 7; 3 4; 3 8; 5 6]; 

% Register octagon neurons to square neurons
disp('Registering octagon to square sessions')
if isempty(Mouse(4).sq_to_cir_map)
    for j = 1:num_animals
        disp(['Mouse number ' num2str(j)])
        load(fullfile(Mouse(j).working_dirs{1},'batch_session_map.mat'))
        [COM_square, MeanMask_square] = get_batch_COM(batch_session_map);
        load(fullfile(Mouse(j).working_dirs{2},'batch_session_map.mat'))
        [COM_circle, MeanMask_circle] = get_batch_COM(batch_session_map,Mouse(j).square_base_sesh);
        Mouse(j).sq_to_cir_map = COM_register(COM_square, COM_circle, MeanMask_square, MeanMask_circle);
    end
end

% Pull out appropriate comparisons
circ_v_square = cell(2,num_sessions,num_sessions);
circ_v_square_all = cell(2,2,num_sessions,num_sessions,num_animals);
for align_type = 1:2
    for arena_type = 1:2
        for j = 1:num_animals
            temp = nanmean(Mouse(j).corr_matrix{align_type,arena_type},3);
            for k = 1:size(sessions_compare)
                circ_v_square{align_type, sessions_compare(k,1), sessions_compare(k,2)}(j,arena_type) = ...
                    temp(sessions_compare(k,1), sessions_compare(k,2));
                % Assign appropriate indices to use
                if arena_type == 1
                    neuron_indices = 1:size(Mouse(j).corr_matrix{align_type,arena_type},3);
                elseif arena_type == 2
                    neuron_indices = Mouse(j).sq_to_cir_map;
                end
                valid_indices = ~isnan(neuron_indices); % non-nan indices
                invalid_indices = isnan(neuron_indices); % non-valid neuron assignments
                
                circ_v_square_all{align_type, arena_type, sessions_compare(k,1), sessions_compare(k,2),j}...
                    (valid_indices,1) = Mouse(j).corr_matrix{align_type,arena_type}...
                    (sessions_compare(k,1),sessions_compare(k,2), neuron_indices(valid_indices));
                circ_v_square_all{align_type, arena_type, sessions_compare(k,1), sessions_compare(k,2),j}...
                    (invalid_indices,1) = nan; % Assign NaNs to neurons that don't map between sessions
                    
                
            end
        end
    end
end

align_plot = {'Distal Aligned','Local Aligned'};
for align_type = 1:2
    figure(700+align_type)
    for j = 1:size(sessions_compare,1)
        subplot(2,3,j)
        for m = 1:num_animals
            plot(circ_v_square{align_type,sessions_compare(j,1),sessions_compare(j,2)}(m,1),...
                circ_v_square{align_type,sessions_compare(j,1),sessions_compare(j,2)}(m,2),...
                '*'); hold on;
        end
        xlabel('Square Correlation'); ylabel('Circle Correlation');
        title(['Session ' num2str(sessions_compare(j,1))  ' - ' ...
            num2str(sessions_compare(j,2)) ' with ' align_plot{align_type}])
        xlim([-0.2 0.7]); ylim([-0.2 0.7])
        legend(arrayfun(@(a) a.Name,Mouse,'UniformOutput',0))
        hold off
        
    end
end

% Same as above but for ALL neurons
align_plot = {'Distal Aligned','Local Aligned'};
for align_type = 1:2
    figure(710+align_type)
    for j = 1:size(sessions_compare,1)
        subplot(2,3,j)
        for m = 1:num_animals
            plot(circ_v_square_all{align_type, 1, sessions_compare(j,1), sessions_compare(j,2), m},...
                circ_v_square_all{align_type, 2, sessions_compare(j,1), sessions_compare(j,2), m},...
                '*'); hold on;
        end
        xlabel('Square Correlation'); ylabel('Circle Correlation');
        title(['Session ' num2str(sessions_compare(j,1))  ' - ' ...
            num2str(sessions_compare(j,2)) ' with ' align_plot{align_type}])
        xlim([-0.2 0.7]); ylim([-0.2 0.7])
        legend(arrayfun(@(a) a.Name,Mouse,'UniformOutput',0))
        hold off
        
    end
end

%% More 4-7 session remapping plots

comp_get = {'remap_34','remap_34_sq','remap_34_circ',...
    'remap_47','remap_47_sq','remap_47_circ', ...
    'remap_37','remap_37_sq','remap_37_circ',...
    'remap_56','remap_56_sq','remap_56_circ'};

comp_get2 = {'before_5','after_6'};

% fields_get = 

for j = 1:num_animals
    for kk = 1:length(comp_get)
    
    % Get correlations for appropriate sessions (4-7, 3-7, 5-6)
    [ Mouse(j).local_stat2.remap_47, Mouse(j).distal_stat2.remap_47,  ...
        Mouse(j).both_stat2.remap_47] = twoenv_get_ind_mean(Mouse(j), ...
        remap_47_conflict{j}, remap_47_conflict{j}, 'both_sub_use',remap_47_aligned{j});
    
    [ Mouse(j).local_stat2.(comp_get{kk}), Mouse(j).distal_stat2.(comp_get{kk}),  ...
        Mouse(j).both_stat2.(comp_get{kk})] = twoenv_get_ind_mean(Mouse(j), ...
        remap_struct.([(comp_get{kk}) '_conflict']){j}, remap_struct.([(comp_get{kk}) '_conflict']){j}, ...
        'both_sub_use',remap_struct.([(comp_get{kk}) '_aligned']){j});
    end
end

stat_type = {'local_stat2','distal_stat2'};

for k = 1:length(comp_get)
    for ll = 1:2
    temp = arrayfun(@(a) a.(stat_type{ll}).(comp_get{k}).all_means,Mouse,'UniformOutput',0); % Gets values for all mice for comparison in comp_get{k}
    remap_comb.(comp_get{k}).(stat_type{ll}).all_means = cat(1,temp{:});
    remap_comb.(comp_get{k}).(stat_type{ll}).mean = mean(remap_comb.(comp_get{k}).(stat_type{ll}).all_means);
    remap_comb.(comp_get{k}).(stat_type{ll}).sem = std(remap_comb.(comp_get{k}).(stat_type{ll}).all_means)/...
        sqrt(length(remap_comb.(comp_get{k}).(stat_type{ll}).all_means));
    end
end


figure(800)
k = [1 4 7 10];

for j = 1:4
    subplot(2,2,j)
    h = bar([remap_comb.([comp_get{k(j)} '_sq']).local_stat2.mean, remap_comb.([comp_get{k(j)} '_sq']).distal_stat2.mean; ...
        remap_comb.([comp_get{k(j)} '_circ']).local_stat2.mean, remap_comb.([comp_get{k(j)} '_circ']).distal_stat2.mean; ...
        remap_comb.(comp_get{k(j)}).local_stat2.mean, remap_comb.(comp_get{k(j)}).distal_stat2.mean]);
    hold on
    errorbar(h(1).XData + h(1).XOffset, ...
        [remap_comb.([comp_get{k(j)} '_sq']).local_stat2.mean, remap_comb.([comp_get{k(j)} '_circ']).local_stat2.mean, ...
        remap_comb.(comp_get{k(j)}).local_stat2.mean], [remap_comb.([comp_get{k(j)} '_sq']).local_stat2.sem, ...
        remap_comb.([comp_get{k(j)} '_circ']).local_stat2.sem, ...
        remap_comb.(comp_get{k(j)}).local_stat2.sem],'k.')
    errorbar(h(2).XData + h(2).XOffset, ...
        [remap_comb.([comp_get{k(j)} '_sq']).distal_stat2.mean, remap_comb.([comp_get{k(j)} '_circ']).distal_stat2.mean, ...
        remap_comb.(comp_get{k(j)}).distal_stat2.mean], [remap_comb.([comp_get{k(j)} '_sq']).distal_stat2.sem, ...
        remap_comb.([comp_get{k(j)} '_circ']).distal_stat2.sem, ...
        remap_comb.(comp_get{k(j)}).distal_stat2.sem],'k.')
    hold off
    title(strrep(comp_get{k(j)},'_','\_'))
    legend('Local','Distal');
    set(gca,'XTick',[1 2 3],'XTickLabel',{'Square','Circle','Combined'})
end

figure(801)
for j = 1:2
    subplot(2,1,j)
    h = bar([remap_comb.(comp_get2{k(j)}).local_stat2.mean, remap_comb.(comp_ge2{k(j)}).distal_stat2.mean]);
    hold on
    errorbar(h(1).XData + h(1).XOffset, ...
        [remap_comb.(comp_get2{k(j)}).local_stat2.mean], [remap_comb.(comp_get2{k(j)}).local_stat2.sem],'k.')
    errorbar(h(2).XData + h(2).XOffset, ...
        [remap_comb.(comp_get2{k(j)}).distal_stat2.mean], [remap_comb.(comp_get2{k(j)}).distal_stat2.sem],'k.')
    hold off
    title(strrep(comp_get{k(j)},'_','\_'))
    legend('Local','Distal');
%     set(gca,'XTick',[1 2 3],'XTickLabel',{'Square','Circle','Combined'})
end


%% Create Place-field density maps - move to top eventually...

% Define properties for smoothing of occupancy maps below
gauss_std = 2.5; disk_rad = 4; 
sm_gauss = fspecial('gaussian',[round(8*gauss_std,0), round(8*gauss_std,0)],gauss_std);

arena_type = {'Square', 'Circle'};
cm = colormap('jet');
for j = 1:num_animals
    figure(900+j)
    for k = 1:2
       for ll = 1:8
           subplot(4,4,(k-1)*8+ll)
           imagesc_nan(Mouse(j).PFdens_map{k,ll},cm,[1 1 1]); % Plot with non-occupied pixels white
           colorbar
           title([arena_type{k} ' session ' num2str(ll) ' PF density'])
           xlabel('Local cues aligned')
       end
    end
end

disp('Making PFdensity difference plots')
% Now do difference plots
for j = 1:num_animals
   for k = 1:2
       
       % First calculate all comparisons to get cmax and cmin
       cmin = 0; cmax = 0;
       occmin = 0; occmax = 0;
       for ll = 1:8
           for mm = 1:8
               diff_map = Mouse(j).PFdens_map{k,mm} - Mouse(j).PFdens_map{k,ll};
               cmin = min([cmin nanmin(diff_map(:))]);
               cmax = max([cmax nanmax(diff_map(:))]);
               
               Mouse(j).PFdensity_analysis(k).diff_map{ll,mm} = diff_map;
               
               % Calculate PF density differences by grid
               [~, Mouse(j).PFdensity_analysis(k).grid_sum{ll,mm}] = ...
                   divide_arena(diff_map,num_grids_PFdens);
               
               % Get differences in Occupancy
               occ_diff_map = nan(size(Mouse(j).PFdensity_analysis(k).RunOccMap{mm}));
               occ_diff_map(:) = nansum([Mouse(j).PFdensity_analysis(k).RunOccMap{mm}(:) ...
                   -Mouse(j).PFdensity_analysis(k).RunOccMap{ll}(:)],2); % Get difference, treating nans as zeros with nansum
               occmap_comb = Mouse(j).PFdensity_analysis(k).RunOccMap{mm} | ...
                   Mouse(j).PFdensity_analysis(k).RunOccMap{ll}; % combined occupancy map - used identify areas where the mouse was in EITHER session
               % Smooth difference maps
               occsum = nansum(occ_diff_map(:)); % Get original occupancy sum
               temp = imfilter(occ_diff_map, sm_gauss); % Perform smoothing
               occ_diff_map_sm = temp*occsum./sum(temp(:)); % Make smoothed map add up to the same number as the raw map
               occmin = min([occmin nanmin(occ_diff_map_sm(:))]);
               occmax = max([occmax nanmax(occ_diff_map_sm(:))]);
               [~, occ_diff_map_sm] = make_nan_TMap(occmap_comb,occ_diff_map_sm); % Make non-occupied areas in BOTH conditions NaN
               Mouse(j).PFdensity_analysis(k).RunOccMap_diff{ll,mm} = occ_diff_map_sm; % Assign to mouse variable
               
               % Calculate Occupancy map differences by grid
               [~, Mouse(j).PFdensity_analysis(k).occ_grid_sum{ll,mm}] = ...
                   divide_arena(occ_diff_map_sm,num_grids_PFdens);
               
           end
       end
       
       % Plot PFdensity differences
       figure(920+(j-1)*2 + k)
       set(gcf,'Name',[Mouse(j).Name ' PF density differences'])
       for ll = 1:8
           for mm = 1:8
               subplot(8,8,(ll-1)*8+mm)
               imagesc_nan(Mouse(j).PFdens_map{k,mm} - Mouse(j).PFdens_map{k,ll},...
                   cm, [1 1 1], [cmin cmax]);
               if ll == 1 && mm == 1
                   colorbar
               end
               title([num2str(mm) ' - ' num2str(ll)])
           end
       end
       
%        % Plot occupancy differences
%        figure(940+(j-1)*2 + k)
%        set(gcf,'Name',[Mouse(j).Name ' Occupancy Differences'])
%        for ll = 1:8
%            for mm = 1:8
%                subplot(8,8,(ll-1)*8+mm)
%                imagesc_nan(Mouse(j).PFdensity_analysis(k).RunOccMap_diff{ll,mm},...
%                    cm, [1 1 1])% , [occmin occmax]);
%                if ll == 1 && mm == 1
%                    colorbar
%                end
%                title([num2str(mm) ' - ' num2str(ll)])
%            end
%        end
       
   end
end

% Combine all
grid_sum_all = nan(2,8,8,num_grids_PFdens,num_grids_PFdens,num_animals);
occ_grid_sum_all = nan(2,8,8,num_grids_PFdens,num_grids_PFdens,num_animals);
for k = 1:2
    for ll = 1:7
        for mm = ll+1:8
            temp = [];
            for j = 1:num_animals
                grid_sum_all(k,ll,mm,:,:,j) = ...
                    Mouse(j).PFdensity_analysis(k).grid_sum{ll,mm};
                occ_grid_sum_all(k,ll,mm,:,:,j) = ...
                    Mouse(j).PFdensity_analysis(k).occ_grid_sum{ll,mm};
            end
        end
    end
end

% Run stats on above
% For all session-mice-arena-grid combos individually
grid_sum_mean = nanmean(grid_sum_all(:));
grid_sum_std = nanstd(grid_sum_all(:));
grid_sum_z = (grid_sum_all - grid_sum_mean)./grid_sum_std;
% How do I want to do this?  Should I combine all the mice into one
% mega-session, get a distribution of PF density changes from all sessions
% and all grids, and then calculate where the combined value lies on that
% distribution with a ztest?

% For combined mice
grid_sum_comb = mean(grid_sum_all,6); % Gives you a mean for all mice (num_arenas x num_sessions x num_sessions x num_grids x num_grids)
grid_sum_comb_mean = nanmean(grid_sum_comb(:));
grid_sum_comb_std = nanstd(grid_sum_comb(:));
occ_grid_sum_comb = mean(occ_grid_sum_all,6);
% I think this is a good start for how to do a z-test to prove PFs move
% toward the hallway during the connected sessions
[h, p] = ztest(squeeze(grid_sum_comb(1,1:4,5:6,3,2)),grid_sum_comb_mean,grid_sum_comb_std);

% Bar graph comparing PF density in each arena near the hallway to the rest
% of the arena - do ANOVA on the two groups (effect of grid location?)
[ conn_hw_mean_square, conn_hw_sem_square, conn_hw_square_all, conn_nonhw_mean_square, ...
    conn_nonhw_sem_square, conn_nonhw_square_all ] = twoenv_get_hallway_PFincrease( grid_sum_comb, 3, 2, 1);
[ conn_hw_mean_circle, conn_hw_sem_circle, conn_hw_circle_all, conn_nonhw_mean_circle, ...
    conn_nonhw_sem_circle, conn_nonhw_circle_all ] = twoenv_get_hallway_PFincrease( grid_sum_comb, 1, 2, 2);
[ occ_conn_hw_mean_square, occ_conn_hw_sem_square, occ_conn_hw_square_all, occ_conn_nonhw_mean_square, ...
    occ_conn_nonhw_sem_square, occ_conn_square_nonhw_all ] = twoenv_get_hallway_PFincrease( occ_grid_sum_comb, 3, 2, 1);
[ occ_conn_hw_mean_circle, occ_conn_hw_sem_circle, occ_conn_hw_circle_all, occ_conn_nonhw_mean_circle, ...
    occ_conn_nonhw_sem_circle, occ_conn_nonhw_circle_all] = twoenv_get_hallway_PFincrease( occ_grid_sum_comb, 1, 2, 2);

%% Attempts to combine PFdensity plots for ALL mice into one.
k =2; ll = 3;

PFdens_comb = cell(2,3);

for k = 1:2
    temp = nan(size(Mouse(1).PFdens_map{k,ll}));
    temp2 = temp;
    temp3 = temp;
    size_use = size(temp);
    for j = 1:3
        % Merge all before sessions
        for ll = 1:4
            temp = cat(3,temp,resize(Mouse(j).PFdens_map{k,ll},size_use));
        end
        
        % Merge all during sessions
        for ll = 5:6
            temp2 = cat(3,temp2,resize(Mouse(j).PFdens_map{k,ll},size_use));
        end
        
        % Merge all after sessions
        for ll = 7:8
            temp3 = cat(3,temp3,resize(Mouse(j).PFdens_map{k,ll},size_use));
        end
        
    end
    PFdens_comb{k,1} = temp;
    PFdens_comb{k,2} = temp2;
    PFdens_comb{k,3} = temp3;
end


figure(1002)
for j = 1:num_animals
    subplot(2,5,j)
    imagesc_nan(Mouse(j).PFdens_map{k,ll},cm,[1 1 1])
    title('Original')
    subplot(2,5,5+j)
    imagesc_nan(squeeze(temp(:,:,j)),cm,[1 1 1])
    title('Resized')
end

% For above, Mouse(4) has his arena off-kilter from the others.  May need
% to re-run everything for him.  For now, combine the first three only

figure(1002)
subplot(2,5,10)
imagesc_nan(nanmean(temp(:,:,1:3),3),cm,[1 1 1])
title('Resized and combining mice 1-3')

%% PF density plots
figure(930)
subplot(2,2,1) 
h10 = bar([conn_hw_mean_square conn_nonhw_mean_square; conn_hw_mean_circle ...
    conn_nonhw_mean_circle]);
hold on;
errorbar(h10(1).XData + h10(1).XOffset, [conn_hw_mean_square conn_hw_mean_circle], ...
    [conn_hw_sem_square conn_hw_sem_circle],'k.');
errorbar(h10(2).XData + h10(2).XOffset, [conn_nonhw_mean_square conn_nonhw_mean_circle], ...
    [conn_nonhw_sem_square conn_nonhw_sem_circle],'k.');
hold off
set(gca,'XTickLabel',{'Square','Circle'})
legend('Near Hallway','Everywhere else')
title('Increase in PF density by arena region')
ylabel('Number fields')
subplot(2,2,2)
hist(grid_sum_comb(:),50)
xlabel('PF density change (#fields/grid)')
ylabel('Count');
% Occupany plots
subplot(2,2,3)
h10 = bar([occ_conn_hw_mean_square occ_conn_nonhw_mean_square; occ_conn_hw_mean_circle ...
    occ_conn_nonhw_mean_circle]);
hold on;
errorbar(h10(1).XData + h10(1).XOffset, [occ_conn_hw_mean_square occ_conn_hw_mean_circle], ...
    [occ_conn_hw_sem_square occ_conn_hw_sem_circle],'k.');
errorbar(h10(2).XData + h10(2).XOffset, [occ_conn_nonhw_mean_square occ_conn_nonhw_mean_circle], ...
    [occ_conn_nonhw_sem_square occ_conn_nonhw_sem_circle],'k.');
hold off
set(gca,'XTickLabel',{'Square','Circle'})
legend('Near Hallway','Everywhere else')
title('Increase in Occupancy by arena region')
subplot(2,2,4)
hist(occ_grid_sum_comb(:),100)
xlabel('Occupancy change (need unit here)')
ylabel('Count');


% Similar analysis for Occupancy in each region



%%
disp(['Script done running in ' num2str(toc(start_ticker)) ' seconds total'])


%% Everything below has been commented out because it isn't that useful each
% time this script is run, but might be in the future
%% Example plots of correlations < 0, and high ones

% load('j:\GCamp Mice\Working\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\PlaceMaps.mat','TMap','TMap_gauss')
% TMaps_distal{3} = TMap_gauss;
% load('j:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\PlaceMaps.mat','TMap','TMap_gauss')
% TMaps_distal{4} = TMap_gauss;
% load('j:\GCamp Mice\Working\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\PlaceMaps_rot_to_std.mat','TMap','TMap_gauss')
% TMaps_rot{3} = TMap_gauss;
% load('j:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\PlaceMaps_rot_to_std.mat','TMap','TMap_gauss')
% TMaps_rot{4} = TMap_gauss;
% load('J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working\batch_session_map.mat');
% 
% highcorrs_ind = find(squeeze(Mouse(1).corr_matrix{2,2}(3,4,:)) > 0.8);
% lowcorrs_ind = find(squeeze(Mouse(1).corr_matrix{1,2}(3,4,:)) < 0.2);
% 
% j = 1; 
% for j = 1:length(highcorrs_ind)
% figure(50); 
% row = highcorrs_ind(j); 
% subplot(1,2,1); imagesc(TMaps_rot{3}{batch_session_map.map(row,4)}); 
% title(['Neuron ' num2str(batch_session_map.map(row,4)) ...
%     ' w/Correlation = ' num2str(Mouse(1).corr_matrix{2,2}(3,4,row))]);
% subplot(1,2,2); imagesc(TMaps_rot{4}{batch_session_map.map(row,5)});
% title(['Neuron ' num2str(batch_session_map.map(row,5))])
% 
% waitforbuttonpress
% 
% end
% 
% for j = 1:length(lowcorrs_ind)
% figure(50); 
% row = lowcorrs_ind(j); 
% subplot(1,2,1); imagesc(TMaps_distal{3}{batch_session_map.map(row,4)}); 
% title(['Neuron ' num2str(batch_session_map.map(row,4)) ...
%     ' w/Correlation = ' num2str(Mouse(1).corr_matrix{1,2}(3,4,row))]);
% subplot(1,2,2); imagesc(TMaps_distal{4}{batch_session_map.map(row,5)});
% title(['Neuron ' num2str(batch_session_map.map(row,5))])
% 
% waitforbuttonpress
% 
% end
% 
% %% Plot out placemaps across days...
% 
% % Specify base directory here
% base_sesh = ref.G31.two_env(1)+2;
% rot_to_std = 1; % 0 = no, 1 = yes rotate such that local cues align
% start_neuron = 108; % Start here when cycling through neurons
% 
% if rot_to_std == 0
%     place_file = ['PlaceMaps' file_append '.mat'];
% elseif rot_to_std == 1
%     place_file = ['PlaceMaps_rot_to_std' file_append '.mat'];
% end
% 
% % Load neuron mapping file
% base_map = fullfile(MD(base_sesh).Location,'batch_session_map.mat');
% load(base_map)
% 
% curr_dir = cd;
% % Load TMaps for all relevant sessions
% num_sessions = length(batch_session_map.session);
% num_neurons = size(batch_session_map.map,1);
% disp('Loading TMaps')
% for j = 1:num_sessions
%     ChangeDirectory(batch_session_map.session(j).mouse, batch_session_map.session(j).date,...
%         batch_session_map.session(j).session);
%     load(place_file,'TMap_gauss')
%     sesh(j).TMap_gauss = TMap_gauss;
% end
% 
% figure(200)
% set(gcf,'Position',[27 724 1823 230])
% blank = nan(size(sesh(1).TMap_gauss{1}));
% disp('Plotting out TMaps across sessions')
% for k = start_neuron:num_neurons
%     for j = 1:num_sessions
%         neuron_use = batch_session_map.map(k,j+1);
%         if neuron_use ~= 0
%             TMap_plot = sesh(j).TMap_gauss{neuron_use};
%             title_use = ['Session ' num2str(j) ' neuron ' num2str(neuron_use)];
%         else
%             TMap_plot = blank;
%             title_use = ['Session ' num2str(j) ' - no valid map'];
%         end
%     
%     subplot(1,num_sessions,j)
%     imagesc_nan(TMap_plot)
%     title(title_use,'FontSize',8)
%     end
%     waitforbuttonpress
%     
% end
% 
% %% Plot of activity versus within day correlations
% 
% % Get sessions to look at correlations for...
% within_day = [1 2; 3 4; 7 8]; within_day_ind = sub2ind([8 8],within_day(:,1), within_day(:,2));
% before_win_local = [1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4]; before_win_local_ind = sub2ind([8 8],before_win_local(:,1), before_win_local(:,2));
% 
% days_active = sum(Mouse(1).batch_session_map(1).map(:,2:9) ~= 0,2); %# days each neuron is active
% for j = 1:length(days_active)
%     temp = [];
%     for k = 1:size(within_day,1)
%         temp = [temp, Mouse(1).corr_matrix{2,1}(within_day(k,1),within_day(k,2),j)];
%     end
%     within_day_corrs(j,:) = temp;
% end
% 
% %% Start to getting cell stability phenotypes
% remap_index = 0.4; % Wang/Muzzio uses 0.21 for e-phys
% 
% for m = 1:num_animals
%     stable_seshs = [];
%     neuron_pass = [];
%     for ll = 1:2
%         for j = 1:size(Mouse(m).corr_matrix{2,ll},3);
%             stable_seshs(j) = nansum(nansum(Mouse(m).corr_matrix{2,ll}(:,:,j) > remap_index & ...
%                 Mouse(m).corr_matrix{2,ll}(:,:,j) ~= 1 & Mouse(m).pass_count{2,ll}(:,:,j) == 1));
%             neuron_pass(j) = sum(sum(Mouse(m).pass_count{2,ll}(:,:,j))) > 0;
%         end
%         stable_2sesh = sum(stable_seshs == 1);
%         stable_longerterm = sum(stable_seshs > 1);
%         unstable = sum(neuron_pass) - stable_2sesh - stable_longerterm;
%        total = sum(neuron_pass);
%         
%         Mouse(m).cellphenos{ll}.stable_2sesh = stable_2sesh ;
%         Mouse(m).cellphenos{ll}.stable_longerterm = stable_longerterm;
%         Mouse(m).cellphenos{ll}.unstable = unstable;
%         Mouse(m).cellphenos{ll}.total = total;
%     end
% end
% 
% % Sum up for ALL sessions and mice
% total_all = 0;
% stable_2sesh_all = 0;
% stable_longerterm_all = 0;
% unstable_all = 0;
% for m = 1:2
%     for ll = 1:2
%         stable_2sesh_all = stable_2sesh_all + Mouse(m).cellphenos{ll}.stable_2sesh;
%         stable_longerterm_all = stable_longerterm_all + Mouse(m).cellphenos{ll}.stable_longerterm;
%         unstable_all = unstable_all + Mouse(m).cellphenos{ll}.unstable;
%         total_all = total_all + Mouse(m).cellphenos{ll}.total;
%     end
% end

%% Display All Mouse corr_matrix

alignment = {'distal','local'};
arena = {'square','octagon'};
for j = 1:num_animals
    for k = 1:2
        for ll = 1:2
            disp(['Mouse ' num2str(j) ' - ' alignment{k} ' - ' arena{ll}])
            nanmean(Mouse(j).corr_matrix{k,ll},3)
        end
    end
end

%% Save workspace for future easy reference

if exist_logical == 0
    cd(Mouse(1).working_dirs{1});
    [savefile_name] = save_workspace_name('workspace');
    disp(['Saving workspace as ' fullfile(Mouse(1).working_dirs{1},savefile_name)])
    save(savefile_name)
end


