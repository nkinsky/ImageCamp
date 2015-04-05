% plot to compare correlations at different grid sizes and with/without
% rotation

%% File locations
directory = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\';

rotation(1).file = 'corrs_cmperbin5_smooth.mat';
rotation(2).file = 'corrs_cmperbin2_smooth.mat';
rotation(3).file = 'corrs_cmperbin1_smooth.mat';
rotation(4).file = 'corrs_cmperbin5_no_rotate_smooth.mat';
rotation(5).file = 'corrs_cmperbin2_no_rotate_smooth.mat';

[rotation(1:3).rotation] = deal('Rotated');
[rotation(4:5).rotation] = deal('Not Rotated');

grid_sizes = [5.3 2.3 1.2 5.3 2.3];

%% Import Data
corrs = importdata([directory rotation(1).file]);
for j = 2:5
    corrs(j) = importdata([directory rotation(j).file]);
end
   
%% Calculate mean values
for j = 1:5
    sesh(j).bw = nanmean(corrs(j).corr_1_2(:)); % between
    bw(1,j) = sesh(j).bw;
    sesh(j).win1 = nanmean(corrs(j).corr_1_win(:)); % win sesh1
    win1(1,j) = sesh(j).win1;
    sesh(j).win2 = nanmean(corrs(j).corr_2_win(:)); % win sesh2
    win2(1,j) = sesh(j).win2;
    sesh(j).shuffle_mean = mean(corrs(j).corr_shuffle(:)); % mean shuffled
    shuffle_mean(j) = sesh(j).shuffle_mean;
    sesh(j).shuffle_var = std(corrs(j).corr_shuffle(:)); % std shuffled
    shuffle_var(j) = sesh(j).shuffle_var;
end


%% Plot stuff
figure;
for j = 1:5
    subplot(2,3,j)
    imagesc_nan(corrs(j).corr_1_2); colorbar; cax(:,j) = caxis;
    title([num2str(grid_sizes(j)) 'cm grid size ' rotation(j).rotation]);
end

cmax = max(cax(:)); cmin = min(cax(:));
for j = 1:5
   subplot(2,3,j)
   caxis([cmin cmax]);
end

subplot(2,3,6)
plot(grid_sizes(1:3), bw(1:3),'k*-', grid_sizes(4:5), bw(4:5), 'b*-', ...
    grid_sizes(1:3), win1(1:3), 'g*--', grid_sizes(1:3), win2(1:3), 'y*--') %,...
    % grid_sizes(1:3), shuffle_mean(1:3), 'k--');
hold on
errorbar(grid_sizes(1:3), shuffle_mean(1:3), shuffle_mean(1:3) - shuffle_var(1:3), ...
    shuffle_mean(1:3) + shuffle_var(1:3),'r*--')
hold off
legend('Between rotated sessions', 'Between sessions no rotation', ...
    'Within session 1', 'Within session 2', 'Shuffled Data Mean ')
xlabel('Grid size (cm)'); ylabel('Mean Correlation Value');




