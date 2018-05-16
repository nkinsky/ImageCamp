% 2env Figure 5: Arena Connection

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

% This code is broken, though it worked before. maybe MATLAB is having
% issues?
% mat_use = cat(2,mean(coh_pairs_after,2),mean(coh_pairs_before,2),...
%     mean(coh_pairs_during,2));
% p = anova1(mat_use,'off'); % Do balanced ANOVA using means of bda for all mice!!

mat_use2 = cat(2,mean(coh_pairs_before,1),mean(coh_pairs_during,1),...
    mean(coh_pairs_after,1));
groups = cat(2,ones(1,size(before_pairs,1)), ones(1,size(during_pairs,1))*2,...
    ones(1,size(after_pairs,1))*3);

figure(701); set(gcf,'Position', [520 420 840 380]);
h = subplot(1,2,1);
scatterBox(mat_use2, groups', 'XLabels',{'Before', 'During', 'After'}, 'yLabel',...
    'Prob. Coherent','h',h);
make_plot_pretty(h)
[p, t, stats] = anova1(mat_use2, groups,'off');
[c, m, h] = multcompare(stats,'display','off');
pkw = kruskalwallis(mat_use2, groups, 'off');

h = subplot(1,2,2);
plot_anova_stats(p,c,0.05,h);

% Run binomial glm too
% groups2 = cat(1, ones(size(coh_pairs_before(:))), 2*ones(size(coh_pairs_during(:))),...
%     3*ones(size(coh_pairs_after(:))));
bda_bin = cat(1,coh_pairs_before(:), coh_pairs_during(:), coh_pairs_after(:));
groups2 = zeros(length(groups2),3);
nb = length(coh_pairs_before(:)); nd = length(coh_pairs_during(:));
na = length(coh_pairs_after(:));
groups2(1:nb,1) = 1; groups2((nb + 1):(nb + nd),2) = 1;
groups2((nb + nd + 1):end,3) = 1;
glm = fitglm(groups2,bda_bin,'Distribution','binomial');

%% Rubin et al replication for connected days only
load(fullfile(ChangeDirectory_NK(G30_square(1),0), ...
    '2env_PV_conn_1000shuffles-2018-01-17.mat'));
%%
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
filts_use = {'coherent_only','no_silent','pval'};
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

%% Get whether or not comparisons are above chance or not
% Note that you only care about upper diagonal of the matrix but you get
% the same answer regardless since all you care about is proportions.
same_arena = [1 0 1 0 0 1 0 1; 0 1 0 1 1 0 1 0; 1 0 1 0 0 1 0 1; 0 1 0 1 1 0 1 0; ...
    0 1 0 1 1 0 1 0; 1 0 1 0 0 1 0 1; 0 1 0 1 1 0 1 0; 1 0 1 0 0 1 0 1];

ppass = nan(4,8,8);
ppass_diffarena = [];
for j = 1:4
    shuf_mean = squeeze(nanmean(nanmean(...
        Mouse(j).PV_corrs.conn.pval.PV_corr_binshuffle,3),4)); % Get mean shuffled corrs in each spatial bin 
    temp = shuf_mean - Mouse(j).PV_corrs.conn.pval.PV_corr_mean; 
    p = sum(temp > 0, 3)/1000; % Get pval from shuffle test
    ppass(j,:,:) = p <= alpha/28; % Compare to 0.05 after bonferroni correction - save for later
    ppass_use = squeeze(ppass(j,:,:));
    ppass_diffarena = [ppass_diffarena, ppass_use(~same_arena)];
end
% This comes out to 68% +/- 18%.
%% ScatterBox proportion of coherent session pairs in same arena vs different arena
% during connection in 

same_arena = [1 0 1 0 0 1 0 1; 0 1 0 1 1 0 1 0; 1 0 1 0 0 1 0 1; 0 1 0 1 1 0 1 0; ...
    0 1 0 1 1 0 1 0; 1 0 1 0 0 1 0 1; 0 1 0 1 1 0 1 0; 1 0 1 0 0 1 0 1];
hmean = mean(hmat_full,3);
pairs_use = logical(triu(ones(8),1));

hmean_vec = hmean(pairs_use);
grps = same_arena(pairs_use);

scatterBox(hmean_vec,grps);

         
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

