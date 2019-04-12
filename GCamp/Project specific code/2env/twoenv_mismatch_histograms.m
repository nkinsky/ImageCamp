% Two-env plot mismatch session histogram
% NK - need to figure out how to run shuffling/get statistics on which are
% global remapping session-pairs and which ones are coherent...

% edges{1} = (-pi()/12):(pi()/6):(23*pi()/12);
% edges{2} = (-pi()/8):(pi()/4):(15*pi()/8);
% edges{3} = (-pi()/16):(pi()/8):(31*pi()/16);
% edges{4} = (-pi()/24):(pi()/12):(47*pi()/24);
% ne = length(edges{1});
% ne21 = length(edges2);
% ne3 = length(edges3);
% ne4 = length(edges4);
ppp = mfilename;

PCfilter = false;
mismatch_cutoff = 22.5; % Used for calculating mismatches 
nshuf = 1000;

coh_ang_thresh = 30; % used for calculating significance values and # cells close to mean
plot_hists = true; % true = plot histograms for all mice/session-pairs
plot_entry = false; % true = plot entry breakdown for all animals

load_existing = 1; % 0 = run again, 1 = load PCfilter = false, 1000 shuf data

%% Calculate rotation angles for all square session-pairs
% Shuffle, get p value, and apply CIs from shuffled data! - shuffle cell
% identity between session, get # neurons <30 degrees from median of actual
% data. p = 1 - sum( (ndata<30) > (nshuf<30))/nshuf!!!. Also plot arena
% rotation on these plots (solid line) and median of data (dashed line).
% Bonferroni correct data.
% Get shuffled values by running histcounts on get_PF_angle_delta

% Last but not least - run this on place cells ONLY to see if you get less
% random remapping neurons and tighther clustering around median value.

if load_existing == 0
mismatch_ang_all_sq = cell(1,4);
mismatch_bool_all_sq = false(4,8,8);
delta_angle_med_sq = nan(4,8,8);
arena_rot_sq = nan(4,8,8);
pshuf_sq = nan(4,8,8);
ncells_sq = nan(4,8,8);
coh_ratio_sq = nan(4,8,8);
tic
for j = 1:4
    [~, delta_angle_med_sq(j,:,:), arena_rot_sq(j,:,:), pshuf_sq(j,:,:), ...
        ncells_sq(j,:,:), coh_ratio_sq(j,:,:)] = plot_pfangle_batch(...
        all_square2(j,:), [], nshuf, PCfilter, coh_ang_thresh, plot_hists);
    if plot_hists
        printNK(['Square pf_rot_histograms - Mouse ' num2str(j) '_PF' ...
            num2str(PCfilter) '_cohthresh' num2str(round(coh_ang_thresh))],'2env')
    end
end 
toc

%% Calculate rotation angles for all octagon session-pairs
mismatch_ang_all_oct = cell(1,4);
mismatch_bool_all_oct = false(4,8,8);
delta_angle_med_oct = nan(4,8,8);
arena_rot_oct = nan(4,8,8);
pshuf_oct = nan(4,8,8);
ncells_oct = nan(4,8,8);
coh_ratio_oct = nan(4,8,8);
tic
for j = 1:4
    [~, delta_angle_med_oct(j,:,:), arena_rot_oct(j,:,:), pshuf_oct(j,:,:),...
        ncells_oct(j,:,:), coh_ratio_oct(j,:,:)] = ...
        plot_pfangle_batch(all_oct2(j,:), [], nshuf, PCfilter, ...
        coh_ang_thresh, plot_hists);
    if plot_hists
        printNK(['Octagon pf_rot_histograms - Mouse ' num2str(j) '_PF' ...
            num2str(PCfilter) '_cohthresh' num2str(round(coh_ang_thresh))],'2env')
    end
end
toc

