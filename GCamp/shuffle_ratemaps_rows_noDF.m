% Shuffle sessions - this file does it based on the non-DF
% reverse-placefield data

% To do for day 4 comparison
% -2) Do PreProcessMousePosition for octagon sessions...
% -1) Figure out how to scale and rotate arenas appropriately to deal with
% lens distortion - maybe, rather than scaling, we set the grid size we
% want and define Xedges and Yedges based on that - would set different
% cmperbin each way
% 0) double check that "exclude" is appropriate ...
% 1) Compare occupancy maps for each session and see if/where low and high correlations occur 
% 1.5) Velocity threshold reverse_placefield... AND set minimum occupancy,
% don't want a bin that he only runs through once to be included...
% 1.7) Get binning the same - right now we have terrible overlap, e.g. the
% top row in sesh1 has almost no occupancy... need to use Dave style
% cut-offs for xmin and xmax
% 2) Compare to day 1...do we see good correlations between session 1 and
% session 2 there?
% 3) Look at an octagon sessions maybe?
% 4) Look at day 7 maybe?  Do we see the same trend?
% 5) 

close all
clear all

%% Important Variables to tweak

day = 2; % Day to analyze
movie_type = 'ChangeMovie'; % flag to ID if you want to look at ICmovie data or ChangeMovie data
rot_overwrite = 0; % 1 if you wish to analyze data for which a rotation has been intentionally NOT applied

%% List of session working directories..
sesh1list{1} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\';
sesh2list{1} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\2 - 2env square mid 201B\Working\';
sesh1list{2} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\1 - 2env octagon left\Working\';
sesh2list{2} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Working\';
sesh1list{4} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\';
sesh2list{4} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\';

%% Import stuff

if rot_overwrite == 1
    import_append = '_no_rotate';
elseif rot_overwrite == 0
    import_append ='';
end

disp('Loading .mat files')
if strcmpi(movie_type,'ICmovie_smooth')
    import_file = ['reverse_placefields' import_append '.mat'];
elseif strcmpi(movie_type,'ChangeMovie')
    import_file = [ 'reverse_placefields_ChangeMovie' import_append '.mat'];
end
sesh1 = importdata([ sesh1list{day} import_file]);
sesh2 = importdata([ sesh2list{day} import_file]);

image_xpix = size(sesh1.AvgFrame{1},2);
image_ypix = size(sesh1.AvgFrame{1},1);

%% Select region to exclude (in this case, where we get traveling waves)
x_exclude = 325:image_xpix; % in pixels
y_exclude = 300:image_ypix;
exclude = zeros(size(sesh1.AvgFrame{1}));
exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));

%% Calculate it out
% Get resistor weighted occupancy
weight1 = sesh1.Occmap/nansum(sesh1.Occmap(:));
weight2 = sesh2.Occmap/nansum(sesh2.Occmap(:));
weight3 = weight1.*weight2./(weight1+weight2);
res_weight = weight3/nansum(weight3(:));

% Get correlations w/in sessions and between sessions
corr_1_2 = corr_bw_sessions(sesh1.AvgFrame,sesh2.AvgFrame,exclude);
corr_1_win = corr_bw_sessions(sesh1.AvgFrame_1st,sesh1.AvgFrame_2nd,exclude);
corr_2_win = corr_bw_sessions(sesh2.AvgFrame_1st,sesh2.AvgFrame_2nd,exclude);

corr_1_2_weighted_mean = nansum(res_weight(:).*corr_1_2(:));
corr_1_win_weighted_mean = nansum(res_weight(:).*corr_1_win(:));
corr_2_win_weighted_mean = nansum(res_weight(:).*corr_2_win(:));

% Shuffle each row of rate_map independently - is this legit?

[num_rows, num_cols] = size(sesh1.AvgFrame);
num_fields = num_rows*num_cols;

