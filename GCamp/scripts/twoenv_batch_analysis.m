% Batch script for two-env experiment
close all
start_ticker = tic;

%% Filtering variables
trans_rate_thresh = 0.005; % Hz
pval_thresh = 0.05; % don't include ANY TMaps with p-values above this
within_session = 1;
num_shuffles = 10; 
days_active_use = 2; % Do same plots using only neurons that are active this number of days
file_append = ''; % If using archived PlaceMaps, this will be appended to the end of the Placemaps files

%% Set up mega-variable - note that working_dir 1 = square sessions and 2 = octagon sessions (REQUIRED)

Mouse(1).Name = 'G30';
Mouse(1).working_dirs{1} = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working';
Mouse(1).working_dirs{2} = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working';

Mouse(2).Name = 'G31';
Mouse(2).working_dirs{1} = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
Mouse(2).working_dirs{2} = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\1 - 2env octagon left\Working';

Mouse(3).Name = 'G45';
Mouse(3).working_dirs{1} = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\1 - square right\Working';
Mouse(3).working_dirs{2} = 'J:\GCamp Mice\Working\G45\2env\08_29_2015\1 - oct right\Working';

Mouse(4).Name = 'G48';
Mouse(4).working_dirs{1} = 'I:\GCamp Mice\G48\2env\08_29_2015\1 - square right\Working';
Mouse(4).working_dirs{2} = 'I:\GCamp Mice\G48\2env\08_30_2015\1 - oct mid\Working';

num_animals = length(Mouse);

for j = 1:num_animals
    Mouse(j).key = '1,1 = square distal cues aligned, 1,2 = octagon distal cues aligned, 2,1 = square local cues aligned, 2,2 = octagon local cues aligned';
end

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
            [Mouse(j).corr_matrix{m+1,k}, pop_struct_temp, Mouse(j).min_dist_matrix{m+1,k}, Mouse(j).pass_count{m+1,k},...
                Mouse(j).within_corr{m+1,k}, Mouse(j).shuffle_matrix{m+1,k}, Mouse(j).dist_shuffle_matrix{m+1,k}] = ...
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

%% Mega-matrix2 - dump ALL neuron correlations together into appropriate matrices
% simple version = only look at mean values for each animal
% [ before_win2.distal_all, before_win2.local_all, before_win2.both_all, ...
%     before_win2.distal_simple, before_win2.local_simple, before_win2.both_simple] = ...
%     twoenv_make_megamean2(Mouse, before_win_conflict, before_win_aligned );



%% Get basic stats - not done for population correlations yet

exclude_G48 = 2; % Use if you want to exclude G48 due to high remapping within session
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
    
end

%% Plot stability over time
corrs_all = [];
corrs_all2 = [];
shuffle_all = [];
shuffle_all2 = [];
time_all = [];
figure(500)
for j = 1:num_animals
    subplot(4,1,j)
    plot(Mouse(j).both_stat2.separate_win_time, Mouse(j).both_stat2.separate_win.all_means,...
        'b*',Mouse(j).both_stat2.before_after_time, Mouse(j).both_stat2.before_after.all_means,'b*');
    title(Mouse(j).Name)
    xlabel('Days'); ylabel('Mean correlation')
    xlim([0 7]); set(gca,'XTick',[1 2 3 4 5 6])
    
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
    
end

days_plot = [0 1 2 3 4 5 6]; % Days between sessions to plot

corrs_mean_by_day = arrayfun(@(a) mean(corrs_all(time_all == a)),days_plot);
corrs_sem_by_day = arrayfun(@(a) std(corrs_all(time_all == a))/...
    sum(time_all == a),days_plot);
shuffle_mean_by_day = arrayfun(@(a) mean(shuffle_all(time_all == a)),days_plot);