%% Do the same for circ2square
delta_angle_med_c2s = nan(4,8,8);
arena_rot_c2s = nan(4,8,8);
pshuf_c2s = nan(4,8,8);
ncells_c2s = nan(4,8,8);
coh_ratio_c2s = nan(4,8,8);
tic
for j = 1:4
    [~, delta_angle_med_c2s(j,:,:), arena_rot_c2s(j,:,:), pshuf_c2s(j,:,:),...
        ncells_c2s(j,:,:), coh_ratio_c2s(j,:,:)] = ...
    plot_pfangle_batch(all_square2(j,:), all_oct2(j,:), nshuf,...
        PCfilter, coh_ang_thresh, plot_hists);
    if plot_hists
        printNK(['Circ2square pf_rot_histograms - Mouse ' num2str(j) '_PF' ...
            num2str(PCfilter) '_cohthresh' num2str(round(coh_ang_thresh))],'2env')
    end
end
toc

gr_bool_c2s = pshuf_c2s > 0.05/64;

% Save everything in workspace
save(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    ['2env_misma_coh' num2str(round(coh_ang_thresh)) '_shuf' ...
    num2str(nshuf) '-' datestr(now,29) '.mat'])); %'ncells_sq','coh_ratio_sq',...
%     'ncells_oct','coh_ratio_oct','ncells_c2s','coh_ratio_c2s')

elseif load_existing == 1
    
    load(fullfile(ChangeDirectory_NK(G30_square(1),0), ...
        '2env_misma_coh30_shuf1000-2018-06-01.mat'));
end

%% Classify square session-pairs
% Figure out a global remapping metric here and apply it!!! 
gr_bool_sq = pshuf_sq > 0.05/28; % Get global remapping session-pairs

distal_bool_all_sq = nan(4,8,8);
local_bool_all_sq = nan(4,8,8);
sq_breakdown = nan(4,2,4); %[nmis_rot, nloc_rot, ndist_rot; nmis_nr, nloc_nr, ndist_nr]; 
for j = 1:4
    % Get angle used
    delta_ang_use = squeeze(delta_angle_med_sq(j,:,:));
    arena_rot_use = squeeze(arena_rot_sq(j,:,:));
    gr_bool_use = squeeze(gr_bool_sq(j,:,:));
    [mismatch_bool, local_bool_all_sq(j,:,:), distal_bool_all_sq(j,:,:),...
        sq_breakdown(j,:,:)]  = ...
        twoenv_classify_rots(delta_ang_use, arena_rot_use, mismatch_cutoff,...
        gr_bool_use); 
    gr_use = squeeze(gr_bool_sq(j,:,:));
    delta_temp = squeeze(delta_angle_med_sq(j,:,:));
    mismatch_ang_all_sq{j} =  delta_temp(mismatch_bool & ~gr_use);
    mismatch_bool_all_sq(j,:,:) = mismatch_bool;
end
%% Classify octagon session-pairs
% NK to-do: classify global remapping sessions and exclude those from
% mismatch_bool below.
gr_bool_oct = pshuf_oct > 0.05/28;

distal_bool_all_oct = nan(4,8,8);
local_bool_all_oct = nan(4,8,8);
oct_breakdown = nan(4,2,4); %[nmis_rot, nloc_rot, ndist_rot; nmis_nr, nloc_nr, ndist_nr]; 
for j = 1:4
    % Get angle used
    delta_ang_use = squeeze(delta_angle_med_oct(j,:,:));
    arena_rot_use = squeeze(arena_rot_oct(j,:,:));
    gr_bool_use = squeeze(gr_bool_oct(j,:,:));
    [mismatch_bool, local_bool_all_oct(j,:,:), distal_bool_all_oct(j,:,:), ...
        oct_breakdown(j,:,:)]  = ...
        twoenv_classify_rots(delta_ang_use, arena_rot_use, mismatch_cutoff,...
        gr_bool_use); 
    gr_use = squeeze(gr_bool_oct(j,:,:));
    delta_temp = squeeze(delta_angle_med_oct(j,:,:));
    mismatch_ang_all_oct{j} =  delta_temp(mismatch_bool & ~gr_use);
    mismatch_bool_all_oct(j,:,:) = mismatch_bool;