load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_PVsilent_cm4_local0-1000shuffles-2018-01-06.mat'))

% Get whether PVcorrs are above chance or not.
ppass = nan(4,8,8);
shuf95 = nan(4,8,8);
for j = 1:4
    shuf_mean = Mouse(j).PVcorrs.circ2square(1).PVshuf_corrs;
    temp = shuf_mean - Mouse(j).PVcorrs.circ2square(1).PVcorrs; 
    p = sum(temp > 0, 3)/1000; % Get pval from shuffle test
    ppass(j,:,:) = p < alpha/64; % Compare to 0.05 after bonferroni correction - save for later
    ppass_use = squeeze(ppass(j,:,:));
    
    shuf_sort = sort(shuf_mean,3);
    shuf95(j,:,:) = squeeze(shuf_sort(:,:,975)); % Get upper 95% CI value for each comparison
end
ppass = logical(ppass);

% Get all pairs <= 1 day apart - sig diff.
before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
during_pairs = [5 5 6 6 ; 5 6 5 6]';
after_pairs = [7 7 8 8; 7 8 7 8]';

% Get all pairs exactly 1 day apart - trend toward significance
% before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
% during_pairs = [5 6  ; 6 5]';
% after_pairs = [7 7 8 8; 7 8 7 8]';

before_all = []; ppass_before_all = []; before_all95 = [];
during_all = []; ppass_during_all = []; during_all95 = [];
after_all = []; ppass_after_all = []; after_all95 = [];
groups_all = [];
for k = 1:4
    mouse_name = Mouse(k).sesh.circ2square(1).Animal;
    before = Mouse(k).PVcorrs.circ2square(1).PVcorrs(sub2ind([8,8],...
        before_pairs(:,1),before_pairs(:,2)));
    during = Mouse(k).PVcorrs.circ2square(1).PVcorrs(sub2ind([8,8],...
        during_pairs(:,1),during_pairs(:,2)));
    after = Mouse(k).PVcorrs.circ2square(1).PVcorrs(sub2ind([8,8],...
        after_pairs(:,1),after_pairs(:,2)));
    ppass_before = ppass(sub2ind([8,8],before_pairs(:,1),before_pairs(:,2)));
    ppass_during = ppass(sub2ind([8,8],during_pairs(:,1),during_pairs(:,2)));
    ppass_after = ppass(sub2ind([8,8],after_pairs(:,1),after_pairs(:,2)));
    before95 = shuf95(sub2ind([8,8],before_pairs(:,1),before_pairs(:,2)));
    during95 = shuf95(sub2ind([8,8],during_pairs(:,1),during_pairs(:,2)));
    after95 = shuf95(sub2ind([8,8],after_pairs(:,1),after_pairs(:,2)));
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
    
    ppass_before_all = cat(1,ppass_before_all,ppass_before);
    ppass_during_all = cat(1,ppass_during_all,ppass_during);
    ppass_after_all = cat(1,ppass_after_all,ppass_after);
    
    before_all95 = cat(1,before_all95,before95);
    during_all95 = cat(1,during_all95,during95);
    after_all95 = cat(1,after_all95,after95);
    
end

groups_all = cat(1,ones(size(before_all)), 2*ones(size(during_all)), ...
    3*ones(size(after_all)));
bda_all = cat(1, before_all, during_all, after_all);

scatterBox(bda_all,groups_all,'xLabels',{'Before','During','After'},'yLabel', ...
    'Mean \rho_{PV}','transparency', 0.7, 'Position', [1000 420 350 380]);
title('All Mice');
set(gca,'tickdir','in','YLim',[-0.2 0.6])
hold on
plot([1 2 3], [mean(before_all95), mean(during_all95), mean(after_all95)],'k--')
make_plot_pretty(gca)

printNK('PV Before During After for All Mice', '2env')

% Between group stats
[p_bda, t_bda, bda_stats] = kruskalwallis(bda_all, groups_all, 'off');
[c_bda, m_bda, h_bda] = multcompare(bda_stats,'display','off');

% Conservative stats versus chance
pbef_chance = signtest(bda_all(groups_all == 1),mean(before_all95));
pdur_chance = signtest(bda_all(groups_all == 2),mean(during_all95));
paft_chance = signtest(bda_all(groups_all == 3),mean(after_all95));

