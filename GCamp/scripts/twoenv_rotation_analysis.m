% Day 4 arena rotation analysis

corr_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\corr_ChangeMovie.mat';

load(corr_file);

file1 = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\reverse_placefields_ChangeMovie_no_rotate.mat';
file2 = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working\reverse_placefields_ChangeMovie_no_rotate.mat';
% file1 = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\reverse_placefields_ChangeMovie_no_rotate.mat';
% file2 = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\reverse_placefields_ChangeMovie_no_rotate.mat';

rot = [0 90 180 270];

for j = 1:4
    corr_rot{j} = rvp_bw_session_rotate(file1, file2, rot(j));
end

%% 
figure
for j = 1:4
    subplot(2,3,j)
    imagesc(corr_rot{j}); colorbar; cax(j,:) = caxis;
    title([num2str(rot(j)) ' Degrees Rotation'])
    corr_rot_mean(j) = nanmean(corr_rot{j}(:));
end
cmin = min(cax(:)); cmax = max(cax(:));
for j = 1:4
    subplot(2,3,j); caxis([cmin cmax]);
end

%% Plot rotated data on top of shuffled data
[nrows_1 xrows_1] = hist(weighted_mean_corr_shuffle_rows);
[nrows_2 xrows_2] = hist(weighted_mean_corr_shuffle_rows2);
[nall xall] = hist(weighted_mean_corr_shuffle_all);

% Plot all the shuffled data and real data
subplot(2,3,5)
plot(xrows_1, nrows_1,'b:*', xrows_2, nrows_2, 'r-.*', xall, nall, 'g--*');
ylimit = get(gca,'YLim');
hold on
plot([corr_rot_mean(1) corr_rot_mean(1)], ylimit,'k-',...
    [corr_rot_mean(2) corr_rot_mean(2)], ylimit, 'c-',...
    [corr_rot_mean(3) corr_rot_mean(3)], ylimit, 'm-',...
    [corr_rot_mean(4) corr_rot_mean(4)],ylimit,'y-')
legend('Row shuffle 1','Row shuffle 2','All shuffle','No rotation',...
    '90 degree rotation', '180 degree rotation', '-90 degree rotation');
xlabel('Weighted Correlation Value'); ylabel('Count');
title('Rotation Analysis');
