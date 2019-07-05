% Alternation - track 1st trial splitting across all sessions

sesh_use = G48_alt(G48_forced_bool);
% sesh_use = alt_all(alt_all_free_bool);
binthresh = 3;

% Run through analysis for all sessions in sesh_use above
firsttrial_corr_all = []; othertrial_corr_all = []; other_mean_all = [];
firsttrial_PVcorr_all = []; othertrial_PVcorr_all = []; other_PVmean_all = [];
for j = 1:length(sesh_use)
    [firstturn_corr, otherturn_corr, PVcorr_firstturn, PVcorr_otherturn] ...
        = alt_first_trial_split(sesh_use(j), binthresh, false);
    
    firsttrial_corr_all = cat(2, firsttrial_corr_all, nanmean(firstturn_corr(:,1)));
    othertrial_corr_all = cat(2, othertrial_corr_all, [nanmean(firstturn_corr(:,2:end)),...
        nanmean(otherturn_corr)]);
    other_mean_all = cat(2, other_mean_all, nanmean([nanmean(firstturn_corr(:,2:end)),...
        nanmean(otherturn_corr)]));
    
    firsttrial_PVcorr_all = cat(2, firsttrial_PVcorr_all, PVcorr_firstturn(1));
    othertrial_PVcorr_all = cat(2, othertrial_PVcorr_all, PVcorr_firstturn(2:end),...
        PVcorr_otherturn);
    other_PVmean_all = cat(2, other_PVmean_all, ...
        nanmean(cat(2, PVcorr_firstturn(2:end),PVcorr_otherturn)));
    
end

%% Plot it out!
figure;
set(gcf, 'Position', [1950 200 1710 740])
subplot(2,3,1)
hf = histogram(firsttrial_corr_all,0:0.05:1,'Normalization','Probability');
hold on
hother = histogram(othertrial_corr_all,0:0.05:1,'Normalization','Probability');
legend(cat(2, hf, hother),{'First Trial','Other Trials'})
xlabel('Spearman''s \rho')
ylabel('Probability')
title('Single Cell Trial-by-Trial Corrs with Tuning Curve')
make_plot_pretty(gca);

subplot(2,3,2);
hf = histogram(firsttrial_PVcorr_all,0:0.05:1,'Normalization','Probability');
hold on
hother = histogram(othertrial_PVcorr_all,0:0.05:1,'Normalization','Probability');
legend(cat(2, hf, hother),{'First Trial','Other Trials'})
xlabel('Spearman''s \rho')
ylabel('Probability')
title('PV Trial-by-Trial Corrs with Tuning Curve')
make_plot_pretty(gca);

subplot(2,3,3)
[~, pks] = kstest2(firsttrial_corr_all, othertrial_corr_all, 'tail', 'larger');
[~, pksPV] = kstest2(firsttrial_PVcorr_all, other_PVmean_all, 'tail', 'larger');
text(0.1, 0.5, ['Single Cell p_{ks,1 sided} = ' num2str(pks, '%0.2g')])
text(0.1, 0.3, ['PV p_{ks,1 sided} = ' num2str(pksPV, '%0.2g')])
axis off

subplot(2,3,4)
h1 = plot([1 2], [firsttrial_corr_all' other_mean_all'], 'ko-');
arrayfun(@(a) set(a,'XData',a.XData + 0.05*randn(1,2)), h1); % Jitter X points
xlim([0.5 2.5])
ylabel('\rho_{mean} (Spearman)')
xlabel('Trial Type')
title('Single Cells')
set(gca,'XTick', [1 2], 'XTickLabel', {'First', 'Other'})

subplot(2,3,5)
hPV = plot([1 2], [firsttrial_PVcorr_all' other_PVmean_all'], 'ko-');
arrayfun(@(a) set(a,'XData',a.XData + 0.05*randn(1,2)), hPV); % Jitter X points
xlim([0.5 2.5])
ylabel('\rho_{mean} (Spearman)')
xlabel('Trial Type')
title('PV')
set(gca,'XTick', [1 2], 'XTickLabel', {'First', 'Other'})

subplot(2,3,6)
psr = signrank(firsttrial_corr_all, other_mean_all,'tail','left');
psrPV = signrank(firsttrial_PVcorr_all, other_PVmean_all);
text(0.1, 0.5, ['Single cell p_{signrank,1 sided} = ' num2str(psr, '%0.2g')])
text(0.1, 0.3, ['PV p_{signrank,1 sided} = ' num2str(psrPV, '%0.2g')])
axis off

%% Look at tuning curve correlations between individual sessions across the stem
% Seems like they are pretty consistent across the whole stem...
stem_corrs_fall = []; stem_corrs_oall = [];
for j = 1:length(sesh_use)
    [firstturn_stem_corrs, otherturn_stem_corrs] = ...
        alt_stem_split_corrs(sesh_use(j), binthresh);
    if j == 1
        stem_size = [1, size(firstturn_stem_corrs,2)];
    end
    stem_corrs_fall = cat(1, stem_corrs_fall, ...
        resize(nanmean(firstturn_stem_corrs), stem_size)); % reshape each array to match the first one - accounts for slight differences in stem bounds between sessions
    stem_corrs_oall = cat(1, stem_corrs_oall, ...
        resize(nanmean(otherturn_stem_corrs), stem_size));
    
end




