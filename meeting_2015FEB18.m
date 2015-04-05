% Plot - 1) & 4) show occupancy for session1 and session 2 with one area
% highlighted
% 2) & 5 show reverse placefield for those two sessions
% 3) show overall sesh1 to sesh2 correlation matrix
% 6) show shuffle plots
% Rat stuff - show video - raw and DF

close all

if ~exist('xall','var')
    load corr.mat
else
end

% Prep Reverse-Place Fields
sesh1_plot = zeros(size(sesh1.AvgFrame_DF{2,2}));
sesh1_plot(~exclude) = sesh1.AvgFrame_DF{2,2}(~exclude);
sesh2_plot = zeros(size(sesh2.AvgFrame_DF{2,2}));
sesh2_plot(~exclude) = sesh2.AvgFrame_DF{2,2}(~exclude);

figure(10); 
subplot(2,3,1); plot_occupancy_grid(sesh1.x, sesh1.y, sesh1.Xedges,...
    sesh1.Yedges); title('Session 1');
hold on; plot([sesh1.Xedges(2) sesh1.Xedges(2) sesh1.Xedges(3) sesh1.Xedges(3)], ...
    [sesh1.Yedges(3) sesh1.Yedges(2) sesh1.Yedges(2) sesh1.Yedges(3)],'k*-') 
subplot(2,3,4); plot_occupancy_grid(sesh2.x, sesh2.y, sesh2.Xedges, ...
    sesh2.Yedges); 
hold on; plot([sesh2.Xedges(2) sesh2.Xedges(2) sesh2.Xedges(3) sesh2.Xedges(3)], ...
    [sesh2.Yedges(3) sesh2.Yedges(2) sesh2.Yedges(2) sesh2.Yedges(3)],'k*-')
title('Session 2');
subplot(2,3,2); imagesc_gray(sesh1_plot); title('Session 1'); cax1(1,:) = caxis;
subplot(2,3,5); imagesc_gray(sesh2_plot); title('Session 2'); cax1(2,:) = caxis;
subplot(2,3,3); imagesc(corr_1_2); title('Session 1 to Session 2 correlations');...
    colorbar

cmin1 = min(cax1(:)); cmax1 = max(cax1(:));
subplot(2,3,2); caxis(gca, [cmin1 cmax1])
subplot(2,3,5); caxis(gca, [cmin1 cmax1])

subplot(2,3,6); 
plot(xall, nall, 'g--*');
ylimit = get(gca,'YLim');
hold on
plot([corr_1_2_weighted_mean corr_1_2_weighted_mean], ylimit,'k-') %,...
%     [corr_1_win_weighted_mean corr_1_win_weighted_mean], ylimit, 'c-',...
%     [corr_2_win_weighted_mean corr_2_win_weighted_mean], ylimit, 'm-')
legend('Shuffled Data','1st-2nd session weighted corr');
xlabel('Weighted Correlation Value'); ylabel('Count');
title('Histogram of shuffled correlations');

NumXBins = 7; NumYBins = 7;
figure(11)
n = 1;
for i = 1:NumYBins
    for j = 1:NumXBins
        subplot(NumYBins,NumXBins,(i-1)*NumXBins+j)
        temp_plot = zeros(size(sesh1.AvgFrame_DF{1,1}));
        temp_plot(~exclude) = sesh1.AvgFrame_DF{i,j}(~exclude);
        imagesc(temp_plot); colormap(gray); colorbar; cax2(n,:) = caxis;
        
    end
end

% cmin2 = min(cax2(:)); cmax2 = max(cax2(:));
% for i = 1:NumYBins
%     for j = 1:NumXBins
%         subplot(NumYBins,NumXBins,(i-1)*NumXBins+j)
%         caxis([cmin2 cmax2])
%     end
% end


%% Reverse Place-field description
avi_path = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\Raw.AVI';
figure(12)

subplot(2,2,1) % Mouse picture
vidObj = VideoReader(avi_path);
vidObj.CurrentTime = 18;
vidFrame = readFrame(vidObj);
image(flipud(vidFrame)); set(gca,'YDir','normal')

subplot(2,2,2);
image(flipud(vidFrame)); set(gca,'YDir','normal'); hold on; 
plot_occupancy_grid(sesh1.x/0.15*.6246, sesh1.y/0.15*.6246,...
    sesh1.Xedges/0.15*.6246, sesh1.Yedges/0.15*.6246);
