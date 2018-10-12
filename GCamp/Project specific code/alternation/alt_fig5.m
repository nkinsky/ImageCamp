% Alternation Figure 5: Splitter Ontogeny

%% Plot for each mouse
save_pdf = false;
sigthresh = 3;
days_ba = 2;
free_only = true;
ignore_sameday = true;
norm_max = false;
daydiff_all = [];
dmean_all = [];
rmean_all = [];
alt_inds = [1 2 4 6]; % Use these groups of sessions in alt_all_cell_sp
for k = 1:length(alt_inds)
    j = alt_inds(k);
    [ relymat, deltamaxmat, sigmat, onsetsesh, days_aligned] = track_splitters(...
        alt_all_cell_sp{j}(1), alt_all_cell_sp{j}(2:end), sigthresh, days_ba, free_only, ...
        ignore_sameday, norm_max);
    if save_pdf
        printNK(['Splitter Ontogeny ba=' num2str(days_ba) ' days'],'alt', ...
            'append', true)
        close(gcf)
    end
    
    unique_daydiff = unique(days_aligned(~isnan(days_aligned)));
    dmean = arrayfun(@(a) nanmean(deltamaxmat(days_aligned == a)), ...
        unique_daydiff);
    rmean = arrayfun(@(a) nanmean(relymat(days_aligned == a)), ...
        unique_daydiff);
    
    daydiff_all = [daydiff_all; unique_daydiff];
    dmean_all = [dmean_all; dmean];
    rmean_all = [rmean_all; rmean];
end

% scatterBox of rmean_all and dmean_all reveals that these two metrics
% clearly stay higher after splitting than before...now figure out a good
% way to demonstrate this... maybe do scatterBox for +/- 1 day and +/- 7
% days
%% Adjust below to do 1-3, 4-6, 7-9, etc.
day_lims = [1 2];
good_bool = abs(daydiff_all) <= day_lims(2) & abs(daydiff_all) >= day_lims(1)...
    | daydiff_all == 0;
dayba = daydiff_all(good_bool);
dayba(dayba <= -day_lims(1) & dayba >= -day_lims(2)) = -1; 
dayba(dayba >= day_lims(1) & dayba <= day_lims(2)) = 1;
dmean_plot = dmean_all(good_bool);
rmean_plot = rmean_all(good_bool);
figure; set(gcf,'Position', [220 260 1030 690])
hd = subplot(2,2,1); hr = subplot(2,2,3);
xlab = {['-' num2str(day_lims(2)) ' to -' num2str(day_lims(1))], '0', ...
    [num2str(day_lims(1)) ' to ' num2str(day_lims(2))]};
scatterBox(dmean_plot, dayba, 'xLabels', xlab, 'yLabel', '\Deltacurve_{mean}',...
    'h', hd)
xlabel('Days from splitting onset')
title('All Mice means')

scatterBox(rmean_plot, dayba, 'xLabels', xlab, 'yLabel', 'rely_{mean} (1-p)',...
    'h', hr)
xlabel('Days from splitting onset')
title('All Mice means')

% add in stats
[pkwd, ~, statsd] = kruskalwallis(dmean_plot, dayba, 'off');
cmatd = multcompare(stats,'display','off');
subplot(2,2,2)
text(0.1, 0.65, 'g1   g2   pval')
text(0.1, 0.5, num2str(cmatd(:,[1 2 6]), '%0.2g \t'))
text(0.1, 0.9, ['pkw = ' num2str(pkwd, '%0.2g')])
axis off

% add in stats
[pkwr, ~, statsr] = kruskalwallis(dmean_plot, dayba, 'off');
cmatr = multcompare(statsr,'display','off');
subplot(2,2,4)
text(0.1, 0.65, 'g1   g2   pval')
text(0.1, 0.5, num2str(cmatr(:,[1 2 6]), '%0.2g \t'))
text(0.1, 0.9, ['pkw = ' num2str(pkwr, '%0.2g')])
axis off


