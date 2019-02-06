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
split_onset_bymouse = cell(1,6);
% alt_inds = [1 2 3 4 5 6]; % Use these groups of sessions in alt_all_cell_sp - need
clear rmean_half1 rmean_half2 dmean_half1 dmean_half2
for j = 1:6 %k = 1:length(alt_inds)
%     j = alt_inds(k);

    [ relymat, deltamaxmat, sigmat, onsetsesh, days_aligned, ~, ~, ...
        deltamax_normmat] = track_splitters(alt_all_cell_sp{j}(1), ...
        alt_all_cell_sp{j}(2:end), sigthresh, 'days_ba', days_ba, ...
        'free_only', free_only, 'ignore_sameday', ignore_sameday, ...
        'norm_max', norm_max, 'nactive_thresh', nactive_thresh);
    
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
    
    split_onset_bymouse{j} = onsetsesh;
    
    % Average together 1st and 2nd halves of G45 and G48 for splitter
    % metrics
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

%% Now do all the above but for placefields!

save_pdf = true;
pthresh = 0.05;
days_ba = 9;
free_only = true;
ignore_sameday = true;
nactive_thresh = 5; % Neurons must be active at least this many trials to be considered
daydiff_arms_all = [];
daydiff_stem_all = [];
MImat_arms_all = [];
MImat_stem_all = [];
pc_onset_bymouse = cell(1,6);
% alt_inds = [1 2 3 4 5 6]; % Use these groups of sessions in alt_all_cell_sp - need
% to figure out how to combine G45 1st and 2nd half and G48 1st and 2nd
% half
clear rmean_half1 rmean_half2 dmean_half1 dmean_half2
for j=1:6 %k = 1:length(alt_inds)
%     j = alt_inds(k);

    [ sigmat, MImat, onsetsesh, days_aligned, ~, ~,...
        MImat_arms, days_aligned_arms, MImat_stem, days_aligned_stem] = ...
        track_PFontogeny(alt_all_cell_sp{j}(1), ...
        alt_all_cell_sp{j}(2:end), pthresh, 'days_ba', days_ba, ...
        'free_only', free_only, 'ignore_sameday', ignore_sameday, ...
        'nactive_thresh', nactive_thresh);
    
    if save_pdf
        printNK(['PFSplitter Ontogeny ba=' num2str(days_ba) ' days'],'alt', ...
            'append', true)
        close(gcf)
    end
    
    unique_daydiff_arms = unique(days_aligned_arms(~isnan(days_aligned_arms)));
    unique_daydiff_stem = unique(days_aligned_stem(~isnan(days_aligned_stem)));
    MIarms_mean = arrayfun(@(a) nanmean(MImat_arms(days_aligned_arms == a)), ...
        unique_daydiff_arms);
    MIstem_mean = arrayfun(@(a) nanmean(MImat_stem(days_aligned_stem == a)), ...
        unique_daydiff_arms);
    
    pc_onset_bymouse{j} = onsetsesh;
    
    if j == 3 || j == 5
        MIarms_half1 = MIarms_mean;
        MIstem_half1 = MIstem_mean;
        daydiff1_arms = unique_daydiff_arms;
        daydiff1_stem = unique_daydiff_stem;
    elseif j == 4 || j == 6
        MIarms_half2 = MIarms_mean;
        MIstem_half2 = MIstem_mean;
        daydiff2_arms = unique_daydiff_arms;
        daydiff2_stem = unique_daydiff_stem;
        
        % Get averages of both halves
        MIarms_comb = [MIarms_half1; MIarms_half2];
        MIstem_comb = [MIstem_half1; MIstem_half2];
        daydiff_arms_comb = [daydiff1_arms; daydiff2_arms];
        daydiff_stem_comb = [daydiff1_stem; daydiff2_stem];
        
        unique_daydiff_arms = unique(daydiff_arms_comb);
        unique_daydiff_stem = unique(daydiff_stem_comb);
        MIarms_mean = arrayfun(@(a) nanmean(MIarms_comb(a == daydiff_arms_comb)),...
            unique_daydiff_arms);
        MIstem_mean = arrayfun(@(a) nanmean(MIstem_comb(a == daydiff_stem_comb)),...
            unique_daydiff_stem);
        
        clear MIstem_half1 MIstem_half2 MIarms_half1 MIarms_half2 ...
            daydiff1_arms daydiff2_arms daydiff1_stem daydiff2_stem
    end
    
    daydiff_arms_all = [daydiff_arms_all; unique_daydiff_arms];
    daydiff_stem_all = [daydiff_stem_all; unique_daydiff_stem];
    MImat_arms_all = [MImat_arms_all; MIarms_mean];
    MImat_stem_all = [MImat_stem_all; MIstem_mean];

end


%% Place Cell Ontogeny Population plots with smoothed windows before/after
day_groups = 3;
[~, ~, ~, hplot] = split_ontogeny_plot(MImat_arms_all, daydiff_arms_all, ...
    day_groups, 'ylabel', 'Mutual Information', 'max_day', 9);
title(hplot,'Return Arm Place Cells'); 
xlabel(hplot, 'Days from Place Cell Birth');
printNK('Return Arm Place Cell Ontogeny - All mice means 3 day groups 9 day max', 'alt')
[~, ~, ~, hplot] = split_ontogeny_plot(MImat_stem_all, daydiff_stem_all, ...
    day_groups, 'ylabel', 'Mutual Information', 'max_day', 9);
title(hplot,'Stem Place Cells'); 
xlabel(hplot, 'Days from Place Cell Birth');
printNK('Stem Place Cell Ontogeny - All mice means 3 day groups 9 day max', 'alt')

%% Compare PF onset to splitter onset
mouse_names = {'G30', 'G31', 'G45\_1sthalf', 'G45\_2ndhalf', ...
    'G48\_1sthalf', 'G48\_2ndhalf'};
mouse_names_print = {'G30', 'G31', 'G45_1', 'G45_2', 'G48_1',  'G48_2'};

% Individual Mice
for j = 1:6
    plot_phenotype_onset(pc_onset_bymouse{j}, split_onset_bymouse{j},...
        mouse_names{j})  
    printNK(['Split v PC Onset plots ' mouse_names_print{j}], 'alt');
end

% Combined mice - keep all sessions for difference in phenotype onsets
plot_phenotype_onset(cat(1,pc_onset_bymouse{:}), cat(1,split_onset_bymouse{:}),...
    'All Mice/Sessions - Offset Diff Only!')
printNK('Split v Onset Diffs for All Mice','alt');
% Combined mice - exclude 2nd half of G45 and G48 since you don't have a
% legit reference point!
plot_phenotype_onset(cat(1,pc_onset_bymouse{[1 2 3 5]}), ...
    cat(1,split_onset_bymouse{[1 2 3 5]}),...
    'All Mice/Sessions - Good for absolute onset day plots!')
printNK('Split and PC absolute onset days All Mice', 'alt');