xlim([85 300]); ylim([50 275])
hold on; plot([sesh1.Xedges(2) sesh1.Xedges(2) ...
    sesh1.Xedges(3) sesh1.Xedges(3)]/0.15*.6246, ...
    [sesh1.Yedges(3) sesh1.Yedges(2) sesh1.Yedges(2) sesh1.Yedges(3)]/0.15*.6246,'k*-')

subplot(2,2,3); 
temp3_plot = zeros(size(sesh1.AvgFrame_DF{2,2}));
temp3_plot(~exclude) = sesh1.AvgFrame_DF{2,2}(~exclude);
imagesc_gray(temp3_plot); title('Reverse Place-field')

%%
figure(13)

subplot(2,2,1) % Mouse picture
vidObj = VideoReader(avi_path);
vidObj.CurrentTime = 18;
vidFrame = readFrame(vidObj);
image(flipud(vidFrame)); set(gca,'YDir','normal')

subplot(2,2,2);
image(flipud(vidFrame)); set(gca,'YDir','normal'); hold on; 
plot_occupancy_grid(sesh1.x/0.15*.6246, sesh1.y/0.15*.6246,...
    sesh1.Xedges/0.15*.6246, sesh1.Yedges/0.15*.6246);
xlim([85 300]); ylim([50 275])
hold on; plot([sesh1.Xedges(2) sesh1.Xedges(2) ...
    sesh1.Xedges(3) sesh1.Xedges(3)]/0.15*.6246, ...
    [sesh1.Yedges(3) sesh1.Yedges(2) sesh1.Yedges(2) sesh1.Yedges(3)]/0.15*.6246,'k*-')

subplot(2,2,3); 
temp3_plot = zeros(size(sesh1.AvgFrame{2,2}));
temp3_plot(~exclude) = sesh1.AvgFrame{2,2}(~exclude);
imagesc_gray(temp3_plot); title('Reverse Place-field ')

subplot(2,2,4); 
temp3_plot = zeros(size(sesh1.AvgFrame_DF{2,2}));
temp3_plot(~exclude) = sesh1.AvgFrame_DF{2,2}(~exclude);
imagesc_gray(temp3_plot); title('DF Reverse Place-field ')

%%
figure(14)

subplot(2,2,1);
image(flipud(vidFrame)); set(gca,'YDir','normal'); hold on; 
plot_occupancy_grid(sesh1.x/0.15*.6246, sesh1.y/0.15*.6246,...
    sesh1.Xedges/0.15*.6246, sesh1.Yedges/0.15*.6246);
xlim([50 350]); ylim([25 325])
hold on; plot([sesh1.Xedges(2) sesh1.Xedges(2) ...
    sesh1.Xedges(3) sesh1.Xedges(3)]/0.15*.6246, ...
    [sesh1.Yedges(3) sesh1.Yedges(2) sesh1.Yedges(2) sesh1.Yedges(3)]/0.15*.6246,'k*-')

subplot(2,2,2)
imagesc_gray(sesh1.F0); title('Average Projection')

subplot(2,2,3); 
temp3_plot = zeros(size(sesh1.AvgFrame{2,2}));
temp3_plot(~exclude) = sesh1.AvgFrame{2,2}(~exclude);
imagesc_gray(temp3_plot); title('Reverse Place-field ')

subplot(2,2,4); 
temp3_plot = zeros(size(sesh1.AvgFrame_DF{2,2}));
temp3_plot(~exclude) = sesh1.AvgFrame_DF{2,2}(~exclude);
imagesc_gray(temp3_plot); title('DF Reverse Place-field ')

%% 
figure(15)
subplot(2,2,1)
imagesc_gray(image_exclude(sesh1.AvgFrame_DF{7,1},exclude))
subplot(2,2,2)
imagesc_gray(image_exclude(sesh1.AvgFrame_DF{7,7},exclude))
subplot(2,2,3)
imagesc_gray(image_exclude(sesh1.AvgFrame_DF{1,1},exclude))
subplot(2,2,4)
imagesc_gray(image_exclude(sesh1.AvgFrame_DF{1,6},exclude))
set_same_clim(15,[2 2],[1:4])




