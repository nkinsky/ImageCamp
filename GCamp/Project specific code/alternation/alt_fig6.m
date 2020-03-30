% Alternation Figure 6: Splitter Ontogeny
wood_filt = true;
half_life_thresh = 2;
use_expfit = true;
text_append = alt_set_filters(wood_filt, half_life_thresh, use_expfit);

%% Example cells between sessions

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
save_pdf = true;
sigthresh = 3;
days_ba = 1;
free_only = true;
ignore_sameday = true;
dplot = 'norm_max_int'; % metric to plot for discriminability
rplot = 'sigprop'; % metric to plot for reliability (max or mean of 1-p) or proportion of stem bins with sig splitting (sigprop)...
nactive_thresh = 5; % Neurons must be active at least this many trials to be considered
daydiff_all = [];
dmean_all = [];
dnormmean_all = [];
dimean_all = [];
rmean_all = [];
rm_mean_all = [];
spmean_all = [];
dnorm_mean_noalign_all = [];
lc_stage_split_all = [];
split_onset_bymouse = cell(1,6);
split_onsetstage_bymouse = cell(1,6);
% alt_inds = [1 2 3 4 5 6]; % Use these groups of sessions in alt_all_cell_sp - need
clear rmean_half1 rmean_half2 dmean_half1 dmean_half2 dimean_half1 ...
    dimean_half2 rm_mean_half1 rm_mean_half2 daydiff1 daydiff2 spmean_half1 ...
    spmean_half2
text_append = alt_get_filter_text();
for j = 1:6 %k = 1:length(alt_inds)
%     j = alt_inds(k);

    [ relymat, deltamaxmat, sigmat, onsetsesh, days_aligned, ~, ~, ...
        deltamax_normmat, sesh_final, dintnmat, relymeanmat, sigpropmat] = ...
        track_splitters(alt_all_cell_sp{j}(1), ...
        alt_all_cell_sp{j}(2:end), sigthresh, 'days_ba', days_ba, ...
        'free_only', free_only, 'ignore_sameday', ignore_sameday, ...
        'dplot', dplot, 'rplot', rplot, 'nactive_thresh', nactive_thresh);
    
    if save_pdf
        printNK(['Splitter Ontogeny ba=' num2str(days_ba) ' days' text_append],'alt', ...
            'append', true)