to_plot = ~isnan(corrs_mean_by_day);
figure(501)
plot(days_plot(to_plot),corrs_mean_by_day(to_plot),'k.-',days_plot(to_plot),...
shuffle_mean_by_day(to_plot),'r--') % time_all,corrs_all,'r*'
hold on
errorbar(days_plot(to_plot),corrs_mean_by_day(to_plot),corrs_sem_by_day(to_plot),'k')
xlabel('Days between session'); ylabel('Mean correlation - individual TMaps')
xlim([-0.5 6.5]); set(gca,'XTick',[0 1 2 3 4 5 6])
legend('Actual','Shuffled')

figure(499)
plot(time_all,corrs_all,'r*')
xlabel('Days between session'); ylabel('Mean correlation - individual TMaps')
xlim([-0.5 6.5]); set(gca,'XTick',[0 1 2 3 4 5 6])

% Do this but in ecdf format - that is, group ALL TMap individual
% correlations for a given day together
corrs_all_by_day = arrayfun(@(a) cat(1,corrs_all2{time_all == a}),...
    days_plot,'UniformOutput',0);
shuffle_all_comb = cat(1,shuffle_all2{:});

figure(502)
days_plot_ind = find(to_plot);
days_plot2 = days_plot(days_plot_ind);
for j = 1:length(days_plot2)
    ecdf(corrs_all_by_day{days_plot_ind(j)});
    hold on
end
ecdf(shuffle_all_comb)
xlabel('Individual TMap Correlation Value');
legend([cellfun(@(a) [num2str(a) ' Days'], num2cell(days_plot2),'UniformOutput',0), ...
    'Shuffle']);

% 3 Day correlations are very low for some reason (yet still higher than
% chance).  Most likely reason is that they include sessions right
% before/after connection, whereas there are more sessions for the 5/6 day
% comparisons that occur after at least one session back in the single
% arenas.  GLM could maybe pull this apart...
% Could do the same for the local individual correlations after showing
% that rotating typically does not induce a remapping relative to the local
% cues - maybe this will pull more together...


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
    separate_win_local, separate_win_distal,'plot_ecdf','separate');
[ statss.sep_conn1.h, statss.sep_conn1.p, statss.sep_conn1.mean ] = twoenv_kstest( Mouse, shuffle_comb, ...
    sep_conn1_local, sep_conn1_distal,'plot_ecdf','sep_conn1');
[ statss.sep_conn2.h, statss.sep_conn2.p , statss.sep_conn2.mean] = twoenv_kstest( Mouse, shuffle_comb, ...
    sep_conn2_local, sep_conn2_distal,'plot_ecdf','sep_conn2');
[ statss.before_after.h, statss.before_after.p, statss.before_after.mean] = twoenv_kstest( Mouse, shuffle_comb, ...
    before_after_local, before_after_distal,'plot_ecdf','before_after');

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
error_on = 1;
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

%% Similar to above but with "both" alignment included
figure(111)
plot_simplified_summary(local_stat2_all, distal_stat2_all, 'both_stat',...
    both_stat2_all)
ylabel('Transient Map Mean Correlations - Individual Neurons')
set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
    'Separate - Connected Day 2','Before - After'})
title('All Mice');

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

%% Simplified for all Animals
figure(115)
for j = 1:length(Mouse)
   subplot(4,1,j)
   plot_simplified_summary(Mouse(j).local_stat,Mouse(j).distal_stat)
   title(Mouse(j).Name)
end

% Divided into distal aligned, local aligned, and both aligned groups
figure(116)
for j = 1:length(Mouse)
   subplot(4,1,j)
   plot_simplified_summary(Mouse(j).local_stat2,Mouse(j).distal_stat2,...
       'both_stat',Mouse(j).both_stat2)
   title(Mouse(j).Name)
end

%% Plot population correlation summary
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

disp(['Script done running in ' num2str(toc(start_ticker)) ' seconds total'])


