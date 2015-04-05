function [h1, corrs] = shuffle_ratemaps2(folder1, folder2, analysis_type, num_shuffles, rot_overwrite, exclude)
% corrs = shuffle_ratemaps(folder1, folder2, num_shuffles, rot_overwrite, exclude)
% This function takes two sessions and calculates the correlation between
% their reverse place fiels across the whole arena, as well as calculating correlation values based on shuffled data
% folder1 and folder2 are the two sessions you wish to compare
% analysis_type = 1 means you are using the smoothed RVP DF data ((F-F0)/F0),
% 0 = unsmoothed DF data, 2 = smoothed z data ((F-F0)/stdev)
% num_shuffles - the number of times to shuffle the RVP occupancy grids
% when calculated your shuffled correlations
% rot_overwrite - a value of 1 indicates that you wish to NOT rotate the
% arenas back the base config
% exclude = a binary vector indicating which pixels from the brain imaging
% data you wish to exclude from any RVP analysis (e.g. due to abberant
% activity, blood, edge of cannula, etc.)
%
% h1 is the handle to the plot of all the correlations
% corrs contains all the correlation data

close all

%% Variables to set

movie_type = 'ChangeMovie'; % hack for now



%% Import stuff

if rot_overwrite == 1
    import_append = '_no_rotate';
elseif rot_overwrite == 0
    import_append = '';
end

disp('Loading .mat files')
if strcmpi(movie_type,'ICmovie_smooth')
    import_file = ['reverse_placefields' import_append '.mat'];
elseif strcmpi(movie_type,'ChangeMovie')
    import_file = [ 'reverse_placefields_ChangeMovie' import_append '.mat'];
end
sesh1 = importdata([ folder1 import_file]);
sesh2 = importdata([ folder2 import_file]);

%% Assign data based on smoothed flag 
if analysis_type == 1
   sesh1.frame_use = sesh1.AvgFrame_DF_smooth;
   sesh1.frame_use_1st = sesh1.AvgFrame_DF_1st_smooth;
   sesh1.frame_use_2nd = sesh1.AvgFrame_DF_2nd_smooth;
   sesh2.frame_use = sesh2.AvgFrame_DF_smooth;
   sesh2.frame_use_1st = sesh2.AvgFrame_DF_1st_smooth;
   sesh2.frame_use_2nd = sesh2.AvgFrame_DF_2nd_smooth;
   analysis_type = 'DF smoothed';
elseif analysis_type == 0
    sesh1.frame_use = sesh1.AvgFrame_DF;
    sesh1.frame_use_1st = sesh1.AvgFrame_DF_1st;
    sesh1.frame_use_2nd = sesh1.AvgFrame_DF_2nd;
    sesh2.frame_use = sesh2.AvgFrame_DF;
    sesh2.frame_use_1st = sesh2.AvgFrame_DF_1st;
    sesh2.frame_use_2nd = sesh2.AvgFrame_DF_2nd;
    analysis_type = 'DF unsmoothed';
elseif analysis_type == 2
    sesh1.frame_use = sesh1.AvgFrame_z_smooth;
    sesh1.frame_use_1st = sesh1.AvgFrame_z_1st_smooth;
    sesh1.frame_use_2nd = sesh1.AvgFrame_z_2nd_smooth;
    sesh2.frame_use = sesh2.AvgFrame_z_smooth;
    sesh2.frame_use_1st = sesh2.AvgFrame_z_1st_smooth;
    sesh2.frame_use_2nd = sesh2.AvgFrame_z_2nd_smooth;
    analysis_type = 'z-score smoothed';
end


image_xpix = size(sesh1.frame_use{1},2);
image_ypix = size(sesh1.frame_use{1},1);

%% Select region to exclude (in this case, where we get traveling waves)
% x_exclude = 325:image_xpix; % in pixels
% y_exclude = 300:image_ypix;
% exclude = zeros(size(sesh1.frame_use{1}));
% exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));

%% Calculate it out
% Get resistor weighted occupancy
weight1 = sesh1.Occmap/nansum(sesh1.Occmap(:));
weight2 = sesh2.Occmap/nansum(sesh2.Occmap(:));
weight3 = weight1.*weight2./(weight1+weight2);
res_weight = weight3/nansum(weight3(:));

% Get correlations w/in sessions and between sessions
corr_1_2 = corr_bw_sessions(sesh1.frame_use,sesh2.frame_use,exclude);
corr_1_win = corr_bw_sessions(sesh1.frame_use_1st,sesh1.frame_use_2nd,exclude);
corr_2_win = corr_bw_sessions(sesh2.frame_use_1st,sesh2.frame_use_2nd,exclude);

