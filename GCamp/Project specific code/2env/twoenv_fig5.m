% 2env Figure 4: Arena Connection

%% Load data if required
load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_batch_analysis4_workspace_1000shuffles_2018JAN11.mat'));

sesh_type = {'square','circle','circ2square'};
num_comps = [28 28 64];

%% Keep limits the same for tuning curves
tuning_ylim = [-0.7 0.7];

% Paper positions - will need to scale by ~42% in illustrator after - I'm
% sure there is a better way
paper_pos = [2204 192 600 400]; % for square and circle
paper_pos2 = [2204 192 285 200]; % for circ2square

%% 5c middle: Circle2square Example Coherent Histogram
animal_use = 3;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 5; % must be square if circ2square
sesh2 = 5; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)

figure(hh(2))
printNK('Connected Day Coherency Histogram - G45', '2env', 'append', true)
figure; set(gcf,'Position',hh(2).Position)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off
printNK('Connected Day Coherency Histogram - G45', '2env', 'append', true)

%% 5c top: Circle2square Example Remapping Histogram
animal_use = 1;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 5; % must be square if circ2square
sesh2 = 5; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)

figure(hh(2))
printNK('Connected Day Remapping Histogram - G30', '2env', 'append', true)
figure; set(gcf,'Position',hh(2).Position)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off
printNK('Connected Day Remapping Histogram - G30', '2env', 'append', true)

%% Figure 5c bottom: coherent proportions before-during-after
% Note that this is now just in the text

% Get all pairs <= 1 day apart - sig diff.
before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
during_pairs = [5 5 6 6 ; 5 6 5 6]';
after_pairs = [7 7 8 8; 7 8 7 8]';

coh_pairs_before = nan(4,size(before_pairs,1));
coh_pairs_during = nan(4,size(during_pairs,1));
coh_pairs_after = nan(4,size(after_pairs,1));

for j= 1:4
    coh_mat = ~Mouse(j).remapping_type.global.circ2square;
    coh_pairs_before(j,:) = coh_mat(sub2ind([8,8], before_pairs(:,1),...
        before_pairs(:,2)));
    coh_pairs_during(j,:) = coh_mat(sub2ind([8,8], during_pairs(:,1),...
        during_pairs(:,2)));
    coh_pairs_after(j,:) = coh_mat(sub2ind([8,8], after_pairs(:,1),...
        after_pairs(:,2)));
end

coh_prop_before = mean(coh_pairs_before,2);
coh_prop_during = mean(coh_pairs_during,2);
coh_prop_after = mean(coh_pairs_after,2);

p = anova1(cat(2,mean(coh_pairs_after,2),mean(coh_pairs_before,2),...
    mean(coh_pairs_during,2)),'off');

%% Rubin et al replication for connected days only
plot_all_mice = true;
cm = 'jet';
ticks = 1:8; % 1:16;
ticklabels = {'5s','5c','5s','5c','6c','6s','6c','6s'}; %arrayfun(@num2str,5:6,'UniformOutput',false);% {'s' 's' 'c' 'c' 'c' 'c' 's' 's' 's' 'c' 'c' 's' 's' 's' 'c' 'c' };
filt_use = 'pval';
alpha = 0.05/28; % 0.05 Bonferroni corrected for # of unique session-pairs

mat_full = [];
hmat_full = [];
pmat_full = [];
for j = 1:4
    mat_use = Mouse(j).PV_corrs.conn.(filt_use).PV_corr_mean;
    mat_full = cat(3,mat_full,mat_use);
    corr_use = Mouse(j).PV_corrs.conn.(filt_use).PV_corr;
    shuf_use = Mouse(j).PV_corrs.conn.(filt_use).PV_corr_binshuffle;
    [h_mat, p_mat] = twoenv_PVshuftest( corr_use, shuf_use, alpha);
    hmat_full = cat(3,hmat_full,h_mat);
    pmat_full = cat(3,pmat_full,p_mat);
end

