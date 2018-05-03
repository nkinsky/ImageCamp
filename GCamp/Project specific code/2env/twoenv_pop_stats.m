% Two-env population statistics - # coherent vs # remapping for all
% mice/sessions, silent-to-active and active-to-silent analysis per
% reviewer 4 comment, etc.
MD = MakeMouseSessionListNK('Nat');

%% Coherent cell count/ratio
% Get # coherent for all conditions
% Play around with different parameters for angle (22.5 and 45). 22.5 is
% the answer.
% Play around with PCfilter or not - do we see much higher ratios for place
% cells only?
% Get metric for how cells remap from 1st to 2nd half of session? could
% answer "highly dependent" vs "coherent" comment.
% Need to break this down by coherent vs global remapping sessions too.
% Only include coherent sessions. Also, need to break down by time between
% sessions

%% Get within arena coherent counts
PCfilter = false;
coh_ang_thresh = 30;
nshuf = 1000;

coh_ratio_sq = nan(4,8,8);
pshuf_sq = nan(4,8,8);
ncells_sq = nan(4,8,8);
tic
for j = 1:4
    [~, ~, ~, pshuf_sq(j,:,:), ncells_sq(j,:,:), coh_ratio_sq(j,:,:)] = ...
        plot_pfangle_batch(...
        all_square2(j,:), [], nshuf, PCfilter, coh_ang_thresh, false);
end
gr_bool_sq = pshuf_sq > 0.05/28;

coh_ratio_oct = nan(4,8,8);
pshuf_oct = nan(4,8,8);
ncells_oct = nan(4,8,8);
for j = 1:4
    [~, ~, ~, pshuf_oct(j,:,:), ncells_oct(j,:,:), coh_ratio_oct(j,:,:)] = ...
        plot_pfangle_batch(...
        all_oct2(j,:), [], nshuf, PCfilter, coh_ang_thresh, false);
end
toc

gr_bool_oct = pshuf_oct > 0.05/28;

coh_ratio_all = cat(1, coh_ratio_sq, coh_ratio_oct);
gr_bool_all = cat(1, gr_bool_sq, gr_bool_oct);
ncells_all = cat(1, ncells_sq, ncells_oct);

oct_time_mat = shiftdim(repmat(make_timediff_mat(G30_oct),1,1,4),2);
sq_time_mat = shiftdim(repmat(make_timediff_mat(G30_square),1,1,4),2);
all_time_mat = cat(1,sq_time_mat,oct_time_mat);
%% Time plots
try close(401); end %#ok<*TRYNC>
[gp_sq, ug_sq, ind_sq] = group_mat(coh_ratio_sq, sq_time_mat);
[gp_oct, ug_oct, ind_oct] = group_mat(coh_ratio_oct, oct_time_mat);
gr_gp_sq = gr_bool_sq(cat(1,ind_sq{:}));
gr_gp_oct = gr_bool_oct(cat(1,ind_oct{:}));
figure(401); set(gcf,'Position', [2060 180 1750 660]);
set(gcf,'Name',['PCfilter = ' num2str(PCfilter) ' coh_ang_thresh = ' ...
    num2str(round(coh_ang_thresh))])
hsq = subplot(2,3,1);
scatterBox(cat(1,gp_sq{:}), sq_time_mat(cat(1, ind_sq{:})), 'h', hsq, ...
    'xLabel', arrayfun(@num2str, ug_sq, 'UniformOutput', false), ...
    'yLabel', 'Coherent Ratio');
xlabel('Days between session')
title(['Square - All Mice - ang\_thresh = ' num2str(coh_ang_thresh) ...
    ' PCfilt = ' num2str(PCfilter)])
ylim_use = get(gca,'YLim'); xlim_use = get(gca,'XLim');
hold on
plot(xlim_use,ones(1,2)*coh_ang_thresh*2/360,'k--')
ylim([0 ylim_use(2)])
hold off

hoct = subplot(2,3,2);
scatterBox(cat(1,gp_sq{:}), oct_time_mat(cat(1, ind_oct{:})), 'h', hoct, ...
    'xLabel', arrayfun(@num2str, ug_oct, 'UniformOutput', false), ...
    'yLabel', 'Coherent Ratio');
xlabel('Days between session')
title(['Oct - All Mice - ang\_thresh = ' num2str(coh_ang_thresh) ...
    ' PCfilt = ' num2str(PCfilter)])