% % Try above but plot those not above chance in red...
% ppass_all = logical(cat(1, ppass_before_all, ppass_during_all, ppass_after_all));
% h = scatterBox(bda_all(ppass_all),groups_all(ppass_all),'xLabels',...
%     {'Before','During','After'},'yLabel', ...
%     'Mean \rho_{PV}','transparency', 0.7, 'Position', [1000 420 350 380]);
% hold on
% scatterBox(bda_all(~ppass_all),groups_all(~ppass_all),'xLabels',...
%     {'Before','During','After'},'yLabel', ...
%     'Mean \rho_{PV}','transparency', 0.7, 'circleColors',[0.7 0 0],'h', h);

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

%% Single cell examples of place fields remapping to cluster near the hallway
% Doesn't seem to pan out - most of the neurons with firing near the
% hallway only have 1-2 transients and many fire during the pass through
% the hallway, so the whole effect might be due to me having to include a
% small portion of the hallway in my placefield analysis.
use_same_max = true; % True = normalize all TMaps to max firing rate map

sesh_use = G31_botharenas(11:12);
for j = 1:2
    dirstr = ChangeDirectory_NK(sesh_use(j),0);
    load(fullfile(dirstr,'Placefields_half.mat'),'Placefields_halves')
    sesh_use(j).x{1} = Placefields_halves{1}.x;
    sesh_use(j).x{2} = Placefields_halves{2}.x;
    sesh_use(j).y{1} = Placefields_halves{1}.y;
    sesh_use(j).y{2} = Placefields_halves{2}.y;
    sesh_use(j).PSAbool{1} = Placefields_halves{1}.PSAbool;
    sesh_use(j).PSAbool{2} = Placefields_halves{2}.PSAbool;
    sesh_use(j).TMap{1} = Placefields_halves{1}.TMap_gauss;
    sesh_use(j).TMap{2} = Placefields_halves{2}.TMap_gauss;
    for k = 1:2
        nan_map_plot = Placefields_halves{k}.RunOccMap;
        nan_map_plot(nan_map_plot == 0) = nan;
        nan_map_plot(nan_map_plot ~= 0 & ~isnan(nan_map_plot)) = 0;
        sesh_use(j).nan_map_plot{k} = nan_map_plot;
    end
    
end

hh = figure(125); set(gcf,'Position',[112 134 1565 863]);
l = 1; stay_in = true;
while stay_in
    for k = 1:2
        for j = 1:2
            if j == 1
                subplot(2,4,((k-1)*4+1):((k-1)*4+2))
                x_use = sesh_use(j).x{k};
                y_use = sesh_use(j).y{k};
                PSAuse = sesh_use(j).PSAbool{k}(l,:);
                plot(x_use,y_use,'k',x_use(PSAuse),y_use(PSAuse),'r.')
                axis off
                if k == 1
                    title(num2str(l))
                end
            end
            subplot(2,4,(k-1)*4 + j + 2)
            if all(isnan(sesh_use(j).TMap{k}{l}(:)))
                imagesc_nan(rot90(sesh_use(j).nan_map_plot{k},1));
            else
                imagesc_nan(rot90(sesh_use(j).TMap{k}{l},1));
            end
            axis off
        end
    end
    
    % normalize to max FR
    if use_same_max
        maxes = cat(1,hh.Children([1,2,4,5]).CLim);
        maxes = maxes(maxes(:,2) ~= 1,:);
        clims_use = [0 max(max(maxes))];
        if ~all(clims_use == 0)
            arrayfun(@(a) set(a,'CLim',clims_use),hh.Children([1 2 4 5]));
        end
    end
        

    [l, stay_in] = LR_cycle(l,[1 size(sesh_use(j).PSAbool{k},1)]);
end

%% Make 2 plots: one of connected days only, the other of all days, but
% all scaled the same
Mouseconn = load('2env_PV_conn_1000shuffles-2018-01-17.mat');
% load('2env_PVsilent_cm4_local0-0shuffles-2018-05-03.mat'); % this has no place cell filter!
load('2env_PVsilent_cm4_local0-1000shuffles-2018-01-06.mat')
silent_thresh = nan;
if isnan(silent_thresh)
    sil_bool = [true false false];
else
    sil_bool = silent_thresh == [nan 0 1];