mat_use(logical(eye(8))) = nan;
if plot_all_mice
    figure(302)
    set(gcf,'Position',[1937 25 1796 953])
    for j = 1:4
        subplot(2,3,j);
        mat_plot = squeeze(mat_full(:,:,j));
        hmat_plot = squeeze(hmat_full(:,:,j));
        
        mat_plot(logical(eye(8))) = nan;
        hmat_plot(logical(eye(8))) = nan;
%         imagesc_nan(mat_plot,cm);
        sig_on_confmat(gca, make_mat_sym(mat_plot), make_mat_sym(hmat_plot));
       
        title(mouse_name_title(Mouse(j).sesh.circ2square(1).Animal));
        set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
            'YTick',ticks,'YTickLabel',ticklabels);
        hc = colorbar;
        make_plot_pretty(gca);
        make_plot_pretty(hc);
    end
    subplot(2,3,5); 
    mat_plot = mean(mat_full,3);
    mat_plot(logical(eye(8))) = nan;
    hmat_plot = max(pmat_full,[],3) < alpha;

    sig_on_confmat(gca, make_mat_sym(mat_plot), make_mat_sym(hmat_plot));
    set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
        'YTick',ticks,'YTickLabel',ticklabels);
    hc = colorbar;
    title('All Mice')
    make_plot_pretty(gca);
    make_plot_pretty(hc);
        
    subplot(2,3,6)
    text(0.1,0.1,['Filter type = ' filt_use])
    text(0.1,0.3,['pval thresh = ' num2str(inclusion_criteria.pval_thresh)])
    text(0.1,0.5,['ntrans thresh = ' num2str(inclusion_criteria.ntrans_thresh)])
    text(0.1,0.7,['cmperbin = ' num2str(inclusion_criteria.cmperbin_use)])
    axis off
end

figure(303)
set(gcf,'Position',[1980 10 1260 1000])
mean_plot = mean(mat_full,3);
mean_plot = nansum(cat(3, mean_plot, mean_plot'),3);
mean_plot(logical(eye(8))) = nan;

subplot(2,2,1)
hmat_plot = mat_plot;
hmat_plot(~isnan(hmat_plot)) = true;
sig_on_confmat(gca, make_mat_sym(mean_plot), make_mat_sym(hmat_plot), ...
    make_mat_sym(max(pmat_full,[],3)));
set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
    'YTick',ticks,'YTickLabel',ticklabels);
axis equal tight
hc = colorbar; % hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
title('All Mice - pmax shown')
make_plot_pretty(gca);
make_plot_pretty(hc)

subplot(2,2,2)
sig_on_confmat(gca, make_mat_sym(mean_plot), make_mat_sym(hmat_plot), ...
    make_mat_sym(mean(hmat_full,3)));
set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
    'YTick',ticks,'YTickLabel',ticklabels);
axis equal tight
hc = colorbar; % hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
title('All Mice - mean(h) shown')
make_plot_pretty(gca);
make_plot_pretty(hc)

subplot(2,2,3)
% sig_on_confmat(gca,mean_plot,hmat_plot,mean(pmat_full,[],3));
imagesc_nan(make_mat_sym(mean_plot))
set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
    'YTick',ticks,'YTickLabel',ticklabels);
axis equal tight
hc = colorbar; % hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
title('All Mice')
make_plot_pretty(gca);
make_plot_pretty(hc)


subplot(2,2,4)
text(0.1,0.1,['Filter type = ' filt_use])
text(0.1,0.3,['pval thresh = ' num2str(inclusion_criteria.pval_thresh)])
text(0.1,0.5,['ntrans thresh = ' num2str(inclusion_criteria.ntrans_thresh)])
text(0.1,0.7,['cmperbin = ' num2str(inclusion_criteria.cmperbin_use)])
axis off