end

%% Calculate how much each mouse uses right angles to orient each map
right_lims = repmat((0:90:360)',1,2)+ [-22.5 22.5];
sq_rightang_bool = cellfun(@(a) bw_bool(a,right_lims),...
    mismatch_ang_all_sq,'UniformOutput',false);
oct_rightang_bool = cellfun(@(a) bw_bool(a,right_lims),...
    mismatch_ang_all_oct,'UniformOutput',false);

%% Plot everything
bin_size = 22.5; % degrees
edges_use = -bin_size/2:bin_size:(360-bin_size/2);
edges_use2 = -bin_size:2*bin_size:(360-bin_size);
nbins = length(edges_use)-1;
nbins2 = length(edges_use2)-1;

try close(35); end %#ok<TRYNC>
figure(35); set(gcf,'Position',[2225 10 1700 1000]);
set(gcf,'Name',['PCfilter = ' num2str(PCfilter) ' coh_ang_thresh = ' ...
    num2str(round(coh_ang_thresh))])

subplot(3,3,1); hold off
angles_all_sq = cat(1,mismatch_ang_all_sq{:});
hsq = polarhistogram(circ_ang2rad(angles_all_sq), circ_ang2rad(edges_use), ...
    'DisplayStyle', 'stairs', 'Normalization', 'probability');
hold on

angles_all_oct = cat(1,mismatch_ang_all_oct{:});
hoct = polarhistogram(circ_ang2rad(angles_all_oct), circ_ang2rad(edges_use), ...
    'DisplayStyle', 'stairs', 'Normalization', 'probability');

hc = polarplot(circ_ang2rad(edges_use),1/nbins*ones(size(edges_use)),'r--');
legend(cat(1,hsq,hoct,hc),{'Square','Octagon','Chance'})
title('Mismatch session PF rot angles')

subplot(3,3,2); hold off
angles_all_sq_adj = angles_all_sq;
angles_all_sq_adj(angles_all_sq_adj > 360-2*bin_size) = ...
    angles_all_sq_adj(angles_all_sq_adj > 360-2*bin_size) - 360;
hsq2 = histogram(angles_all_sq_adj, edges_use2, 'DisplayStyle', 'bar',...
    'Normalization','probability');
hold on
angles_all_oct_adj = angles_all_oct;
angles_all_oct_adj(angles_all_oct_adj > 360-2*bin_size) = ...
    angles_all_oct_adj(angles_all_oct_adj > 360-2*bin_size) - 360;
hoct2 = histogram(angles_all_oct_adj, edges_use2 , 'DisplayStyle', ...
    'bar','Normalization','probability');
hc2 = plot(edges_use2,1/nbins2*ones(size(edges_use2)),'r--');
hold off
legend(cat(1,hsq2,hoct2,hc2),{'Square','Octagon','Chance'},...
    'Location','NorthWest')
xlim([-22.5 382.5]); ylim([0 0.4])
set(gca,'XTick',0:45:360,'XTickLabels', ...
    arrayfun(@num2str,0:45:360,'UniformOutput',false));
ylabel('Probability')
title('Mismatch session PF rot angles')

subplot(3,3,3)
% Calculate if mismatch sessions occur more at right angles for square
% vs octagon
sq_right_ratio = sum(cat(1,sq_rightang_bool{:}))/...
    length(cat(1,sq_rightang_bool{:}));
oct_right_ratio = sum(cat(1,oct_rightang_bool{:}))/...
    length(cat(1,oct_rightang_bool{:}));
% ha = bar(1:2,[sq_right_ratio, oct_right_ratio; nan, nan]);
% offsets = [ha(1).XOffset, ha(2).XOffset];
% hold on
right_rat_all = nan(4,2);
groups = repmat([1,2],4,1);
for j = 1:4
   sq_use =  sum(sq_rightang_bool{j})/length(sq_rightang_bool{j});
   oct_use =  sum(oct_rightang_bool{j})/length(oct_rightang_bool{j});
%    xplot = 1 + offsets;
   right_rat_all(j,:) = [sq_use, oct_use];
end
ha = bar(1:2,[mean(right_rat_all,1); nan, nan]);
hold on
offsets = [ha(1).XOffset, ha(2).XOffset];
xplot = repmat(1 + offsets,4,1);
xplot = xplot + randn(size(xplot))*0.03;
plot(xplot(:),right_rat_all(:),'ko'); 
hc = plot([0.7 1.3], [0.5 0.5],'k--');
legend(hc,'Chance')
xlim([0.6 3.4]); ylim([0 1.2])
set(gca,'YTick',0:0.2:1)
ylabel('Proportion')
title('Proportion mismatch sessions at right angles')
legend(ha,{'Square','Circle'})

% Stats
pright = ranksum(right_rat_all(:,1), right_rat_all(:,2),'tail','right');
subplot(3,3,9)
text(0.1,0.9,['Wilcoxon: p90align,sq > oct = ' num2str(pright,'%0.3f')])
axis off

% Plot breakdown - rotated between sessions
% NK - add in global remapping values here
subplot(3,3,4); hold off
sq_sum = squeeze(sum(sq_breakdown,1))';
oct_sum = squeeze(sum(oct_breakdown,1))';
rot_sum = [sq_sum(:,1), oct_sum(:,1)];
nrot_sum = [sq_sum(:,2), oct_sum(:,2)];
chance_level = 2*mismatch_cutoff/360;
h = bar((1:4)', rot_sum./sum(rot_sum,1)); hold on;
plot([2, 3],[chance_level, chance_level],'k--')
set(gca,'XTickLabels',{'Mismatch', 'Local', 'Distal', 'Global Remap'})
title('Rotation Breakdown - Arena Rotated Between Sessions')
for j = 1:4
    sq_use = squeeze(sq_breakdown(j,1,:));
    oct_use = squeeze(oct_breakdown(j,1,:));
    xplot1 = (1:4)' + h(1).XOffset;
    xplot2 = (1:4)' + h(2).XOffset;
    scatter(xplot1 + randn(size(xplot1))*0.02, sq_use/sum(sq_use),'ko')
    scatter(xplot2 + randn(size(xplot2))*0.02, oct_use/sum(oct_use),'ko')
end
legend(h,{'Square','Circle'})

% Stats on above
subplot(3,3,7)
comb_breakdown = cat(1,squeeze(sq_breakdown(:,1,:)),...
    squeeze(oct_breakdown(:,1,:)));
comb_breakdownw = cat(3,squeeze(sq_breakdown(:,1,:)),...
    squeeze(oct_breakdown(:,1,:)));
[pkw,~,statskw] = kruskalwallis(comb_breakdown(:,1:3),...
    {'Local','Mismatch','Distal'},'off');
c = multcompare(statskw,'display','off');

% Is there a difference between square/circ? Not after Bonf correction.
plcdiff_rot = ranksum(squeeze(comb_breakdownw(:,1,1)),...
    squeeze(comb_breakdownw(:,1,2)));
pmmdiff_rot = ranksum(squeeze(comb_breakdownw(:,2,1)),...
    squeeze(comb_breakdownw(:,2,2)));
pdistdiff_rot = ranksum(squeeze(comb_breakdownw(:,3,1)),...
    squeeze(comb_breakdownw(:,3,2)));

text(0.6,0.7,['1v2 p = ' num2str(c(1,6),'%0.2g')])
text(0.1,0.5,['1v3 p = ' num2str(c(2,6),'%0.2g')])
text(0.6,0.5,['2v3 p = ' num2str(c(3,6),'%0.2g')])
text(0.1,0.7,['pkw = ' num2str(pkw,'%0.2g')])
text(0.1,0.3,'Cir v Sq diff?')
text(0.6,0.3,['ploc\_diff = ' num2str(plcdiff_rot,'%0.2g')])
text(0.1,0.1,['pmm\_diff = ' num2str(pmmdiff_rot,'%0.2g')])
text(0.6,0.1,['pdist\_diff = ' num2str(pdistdiff_rot,'%0.2g')])
title('KW test with post-hoc Tukey HSD')
axis off


% Plot breakdown - not rotated between sessions
subplot(3,3,5); hold off
chance_level = 2*mismatch_cutoff/360;
h = bar((1:4)', nrot_sum./sum(nrot_sum,1)); hold on;
plot([2, 3],[chance_level, chance_level],'k--')
set(gca,'XTickLabels',{'Mismatch', 'Local', 'Distal', 'Global Remap'})
title('Rotation Breakdown - Arena NOT Rotated Between Sessions')
for j = 1:4
    sq_use = squeeze(sq_breakdown(j,2,:));
    oct_use = squeeze(oct_breakdown(j,2,:));
    xplot1 = (1:4)' + h(1).XOffset;
    xplot2 = (1:4)' + h(2).XOffset;
    scatter(xplot1 + randn(size(xplot1))*0.02, sq_use/sum(sq_use),'ko')
    scatter(xplot2 + randn(size(xplot2))*0.02, oct_use/sum(oct_use),'ko')
end
legend(h,{'Square','Circle'})

% Stats on above
subplot(3,3,8)
comb_breakdown = cat(1,squeeze(sq_breakdown(:,2,:)),...
    squeeze(oct_breakdown(:,2,:)));
comb_breakdownw = cat(3,squeeze(sq_breakdown(:,2,:)),...
    squeeze(oct_breakdown(:,2,:)));
[pkw,~,statskw] = kruskalwallis(comb_breakdown(:,1:3),...
    {'Local','Mismatch','Distal'},'off');
c = multcompare(statskw,'display','off');
prsmm_lc = ranksum(comb_breakdown(:,1,:),comb_breakdown(:,2,:));

% Is there a difference between square/circ? Not after Bonf correction.
plcdiff_nrot = ranksum(squeeze(comb_breakdownw(:,1,1)),...
    squeeze(comb_breakdownw(:,1,2)));
pmmdiff_nrot = ranksum(squeeze(comb_breakdownw(:,2,1)),...
    squeeze(comb_breakdownw(:,2,2)));
pdistdiff_nrot = ranksum(squeeze(comb_breakdownw(:,3,1)),...
    squeeze(comb_breakdownw(:,3,2)));

text(0.6,0.7,['1v2 p = ' num2str(c(1,6),'%0.2g')])
text(0.1,0.5,['1v3 p = ' num2str(c(2,6),'%0.2g')])
text(0.6,0.5,['2v3 p = ' num2str(c(3,6),'%0.2g')])
text(0.1,0.7,['pkw = ' num2str(pkw,'%0.2g')])
text(0.1,0.3,'Cir v Sq diff?')
text(0.6,0.3,['ploc\_diff = ' num2str(plcdiff_nrot,'%0.2g')])
text(0.1,0.1,['pmm\_diff = ' num2str(pmmdiff_nrot,'%0.2g')])
text(0.6,0.1,['pdist\_diff = ' num2str(pdistdiff_nrot,'%0.2g')])
text(0.1,0.9,['loc v mm rank-sum p = ' num2str(prsmm_lc,'%0.2g')])
title('KW test with post-hoc Tukey HSD')
axis off

 
% Plot coherent v global remapping proportions for all comparisons (circle,
% square, and circ2square here).
subplot(3,3,6)
gr_breakdown = [ sum(gr_bool_sq(:,:),2)/28, sum(gr_bool_oct(:,:),2)/28 ...
    sum(gr_bool_c2s(:,:),2)/64];
h = bar(1:2, [mean(gr_breakdown,1); 1-mean(gr_breakdown,1)]);
xplot = repmat(arrayfun(@(a) a.XOffset,h),4,1) + 2;
xplot = xplot + randn(size(xplot))*0.02;
hold on
scatter(xplot(:), 1- gr_breakdown(:),'ko')
title('Coherent v Gl. Remapping Breakdown')
hold off
set(gca,'XTickLabel',{'Gl Remap','Coherent'})
xlim([1.5 3.5])

% Stats
subplot(3,3,9)
[pkw,~,statskw] = kruskalwallis(gr_breakdown,{'Square','Oct','Oct2Sq'},'off');
prks_circ_v_sq = ranksum(gr_breakdown(:,1), gr_breakdown(:,2));
text(0.1,0.5, ['pkw circ\_win v sq\_win v c2s coh prop diff = ' ...
    num2str(pkw,'%0.2f')])
text(0.1,0.3, ['prks circ\_win v sq\_win coh prop diff = ' ...
    num2str(prks_circ_v_sq,'%0.2f')])
axis off

make_figure_pretty(gcf)
printNK(['Mismatch Breakdown PFfilt=' num2str(PCfilter) ' ang_thresh= ' ...
    num2str(round(coh_ang_thresh))],'2env')

%%
% Plot coherent v global remapping proportions for all comparisons (circle,
% square, and circ2square here).
try close(383); end

figure(383); set(gcf,'Position',[1990 150 460 800]);
subplot(2,1,1)
gr_breakdown_win = sum(cat(1, gr_bool_sq(:,:), gr_bool_oct(:,:)),2)/28;
gr_breakdown_c2s = sum(gr_bool_c2s(:,:),2)/64;
h = bar(1:2, [1 - mean(gr_breakdown_win), 1 - mean(gr_breakdown_c2s)]);
xlim([0 3])
xplot = 1 + randn(size(gr_breakdown_win))*0.02;
hold on
scatter(xplot(:), 1 - gr_breakdown_win(:),'ko')
xplot = 2 + randn(size(gr_breakdown_c2s))*0.02;
hold on
scatter(xplot(:), 1 - gr_breakdown_c2s(:),'ko')
title('Coherent v Gl. Remapping Breakdown')
hold off
set(gca,'XTickLabel',{'Same','Diff.'})
xlabel('Arena')
ylabel('Prob. Coh. x Mouse')
make_plot_pretty(gca,'linewidth',1)

% Stats
subplot(2,1,2)
prks = ranksum(gr_breakdown_win, gr_breakdown_c2s);
text(0.1,0.5, ['prks_diff = ' num2str(prks,'%0.2f')])
axis off

printNK('Coh probability same v diff','2env')

%% Get entry and landing angle changes between sessions and shuffled values
nshuf = 1000;
dtheta_sq = nan(4,3,8,8); dtheta_shuf_sq = nan(4,3,8,8,1000);
dtheta_oct = nan(4,3,8,8); dtheta_shuf_oct = nan(4,3,8,8,1000);
for j = 1:4
   dtheta_sq(j,:,:,:) = twoenv_entry_ang_mat(all_square2(j,:));
   dtheta_oct(j,:,:,:) = twoenv_entry_ang_mat(all_oct2(j,:));
   dtheta_shuf_sq(j,:,:,:,:) = twoenv_shuffle_dtheta(...
       squeeze(dtheta_sq(j,:,:,:)),nshuf);
   dtheta_shuf_oct(j,:,:,:,:) = twoenv_shuffle_dtheta(...
       squeeze(dtheta_oct(j,:,:,:)),nshuf);
   
end

%% Plot histograms of PFrot - theta to see if entry angles/directions and/or 
% landing direction dictates the orientation of the map - do for all mice,
% AND as a whole
% The answer is NO by eye - just need to do stats!!! Separate for square
% and circle - use only 90 degree increments for square and all 360 for
% circle? 22.5 degree bins? anova of probability of using
%
% Why are there so few values for G45 - are there that few mismatch pairs?
% Only for circle. There are 19 for square...

if plot_entry
    
for j = 1:5; try close(hf(j)); end; end

nbins = 24; % bin_size = 22.5;
hf(1) = figure(105);  set(gcf,'Position', [2100, 122, 1266, 748]);
for j = 1:4
    hf(j+1) = figure(105+j); 
%     set(gcf,'Position', [2100, 122, 1266, 748]); 
end

figure(hf(1))

% Plot pf_rot - delta entr side for all mice
rot_vs_entry_ang_sq = delta_angle_med_sq - squeeze(dtheta_sq(:,1,:,:));
sq_shuf = reshape(delta_angle_med_sq - squeeze(dtheta_shuf_sq(:,1,:,:,:)),...
    [],8,nshuf);
rot_vs_entry_ang_oct = delta_angle_med_oct - squeeze(dtheta_oct(:,1,:,:));
oct_shuf = reshape(delta_angle_med_oct - squeeze(dtheta_shuf_oct(:,1,:,:,:)),...
    [],8,nshuf);
[p1sq,hsq] = twoenv_plot_entry_hist(rot_vs_entry_ang_sq,...
    sq_shuf,bin_size,subplot(2,2,1),false);
hold on
[p1oct,hoct] = twoenv_plot_entry_hist(rot_vs_entry_ang_oct,...
    oct_shuf,bin_size,subplot(2,2,1),false);
legend(cat(1,hsq,hoct),{'Square','Circle'})
title('\Delta_{pf} vs \Delta_{\theta,entry}')

% Plot pf rot - delta entry_dir for all mice
rot_vs_entrydir_ang_sq = delta_angle_med_sq - squeeze(dtheta_sq(:,2,:,:));
sq_shuf = reshape(delta_angle_med_sq - squeeze(dtheta_shuf_sq(:,2,:,:,:)),...
    [],8,nshuf);
rot_vs_entrydir_ang_oct = delta_angle_med_oct - squeeze(dtheta_oct(:,2,:,:));
oct_shuf = reshape(delta_angle_med_oct - squeeze(dtheta_shuf_oct(:,2,:,:,:)),...
    [],8,nshuf);
[p2sq,hsq] = twoenv_plot_entry_hist(rot_vs_entrydir_ang_sq,...
    sq_shuf,bin_size,subplot(2,2,2),false);
hold on
[p2oct,hoct] = twoenv_plot_entry_hist(rot_vs_entrydir_ang_oct,...
    oct_shuf,bin_size,subplot(2,2,2),false);
legend(cat(1,hsq,hoct),{'Square','Circle'})
title('\Delta_{pf} vs \Delta_{\theta,entrydir}')

% plot pf_rot vs delta land direction
subplot(2,2,3);
rot_vs_landdir_ang_sq = delta_angle_med_sq - squeeze(dtheta_sq(:,3,:,:));
sq_shuf = reshape(delta_angle_med_sq - squeeze(dtheta_shuf_sq(:,3,:,:,:)),...
    [],8,nshuf);
rot_vs_landdir_ang_oct = delta_angle_med_oct - squeeze(dtheta_oct(:,3,:,:));
oct_shuf = reshape(delta_angle_med_oct - squeeze(dtheta_shuf_oct(:,3,:,:,:)),...
    [],8,nshuf);
[p3sq,hsq] = twoenv_plot_entry_hist(rot_vs_landdir_ang_sq,...
    sq_shuf,bin_size,subplot(2,2,3),false);
hold on
[p3oct,hoct] = twoenv_plot_entry_hist(rot_vs_landdir_ang_oct,...
    oct_shuf,bin_size,subplot(2,2,3),false);
legend(cat(1,hsq,hoct),{'Square','Circle'})
title('\Delta_{pf} vs \Delta_{\theta,landdir}')

subplot(2,2,4);
text(0.1,0.9,['p_{sq,entry} = ' num2str(p1sq,'%0.02f')])
text(0.1,0.8,['p_{oct,entry} = ' num2str(p1oct,'%0.02f')])
text(0.1,0.6,['p_{sq,entry,dir} = ' num2str(p2sq,'%0.02f')])
text(0.1,0.5,['p_{oct,entry,dir} = ' num2str(p2oct,'%0.02f')])
text(0.1,0.3,['p_{sq,land,dir} = ' num2str(p3sq,'%0.02f')])
text(0.1,0.2,['p_{oct,land,dir} = ' num2str(p3oct,'%0.02f')])
title('Shuffle test results')
axis off

printNK('Entry and land dir rot vs pf rot - All Mice','2env')

%%
for j = 1:4
    figure(hf(j+1))
    a = rot_vs_entry_ang_sq(j,:,:);
    ashuf = squeeze(delta_angle_med_sq(j,:,:)) - ...
        squeeze(dtheta_shuf_sq(j,1,:,:,:));
    p = twoenv_plot_entry_hist( a(mismatch_bool_all_sq(j,:,:)), ...
        ashuf, bin_size, subplot(2,3,1));
    title({'\Delta_{pf} vs \Delta_{\theta,entry}, square',...
        ['p_0 = ' num2str(p,'%0.2f')]})
    b = rot_vs_entry_ang_oct(j,:,:);
    bshuf = squeeze(delta_angle_med_oct(j,:,:)) - ...
        squeeze(dtheta_shuf_oct(j,1,:,:,:));
    p = twoenv_plot_entry_hist( b(mismatch_bool_all_oct(j,:,:)), ...
        bshuf, bin_size, subplot(2,3,4));
    title({'\Delta_{pf} vs \Delta_{\theta,entry}, oct',...
        ['p_0 = ' num2str(p,'%0.2f')]})
    
    a = rot_vs_entrydir_ang_sq(j,:,:);
    ashuf = squeeze(delta_angle_med_sq(j,:,:)) - ...
        squeeze(dtheta_shuf_sq(j,2,:,:,:));
    p = twoenv_plot_entry_hist( a(mismatch_bool_all_sq(j,:,:)), ...
        ashuf, bin_size, subplot(2,3,2));
    title({'\Delta_{pf} vs \Delta_{\theta,entrydir}, square',...
        ['p_0 = ' num2str(p,'%0.2f')]})
    b = rot_vs_entrydir_ang_oct(j,:,:);
    bshuf = squeeze(delta_angle_med_oct(j,:,:)) - ...
        squeeze(dtheta_shuf_oct(j,2,:,:,:));
    p = twoenv_plot_entry_hist( b(mismatch_bool_all_oct(j,:,:)), ...
        bshuf, bin_size, subplot(2,3,5));
    title({'\Delta_{pf} vs \Delta_{\theta,entrydir}, oct',...
        ['p_0 = ' num2str(p,'%0.2f')]})
    
    a = rot_vs_landdir_ang_sq(j,:,:);
    ashuf = squeeze(delta_angle_med_sq(j,:,:)) - ...
        squeeze(dtheta_shuf_sq(j,3,:,:,:));
    p = twoenv_plot_entry_hist( a(mismatch_bool_all_sq(j,:,:)), ...
        ashuf, bin_size, subplot(2,3,3));
    title({'\Delta_{pf} vs \Delta_{\theta,landdir}, oct',...
        ['p_0 = ' num2str(p,'%0.2f')]})
    b = rot_vs_landdir_ang_oct(j,:,:);
     bshuf = squeeze(delta_angle_med_oct(j,:,:)) - ...
        squeeze(dtheta_shuf_oct(j,3,:,:,:));
    [p, ~, hshuf_CI, hshuf_mean] = twoenv_plot_entry_hist( b(mismatch_bool_all_oct(j,:,:)), ...
        bshuf, bin_size, subplot(2,3,6));
    title({'\Delta_{pf} vs \Delta_{\theta,landdir}, sq',...
        ['p_0 = ' num2str(p,'%0.2f')]})
    legend(cat(1,hshuf_CI(1),hshuf_mean),{'95% CI shuffled','shuffled mean'})
    printNK(['Entry and land dir rot vs pf rot - Mouse ' num2str(j)],'2env')
    
end

end
%% NK revisit this - plot probability of having a mismatch rotation versus time b/w sessions
sq_time_diff = make_timediff_mat(G30_square);
oct_time_diff = make_timediff_mat(G30_oct);


