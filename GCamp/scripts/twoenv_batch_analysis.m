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

num_animals = length(Mouse);

for j = 1:num_animals
    Mouse(j).key = '1,1 = square no-rotate, 1,2 = octagon no-rotate, 2,1 = square rotate, 2,2 = octagon rotate';
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
            [Mouse(j).corr_matrix{m+1,k}, pop_struct_temp, Mouse(j).pass_count{m+1,k},...
                Mouse(j).within_corr{m+1,k}, Mouse(j).shuffle_matrix] = tmap_corr_across_days(Mouse(j).working_dirs{k},...
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
        mega_mean_rot_temp = nanmean(Mouse(j).corr_matrix{2,k},3);
        mega_mean_no_rot_temp = nanmean(Mouse(j).corr_matrix{1,k},3);
        
        mega_mean(1).matrix(:,:,count) = mega_mean_no_rot_temp; % [mega_mean(1).matrix(ll,mm) mega_mean_no_rot_temp];
        mega_mean(2).matrix(:,:,count) = mega_mean_rot_temp; % [mega_mean(2).matrix(ll,mm) mega_mean_rot_temp];
        count = count + 1;
    end
end

% Do this with criteria for # days active
for ll = 2:8
    count = 1; % Start counter
    for j = 1:num_animals
        for k = 1:2
            mega_mean_rot_temp = nanmean(Mouse(j).corr_matrix{2,k}(:,:,Mouse(j).days_active{k} == ll),3);
            mega_mean_no_rot_temp = nanmean(Mouse(j).corr_matrix{1,k}(:,:,Mouse(j).days_active{k} == ll),3);
            
            mega_mean_byday(ll).mega_mean(1).matrix(:,:,count) = mega_mean_no_rot_temp; % [mega_mean(1).matrix(ll,mm) mega_mean_no_rot_temp];
            mega_mean_byday(ll).mega_mean(2).matrix(:,:,count) = mega_mean_rot_temp; % [mega_mean(2).matrix(ll,mm) mega_mean_rot_temp];
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
                mega_mean_pop_rot_temp = Mouse(j).pop_corr_matrix{2,k}(ll,mm,:);
                mega_mean_pop_no_rot_temp = Mouse(j).pop_corr_matrix{1,k}(ll,mm,:);
                
                mega_mean(1).pop_matrix(ll,mm,count) = mega_mean_pop_no_rot_temp; % [mega_mean(1).matrix(ll,mm) mega_mean_no_rot_temp];
                mega_mean(2).pop_matrix(ll,mm,count) = mega_mean_pop_rot_temp; % [mega_mean(2).matrix(ll,mm) mega_mean_rot_temp];
                count = count + 1;
            end
        end
    end
end

% Get shuffled distributions
shuffle_comb = Mouse(1).shuffle_matrix;
for j = 2:num_animals
   shuffle_comb = cat(4,shuffle_comb,Mouse(j).shuffle_matrix); 
end

%% Get basic stats - not done for population correlations yet

% Better way to do things in the future is to get values for ALL neuron correlations in
% each session and group them together somehow after classifying them due
% to the various comparisons below
mean_simple_norot = mean(mega_mean(1).matrix,3);
mean_simple_rot = mean(mega_mean(2).matrix,3);
if isnan(sum(mean_simple_rot(:))) || isnan(sum(mean_simple_norot(:)))
    disp('Note - some sessions have NO good correlations due to not meeting the threshold - be sure to check!')
    mean_simple_norot = nanmean(mega_mean(1).matrix,3);
    mean_simple_rot = nanmean(mega_mean(2).matrix,3);
end

% Population Simple Means
mean_simple_pop_norot = mean(mega_mean(1).pop_matrix,3);
mean_simple_pop_rot = mean(mega_mean(2).pop_matrix,3);

% Shuffled Simple means
mean_shuffle_simple = nanmean(squeeze(nanmean(shuffle_comb,1)),3);
shuffle_mean = nanmean(shuffle_comb(:));

% Indices for various comparisons - wow, that's a lot of work
before_win = [1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4]; before_win_ind = sub2ind([8 8],before_win(:,1), before_win(:,2));
before_win_norot = [1 2; 1 4; 2 4; 3 4]; before_win_norot_ind = sub2ind([8 8],before_win(:,1), before_win(:,2));
after_win = [7 8]; after_win_ind = sub2ind([8 8],after_win(:,1), after_win(:,2));
after_win_norot = [7 8]; after_win_norot_ind = sub2ind([8 8],after_win_norot(:,1), after_win_norot(:,2));
before_after = [1 7; 2 7; 3 7; 4 7; 1 8; 2 8 ;3 8; 4 8]; before_after_ind = sub2ind([8 8],before_after(:,1), before_after(:,2));
before_after_norot = [2 7; 4 7; 1 8; 2 8 ; 3 8]; before_after_norot_ind = sub2ind([8 8],before_after_norot(:,1), before_after_norot(:,2));
before_5 = [1 5; 2 5; 3 5; 4 5]; before_5_ind = sub2ind([8 8],before_5(:,1), before_5(:,2));
before_5_norot = [2 5; 4 5]; before_5_norot_ind = sub2ind([8 8],before_5_norot(:,1), before_5_norot(:,2));
before_6 = [1 6; 2 6 ; 3 6; 4 6]; before_6_ind = sub2ind([8 8],before_6(:,1), before_6(:,2));
before_6_norot = [1 6; 2 6; 3 6; 4 6]; before_6_norot_ind = sub2ind([8 8],before_6_norot(:,1), before_6_norot(:,2));
after_5 = [5 7; 5 8]; after_5_ind = sub2ind([8 8],after_5(:,1), after_5(:,2));
after_5_norot = [5 8]; after_5_norot_ind = sub2ind([8 8],after_5_norot(:,1), after_5_norot(:,2));
after_6 = [6 7; 6 8]; after_6_ind = sub2ind([8 8],after_6(:,1), after_6(:,2));
after_6_norot = [6 7; 6 8]; after_6_norot_ind = sub2ind([8 8],after_6_norot(:,1), after_6_norot(:,2));
conn1_conn2 = [5 6]; conn1_conn2_ind = sub2ind([8 8],conn1_conn2(:,1), conn1_conn2(:,2));
conn1_conn2_norot = [5 6]; conn1_conn2_norot_ind = sub2ind([8 8],conn1_conn2_norot(:,1), conn1_conn2_norot(:,2));

% Mean of individual correlations
before_win_mean = mean(mean_simple_rot(before_win_ind));
before_win_sem = std(mean_simple_rot(before_win_ind))/sqrt(length(before_win_ind));
before_win_norot_mean = mean(mean_simple_norot(before_win_norot_ind));
before_win_norot_sem = std(mean_simple_norot(before_win_norot_ind))/sqrt(length(before_win_norot_ind));
before_win_shuffle_mean = mean(mean_shuffle_simple(before_win_ind));
before_win_shuffle_sem = std(mean_shuffle_simple(before_win_ind))/sqrt(length(before_win_ind));

before_after_mean = mean(mean_simple_rot(before_after_ind));
before_after_sem = std(mean_simple_rot(before_after_ind))/sqrt(length(before_after_ind));
before_after_norot_mean = mean(mean_simple_norot(before_after_norot_ind));
before_after_norot_sem = std(mean_simple_norot(before_after_norot_ind))/sqrt(length(before_after_norot_ind));
before_after_shuffle_mean = mean(mean_shuffle_simple(before_after_ind));
before_after_shuffle_sem = std(mean_shuffle_simple(before_after_ind))/sqrt(length(before_after_ind));

before_5_mean = mean(mean_simple_rot(before_5_ind));
before_5_sem = std(mean_simple_rot(before_5_ind))/sqrt(length(before_5_ind));
before_5_norot_mean = mean(mean_simple_norot(before_5_norot_ind));
before_5_norot_sem = std(mean_simple_norot(before_5_norot_ind))/sqrt(length(before_5_norot_ind));
before_5_shuffle_mean = mean(mean_shuffle_simple(before_5_ind));
before_5_shuffle_sem = std(mean_shuffle_simple(before_5_ind))/sqrt(length(before_5_ind));

before_6_mean = mean(mean_simple_rot(before_6_ind));
before_6_sem = std(mean_simple_rot(before_6_ind))/sqrt(length(before_6_ind));
before_6_norot_mean = mean(mean_simple_norot(before_6_norot_ind));
before_6_norot_sem = std(mean_simple_norot(before_6_norot_ind))/sqrt(length(before_6_norot_ind));
before_6_shuffle_mean = mean(mean_shuffle_simple(before_6_ind));
before_6_shuffle_sem = std(mean_shuffle_simple(before_6_ind))/sqrt(length(before_6_ind));

after_5_mean = mean(mean_simple_rot(after_5_ind));
after_5_sem = std(mean_simple_rot(after_5_ind))/sqrt(length(after_5_ind));
after_5_norot_mean = mean(mean_simple_norot(after_5_norot_ind));
after_5_norot_sem = std(mean_simple_norot(after_5_norot_ind))/sqrt(length(after_5_norot_ind));
after_5_norot_sem = after_5_sem; % Fake it for now...only have one sample currently
after_5_shuffle_mean = mean(mean_shuffle_simple(after_5_ind));
after_5_shuffle_sem = std(mean_shuffle_simple(after_5_ind))/sqrt(length(after_5_ind));

after_6_mean = mean(mean_simple_rot(after_6_ind));
after_6_sem = std(mean_simple_rot(after_6_ind))/sqrt(length(after_6_ind));
after_6_norot_mean = mean(mean_simple_norot(after_6_norot_ind));
after_6_norot_sem = std(mean_simple_norot(after_6_norot_ind))/sqrt(length(after_6_norot_ind));
after_6_shuffle_mean = mean(mean_shuffle_simple(after_6_ind));
after_6_shuffle_sem = std(mean_shuffle_simple(after_6_ind))/sqrt(length(after_6_ind));

% Mean of population correlations
pop_before_win_mean = mean(mean_simple_pop_rot(before_win_ind));
pop_before_win_sem = std(mean_simple_pop_rot(before_win_ind))/sqrt(length(before_win_ind));
pop_before_win_norot_mean = mean(mean_simple_pop_norot(before_win_norot_ind));
pop_before_win_norot_sem = std(mean_simple_pop_norot(before_win_norot_ind))/sqrt(length(before_win_norot_ind));

pop_before_after_mean = mean(mean_simple_pop_rot(before_after_ind));
pop_before_after_sem = std(mean_simple_pop_rot(before_after_ind))/sqrt(length(before_after_ind));
pop_before_after_norot_mean = mean(mean_simple_pop_norot(before_after_norot_ind));
pop_before_after_norot_sem = std(mean_simple_pop_norot(before_after_norot_ind))/sqrt(length(before_after_norot_ind));

pop_before_5_mean = mean(mean_simple_pop_rot(before_5_ind));
pop_before_5_sem = std(mean_simple_pop_rot(before_5_ind))/sqrt(length(before_5_ind));
pop_before_5_norot_mean = mean(mean_simple_pop_norot(before_5_norot_ind));
pop_before_5_norot_sem = std(mean_simple_pop_norot(before_5_norot_ind))/sqrt(length(before_5_norot_ind));

pop_before_6_mean = mean(mean_simple_pop_rot(before_6_ind));
pop_before_6_sem = std(mean_simple_pop_rot(before_6_ind))/sqrt(length(before_6_ind));
pop_before_6_norot_mean = mean(mean_simple_pop_norot(before_6_norot_ind));
pop_before_6_norot_sem = std(mean_simple_pop_norot(before_6_norot_ind))/sqrt(length(before_6_norot_ind));

pop_after_5_mean = mean(mean_simple_pop_rot(after_5_ind));
pop_after_5_sem = std(mean_simple_pop_rot(after_5_ind))/sqrt(length(after_5_ind));
pop_after_5_norot_mean = mean(mean_simple_pop_norot(after_5_norot_ind));
pop_after_5_norot_sem = std(mean_simple_pop_norot(after_5_norot_ind))/sqrt(length(after_5_norot_ind));
pop_after_5_norot_sem = pop_after_5_sem; % Fake it for now...only have one sample currently

pop_after_6_mean = mean(mean_simple_pop_rot(after_6_ind));
pop_after_6_sem = std(mean_simple_pop_rot(after_6_ind))/sqrt(length(after_6_ind));
pop_after_6_norot_mean = mean(mean_simple_pop_norot(after_6_norot_ind));
pop_after_6_norot_sem = std(mean_simple_pop_norot(after_6_norot_ind))/sqrt(length(after_6_norot_ind));

% Attempt to get more legit statistics - get mean of ALL comparisons
% across all mice, not mean of means...confusing, I know, but more legit
mega_size = size(mega_mean(2).matrix);
before_win_ind = make_mega_sub2ind(mega_size, before_win(:,1), before_win(:,2)); 
before_win_norot_ind = make_mega_sub2ind(mega_size, before_win(:,1), before_win(:,2));
before_5_ind = make_mega_sub2ind(mega_size, before_5(:,1), before_5(:,2)); 
before_5_norot_ind = make_mega_sub2ind(mega_size, before_5(:,1), before_5(:,2));
after_5_ind = make_mega_sub2ind(mega_size, after_5(:,1), after_5(:,2)); 
after_5_norot_ind = make_mega_sub2ind(mega_size, after_5(:,1), after_5(:,2));
before_6_ind = make_mega_sub2ind(mega_size, before_6(:,1), before_6(:,2)); 
before_6_norot_ind = make_mega_sub2ind(mega_size, before_6(:,1), before_6(:,2));
after_6_ind = make_mega_sub2ind(mega_size, after_6(:,1), after_6(:,2)); 
after_6_norot_ind = make_mega_sub2ind(mega_size, after_6(:,1), after_6(:,2));
conn1_conn2_ind = make_mega_sub2ind(mega_size, conn1_conn2(:,1), conn1_conn2(:,2)); 
conn1_conn2_norot_ind = make_mega_sub2ind(mega_size, conn1_conn2(:,1), conn1_conn2(:,2));

% Combined groupings (separate, connected day 1, connected day 2)
separate_win_ind = [before_win_ind; before_after_ind];
separate_win_mean = mean(mega_mean(2).matrix(separate_win_ind));
separate_win_sem = std(mega_mean(2).matrix(separate_win_ind))/sqrt(length(separate_win_ind));
separate_win_norot_ind = [before_win_norot_ind; before_after_norot_ind];
separate_win_norot_mean = mean(mega_mean(1).matrix(separate_win_norot_ind));
separate_win_norot_sem = std(mega_mean(1).matrix(separate_win_norot_ind))/sqrt(length(separate_win_norot_ind));

sep_conn1_ind = [before_5_ind; after_5_ind];
sep_conn1_mean = mean(mega_mean(2).matrix(sep_conn1_ind));
sep_conn1_sem = std(mega_mean(2).matrix(sep_conn1_ind))/sqrt(length(sep_conn1_ind));
sep_conn1_norot_ind = [before_5_norot_ind; after_5_norot_ind];
sep_conn1_norot_mean = mean(mega_mean(1).matrix(sep_conn1_norot_ind));
sep_conn1_norot_sem = std(mega_mean(1).matrix(sep_conn1_norot_ind))/sqrt(length(sep_conn1_norot_ind));

sep_conn2_ind = [before_6_ind; after_6_ind];
sep_conn2_mean = mean(mega_mean(2).matrix(sep_conn2_ind));
sep_conn2_sem = std(mega_mean(2).matrix(sep_conn2_ind))/sqrt(length(sep_conn2_ind));
sep_conn2_norot_ind = [before_6_norot_ind; after_6_norot_ind];
sep_conn2_norot_mean = mean(mega_mean(1).matrix(sep_conn2_norot_ind));
sep_conn2_norot_sem = std(mega_mean(1).matrix(sep_conn2_norot_ind))/sqrt(length(sep_conn2_norot_ind));

conn1_conn2_mean = mean(mega_mean(2).matrix(conn1_conn2_ind));
conn1_conn2_sem = std(mega_mean(2).matrix(conn1_conn2_ind))/sqrt(length(conn1_conn2_ind));
conn1_conn2_norot_mean = mean(mega_mean(1).matrix(conn1_conn2_norot_ind));
conn1_conn2_norot_sem = std(mega_mean(1).matrix(conn1_conn2_norot_ind))/sqrt(length(conn1_conn2_norot_ind));

%% Attempt to do above for day restricted data
for ll = 2:8
   twoenv_bars( mega_mean_byday(ll).mega_mean, shuffle_comb, ll) 
end

%% First attempt to get real stats

% Should probably write below into a simple function and then call it
% repeatedly

after_5_comb = [];
after_5_comb_no_rot = [];
for j = 1:num_animals
    for ll = 1:2
        for mm = 1:size(after_5,1)
                after_5_comb = [ after_5_comb ; squeeze(Mouse(j).corr_matrix{1,ll}(after_5(mm,1),after_5(mm,2),...
                    logical(squeeze(Mouse(j).pass_count{ll,1}(after_5(mm,1),after_5(mm,2),:)))))];
                after_5_comb_no_rot = [ after_5_comb_no_rot ; squeeze(Mouse(j).corr_matrix{2,ll}(after_5(mm,1),after_5(mm,2),...
                    logical(squeeze(Mouse(j).pass_count{ll,2}(after_5(mm,1),after_5(mm,2),:)))))];
        end
    end
end
nanmean(after_5_comb);
nanstd(after_5_comb);

%% Plot individual neuron summaries
error_on = 1;
figure(10)
h = bar([before_win_mean, before_win_norot_mean;  ...
    before_5_mean, before_5_norot_mean; after_5_mean, after_5_norot_mean; ...
    before_6_mean, before_6_norot_mean; after_6_mean, after_6_norot_mean; ...
    before_after_mean, before_after_norot_mean;]);
hold on
if error_on == 1
    errorbar(h(1).XData + h(1).XOffset, [before_win_mean, ...
        before_5_mean, after_5_mean, before_6_mean, after_6_mean, before_after_mean], [before_win_sem, ...
        before_5_sem, after_5_sem, before_6_sem, after_6_sem, before_after_sem],...
        '.')
    errorbar(h(2).XData + h(2).XOffset, [before_win_norot_mean, ...
        before_5_norot_mean, after_5_norot_mean, before_6_norot_mean, after_6_norot_mean, before_after_norot_mean], [before_win_norot_sem, ...
        before_5_norot_sem, after_5_norot_sem, before_6_norot_sem, after_6_norot_sem, before_after_norot_sem],...
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
h = bar([separate_win_mean, separate_win_norot_mean;  ...
    sep_conn1_mean, sep_conn1_norot_mean; sep_conn2_mean, sep_conn2_norot_mean;...
    conn1_conn2_mean, conn1_conn2_norot_mean]);
hold on
if error_on == 1
    errorbar(h(1).XData + h(1).XOffset, [separate_win_mean, ...
        sep_conn1_mean, sep_conn2_mean, conn1_conn2_mean], [separate_win_sem, ...
        sep_conn1_sem, sep_conn2_sem, conn1_conn2_sem],'.')
    errorbar(h(2).XData + h(2).XOffset, [separate_win_norot_mean, ...
        sep_conn1_norot_mean, sep_conn2_norot_mean, conn1_conn2_norot_mean], [separate_win_norot_sem, ...
        sep_conn1_norot_sem, sep_conn2_norot_sem, conn1_conn2_norot_sem],'.')
end
h2 = plot(get(gca,'XLim'),[shuffle_mean shuffle_mean],'r--');
set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
    'Separate - Connected Day 2','Connected Day 1 - Connected Day 2'})