ylim_use = get(gca,'YLim'); xlim_use = get(gca,'XLim');
hold on
plot(xlim_use,ones(1,2)*coh_ang_thresh*2/360,'k--')
ylim([0 ylim_use(2)])
hold off

hcomb = subplot(2,3,3);
gp_all = cat(1,gp_sq{:},gp_oct{:});
time_all = cat(1, sq_time_mat(cat(1, ind_sq{:})), oct_time_mat(cat(1, ind_oct{:})));
scatterBox(gp_all, time_all, 'h', hcomb, ...
    'xLabel', arrayfun(@num2str, ug_oct, 'UniformOutput', false), ...
    'yLabel', 'Coherent Ratio');
xlabel('Days between session')
title(['Sq/Circ Combined - All Mice - ang\_thresh = ' num2str(coh_ang_thresh) ...
    ' PCfilt = ' num2str(PCfilter)])
ylim_use = get(gca,'YLim'); xlim_use = get(gca,'XLim');
hold on
plot(xlim_use,ones(1,2)*coh_ang_thresh*2/360,'k--')
ylim([0 ylim_use(2)])
hold off

% Now just plot some histograms - one of absolute numbers, the other of
% ratios of cells that are coherent and those that remap - put dashed line
% at chance (2*coh_ang_thresh/360)
nbins = 30;
subplot(2,3,4)
hold off
hcoh = histogram(coh_ratio_all(:)*100,'BinLimits',[0 100]);
ylim_use = get(gca,'YLim');
hold on
hchance = plot(ones(1,2)*2*coh_ang_thresh/360*100, ylim_use, 'k--');
xlabel(['Pct. of Cells w/in ' num2str(coh_ang_thresh,'%0.1f') ...
    ' of mean rot. angle'])
ylabel('Number of session-pairs')
[ht,pt] = ttest(coh_ratio_all(:),2*coh_ang_thresh/360,'tail','right');
legend(hchance,['p_t > Chance = ' num2str(pt,'%0.2g')],...
    'Location','NorthWest')
title(['PCfilter = ' num2str(PCfilter)])
make_plot_pretty(gca)

coh_num_all = coh_ratio_all.*ncells_all;
gr_num_all = ncells_all - coh_num_all;

subplot(2,3,5)
hcohn = histogram(coh_num_all(:),0:12.5:175);
hold on;
hgrn = histogram(gr_num_all(:), hcohn.BinEdges);
xlabel('Num. Cells')
legend(cat(1,hcohn,hgrn),{['< ' num2str(coh_ang_thresh,'%0.1f') ' from mean'],...
    ['>= ' num2str(coh_ang_thresh,'%0.1f') ' from mean']})
ylabel('Number of session-pairs')
title(['PCfilter = ' num2str(PCfilter)])
[hks,pks] = kstest2(coh_num_all(:), gr_num_all(:),'tail','smaller');
text(100,40,['p_{ks}(1-sided) = ' num2str(pks,'%0.2g')])
make_plot_pretty(gca)

coh_num_sq = coh_ratio_sq.*ncells_sq;
gr_num_sq = ncells_sq - coh_num_sq;
coh_num_oct = coh_ratio_oct.*ncells_oct;
gr_num_oct = ncells_oct - coh_num_oct;

h = subplot(2,3,6);
[~, dmean] = plot_delta_angle_hist(G30_square(1), G30_square(4), G30_square(1),...
    'h', h, 'PCfilter', PCfilter, 'nshuf', nshuf, 'coh_ang_thresh', ...
    coh_ang_thresh); hold on
ylim_use = get(gca,'YLim');
sum_lims = dmean + [-coh_ang_thresh coh_ang_thresh];
sum_lims(sum_lims < 0) = sum_lims(sum_lims < 0) + 360;
sum_lims(sum_lims > 360) = sum_lims(sum_lims > 360) - 360;
plot(ones(1,2)*sum_lims(1),ylim_use, 'k-.', ...
    ones(1,2)*sum_lims(2),ylim_use, 'k-.',...
    ones(1,2)*dmean,ylim_use, 'k-')
make_plot_pretty(gca)
%%
printNK(['Population Statistics Breakdown PCfilt_' num2str(PCfilter) ...
    'ang_thresh_' num2str(round(coh_ang_thresh))],'2env')