end

sq_inds = [1 2 7 8 9 12 13 14]; cir_inds = [3 4 5 6 10 11 15 16];

% Make all sessions matrix - circ2square
c2s_sesh_all = []; sq_sesh_all = []; cir_sesh_all = [];
for j = 1:4 
    c2s_sesh_all = cat(3,c2s_sesh_all,Mouse(j).PVcorrs.circ2square(sil_bool).PVcorrs); 
    sq_sesh_all = cat(3,sq_sesh_all,Mouse(j).PVcorrs.square(sil_bool).PVcorrs); 
    cir_sesh_all = cat(3,cir_sesh_all,Mouse(j).PVcorrs.circle(sil_bool).PVcorrs); 
end
c2s_sesh_mean = nanmean(c2s_sesh_all,3);
cir_sesh_mean = nanmean(cir_sesh_all,3);
sq_sesh_mean = nanmean(sq_sesh_all,3);

% Construct mega matrix with everthing inside - why didn't I just do this
% to begin with? 
all_sesh_full_mean = nan(16,16);
for j = 1:16
    for k = 1:16
        if j == k
            continue
        end
        
        if any(sq_inds == j) && any(sq_inds == k) % both square
            sq_inds_use = find((sq_inds == j) | (sq_inds == k));
            all_sesh_full_mean(j,k) = sq_sesh_mean(sq_inds_use(1),...
                sq_inds_use(2));
        elseif any(cir_inds == j) && any(cir_inds == k) % both cir
            cir_inds_use = find((cir_inds == j) | (cir_inds == k));
            all_sesh_full_mean(j,k) = cir_sesh_mean(cir_inds_use(1),...
                cir_inds_use(2));
        else
            sq_ind_use = (sq_inds == j) | (sq_inds == k);
            cir_ind_use = (cir_inds == j) | (cir_inds == k);
            all_sesh_full_mean(j,k) = c2s_sesh_mean(sq_ind_use, cir_ind_use);
        end
    end
end
% 
% all_sesh_bef_aft = c2s_sesh_mean([1:4, 7:8],[1:4, 7:8]);

% Make connected sessions matrix
conn_sesh_all = [];
for j = 1:4
    conn_sesh_all = cat(3,conn_sesh_all,...
        Mouseconn.Mouse(j).PV_corrs.conn.pval.PV_corr_mean);
end
conn_sesh_all(logical(eye(8))) = nan;

all_sesh_bef_aft2 = all_sesh_full_mean([1:8, 13:16],[1:8, 13:16]);

divs = [1.5 6.5 10.5];
try close(456); end
figure(456)
hconf(1) = subplot(2,3,[1 2 4 5]);
imagesc_nan(all_sesh_bef_aft2); colorbar
hold on
plot([0.5 12.5],[2.5 2.5],'r--', [0.5 12.5],[6.5 6.5],'r--',...
    [0.5 12.5],[10.5 10.5],'r--');
plot([2.5 2.5],[0.5 12.5],'r--', [6.5 6.5], [0.5 12.5],'r--',...
    [10.5 10.5], [0.5 12.5], 'r--');
title('Non-Connected Days')

hconf(2) = subplot(2,3,3);
imagesc_nan(mean(conn_sesh_all,3)); colorbar
hold on
plot([4.5 4.5],[0.5 8.5],'r--',[0.5 8.5],[4.5 4.5],'r--')
title('Connected Days')
make_figure_pretty(gcf)

% Scale color limits
clim_both = cat(1,hconf.CLim);
clim_use = [min(clim_both(:)) max(clim_both(:))];
arrayfun(@(a) set(a,'CLim',clim_use),hconf)
chil = get(gcf,'Children');
arrayfun(@(a) set(a,'Ticks',clim_use,'TickLabels',...
    arrayfun(@(a) num2str(a,'%0.2f'),clim_use','UniformOutput',false)),chil([1 3]))

%% Get day means
all_sesh_cond = nan(8,8);
for j = 1:8
    for k = 1:8
        ind1_use = (2*j-1):(2*j);
        ind2_use = (2*k-1):(2*k);
        vals_use = all_sesh_full_mean(ind1_use,ind2_use);
        all_sesh_cond(j,k) = nanmean(vals_use(:)); 
    end
end