%% Get example plots of rotated versus non-rotated correlation histograms and hopefully example neurons
session_distal = squeeze(Mouse(1).corr_matrix{1,2}(1,4,:));
session_local = squeeze(Mouse(1).corr_matrix{2,2}(1,4,:));
session2_distal = squeeze(Mouse(1).corr_matrix{1,2}(6,8,:));
session2_local = squeeze(Mouse(1).corr_matrix{2,2}(6,8,:));
centers = -0.2:0.05:0.9;

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

% subplot(1,3,3)
% ecdf(squeeze(Mouse(1).corr_matrix{1,2}(1,4,:))); 
% hold on; 
% ecdf(squeeze(Mouse(1).corr_matrix{2,2}(1,4,:)));
% ecdf(shuffle_comb(:))
% legend('Distal cues aligned','Local cues aligned',...
%     'Shuffled Data','Location','SouthEast')
% title('Empirical CDF')
% xlabel('Calcium Transient Heat Map Correlation (x)');

%% Get and plot numbers of cells that pass criteria for each session

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
    
nn = histc(num_pass_comb,0.5:8.5);
figure(25)
bar(0.5:8.5,nn,'histc')
xlim([0.5 8.5])
xlabel('Number of Sessions Passing Criteria')
ylabel('Neuron Count')
title('Histogram - neurons passing inclusion criteria')

%% Example plots of correlations < 0, and high ones

load('j:\GCamp Mice\Working\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\PlaceMaps.mat','TMap','TMap_gauss')
TMaps_distal{3} = TMap_gauss;
load('j:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\PlaceMaps.mat','TMap','TMap_gauss')
TMaps_distal{4} = TMap_gauss;
load('j:\GCamp Mice\Working\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\PlaceMaps_rot_to_std.mat','TMap','TMap_gauss')
TMaps_rot{3} = TMap_gauss;
load('j:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\PlaceMaps_rot_to_std.mat','TMap','TMap_gauss')
TMaps_rot{4} = TMap_gauss;
load('J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working\batch_session_map.mat');

highcorrs_ind = find(squeeze(Mouse(1).corr_matrix{2,2}(3,4,:)) > 0.8);
lowcorrs_ind = find(squeeze(Mouse(1).corr_matrix{1,2}(3,4,:)) < 0.2);

j = 1; 
for j = 1:length(highcorrs_ind)
figure(50); 
row = highcorrs_ind(j); 
subplot(1,2,1); imagesc(TMaps_rot{3}{batch_session_map.map(row,4)}); 
title(['Neuron ' num2str(batch_session_map.map(row,4)) ...
    ' w/Correlation = ' num2str(Mouse(1).corr_matrix{2,2}(3,4,row))]);
subplot(1,2,2); imagesc(TMaps_rot{4}{batch_session_map.map(row,5)});
title(['Neuron ' num2str(batch_session_map.map(row,5))])

waitforbuttonpress

end

for j = 1:length(lowcorrs_ind)
figure(50); 
row = lowcorrs_ind(j); 
subplot(1,2,1); imagesc(TMaps_distal{3}{batch_session_map.map(row,4)}); 
title(['Neuron ' num2str(batch_session_map.map(row,4)) ...
    ' w/Correlation = ' num2str(Mouse(1).corr_matrix{1,2}(3,4,row))]);
subplot(1,2,2); imagesc(TMaps_distal{4}{batch_session_map.map(row,5)});
title(['Neuron ' num2str(batch_session_map.map(row,5))])

waitforbuttonpress

end

%% Plot out placemaps across days...

% Specify base directory here
base_sesh = ref.G31.two_env(1)+2;
rot_to_std = 1; % 0 = no, 1 = yes rotate such that local cues align
start_neuron = 108; % Start here when cycling through neurons

if rot_to_std == 0
    place_file = ['PlaceMaps' file_append '.mat'];
elseif rot_to_std == 1
    place_file = ['PlaceMaps_rot_to_std' file_append '.mat'];
end

% Load neuron mapping file
base_map = fullfile(MD(base_sesh).Location,'batch_session_map.mat');
load(base_map)