ylabel('Transient Map Mean Correlations - Individual Neurons')
h_legend = legend([h(1) h(2) h2],'Local cues aligned','Distal cues aligned','Chance (Shuffled Data)');
hold off
ylims_given = get(gca,'YLim');
% ylim([ylims_given(1)-0.1, ylims_given(2)+0.1]);

%% Plot population correlation summary
figure(11)
h = bar([pop_before_win_mean, pop_before_win_norot_mean; ...
    pop_before_5_mean, pop_before_5_norot_mean; pop_after_5_mean, pop_after_5_norot_mean; ...
    pop_before_6_mean, pop_before_6_norot_mean; pop_after_6_mean, pop_after_6_norot_mean; ...
    pop_before_after_mean, pop_before_after_norot_mean]);
hold on
if error_on == 1
    errorbar(h(1).XData + h(1).XOffset, [pop_before_win_mean, ...
        pop_before_5_mean, pop_after_5_mean, pop_before_6_mean, pop_after_6_mean, pop_before_after_mean],...
        [pop_before_win_sem, pop_before_5_sem, pop_after_5_sem, pop_before_6_sem, pop_after_6_sem,pop_before_after_sem],...
        '.')
    errorbar(h(2).XData + h(2).XOffset, [pop_before_win_norot_mean, ...
        pop_before_5_norot_mean, pop_after_5_norot_mean, pop_before_6_norot_mean, pop_after_6_norot_mean, pop_before_after_norot_mean], [pop_before_win_norot_sem, ...
        pop_before_5_norot_sem, pop_after_5_norot_sem, pop_before_6_norot_sem, pop_after_6_norot_sem, pop_before_after_norot_sem],...
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
centers = -0.2:0.05:0.9;
figure
set(gcf,'Position', [2121, 482, 886, 370]);
subplot(1,2,1)
hist(session_distal,centers);
mean_distal = nanmean(session_distal);
ylim_use = get(gca,'YLim');
hold on;
plot([mean_distal, mean_distal],[ylim_use(1), ylim_use(2)],'r--')
hold off;
title(char('     Histogram','Distal cues aligned'))
xlabel('Calcium Transient Heat Map Correlation'); ylabel('Count')

subplot(1,2,2)
hist(session_local,centers);
mean_local = nanmean(session_local);
ylim_use = get(gca,'YLim');
hold on;
plot([mean_local, mean_local],[ylim_use(1), ylim_use(2)],'r--')
hold off;
title(char('     Histogram','Local cues aligned'))
xlabel('Calcium Transient Heat Map Correlation'); ylabel('Count')
% ylim([0 80])

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
TMaps_norot{3} = TMap_gauss;
load('j:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\PlaceMaps.mat','TMap','TMap_gauss')
TMaps_norot{4} = TMap_gauss;
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
subplot(1,2,1); imagesc(TMaps_norot{3}{batch_session_map.map(row,4)}); 
title(['Neuron ' num2str(batch_session_map.map(row,4)) ...
    ' w/Correlation = ' num2str(Mouse(1).corr_matrix{1,2}(3,4,row))]);
subplot(1,2,2); imagesc(TMaps_norot{4}{batch_session_map.map(row,5)});
title(['Neuron ' num2str(batch_session_map.map(row,5))])

waitforbuttonpress

end

%% Plot out placemaps across days...

% Specify base directory here
base_sesh = ref.G31.two_env(1);
rot_to_std = 1; % 0 = no, 1 = yes rotate such that local cues align
start_neuron = 57; % Start here when cycling through neurons

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
before_win = [1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4]; before_win_ind = sub2ind([8 8],before_win(:,1), before_win(:,2));

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

