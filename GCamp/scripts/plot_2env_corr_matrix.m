% Plot out all correlations between sessions...

clear all
close all

analysis_type = {'z_smooth' 'no_rotate_z_smooth' };

% Session File locations
plot_save_folder = 'J:\GCamp Mice\Working\2env\plots\2015APR26';
square_sesh_path = 'J:\GCamp Mice\Working\2env\square_sessions.mat';
octagon_sesh_path = 'J:\GCamp Mice\Working\2env\octagon_sessions.mat';
load(square_sesh_path)
load(octagon_sesh_path)

%Definintions of analysis days and sessions to use...
analysis_days_octagon = [2 2 3 3 5 6 8 8]; 
analysis_sesh_octagon = [1 2 1 2 2 2 1 2];
analysis_days_square = [1 1 4 4 5 6 7 7];
analysis_sesh_square = [1 2 1 2 1 1 1 2];

% Specify sessions that are already not rotated - will exlude correlations
% between these sessions when doing non-rotation control comparisons
non_rotate_oct_days = [2 3 5 8 8];
non_rotate_oct_sesh = [1 1 2 1 2];
% Get the appropriate indices for use below
for j = 1:length(non_rotate_oct_days)
non_rotate_ind_oct(j) = find(analysis_days_octagon == non_rotate_oct_days(j) & ...
    analysis_sesh_octagon == non_rotate_oct_sesh(j));
end
non_rotate_square_days = [1 1 4 5 7];
non_rotate_square_sesh = [1 2 1 1 1];
for j = 1:length(non_rotate_square_days)
non_rotate_ind_square(j) = find(analysis_days_square == non_rotate_square_days(j) & ...
    analysis_sesh_square == non_rotate_square_sesh(j));
end

sesh_ind_use(3).cy = 4:7; sesh_ind_use(3).cx = 4:7; % Assumes 2.3 cm/bin and a 10x10 occupancy grid
sesh_ind_use(4).cy = 5:8; sesh_ind_use(4).cx = 4:7; % Assumes 2.3 cm/bin and a 11x11 occupancy grid

sesh_type = {'square' 'octagon' 'square' 'octagon'};
sesh_where = {'Whole Arena' 'Whole Arena' 'Center Only' 'Center Only'};

comb_sesh_where = {'Whole Arena' 'Center Only' 'Whole Arena' 'Center Only'};