curr_dir = cd;
% Load TMaps for all relevant sessions
num_sessions = length(batch_session_map.session);
num_neurons = size(batch_session_map.map,1);
disp('Loading TMaps')
for j = 1:num_sessions
    ChangeDirectory(batch_session_map.session(j).mouse, batch_session_map.session(j).date,...
        batch_session_map.session(j).session);
    load(place_file,'TMap_gauss')
    sesh(j).TMap_gauss = TMap_gauss;
end

figure(200)
set(gcf,'Position',[27 724 1823 230])
blank = nan(size(sesh(1).TMap_gauss{1}));
disp('Plotting out TMaps across sessions')
for k = start_neuron:num_neurons
    for j = 1:num_sessions
        neuron_use = batch_session_map.map(k,j+1);
        if neuron_use ~= 0
            TMap_plot = sesh(j).TMap_gauss{neuron_use};
            title_use = ['Session ' num2str(j) ' neuron ' num2str(neuron_use)];
        else
            TMap_plot = blank;
            title_use = ['Session ' num2str(j) ' - no valid map'];
        end
    
    subplot(1,num_sessions,j)
    imagesc_nan(TMap_plot)
    title(title_use,'FontSize',8)
    end
    waitforbuttonpress
    
end

%% Plot of activity versus within day correlations

% Get sessions to look at correlations for...
within_day = [1 2; 3 4; 7 8]; within_day_ind = sub2ind([8 8],within_day(:,1), within_day(:,2));
before_win_local = [1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4]; before_win_local_ind = sub2ind([8 8],before_win_local(:,1), before_win_local(:,2));

days_active = sum(Mouse(1).batch_session_map(1).map(:,2:9) ~= 0,2); %# days each neuron is active
for j = 1:length(days_active)
    temp = [];
    for k = 1:size(within_day,1)
        temp = [temp, Mouse(1).corr_matrix{2,1}(within_day(k,1),within_day(k,2),j)];
    end
    within_day_corrs(j,:) = temp;
end

%% Start to getting cell stability phenotypes
remap_index = 0.4; % Wang/Muzzio uses 0.21 for e-phys

for m = 1:num_animals
    stable_seshs = [];
    neuron_pass = [];
    for ll = 1:2
        for j = 1:size(Mouse(m).corr_matrix{2,ll},3);
            stable_seshs(j) = nansum(nansum(Mouse(m).corr_matrix{2,ll}(:,:,j) > remap_index & ...
                Mouse(m).corr_matrix{2,ll}(:,:,j) ~= 1 & Mouse(m).pass_count{2,ll}(:,:,j) == 1));
            neuron_pass(j) = sum(sum(Mouse(m).pass_count{2,ll}(:,:,j))) > 0;
        end
        stable_2sesh = sum(stable_seshs == 1);
        stable_longerterm = sum(stable_seshs > 1);
        unstable = sum(neuron_pass) - stable_2sesh - stable_longerterm;
       total = sum(neuron_pass);
        
        Mouse(m).cellphenos{ll}.stable_2sesh = stable_2sesh ;
        Mouse(m).cellphenos{ll}.stable_longerterm = stable_longerterm;
        Mouse(m).cellphenos{ll}.unstable = unstable;
        Mouse(m).cellphenos{ll}.total = total;
    end
end

% Sum up for ALL sessions and mice
total_all = 0;
stable_2sesh_all = 0;
stable_longerterm_all = 0;
unstable_all = 0;
for m = 1:2
    for ll = 1:2
        stable_2sesh_all = stable_2sesh_all + Mouse(m).cellphenos{ll}.stable_2sesh;
        stable_longerterm_all = stable_longerterm_all + Mouse(m).cellphenos{ll}.stable_longerterm;
        unstable_all = unstable_all + Mouse(m).cellphenos{ll}.unstable;
        total_all = total_all + Mouse(m).cellphenos{ll}.total;
    end
end

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