tic
disp('Now shuffling each row of the reverse place field');
num_shuffles = 100;
for k = 1:num_shuffles
    temp1 = cell(size(sesh1.AvgFrame));
    
    
     for i = 1:num_rows
        shuffle1a = randperm(num_cols);
        shuffle1b = randperm(num_cols);
        for j = 1:num_cols
            temp1_1{i,j} = sesh1.AvgFrame{i,shuffle1a(j)};
            temp1_2{i,j} = sesh2.AvgFrame{i,shuffle1b(j)};
        end
    end
    
    corr_1_2_rowshuffle = corr_bw_sessions(temp1_1,sesh2.AvgFrame,exclude); % Shuffle only sesh1
    corr_1_2_rowshuffle2 = corr_bw_sessions(temp1_1,temp1_2,exclude); % Shuffle both sesh1 and sesh2
    
    weighted_mean_corr_shuffle_rows(k) = nansum(res_weight(:).*corr_1_2_rowshuffle(:));
    mean_corr_shuffle_rows(k) = nanmean(corr_1_2_rowshuffle(:));
    weighted_mean_corr_shuffle_rows2(k) = nansum(res_weight(:).*corr_1_2_rowshuffle2(:));
    mean_corr_shuffle_rows2(k) = nanmean(corr_1_2_rowshuffle2(:));
    
    if round(k/10) == k/10
        disp([ num2str(k) ' row shuffles out of ' num2str(num_shuffles) ' completed.'])
    end

end
toc

tic
disp('Now shuffling all entries in reverse place field cell variable.')
for k = 1:num_shuffles
   temp2_1 = cell(size(sesh1.AvgFrame)); 
   temp2_2 = cell(size(sesh1.AvgFrame));
   
   % Create shuffled indices
   shuffle2a = randperm(num_fields);
   shuffle2b = randperm(num_fields);
   
   % Create shuffled fields
   temp2_1(1:num_fields) = sesh1.AvgFrame(shuffle2a);
   temp2_2(1:num_fields) = sesh2.AvgFrame(shuffle2b);
   
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

[nrows_1 xrows_1] = hist(weighted_mean_corr_shuffle_rows);
[nrows_2 xrows_2] = hist(weighted_mean_corr_shuffle_rows2);
[nall xall] = hist(weighted_mean_corr_shuffle_all);

% Plot all the shuffled data and real data
figure
plot(xrows_1, nrows_1,'b:*', xrows_2, nrows_2, 'r-.*', xall, nall, 'g--*');
ylimit = get(gca,'YLim');
hold on
plot([corr_1_2_weighted_mean corr_1_2_weighted_mean], ylimit,'k-',...
    [corr_1_win_weighted_mean corr_1_win_weighted_mean], ylimit, 'c-',...
    [corr_2_win_weighted_mean corr_2_win_weighted_mean], ylimit, 'm-')
legend('Row shuffle 1','Row shuffle 2','All shuffle','1st-2nd weighted corr',...
    '1st w/in weighted corr', '2nd w/in weighted corr');
xlabel('Weighted Correlation Value'); ylabel('Count');
title('Histogram of shuffled correlations');

% Plot out correlations by area of arena
figure; 
subplot(2,3,1); plot_occupancy_grid(sesh1.x, sesh1.y, sesh1.Xedges,...
    sesh1.Yedges); title('Session 1');
subplot(2,3,4); plot_occupancy_grid(sesh2.x, sesh2.y, sesh2.Xedges, ...
    sesh2.Yedges); 
title('Session 2');

subplot(2,3,2); imagesc(corr_1_2); colorbar; title('Session 1 - Session 2'); cax(1,:) = caxis;
subplot(2,3,3); imagesc(corr_1_win); colorbar; title('Within Session 1'); cax(2,:) = caxis;
subplot(2,3,5); imagesc(corr_2_win); colorbar; title('Within Session 2'); cax(3,:) = caxis;
subplot(2,3,6); imagesc(sesh1.Occmap + sesh2.Occmap); colorbar; title('Occmap1 + Occmap2');

cmin = min(cax(:));
cmax = max(cax(:));

for j = [2 3 5]
    subplot(2,3,j); caxis([cmin cmax]);
end

disp('Saving data')
if strcmpi(movie_type,'ICmovie_smooth')
    savename = ['corr' import_append '_noDF.mat'];
elseif ~strcmpi(movie_type,'ICmovie_smooth')
    savename = ['corr_' movie_type import_append '_noDF.mat'];
end
 save(savename, 'sesh1', 'sesh2', 'exclude', 'weight1', ...
        'weight2', 'weight3', 'res_weight', 'corr_1_2', 'corr_1_win', 'corr_2_win',...
        'weighted_mean_corr_shuffle_rows', 'weighted_mean_corr_shuffle_rows2', ...
        'weighted_mean_corr_shuffle_all')

clear temp1 temp2

