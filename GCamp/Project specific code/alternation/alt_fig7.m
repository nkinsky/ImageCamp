% Alternation figure 7

%% Run alt_fig6 bottom sections first - gets you splitter and PF onsets!

%% Get stats for G45_1st half and group data for Figure
[h45, p45] = kstest2(pc_onset_bymouse{3}, split_onset_bymouse{3},...
    'tail','larger');

[hall, pall] = kstest2(cat(1,pc_onset_bymouse{:}), cat(1,split_onset_bymouse{:}),...
    'tail', 'larger');

[~, pchi45, statschi45] = chi2gof(pc_onset_bymouse{3} - ...
    split_onset_bymouse{3})
diff45med = nanmedian(split_onset_bymouse{3} - pc_onset_bymouse{3})
diff45mean = nanmean(split_onset_bymouse{3} - pc_onset_bymouse{3})

[~, pchiall, statschiall] = chi2gof(cat(1,pc_onset_bymouse{:}) - ...
    cat(1,split_onset_bymouse{:}))
alldiffmed = nanmedian(cat(1,split_onset_bymouse{:}) - ...
    cat(1,pc_onset_bymouse{:}))
alldiffmean = nanmean(cat(1,split_onset_bymouse{:}) - ...
    cat(1,pc_onset_bymouse{:}))