figure(304)
set(gcf,'Position',[1937 25 1796 953])
filts_use = {'coherent_only','no_silent','pval', 'no_remap'};
for k = 1:length(filts_use)
    
    mat_full = [];
    pmat_full = [];
    for j = 1:4
        mat_use = Mouse(j).PV_corrs.conn.(filts_use{k}).PV_corr_mean;
        corr_use = Mouse(j).PV_corrs.conn.(filts_use{k}).PV_corr;
        shuf_use = Mouse(j).PV_corrs.conn.(filts_use{k}).PV_corr_binshuffle;
        [hval_mat, p_mat] = twoenv_PVshuftest( corr_use, shuf_use, alpha);
        mat_use(logical(eye(8))) = nan;
        mat_full = cat(3,mat_full,mat_use);
        pmat_full = cat(3,pmat_full,p_mat);
    end
    mat_plot = mean(mat_full,3);
    mat_plot(logical(eye(8))) = nan;
    subplot(2,3,k);
    imagesc_nan(make_mat_sym(mat_plot));
    hc = colorbar;
    set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
        'YTick',ticks,'YTickLabel',ticklabels);
    make_plot_pretty(gca);
    make_plot_pretty(hc)
    title(['Conn PVs filt = ' mouse_name_title(filts_use{k})])
    
end
subplot(2,3,6)
text(0.1,0.3,['pval thresh = ' num2str(inclusion_criteria.pval_thresh)])
text(0.1,0.5,['ntrans thresh = ' num2str(inclusion_criteria.ntrans_thresh)])
text(0.1,0.7,['cmperbin = ' num2str(inclusion_criteria.cmperbin_use)])
axis off
         
%% Now quantify in bar graph form
figure(305)
% set(gcf,'Position',[2060 350 1000 440])
filts_use = {'coherent_only','no_silent','pval'}; % {'coherent_only','silent_only','remap_only','no_coherent','no_silent', 'no_remap','pval'}; %
legend_use = {'Coherent Only', 'Coherent + Remap', 'Coh. + Remap + Silent'};
PVmat_all = [];
stdmat_all = [];
for j = 1:num_animals
    subplot(2,3,j)
    PVmat = [];
    stdmat = [];
    for k = 1:length(filts_use)
        [temps, tempd, std_s, std_d] = twoenv_connPVdelta(make_mat_sym(...
            Mouse(j).PV_corrs.conn.(filts_use{k}).PV_corr_mean));
        PVmat = [PVmat, [temps; tempd]]; % build up mat for each mouse
        stdmat = [stdmat, [std_s; std_d]];
    end
    bar_w_err(PVmat, stdmat)
    title(['Conn. \DeltaPV ' mouse_name_title(Mouse(j).sesh.circ2square(1).Animal)]);
    legend(legend_use)
    ylabel('\rho_{same} - \rho_{diff}')
    set(gca,'XTickLabel',{'Same Day','Diff. Day'});
    make_plot_pretty(gca)
    PVmat_all = cat(3,PVmat_all,PVmat);
    stdmat_all = cat(3,PVmat_all, stdmat);
    
    
end

subplot(2,3,5)
PVmat_all_mean = mean(PVmat_all,3);
PVmat_all_sem = std(PVmat_all,1,3)/sqrt(num_animals);
bar_w_err(PVmat_all_mean, PVmat_all_sem);
title('Conn. \DeltaPV - All Mice' );
ylabel('\rho_{same} - \rho_{diff}')
set(gca,'XTickLabel',{'Same Day','Diff. Day'});
legend(legend_use)
make_plot_pretty(gca)

subplot(2,3,6)
text(0.1,0.3,['pval thresh = ' num2str(inclusion_criteria.pval_thresh)])
text(0.1,0.5,['ntrans thresh = ' num2str(inclusion_criteria.ntrans_thresh)])
text(0.1,0.7,['cmperbin = ' num2str(inclusion_criteria.cmperbin_use)])
axis off

% Do rudimentary stats to see if adding in new cell population increases PV
% discrimination
[h12, p12] = ttest(PVmat_all(1,1,:),PVmat_all(1,2,:),'tail','left');
[h23, p23] = ttest(PVmat_all(1,2,:),PVmat_all(1,3,:),'tail','left');

[h12d, p12d] = ttest(PVmat_all(2,1,:),PVmat_all(2,2,:),'tail','left');
[h23d, p23d] = ttest(PVmat_all(2,2,:),PVmat_all(2,3,:),'tail','left');