for ll = 1:2
    for i = 1:4
        for j = 1:8
            % Load appropriate mat file for the session type you want to analyze
            if strcmpi(sesh_type{i},'square')
                sesh_db_use = square_sessions;
                day_use = analysis_days_square;
                sesh_use = analysis_sesh_square;
            elseif strcmpi(sesh_type{i},'octagon')
                sesh_db_use = octagon_sessions;
                day_use = analysis_days_octagon;
                sesh_use = analysis_sesh_octagon;
            end
            
            % Get jth-kth correlation file and load it
            file_ind_use = [];
            for k = j+1:8
                cd(sesh_db_use(k).folder) % Go to directory of kth session
                corr_list = ls('*corrs_cmperbin2*_z_smooth.mat');
                text_search = ['day' num2str(day_use(j)) '_sesh' ...
                    num2str(sesh_use(j)) '_' analysis_type{ll}];
                for m = 1:size(corr_list,1)
                    file_ind_use(m) = ~isempty(regexpi(corr_list(m,:),text_search));
                end
                load(corr_list(logical(file_ind_use),:));
                
                % Get indices for appropriate occupancy bins to use
                temp = [];
                if ~isempty(sesh_ind_use(i).cy) && ~isempty(sesh_ind_use(i).cx)
                    % Grab center indices if specified
                    temp = sub2ind(size(corrs.corr_1_2), ...
                        repmat(sesh_ind_use(i).cy',1,length(sesh_ind_use(i).cx)), ...
                        repmat(sesh_ind_use(i).cx,length(sesh_ind_use(i).cy),1));
                else % otherwise, grab all indices
                    temp = 1:size(corrs.corr_1_2,1)*size(corrs.corr_1_2,2);
                end
                ind_use = temp(:);
                % Get within session correlations
                if j == 1
                    if k == 2 % Load up 1st session within correlations
                        corr_matrix(1,1) = nanmean(corrs.corr_1_win(ind_use));
                    end
                    corr_matrix(k,k) = nanmean(corrs.corr_2_win(ind_use));
                end
                corr_matrix(j,k) = nanmean(corrs.corr_1_2(ind_use));
                corr_matrix(k,j) = corr_matrix(j,k); % Mirror values
                corr_matrix_shufflemax(j,k) = max(corrs.corr_shuffle); % Get max of shuffled correlations
                corr_matrix_shufflemax(k,j) = corr_matrix_shufflemax(j,k);
                
                % Another take on statistics - get the mean number of bins in
                % which shuffled correlations are bigger than non-shuffled
                % correlations...divide by number of bins to get a "p-value"
                % for the null hypothesis that there is no consistent spatial
                % code between sessions
                shuffle_bins_mean = mean(corrs.corr_1_2_diff);
                num_bins = sum(~isnan(corrs.corr_1_2(ind_use)));
                shuffle_p_value(j,k) = shuffle_bins_mean/num_bins;
                shuffle_p_value(k,j) = shuffle_p_value(j,k);
                % Another attempt - this time compare the mean corr_1_2 value
                % to the mean of the shuffled correlation.
                shuffle_p_value2(j,k) = sum((nanmean(corrs.corr_1_2(ind_use)) - ...
                    corrs.corr_shuffle(:)) < 0)/length(corrs.corr_shuffle);
                shuffle_p_value2(k,j) = shuffle_p_value2(j,k);
            end
        end
        % Dump everything into mega_corr structure
        mega_corr((ll-1)*4+i).arena = [sesh_type{i} ' - ' sesh_where{i}];
        mega_corr((ll-1)*4+i).analysis_type = analysis_type{ll};
        mega_corr((ll-1)*4+i).corr_matrix = corr_matrix;
        mega_corr((ll-1)*4+i).corr_matrix_shufflemax = corr_matrix_shufflemax;
        mega_corr((ll-1)*4+i).shuffle_p_value = shuffle_p_value;
        mega_corr((ll-1)*4+i).shuffle_p_value2 = shuffle_p_value2;
        
    end
end



%% Plot mega correlation matrices
figure
subplot(2,2,1); imagesc(mega_corr(1).corr_matrix); colorbar
title('Square session correlations');
subplot(2,2,2); imagesc(mega_corr(2).corr_matrix); colorbar
title('Octagon session correlations');
subplot(2,2,3); imagesc(mega_corr(3).corr_matrix); colorbar
title('Square session correlations - Center Only');
subplot(2,2,4); imagesc(mega_corr(4).corr_matrix); colorbar
title('Octagon session correlations - Center Only');
figure
subplot(2,2,1); imagesc(mega_corr(5).corr_matrix); colorbar
title('Square session correlations - no rotate control');
subplot(2,2,2); imagesc(mega_corr(6).corr_matrix); colorbar
title('Octagon session correlations - no rotate control');
subplot(2,2,3); imagesc(mega_corr(7).corr_matrix); colorbar
title('Square session correlations - Center Only - no rotate control');
subplot(2,2,4); imagesc(mega_corr(8).corr_matrix); colorbar
title('Octagon session correlations - Center Only - no rotate control');
%% Gather and plot correlations between different types of sessions

for m = 1:8
    % Get sessions for which no rotation occurs
    if strcmpi(mega_corr(m).analysis_type,'no_rotate_z_smooth')
        if ~isempty(regexpi(mega_corr(m).arena,'square'))
            non_rot_ind = non_rotate_ind_square;
        elseif ~isempty(regexpi(mega_corr(m).arena,'octagon'))
            non_rot_ind = non_rotate_ind_oct;
        end
    else % Don't set anything if you are looking at the non-rotating comparisons
        non_rot_ind = [];
    end
    % 1) within session - all sessions
    mega_corr(m).within = mega_corr(m).corr_matrix(sub2ind([8 8],1:8,1:8));
    
    % 2) between sessions day 1-4
    % 2a) between sessions but only within day? - not yet
    n = 1;
    for j = 1:3
        for k = j+1:4
            if (sum(j == non_rot_ind) == 1) && (sum(k == non_rot_ind) == 1) % Ignore if both sessions not rotated
            else
            mega_corr(m).within_before(n) = mega_corr(m).corr_matrix(j,k);
            n = n+1;
            end
        end
    end
    
    % 3) day 5 to days 1-4
    j = 5;
    n = 1;
    for k = 1:4
        if (sum(j == non_rot_ind) == 1) && (sum(k == non_rot_ind) == 1) % Ignore if both sessions not rotated
        else
            mega_corr(m).day5_before(n) = mega_corr(m).corr_matrix(j,k);
            n = n+1;
        end
    end
    
    % 4) day 6 to days 1-4
    j = 6;
    n = 1;
    for k = 1:4
        if (sum(j == non_rot_ind) == 1) && (sum(k == non_rot_ind) == 1) % Ignore if both sessions not rotated
        else
            mega_corr(m).day6_before(n) = mega_corr(m).corr_matrix(j,k);
            n = n+1;
        end
    end
    
    % 5) day 6 to days 7-8 
    j = 6;
    n = 1;
    for k = 7:8
        if (sum(j == non_rot_ind) == 1) && (sum(k == non_rot_ind) == 1) % Ignore if both sessions not rotated
        else
            mega_corr(m).day6_after(n) = mega_corr(m).corr_matrix(j,k);
            n = n+1;
        end
    end
    
    % 6) days 1-4 to days 7-8
    n = 1;
    for j = 1:4
        for k = 7:8
            if (sum(j == non_rot_ind) == 1) && (sum(k == non_rot_ind) == 1) % Ignore if both sessions not rotated
            else
                mega_corr(m).before_after(n) = mega_corr(m).corr_matrix(j,k);
                n = n+1;
            end
        end
    end
    
    % 6a) days 1-4 to day 7
    k = 7;
    n = 1;
    for j = 1:4
            if (sum(j == non_rot_ind) == 1) && (sum(k == non_rot_ind) == 1) % Ignore if both sessions not rotated
            else
                mega_corr(m).before_day7(n) = mega_corr(m).corr_matrix(j,k);
                n = n+1;
            end
    end
    
