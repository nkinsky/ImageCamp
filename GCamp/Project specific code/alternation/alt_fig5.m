% Alternation Figure 5: Splitter Ontogeny

%% Example Ontogeny Scenarios Plot
figure; set(gcf,'Position',[34 200 1020 425]);
curve = 0.02*randn(2,50);
for j = 1:5
    if j == 2 || j == 3
        curve(1,20:30) = curve(1,20:30) + 0.2;
    elseif j == 4 || j == 5
        curve(1,20:30) = curve(1,20:30) - 0.2;
    end
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,j);
    plot_smooth_curve(curve,ha);
end

for j = 1:5
    if j == 3
        curve(1,20:30) = curve(1,20:30) + 0.4;
    elseif j == 4 
        curve(1,20:30) = curve(1,20:30) - 0.4;
    end
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,5+j);
    plot_smooth_curve(curve,ha);
end

for j = 1:5
    if j == 3
        curve(1,20:30) = curve(1,20:30) + 0.4;
    elseif j == 4
        curve(1,20:30) = curve(1,20:30) - 0.15;
    end
    curve(2,:) = circshift(curve(2,:),10);
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,10+j);
    plot_smooth_curve(curve,ha);
end

%% Plot for each mouse
save_pdf = false;
sigthresh = 3;
days_ba = 9;
free_only = true;
ignore_sameday = true;
norm_max = false;
nactive_thresh = 5; % Neurons must be active at least this many trials to be considered
daydiff_all = [];
dmean_all = [];
dnormmean_all = [];
rmean_all = [];
alt_inds = [1 2 3 4 5 6]; % Use these groups of sessions in alt_all_cell_sp - need
% to figure out how to combine G45 1st and 2nd half and G48 1st and 2nd
% half
clear rmean_half1 rmean_half2 dmean_half1 dmean_half2
for k = 1:length(alt_inds)
    j = alt_inds(k);
    [ relymat, deltamaxmat, sigmat, onsetsesh, days_aligned, ~, ~, ...
        deltamax_normmat] = track_splitters(alt_all_cell_sp{j}(1), ...
        alt_all_cell_sp{j}(2:end), sigthresh, days_ba, free_only, ...
        ignore_sameday, norm_max, nactive_thresh);
    if save_pdf
        printNK(['Splitter Ontogeny ba=' num2str(days_ba) ' days'],'alt', ...
            'append', true)
        close(gcf)
    end
    
    unique_daydiff = unique(days_aligned(~isnan(days_aligned)));
    dmean = arrayfun(@(a) nanmean(deltamaxmat(days_aligned == a)), ...
        unique_daydiff);
    dnorm_mean = arrayfun(@(a) nanmean(deltamax_normmat(days_aligned == a)), ...
        unique_daydiff);
    rmean = arrayfun(@(a) nanmean(relymat(days_aligned == a)), ...
        unique_daydiff);
    if j == 3 || j == 5
        rmean_half1 = rmean;
        dmean_half1 = dmean;
        dnmean_half1 = dnorm_mean;
        daydiff1 = unique_daydiff;
    elseif j == 4 || j == 6
        rmean_half2 = rmean;
        dmean_half2 = dmean;
        dnmean_half2 = dnorm_mean;
        daydiff2 = unique_daydiff;
        
        % Get averages of both halves
        dmean_comb = [dmean_half1; dmean_half2];
        dnmean_comb = [dnmean_half1; dnmean_half2];
        rmean_comb = [rmean_half1; rmean_half2];
        daydiff_comb = [daydiff1; daydiff2];
        
        unique_daydiff = unique([daydiff1; daydiff2]);
        dmean = arrayfun(@(a) nanmean(dmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        dnorm_mean = arrayfun(@(a) nanmean(dnmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        rmean = arrayfun(@(a) nanmean(rmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        
        clear rmean_half1 rmean_half2 dmean_half1 dmean_half2
    end
    
%     disp(['size ddiff = ' num2str(length(unique_daydiff)), 'size dmean = ' ...
%         num2str(length(dmean))])
    daydiff_all = [daydiff_all; unique_daydiff];
    dmean_all = [dmean_all; dmean];
    dnormmean_all = [dnormmean_all; dnorm_mean];
    rmean_all = [rmean_all; rmean];
end

% scatterBox of rmean_all and dmean_all reveals that these two metrics
% clearly stay higher after splitting than before...now figure out a good
% way to demonstrate this... maybe do scatterBox for +/- 1 day and +/- 7
% days

%% Splitter Ontogeny Population plots with smoothed windows before/after
day_groups = 5;
split_ontogeny_plot(rmean_all, daydiff_all, day_groups, 'ylabel', ...
    'reliability(1-p)_{mean}', 'max_day', 9)
printNK('Splitter Ontogeny - Reliability All mice means 3 day groups 9 day max', 'alt')
split_ontogeny_plot(dmean_all, daydiff_all, day_groups, 'ylabel', ...
    '\Deltamax_{mean}', 'max_day', 9)
printNK('Splitter Ontogeny - Deltamax All mice means 3 day groups 9 day max', 'alt')
split_ontogeny_plot(dnormmean_all, daydiff_all, day_groups, 'ylabel', ...
    '\Deltamax_{mean}_{norm}', 'max_day', 9)
printNK('Splitter Ontogeny - Deltamax_norm All mice means 3 day groups 9 day max', 'alt')

%% Adjust below to do 1-3, 4-6, 7-9, etc. - OLD hacked method - above is better
% day_lims = [1 3];
% good_bool = abs(daydiff_all) <= day_lims(2) & abs(daydiff_all) >= day_lims(1)...
%     | daydiff_all == 0;
% dayba = daydiff_all(good_bool);
% dayba(dayba <= -day_lims(1) & dayba >= -day_lims(2)) = -1; 
% dayba(dayba >= day_lims(1) & dayba <= day_lims(2)) = 1;
% dmean_plot = dmean_all(good_bool);
% rmean_plot = rmean_all(good_bool);
% figure; set(gcf,'Position', [220 260 1030 690])
% hd = subplot(2,2,1); hr = subplot(2,2,3);
% xlab = {['-' num2str(day_lims(2)) ' to -' num2str(day_lims(1))], '0', ...
%     [num2str(day_lims(1)) ' to ' num2str(day_lims(2))]};
% scatterBox(dmean_plot, dayba, 'xLabels', xlab, 'yLabel', '\Deltacurve_{mean}',...
%     'h', hd);
% xlabel('Days from splitting onset')
% title('All Mice means')
% 
% scatterBox(rmean_plot, dayba, 'xLabels', xlab, 'yLabel', 'rely_{mean} (1-p)',...
%     'h', hr);
% xlabel('Days from splitting onset')
% title('All Mice means')
% 
% % add in stats
% [pkwd, ~, statsd] = kruskalwallis(dmean_plot, dayba, 'off');
% cmatd = multcompare(statsd,'display','off');
% subplot(2,2,2)
% text(0.1, 0.65, 'g1   g2   pval')
% text(0.1, 0.5, num2str(cmatd(:,[1 2 6]), '%0.2g \t'))
% text(0.1, 0.9, ['pkw = ' num2str(pkwd, '%0.2g')])
% axis off
% 
% % add in stats
% [pkwr, ~, statsr] = kruskalwallis(rmean_plot, dayba, 'off');
% cmatr = multcompare(statsr,'display','off');
% subplot(2,2,4)
% text(0.1, 0.65, 'g1   g2   pval')
% text(0.1, 0.5, num2str(cmatr(:,[1 2 6]), '%0.2g \t'))
% text(0.1, 0.9, ['pkw = ' num2str(pkwr, '%0.2g')])
% axis off