%% ScatterBox plot of before-during-after PV correlations for one mouse + 
% all mice? All comparisons 1 day apart to control for effects of time.

load('2env_PVsilent_cm4_local0-1000shuffles-2018-01-06.mat')

% Get all pairs <= 1 day apart - sig diff.
before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
during_pairs = [5 5 6 6 ; 5 6 5 6]';
after_pairs = [7 7 8 8; 7 8 7 8]';

% Get all pairs exactly 1 day apart - trend toward significance
% before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
% during_pairs = [5 6  ; 6 5]';
% after_pairs = [7 7 8 8; 7 8 7 8]';

before_all = [];
during_all = [];
after_all = [];
groups_all = [];
for k = 1:4
    mouse_name = Mouse(k).sesh.circ2square(1).Animal;
    before = Mouse(k).PVcorrs.circ2square(1).PVcorrs(sub2ind([8,8],...
        before_pairs(:,1),before_pairs(:,2)));
    during = Mouse(k).PVcorrs.circ2square(1).PVcorrs(sub2ind([8,8],...
        during_pairs(:,1),during_pairs(:,2)));
    after = Mouse(k).PVcorrs.circ2square(1).PVcorrs(sub2ind([8,8],...
        after_pairs(:,1),after_pairs(:,2)));
    groups = cat(1,ones(size(before)), 2*ones(size(during)), ...
        3*ones(size(after)));
    
    scatterBox(cat(1,before,during,after),groups,'xLabels', {'Before', ...
        'During','After'},'yLabel','Mean \rho_{PV}','transparency',0.7,...
        'Position',[1000 420 350 380]);
    title(mouse_name_title(mouse_name));
    set(gca,'tickdir','in')
    make_plot_pretty(gca)
    
    printNK(['PV Before During After for ' mouse_name], '2env')
    
    before_all = cat(1,before_all,before);
    during_all = cat(1,during_all,during);
    after_all = cat(1,after_all,after);
    
    
end

groups_all = cat(1,ones(size(before_all)), 2*ones(size(during_all)), ...
    3*ones(size(after_all)));
bda_all = cat(1, before_all, during_all, after_all);
scatterBox(bda_all,groups_all,'xLabels',{'Before','During','After'},'yLabel', ...
    'Mean \rho_{PV}','transparency', 0.7, 'Position', [1000 420 350 380]);
title('All Mice');
set(gca,'tickdir','in','YLim',[-0.2 0.6])
make_plot_pretty(gca)

printNK('PV Before During After for All Mice', '2env')

[p_bda, t_bda, bda_stats] = anova1(bda_all, groups_all, 'off');
figure; [c_bda, m_bda, h_bda] = multcompare(bda_stats);

%% Stats for 5b: PFdensity increase
dmean_all = nan(2,8,4);
for j = 1:4
    dens_use = Mouse(j).PFdens_map;
    sq_incrs = round(size(dens_use{1,1})/3);
    cir_incrs = round(size(dens_use{2,1})/3);
    sq_bins = [sq_incrs(1) 2*sq_incrs(1); 2*sq_incrs(2) size(dens_use{1,1},2)];
    cir_bins = [cir_incrs(1) 2*cir_incrs(1); 1 cir_incrs(1)];
    dmean_sq = cellfun(@(a) nanmean(nanmean(a(sq_bins(1,1):sq_bins(1,2),sq_bins(2,1):sq_bins(2,2)))), ...
        dens_use(1,:));
    dmean_cir = cellfun(@(a) nanmean(nanmean(a(cir_bins(1,1):cir_bins(1,2),cir_bins(2,1):cir_bins(2,2)))), ...
        dens_use(2,:));
    dmean_all(:,:,j) = cat(1,dmean_sq,dmean_cir);

end

groups = repmat([1 1 1 1 2 2 3 3],2,1,4);

scatterBox(dmean_all(:),groups(:));

[p, t, stats] = anova1(dmean_all(:), groups(:),'off');
[c, m, h] = multcompare(stats,'display','off');