end

%% Create combined correlation matrices

for ll = 1:2
   for ss = 1:2 
   temp_w = []; temp_wb  = []; temp_5b = []; temp_6b = []; temp_6a = []; temp_ba = [];
   temp_7b = [];
       for m = 1:2
           temp_w = [temp_w mega_corr((ll-1)*4+(ss-1)*2+m).within];
           temp_wb = [temp_wb mega_corr((ll-1)*4+(ss-1)*2+m).within_before];
           temp_5b = [temp_5b mega_corr((ll-1)*4+(ss-1)*2+m).day5_before];
           temp_6b = [temp_6b mega_corr((ll-1)*4+(ss-1)*2+m).day6_before];
           temp_6a = [temp_6a mega_corr((ll-1)*4+(ss-1)*2+m).day6_after];
           temp_ba = [temp_ba mega_corr((ll-1)*4+(ss-1)*2+m).before_after];
           temp_7b = [temp_7b mega_corr((ll-1)*4+(ss-1)*2+m).before_day7];
       end
       comb_corr((ll-1)*2+ss).analysis_type = analysis_type{ll}; 
       comb_corr((ll-1)*2+ss).arena = comb_sesh_where{(ll-1)*2+ss}; 
       comb_corr((ll-1)*2+ss).within = temp_w;
       comb_corr((ll-1)*2+ss).within_before = temp_wb;
       comb_corr((ll-1)*2+ss).day5_before = temp_5b;
       comb_corr((ll-1)*2+ss).day6_before = temp_6b;
       comb_corr((ll-1)*2+ss).day6_after = temp_6a;
       comb_corr((ll-1)*2+ss).before_after = temp_ba;
       comb_corr((ll-1)*2+ss).before_day7 = temp_7b;
       
   end
end

%% Calculate means and variances, and get wald statistic between the two
% groups.  mvs = mean_variance_sem
nfigh= 1;
for gg = 1:2
    
    if gg == 1
        corr_mat_use = mega_corr;
    elseif gg == 2
        corr_mat_use = comb_corr;
    end
    for m = 1:size(corr_mat_use,2)
        % Get mean, variance, and sem for all the comparisons
        temp = corr_mat_use(m).within;
        stats(m).within.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        temp = corr_mat_use(m).within_before;
        stats(m).within_before.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        temp = corr_mat_use(m).day5_before;
        stats(m).day5_before.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        temp = corr_mat_use(m).day6_before;
        stats(m).day6_before.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        temp = corr_mat_use(m).day6_after;
        stats(m).day6_after.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        temp = corr_mat_use(m).before_after;
        stats(m).before_after.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        temp = corr_mat_use(m).before_day7;
        stats(m).before_day7.mvs = [mean(temp), var(temp), std(temp)/sqrt(length(temp))];
        % Get the wald statistic for the difference between two means for all
        % the comparisons
        temp1 = stats(m).within.mvs; temp2 = stats(m).within_before.mvs;
        stats(m).within_withinbefore.wald = (temp1(1) - temp2(1))/...
            sqrt(temp1(3)^2 + temp2(3)^2);
        temp1 = stats(m).within_before.mvs; temp2 = stats(m).day5_before.mvs;
        stats(m).withinbefore_before5.wald = (temp1(1) - temp2(1))/...
            sqrt(temp1(3)^2 + temp2(3)^2);
        temp1 = stats(m).within_before.mvs; temp2 = stats(m).day6_before.mvs;
        stats(m).withinbefore_before6.wald = (temp1(1) - temp2(1))/...
            sqrt(temp1(3)^2 + temp2(3)^2);
        temp1 = stats(m).within_before.mvs; temp2 = stats(m).before_after.mvs;
        stats(m).withinbefore_beforeafter.wald = (temp1(1) - temp2(1))/...
            sqrt(temp1(3)^2 + temp2(3)^2);
        temp1 = stats(m).within_before.mvs; temp2 = stats(m).before_day7.mvs;
        stats(m).withinbefore_before7.wald = (temp1(1) - temp2(1))/...
            sqrt(temp1(3)^2 + temp2(3)^2);
        
        % Calculate z-score for differences
        [~, stats(m).within_withinbefore.p] = ztest(stats(m).within_withinbefore.wald,...
            0,1);
        [~, stats(m).withinbefore_before5.p] = ztest(stats(m).withinbefore_before5.wald,...
            0,1);
        [~, stats(m).withinbefore_before6.p] = ztest(stats(m).withinbefore_before6.wald,...
            0,1);
        [~, stats(m).withinbefore_beforeafter.p] = ztest(stats(m).withinbefore_beforeafter.wald,...
            0,1);
        [~, stats(m).withinbefore_before7.p] = ztest(stats(m).withinbefore_before7.wald,...
            0,1);
        
        % Make matrix of means and sems
        shuffled_mean = 0.0638; shuffled_sem = 0.0068;
        plot_mean = [ stats(m).within.mvs(1) stats(m).within_before.mvs(1) ...
            stats(m).day5_before.mvs(1) stats(m).day6_before.mvs(1) ...
            stats(m).day6_after.mvs(1) stats(m).before_after.mvs(1)]; % ...