corr_1_2_weighted_mean = nansum(res_weight(:).*corr_1_2(:));
corr_1_win_weighted_mean = nansum(res_weight(:).*corr_1_win(:));
corr_2_win_weighted_mean = nansum(res_weight(:).*corr_2_win(:));

% Shuffle each row of rate_map independently - is this legit?

[num_rows, num_cols] = size(sesh1.frame_use);
num_fields = num_rows*num_cols;

tic
disp('Now shuffling all entries in reverse place field cell variable.')
for k = 1:num_shuffles
   temp2_1 = cell(size(sesh1.frame_use)); 
   temp2_2 = cell(size(sesh1.frame_use));
   
   % Create shuffled indices
   shuffle2a = randperm(num_fields);
   shuffle2b = randperm(num_fields);
   
   % Create shuffled fields
   temp2_1(1:num_fields) = sesh1.frame_use(shuffle2a);
   temp2_2(1:num_fields) = sesh2.frame_use(shuffle2b);
   
   % Calculate correlation
   corr_1_2_allshuffle = corr_bw_sessions(temp2_1,temp2_2,exclude);
 
   weighted_mean_corr_shuffle_all(k) = nansum(res_weight(:).*corr_1_2_allshuffle(:));
   mean_corr_shuffle_all(k) = nanmean(corr_1_2_allshuffle(:));
   
   if round(k/10) == k/10
       disp([ num2str(k) ' shuffles out of ' num2str(num_shuffles) ' completed.'])
   end
    
end
toc

disp('Plotting stuff')
% Get histogram data for plotting

[nall, xall] = hist(weighted_mean_corr_shuffle_all);

% Plot out correlations by area of arena
h1 = figure; 
subplot(2,3,1); plot_occupancy_grid(sesh1.x, sesh1.y, sesh1.Xedges,...
    sesh1.Yedges); title('Session 1');
subplot(2,3,4); plot_occupancy_grid(sesh2.x, sesh2.y, sesh2.Xedges, ...
    sesh2.Yedges); 
title('Session 2');

subplot(2,3,2); imagesc_nan(corr_1_2); colorbar; title('Session 1 - Session 2'); cax(1,:) = caxis;
subplot(2,3,3); imagesc_nan(corr_1_win); colorbar; title('Within Session 1'); cax(2,:) = caxis;
subplot(2,3,5); imagesc_nan(corr_2_win); colorbar; title('Within Session 2'); cax(3,:) = caxis;
cmin = min(cax(:));
cmax = max(cax(:));

for j = [2 3 5]
    subplot(2,3,j); caxis([cmin cmax]);
end

% Plot all the shuffled data and real data
subplot(2,3,6);
plot(xall, nall, 'g--*');
ylimit = get(gca,'YLim');
hold on
plot([corr_1_2_weighted_mean corr_1_2_weighted_mean], ylimit,'k-',...
    [corr_1_win_weighted_mean corr_1_win_weighted_mean], ylimit, 'c-',...
    [corr_2_win_weighted_mean corr_2_win_weighted_mean], ylimit, 'm-')
legend('Shuffled corrs','1st-2nd weighted corr',...
    '1st w/in weighted corr', '2nd w/in weighted corr');
xlabel('Weighted Correlation Value'); ylabel('Count');
title('Histogram of shuffled correlations');

corrs.sesh1 = folder1;
corrs.sesh2 = folder2;
corrs.analysis_type = analysis_type;
corrs.rot_overwrite = rot_overwrite;
corrs.num_shuffles = num_shuffles;
corrs.exclude = exclude;
corrs.weight1 = weight1;
corrs.weight2 = weight2;
corrs.res_weight = res_weight;
corrs.corr_1_2 = corr_1_2;
corrs.corr_1_win = corr_1_win;
corrs.corr_2_win = corr_2_win;
corrs.corr_shuffle = weighted_mean_corr_shuffle_all;

% disp('Saving data')
% if strcmpi(movie_type,'ICmovie_smooth')
%     savename = ['corr' import_append '.mat'];
% elseif ~strcmpi(movie_type,'ICmovie_smooth')
%     savename = ['corr_' movie_type import_append '.mat'];
% end
% 
% save(savename, 'sesh1', 'sesh2', 'rot_overwrite', 'exclude', 'weight1', ...
%         'weight2', 'weight3', 'res_weight', 'corr_1_2', 'corr_1_win', 'corr_2_win',...
%         'weighted_mean_corr_shuffle_all', 'num_shuffles')

end