%         close(gcf)
    end
    
    unique_daydiff = unique(days_aligned(~isnan(days_aligned)));
    dmean = arrayfun(@(a) nanmean(deltamaxmat(days_aligned == a)), ...
        unique_daydiff);
    dnorm_mean = arrayfun(@(a) nanmean(deltamax_normmat(days_aligned == a)), ...
        unique_daydiff);
    dintn_mean = arrayfun(@(a) nanmean(dintnmat(days_aligned == a)), ...
        unique_daydiff);
    rmean = arrayfun(@(a) nanmean(relymat(days_aligned == a)), ...
        unique_daydiff);
    rm_mean = arrayfun(@(a) nanmean(relymeanmat(days_aligned == a)), ...
        unique_daydiff);
    spmean = arrayfun(@(a) nanmean(sigpropmat(days_aligned == a)), ...
        unique_daydiff);
    
    split_onset_bymouse{j} = onsetsesh;
    
    % Find what stage of learning splitter onset occurs in
    split_onsetstage_bymouse{j} = assign_onset_stage(alt_all_cell_sp{j}, ...
        learning_stage_ends_sp(j,:), onsetsesh);
    
    % Ditto for learning day
    lc_stage_split = assign_onset_stage(alt_all_cell_sp{j}, ...
        learning_stage_ends_sp(j,:), 1:size(deltamax_normmat,2));
    lc_stage_split_all = [lc_stage_split_all, lc_stage_split];
    
    % Now get mean MI for each day
    dnorm_mean_noalign = nanmean(deltamax_normmat,1);
    dnorm_mean_noalign_all = [dnorm_mean_noalign_all, dnorm_mean_noalign];
    
    % Average together 1st and 2nd halves of G45 and G48 for splitter
    % metrics
    if j == 3 || j == 5
        rmean_half1 = rmean;
        rm_mean_half1 = rm_mean;
        dmean_half1 = dmean;
        dnmean_half1 = dnorm_mean;
        dimean_half1 = dintn_mean;
        daydiff1 = unique_daydiff;
        spmean_half1 = spmean;

    elseif j == 4 || j == 6
        rmean_half2 = rmean;
        rm_mean_half2 = rm_mean;
        dmean_half2 = dmean;
        dnmean_half2 = dnorm_mean;
        dimean_half2 = dintn_mean;
        daydiff2 = unique_daydiff;
        spmean_half2 = spmean;
        
        % Get averages of both halves
        dmean_comb = [dmean_half1; dmean_half2];
        dnmean_comb = [dnmean_half1; dnmean_half2];
        dimean_comb = [dimean_half1; dimean_half2];
        rmean_comb = [rmean_half1; rmean_half2];
        rm_mean_comb = [rm_mean_half1; rm_mean_half2];
        spmean_comb = [spmean_half1; spmean_half2];
        daydiff_comb = [daydiff1; daydiff2];
        
        unique_daydiff = unique([daydiff1; daydiff2]);
        dmean = arrayfun(@(a) nanmean(dmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        dnorm_mean = arrayfun(@(a) nanmean(dnmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        dintn_mean = arrayfun(@(a) nanmean(dimean_comb(a == daydiff_comb)),...
            unique_daydiff);
        rmean = arrayfun(@(a) nanmean(rmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        rm_mean = arrayfun(@(a) nanmean(rm_mean_comb(a == daydiff_comb)),...
            unique_daydiff);
        spmean = arrayfun(@(a) nanmean(spmean_comb(a == daydiff_comb)),...
            unique_daydiff);
        
        clear rmean_half1 rmean_half2 dmean_half1 dmean_half2 ...
            dnmean_half1 dnmean_half2 dimean_half1 dimean_half2 ...
            rm_mean_half1 rm_mean_half2 daydiff1 daydiff2 sp_mean1 sp_mean2
    end
    
%     disp(['size ddiff = ' num2str(length(unique_daydiff)), 'size dmean = ' ...
%         num2str(length(dmean))])
    daydiff_all = [daydiff_all; unique_daydiff];
    dmean_all = [dmean_all; dmean];
    dnormmean_all = [dnormmean_all; dnorm_mean];
    dimean_all = [dimean_all; dintn_mean];
    rmean_all = [rmean_all; rmean];
    rm_mean_all = [rm_mean_all; rm_mean];
    spmean_all = [spmean_all; spmean];
end

%% Splitter Ontogeny Population plots with smoothed windows before/after
day_groups = 5;
max_day = 10;
split_ontogeny_plot(rmean_all, daydiff_all, day_groups, 'ylabel', ...
    'max reliability(1-p)_{mean}', 'max_day', max_day, 'group_size', day_groups);
printNK(['Splitter Ontogeny - Max Reliability All mice means ' ...
    num2str(day_groups) ' day groups ' num2str(max_day) ' day max' text_append], 'alt')
split_ontogeny_plot(rm_mean_all, daydiff_all, day_groups, 'ylabel', ...
    'mean reliability(1-p)_{mean}', 'max_day', max_day, 'group_size', day_groups);
printNK(['Splitter Ontogeny - Mean Reliability All mice means ' ...
    num2str(day_groups) ' day groups ' num2str(max_day) ' day max' text_append], 'alt')
split_ontogeny_plot(spmean_all, daydiff_all, day_groups, 'ylabel', ...
    'Sig bin prop._{mean}', 'max_day', max_day, 'group_size', day_groups);
printNK(['Splitter Ontogeny - Sig Bin Proportion All mice means ' ...
    num2str(day_groups) ' day groups ' num2str(max_day) ' day max' text_append], 'alt')
split_ontogeny_plot(dmean_all, daydiff_all, day_groups, 'ylabel', ...
    '\Deltamax_{mean}', 'max_day', max_day, 'group_size', day_groups);
printNK(['Splitter Ontogeny - Deltamax All mice means ' ...
    num2str(day_groups) ' day groups ' num2str(max_day) ' day max' text_append], 'alt')
split_ontogeny_plot(dnormmean_all, daydiff_all, day_groups, 'ylabel', ...
    '\Deltamax_{mean}_{norm}', 'max_day', max_day, 'group_size', day_groups);
printNK(['Splitter Ontogeny - Deltamax_norm All mice means ' ...
    num2str(day_groups) ' day groups ' num2str(max_day) ' day max' text_append], 'alt')
split_ontogeny_plot(dimean_all, daydiff_all, day_groups, 'ylabel', ...
    '\Sigma\Deltamax_{mean}_{norm}', 'max_day', max_day, 'group_size', ...
    day_groups);
printNK(['Splitter Ontogeny - sum Deltamax_norm All mice means ' ...
    num2str(day_groups) ' day groups ' num2str(max_day) ' day max' text_append], 'alt')

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
MImean_arms_noalign_all = [];
MImean_stem_noalign_all = [];
lc_stage_pcs_all = [];
pc_onset_bymouse = cell(1,6);
pc_onsetstage_bymouse = cell(1,6);
stem_only_inds = cell(1,6);
stemactive_inds = cell(1,6);
% alt_inds = [1 2 3 4 5 6]; % Use these groups of sessions in alt_all_cell_sp - need
% to figure out how to combine G45 1st and 2nd half and G48 1st and 2nd
% half
clear MIstem_half1 MIstem_half2 MIarms_half1 MIarms_half2 ...
    daydiff1_arms daydiff2_arms daydiff1_stem daydiff2_stem
text_append = alt_get_filter_text();
for j=1:6 %k = 1:length(alt_inds)
%     j = alt_inds(k);

    [ sigmat, MImat, onsetsesh, days_aligned, ~, ~,...
        MImat_arms, days_aligned_arms, MImat_stem, days_aligned_stem, ~, ...
        stem_only_inds_temp, stem_inds_temp] = ...
        track_PFontogeny(alt_all_cell_sp{j}(1), ...
        alt_all_cell_sp{j}(2:end), pthresh, 'days_ba', days_ba, ...
        'free_only', free_only, 'ignore_sameday', ignore_sameday, ...
        'nactive_thresh', nactive_thresh);
    
    if save_pdf
        printNK(['PF Ontogeny ba=' num2str(days_ba) ' days' text_append],'alt', ...
            'append', true)
        set(gcf,'Position', [12    73   962   604])
%         close(gcf)
    end
    
    unique_daydiff_arms = unique(days_aligned_arms(~isnan(days_aligned_arms)));
    unique_daydiff_stem = unique(days_aligned_stem(~isnan(days_aligned_stem)));
    MIarms_mean = arrayfun(@(a) nanmean(MImat_arms(days_aligned_arms == a)), ...
        unique_daydiff_arms);
    MIstem_mean = arrayfun(@(a) nanmean(MImat_stem(days_aligned_stem == a)), ...
        unique_daydiff_arms);
    
    pc_onset_bymouse{j} = onsetsesh;
    stem_only_inds{j} = stem_only_inds_temp;
    stemactive_inds{j} = stem_inds_temp;
    
    % Find what stage of learning pc onset occurs in
    pc_onsetstage_bymouse{j} = assign_onset_stage(alt_all_cell_sp{j}, ...
        learning_stage_ends_sp(j,:), onsetsesh);
    
    % Ditto for learning day
    lc_stage_pcs = assign_onset_stage(alt_all_cell_sp{j}, ...
        learning_stage_ends_sp(j,:), 1:size(MImat_arms,2));
    lc_stage_pcs_all = [lc_stage_pcs_all, lc_stage_pcs];
    
    % Now get mean MI for each day
    MIarms_mean_noalign = nanmean(MImat_arms,1);
    MIstem_mean_noalign = nanmean(MImat_stem,1);
    MImean_arms_noalign_all = [MImean_arms_noalign_all, MIarms_mean_noalign];
    MImean_stem_noalign_all = [MImean_stem_noalign_all, MIstem_mean_noalign];
 
    
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
day_groups = 5;
max_day = 10;
[~, ~, ~, hplot] = split_ontogeny_plot(MImat_arms_all, daydiff_arms_all, ...
    day_groups, 'ylabel', 'Mutual Information', 'max_day', max_day);
title(hplot,'Return Arm Place Cells'); 
xlabel(hplot, 'Days from Place Cell Birth');
printNK(['Return Arm Place Cell Ontogeny - All mice means ' num2str(day_groups)...
    ' groups ' num2str(max_day) ' day max' text_append], 'alt')
[~, ~, ~, hplot] = split_ontogeny_plot(MImat_stem_all, daydiff_stem_all, ...
    day_groups, 'ylabel', 'Mutual Information', 'max_day', max_day);
title(hplot,'Stem Place Cells'); 
xlabel(hplot, 'Days from Place Cell Birth');
printNK(['Stem Place Cell Ontogeny - All mice means ' num2str(day_groups)...
    ' groups ' num2str(max_day) ' day max' text_append], 'alt')

%% Compare PF onset to splitter onset
mouse_names = {'G30', 'G31', 'G45\_1sthalf', 'G45\_2ndhalf', ...
    'G48\_1sthalf', 'G48\_2ndhalf'};
mouse_names_print = {'G30', 'G31', 'G45_1', 'G45_2', 'G48_1',  'G48_2'};

% Individual Mice - could be PC on either stem OR arm OR both
for j = 1:6
    plot_phenotype_onset(pc_onset_bymouse{j}, split_onset_bymouse{j},...
        mouse_names{j})  
    printNK(['Split v PC Onset plots ' mouse_names_print{j} text_append], 'alt');
end

% Combined mice - keep all sessions for difference in phenotype onsets
plot_phenotype_onset(cat(1,pc_onset_bymouse{:}), cat(1,split_onset_bymouse{:}),...
    'All Mice/Sessions - Onset Diff Only!')
printNK(['Split v Onset Diffs for All Mice' text_append],'alt');
% Combined mice - exclude 2nd half of G45 and G48 since you don't have a
% legit reference point!
plot_phenotype_onset(cat(1,pc_onset_bymouse{[1 2 3 5]}), ...
    cat(1,split_onset_bymouse{[1 2 3 5]}),...
    'All Mice/Sessions - Good for absolute onset day plots!')
printNK(['Split and PC absolute onset days All Mice' text_append], 'alt');

%% Repeat above but only for cells that have fields on the stem ONLY at PC onset
% They look basically the same as when I consider ALL place cell locations.
stemonlypc_onset_bymouse = cellfun (@(a) nan(length(a),1), pc_onset_bymouse,...
    'UniformOutput', false);
for j = 1:6 
    stemonlypc_onset_bymouse{j}(stem_only_inds{j}) = ...
        pc_onset_bymouse{j}(stem_only_inds{j}); 
end

for j = 1:6
    [~, ha] = plot_phenotype_onset(stemonlypc_onset_bymouse{j}, split_onset_bymouse{j},...
        mouse_names{j});
    title(ha(6),'PCs have fields on stem ONLY at onset');
    printNK(['Split v PC Onset with stem fields ONLY plots ' mouse_names_print{j} text_append], 'alt');
    
end

plot_phenotype_onset(cat(1,stemonlypc_onset_bymouse{:}), cat(1,split_onset_bymouse{:}),...
    'All Mice/Sessions Stem PCs at Birth Only - Onset Diff Only!')
printNK(['Split v Onset Diffs for All Mice' text_append],'alt');

plot_phenotype_onset(cat(1,stemonlypc_onset_bymouse{[1 2 3 5]}), ...
    cat(1,split_onset_bymouse{[1 2 3 5]}),...
    'All Mice/Sessions - Good for absolute onset day plots!')
printNK('Split and PC absolute onset days All Mice', 'alt');

%% Do above but by learning stage
plot_phenotype_onset(cat(1,pc_onsetstage_bymouse{:}), ...
    cat(1,split_onsetstage_bymouse{:}),'All Mice/Sessions by Learning Stage')

%% Now plot mean MI and dnorm versus learning stage
scatterBox(MImat_stem_noalign_all, lc_stage_pcs_all,'xLabels',...
    {'Early','Middle','Late'},'ylabel','MI_{mean}'); 
xlabel('Learning Stage')
make_plot_pretty(gca)
printNK(['Mutual Information vs. Learning Stage All Mice' text_append],'alt')
pkw_pc = kruskalwallis(MImat_stem_noalign_all, lc_stage_pcs_all,'off');

scatterBox(dnorm_mean_noalign_all, lc_stage_split_all,'xLabels',...
    {'Early','Middle','Late'},'ylabel','\Deltamax_{mean}'); 
xlabel('Learning Stage')
make_plot_pretty(gca)
printNK(['Dnorm_mean vs. Learning Stage All Mice' text_append],'alt')
pkw_sp = kruskalwallis(dnorm_mean_noalign_all, lc_stage_split_all,'off');