%             stats(m).before_day7.mvs(1)];
        plot_sem = [ stats(m).within.mvs(2) stats(m).within_before.mvs(2) ...
            stats(m).day5_before.mvs(2) stats(m).day6_before.mvs(2) ...
            stats(m).day6_after.mvs(2) stats(m).before_after.mvs(2)]; %...
%             stats(m).before_day7.mvs(2)];
        hlist_fig(nfigh).h = figure(20*gg+m);
        hlist(nfigh).h = gca;
        
        barwitherr(plot_sem, plot_mean); % Plot bars with sems
        hold on;
        plot(get(gca,'XLim'),[shuffled_mean shuffled_mean],'r--')
        legend('Data','','Shuffled')
        set(gca,'XTickLabel',{'Within All Sessions' 'Between Sessions Days 1-4' ...
            'Day 5 to Days 1-4' 'Day 6 to Days 1-4' 'Day 6 to Days 7-8' ...
            'Days 1-4 to Days 7-8'})
        if gg == 1
            if m <=4; rot_append = ''; else; rot_append = ' - No Rotation Control'; end
            plotname{nfigh}  = [sesh_type{mod(m-1,4)+1} ' - ' sesh_where{mod(m-1,4)+1} rot_append];
            title(plotname{nfigh})
        elseif gg == 2
            if m <=2; rot_append = ''; else; rot_append = ' - No Rotation Control'; end
            plotname{nfigh} = ['Combined ' comb_sesh_where{m} rot_append];
            title(plotname{nfigh});
        end
        
        % Save all the stats to the appropriate data structure
        if gg == 1
            mega_corr(m).stats = stats(m);
        elseif gg == 2
            comb_corr(m).stats = stats(m);
        end
        
        nfigh = nfigh + 1;
        
    end
    
end

% Plot day 5 to days 1:4 for square and octagon
plot2_mean = [mega_corr(1).stats.day5_before.mvs(1),...
    mega_corr(2).stats.day5_before.mvs(1)];
plot2_sem = [mega_corr(1).stats.day5_before.mvs(3),...
    mega_corr(2).stats.day5_before.mvs(3)];

hlist_fig(nfigh).h = figure(20*gg+m+1);
hlist(nfigh).h = gca;
barwitherr(plot2_sem, plot2_mean)
plotname{nfigh} = 'Day 5 to Day 1-4 correlations';
title(plotname{nfigh})
set(gca,'XTickLabel',{'Square' 'Octagon'})
ylim([-0.1 0.5]); xlim([0.5 2.5])

% Set x and y limits to be all the same
match_xylim(hlist)

%% Save Stuff

% Save figures as jpgs and figs
for j = 1:size(hlist_fig,2)
    figure(hlist_fig(j).h);
    set(hlist_fig(j).h, 'Position', get(0,'Screensize')); % My attempt to maximize the figure before saving so that it doesn't look funny
    export_fig([plot_save_folder '\' plotname{j}] ,'-jpg');
    saveas(hlist_fig(j).h, [plot_save_folder '\' plotname{j}], 'fig'); % Need to save the plots to a figure also
end







