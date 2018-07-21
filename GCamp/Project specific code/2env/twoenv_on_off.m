%% Two-env on/off analysis

% IMPORTANT NOTE: NO SILENT CELLS INCLUDED IN PVs yet...
% Compare # cells turning on/off entirely between square and circle days
% 1-2 and 3-4  and 7-8 versus those staying on in circle days 2-3 to see how much
% going into a different arena causes new cells to come online.
% Next, do the same but for same day comparisons: 1,2,3,4,7,8 within and
% 5,6 across arenas. include cells with DI = -1/1 too?

% Run plot_pfangle_batch w/plot_flag=false, no PCfilter and nto get coh_ratio and gr_ratio
% and ncells for each session-pair. Better yet, just run twoenv_mismatch first and 
% twoenv_pop_stats.
% Then run classify_cells with batch_session_map for each session pair and 
% get new/old ratio. Then make a breakdown for each session of: #coh, #gr,
% #silent, #new. Then aggregate this breakdown for all coherent and all global
% remapping sessions on the same day (maybe 1-3 days lag?). 
% Show that there is no difference for local vs mismatch pairs.

load_existing = true; % Set to false if you want to run from scratch, true = run existing files
filt_use = 'none';

%% Get silent/new cells for square
if ~load_existing
good_map_sq = cell(4,8,8);
become_silent_sq = cell(4,8,8);
new_cells_sq = cell(4,8,8);
p = ProgressBar(4*28);
for j = 1:4
    
    load(fullfile(all_square2(j,1).Location,'batch_session_map.mat'));
    batch_map = fix_batch_session_map(batch_session_map);
    for k = 1:7
        for ll = (k+1):8
            [good_map_sq{j,k,ll}, become_silent_sq{j,k,ll}, new_cells_sq{j,k,ll}] = ...
                classify_cells(all_square2(j,k), all_square2(j,ll),0,...
                '', 'batch_map',batch_map);
            p.progress;
        end
    end
    
end
p.stop;

% Ditto for Octagon
good_map_oct = cell(4,8,8);
become_silent_oct = cell(4,8,8);
new_cells_oct = cell(4,8,8);
p = ProgressBar(4*28);
for j = 1:4
    
    load(fullfile(all_oct2(j,1).Location,'batch_session_map.mat'));
    batch_map = fix_batch_session_map(batch_session_map);
    for k = 1:7
        for ll = (k+1):8
            [good_map_oct{j,k,ll}, become_silent_oct{j,k,ll}, new_cells_oct{j,k,ll}] = ...
                classify_cells(all_oct2(j,k), all_oct2(j,ll),0,...
                '', 'batch_map',batch_map);
            p.progress;
        end
    end
    
end
p.stop;

% Ditto for circ2square
good_map_c2s = cell(4,8,8);
become_silent_c2s = cell(4,8,8);
new_cells_c2s = cell(4,8,8);
p = ProgressBar(4*28);
for j = 1:4
    
    load(fullfile(all_square2(j,1).Location,'batch_session_map_trans.mat'));
    batch_map = fix_batch_session_map(batch_session_map);
    for k = 1:8
        for ll = 1:8
            [good_map_c2s{j,k,ll}, become_silent_c2s{j,k,ll}, new_cells_c2s{j,k,ll}] = ...
                classify_cells(all_square2(j,k), all_oct2(j,ll),0,...
                '', 'batch_map',batch_map);
            p.progress;
        end
    end
    
end
p.stop;

% use ncells for total number of cells for each session, NOT length
% good_map since ncells only includes cells active above the speed
% threshold.

save(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    ['2env_cell_classications-' datestr(now,29) '.mat']),'become_silent_sq',...
    'new_cells_sq', 'become_silent_oct', 'new_cells_oct', ...
    'become_silent_c2s', 'new_cells_c2s');
else
    load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
        '2env_cell_classications-2018-05-08.mat'))
end

%% Get DI
% Need to calc PVs for each session too to get DI!!! Run twoenv_scratchpad
% with pval_filt = 0 and ntrans_thresh = 0.

if strcmpi(filt_use,'none')
%     load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
%         '2env_PVsilent_cm4_local0-0shuffles-2018-05-03.mat'));
    load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
        '2env_PVsilent_cm4_local0-1000shuffles-2018-05-24.mat'));
elseif strcmpi(filt_use,'pval')
    load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
        '2env_PVsilent_cm4_local0-1000shuffles-2018-01-06.mat'));
end
DIcutoff = 1; % cutoff of DI to be considered "silent" or "rate remapping"
arena = {'square', 'circle', 'circ2square'};
PVcorrs_all = nan(3,4,8,8,3); % arena x mouse x sesh x sesh x filter_type
for j = 1:4
    for m = 1:3 % arena
        for k = 1:2 % :3 % silent cell thresholds (nan, 0, 1) use 1:2 eventually
            PVuse = Mouse(j).PVcorrs.(arena{m})(k).PV;
            PVmax = cellfun(@(a) nanmax(reshape(a,2,[],size(a,4)),[],2), ...
                PVuse,'UniformOutput',false);
            DItemp = cellfun(@(a) get_discr_ratio(a(1,:),a(2,:)),PVmax,...
                'UniformOutput', false);
            Mouse(j).DI.(arena{m})(k).DI = DItemp;
            PVcorrs_all(m,j,:,:,k) = Mouse(j).PVcorrs.(arena{m})(k).PVcorrs;
        end
    end
    
end

%% Get CIs
CIall = nan(3,8,8,3,4); % arena x sesh x sesh x CI x animal
for j = 1:4
    for m = 1:3
        for k = 1
            shuf_corrs_use = Mouse(j).PVcorrs.(arena{m})(k).PVshuf_corrs;
            CIall(m,:,:,1,j) = quantile(shuf_corrs_use,0.975,3);
            CIall(m,:,:,2,j) = mean(shuf_corrs_use,3);
            CIall(m,:,:,3,j) = quantile(shuf_corrs_use,0.025,3);
        end
    end
end

CIall_mean = squeeze(nanmean(CIall,5));
%% Breakdown of coh v remap vs on vs off for circ2square - follow up with square and circle
% Then get breakdown as above for 0 day within vs across (hallway
% comparison), and 1 day within (day 2-3) vs across (day 1-2, 3-4, 7-8).
% Should characterize how much basal on/off stuff is going on vs remapping
% vs coherency. on = DI == 1 OR new cells from registration, off = DI == -1 or
% silent cell from registration
load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_popstats_coh30_shuf1000-2018-05-05.mat'));

cell_cat_breakdown_c2s = nan(4,8,8,4); % mice x sesh_sq x sesh_oct x cat (ncoh, ngr, n_on, n_off)
for j = 1:4
    ncoh = squeeze(coh_ratio_c2s(j,:,:)).*squeeze(ncells_c2s(j,:,:)); % c
    ngr = squeeze(ncells_c2s(j,:,:)) - ncoh;
    n_on = cellfun(@(a) sum(a == 1), Mouse(j).DI.circ2square(1).DI(1:8,1:8));
    n_off = cellfun(@(a) sum(a == -1), Mouse(j).DI.circ2square(1).DI(1:8,1:8));
    nsilent = cellfun(@length, squeeze(become_silent_c2s(j,:,:)));
    nnew = cellfun(@length, squeeze(new_cells_c2s(j,:,:)));
    cell_cat_breakdown_c2s(j,:,:,:) = cat(3, ncoh, ngr, n_on + nnew, n_off + nsilent);
end

cell_cat_breakdown_sq = nan(4,8,8,4); % mice x sesh_sq x sesh_sq x cat (ncoh, ngr, n_on, n_off)
for j = 1:4
    ncoh = squeeze(coh_ratio_sq(j,:,:)).*squeeze(ncells_sq(j,:,:)); % c
    ngr = squeeze(ncells_sq(j,:,:)) - ncoh;
    n_on = cellfun(@(a) sum(a == 1), Mouse(j).DI.square(1).DI(1:8,1:8));
    n_off = cellfun(@(a) sum(a == -1), Mouse(j).DI.square(1).DI(1:8,1:8));
    nsilent = cellfun(@length, squeeze(become_silent_sq(j,:,:)));
    nnew = cellfun(@length, squeeze(new_cells_sq(j,:,:)));
    cell_cat_breakdown_sq(j,:,:,:) = cat(3, ncoh, ngr, n_on + nnew, n_off + nsilent);
end

cell_cat_breakdown_oct = nan(4,8,8,4); % mice x sesh_oct x sesh_oct x cat (ncoh, ngr, n_on, n_off)
for j = 1:4
    ncoh = squeeze(coh_ratio_oct(j,:,:)).*squeeze(ncells_oct(j,:,:)); % c
    ngr = squeeze(ncells_oct(j,:,:)) - ncoh;
    n_on = cellfun(@(a) sum(a == 1), Mouse(j).DI.circle(1).DI(1:8,1:8));
    n_off = cellfun(@(a) sum(a == -1), Mouse(j).DI.circle(1).DI(1:8,1:8));
    nsilent = cellfun(@length, squeeze(become_silent_oct(j,:,:)));
    nnew = cellfun(@length, squeeze(new_cells_oct(j,:,:)));
    cell_cat_breakdown_oct(j,:,:,:) = cat(3, ncoh, ngr, n_on + nnew, n_off + nsilent);
end


% This gives me a breakdown for all circ2square sessions. Can do the same
% for circle and square sessions and compare 0 day and 1 day apart.

%% Make plot for connected day
try close(302); end
day5 = squeeze(cell_cat_breakdown_c2s(:,5,5,:))./...
    sum(squeeze(cell_cat_breakdown_c2s(:,5,5,:)),2);
day6 = squeeze(cell_cat_breakdown_c2s(:,6,6,:))./...
    sum(squeeze(cell_cat_breakdown_c2s(:,6,6,:)),2);
bw0_dur_prop = cat(1,day5,day6);

figure(302)
set (gcf,'Position', [2025, 50, 1890, 800])
subplot(2,4,1)
bar(mean(bw0_dur_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(bw0_dur_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), bw0_dur_prop(:))
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class circ2square on CONN1 and CONN2')
ylabel('Proportion')

[pconn, ~, statsconn] = kruskalwallis(bw0_dur_prop(:), xvals(:), 'off');
cconn = multcompare(statsconn,'display','off');

% Make plot for same arena 0 days apart
sq1 = reshape(cell_cat_breakdown_sq(:,1,2,:),[],4);
sq2 = reshape(cell_cat_breakdown_sq(:,3,4,:),[],4);
sq3 = reshape(cell_cat_breakdown_sq(:,7,8,:),[],4);
oct1 = reshape(cell_cat_breakdown_oct(:,1,2,:),[],4);
oct2 = reshape(cell_cat_breakdown_oct(:,3,4,:),[],4);
oct3 = reshape(cell_cat_breakdown_oct(:,7,8,:),[],4);
win0_all = cat(1, sq1, sq2, sq3, oct1, oct2, oct3);
win0_all_prop = win0_all./sum(win0_all,2);
win0_day3_prop = win0_all_prop([9:12, 21:24],:);

subplot(2,4,2)
bar(mean(win0_all_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(win0_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
hb = scatter(xvaloff(:), win0_all_prop(:));
xvaloff3 = xvaloff([9:12, 21:24],:);
ha = scatter(xvaloff3(:),win0_day3_prop(:),[],'r');
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class within arena same day')
ylabel('Proportion')
legend(cat(1,ha,hb),{'Bef. Conn', 'Aft. Conn'})

% Combine same day plots into one plot - note that same arena comparisons
% are for individual arenas only whereas different arena comparisons are on
% connected days only
subplot(2,4,3)
hbar = bar([mean(win0_all_prop,1); mean(bw0_dur_prop,1) ]' ); xlim([0 5]);
hold on
xvals = repmat(1:4,size(win0_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hwin = scatter(xvaloff(:), win0_all_prop(:),[],'k');
xvals = repmat(1:4,size(bw0_dur_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02+hbar(2).XOffset;
hbw = scatter(xvaloff(:), bw0_dur_prop(:),[],'k');
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class - Same Day (Diff Arena connected)')
ylabel('Proportion')
hchance = plot([-0.4 0 0 0.4]+hbar(1).XData(1), [ones(1,2)*sum(hbar(1).YData(1:2))/6 ,...
    ones(1,2)*sum(hbar(2).YData(1:2))/6],'k--');
legend(cat(2,hbar,hchance),{'Same Arena', 'Diff. Arena', 'Chance'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

% Run stats on above
pcoh_rks = ranksum(win0_all_prop(:,1),bw0_dur_prop(:,1));
pgr_rks = ranksum(win0_all_prop(:,2),bw0_dur_prop(:,2));
pon_rks = ranksum(win0_all_prop(:,3),bw0_dur_prop(:,3));
poff_rks = ranksum(win0_all_prop(:,4),bw0_dur_prop(:,4));
ponoff_win_rks = ranksum(win0_all_prop(:,3),win0_all_prop(:,4));
ponoff_bw_rks = ranksum(bw0_dur_prop(:,3),bw0_dur_prop(:,4));
pcoh_win = signtest(win0_all_prop(:,1), sum(hbar(1).YData(1:2))/6);
pcoh_bw = signtest(bw0_dur_prop(:,1), sum(hbar(2).YData(1:2))/6);

subplot(2,4,4)
title('ranksum test results')
text(0.1,0.9,['p_{coh} diff = ' num2str(pcoh_rks,'%0.3g')])
text(0.1,0.8,['p_{gr} diff = ' num2str(pgr_rks,'%0.3g')])
text(0.1,0.7,['p_{on} diff = ' num2str(pon_rks,'%0.3g')])
text(0.1,0.6,['p_{off} diff = ' num2str(poff_rks,'%0.3g')])
text(0.1,0.5,['p_{on~=off,win} = ' num2str(ponoff_win_rks,'%0.3g')])
text(0.1,0.4,['p_{on~=off,bw} = ' num2str(ponoff_bw_rks,'%0.3g')])
text(0.1,0.3, ['p_{coh,win} > chance = ' num2str(pcoh_win, '%0.3g')])
text(0.1,0.2, ['p_{coh,bw} > chance = ' num2str(pcoh_bw, '%0.3g')])
axis off

% Make plot for c2s 1 day apart
c2s1 = reshape(cell_cat_breakdown_c2s(:,1:2,1:2,:),[],4);
c2s2 = reshape(cell_cat_breakdown_c2s(:,3:4,3:4,:),[],4);
c2s3 = reshape(cell_cat_breakdown_c2s(:,7:8,7:8,:),[],4);
bw1_all = cat(1,c2s1,c2s2,c2s3);
bw1_all_prop = bw1_all./sum(bw1_all,2);
bw1_aft_prop = bw1_all_prop(33:48,:);
PV1 = reshape(PVcorrs_all(3,:,1:2,1:2,1),[],1);
PV2 = reshape(PVcorrs_all(3,:,3:4,3:4,1),[],1);
PV3 = reshape(PVcorrs_all(3,:,7:8,7:8,1),[],1);
PV_bw1_ba = cat(1, PV1, PV2, PV3);

CI1 = squeeze(CIall_mean(3,1:2,1:2,:));
CI2 = squeeze(CIall_mean(3,3:4,3:4,:));
CI3 = squeeze(CIall_mean(3,7:8,7:8,:));
CIcomb_bw1_ba = cat(4,CI1,CI2,CI3);
CI_bw1_ba = mean(mean(reshape(CIcomb_bw1_ba,[],3,3),3),1);

% Assemble CIs for
subplot(2,4,5)
bar(mean(bw1_all_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(bw1_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
hb = scatter(xvaloff(:), bw1_all_prop(:));
xvaloffa = xvaloff(33:48,:);
ha = scatter(xvaloffa(:),bw1_aft_prop(:),[],'r');
legend(cat(1,hb,ha),{'Bef.Conn','Aft. Conn'})
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class circ2square Sq1 v Cir1, Sq2 v Cir2, Sq3 v Cir3')
ylabel('Proportion')

[pc2s1, ~, statc2s1] = kruskalwallis(bw1_all_prop(:), xvals(:), 'off');
c_c2s1 = multcompare(statsconn,'display','off');

% Make plot for same arena 1 days apart (octagon only)
win1_1 = reshape(cell_cat_breakdown_oct(:,2:3,2:3,:),[],4);
win1_2 = reshape(cell_cat_breakdown_oct(:,[2 4],[2 4],:),[],4);
win1_3 = reshape(cell_cat_breakdown_oct(:,[1 4],[1 4],:),[],4);
win1_4 = reshape(cell_cat_breakdown_oct(:,[1 3],[1 3],:),[],4);
win1_all = cat(1, win1_1, win1_2, win1_3, win1_4);
win1_all_prop = win1_all./sum(win1_all,2);
PVw1 = reshape(PVcorrs_all(2,:,2:3,2:3,1),[],1);
PVw2 = reshape(PVcorrs_all(2,:,[2 4],[2 4],1),[],1);
PVw3 = reshape(PVcorrs_all(2,:,[1 4],[1 4],1),[],1);
PVw4 = reshape(PVcorrs_all(2,:,[1 3],[1 3],1),[],1);
PV_win1_bef = cat(1, PVw1, PVw2, PVw3, PVw4);

% Assemble CIs
CIw1 = squeeze(CIall_mean(2,1:2,1:2,:)); % pull out each session pair in oct
CIw2 = squeeze(CIall_mean(2,[2 4],[2 4],:));
CIw3 = squeeze(CIall_mean(2,[1 4],[1 4],:));
CIw4 = squeeze(CIall_mean(2,[1 3],[1 3],:));
CIwcomb = cat(4, CIw1, CIw2, CIw3, CIw4);
CI_win1_bef = nanmean(nanmean(reshape(CIwcomb,[],3,4),3),1);

subplot(2,4,6)
hold off
bar(nanmean(win1_all_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(win1_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), win1_all_prop(:))
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class within arena 1 day apart')
ylabel('Proportion')

% Combine 1 day plots - split this into two separate plots if you decide to
% include it (left = coh vs rand remap , y-axis = propotion of COACTIVE
% cells, right = on/off, y-axis = proportion of TOTAL cells
subplot(2,4,7)
hbar = bar([nanmean(win1_all_prop,1); mean(bw1_all_prop,1)]' ); xlim([0 5]);
hold on
xvals = repmat(1:4,size(win1_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hwin = scatter(xvaloff(:), win1_all_prop(:),[],'k');
xvals = repmat(1:4,size(bw1_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(2).XOffset;
hbw = scatter(xvaloff(:), bw1_all_prop(:),[],'k');
hchance = plot([-0.4 0 0 0.4]+hbar(1).XData(1), [ones(1,2)*sum(hbar(1).YData(1:2))/6 ,...
    ones(1,2)*sum(hbar(2).YData(1:2))/6],'k--');
legend(cat(2,hbar,hchance),{'Same Arena', 'Diff. Arena', 'Chance'})
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class 1 day apart')
ylabel('Proportion')
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

% Get stats
pcoh_rks = ranksum(win1_all_prop(:,1),bw1_all_prop(:,1));
pgr_rks = ranksum(win1_all_prop(:,2),bw1_all_prop(:,2));
pon_rks = ranksum(win1_all_prop(:,3),bw1_all_prop(:,3));
poff_rks = ranksum(win1_all_prop(:,4),bw1_all_prop(:,4));
ponoff_win_rks = ranksum(win1_all_prop(:,3),win1_all_prop(:,4));
ponoff_bw_rks = ranksum(bw1_all_prop(:,3),bw1_all_prop(:,4));
pcoh_win = signtest(win1_all_prop(:,1), sum(hbar(1).YData(1:2))/6);
pcoh_bw = signtest(bw1_all_prop(:,1), sum(hbar(2).YData(1:2))/6);

subplot(2,4,8)
title('ranksum test results')
text(0.1,0.9,['p_{coh} diff = ' num2str(pcoh_rks,'%0.3g')])
text(0.1,0.8,['p_{gr} diff = ' num2str(pgr_rks,'%0.3g')])
text(0.1,0.7,['p_{on} diff = ' num2str(pon_rks,'%0.3g')])
text(0.1,0.6,['p_{off} diff = ' num2str(poff_rks,'%0.3g')])
text(0.1,0.5,['p_{on~=off,win} = ' num2str(ponoff_win_rks,'%0.3g')])
text(0.1,0.4,['p_{on~=off,bw} = ' num2str(ponoff_bw_rks,'%0.3g')])
text(0.1,0.3, ['p_{coh,win} > chance = ' num2str(pcoh_win, '%0.3g')])
text(0.1,0.2, ['p_{coh,bw} > chance = ' num2str(pcoh_bw, '%0.3g')])
text(0.1, 0.1, ['PC filter = ' filt_use])
text(0.1, 0, 'none = no pval or ntrans filt, keep all non-ambiguous silent cells')
text(0.1, -0.1, 'pval = pval < 0.05 and ntrans >= 5 only, no silent cells')
axis off

%% Make alternate plots with different axes for vertical
try close(304); end
figure(304); 
set(gcf,'Position',[1000 100 780 840])
means_plot = [nanmean(win1_all_prop,1); mean(bw1_all_prop,1)]';
means_plot1 = means_plot(1:2,:); means_plot2 = means_plot(3:4,:);
means_plot1 = means_plot1./sum(means_plot1,1);
win1_prop1 = win1_all_prop(:,1:2); win1_prop2 = win1_all_prop(:,3:4);
win1_prop1 = win1_prop1./sum(win1_prop1,2);

bw1_prop1 = bw1_all_prop(:,1:2); bw1_prop2 = bw1_all_prop(:,3:4);
bw1_prop1 = bw1_prop1./sum(bw1_prop1,2);

subplot(2,3,1)
hbar = bar(means_plot1); xlim([0 3]);
xvals = repmat(1:2,size(win1_prop1,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hold on
hwin = scatter(xvaloff(:), win1_prop1(:), 'ko');
xvals = repmat(1:2,size(bw1_prop1,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(2).XOffset;
hbw = scatter(xvaloff(:), bw1_prop1(:), 'ko');
ylim([0 0.8])
xlim([0.5 1.5])

set(gca,'XTickLabels',{'Coh', 'Rand. Remap'})
title('Cell Class Bef/After 1 Day Apart','HorizontalAlignment','left')
ylabel('Proportion Co-active Cells')
hchance = plot([0.5 1.5], [1/6 1/6],'k--');
legend(cat(2,hbar,hchance),{'Same Arena', 'Diff. Arena', 'Chance'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

subplot(2,3,2)
hbar = bar(means_plot2); xlim([0 3]);
xvals = repmat(1:2,size(win1_prop2,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hold on
hwin = scatter(xvaloff(:), win1_prop2(:), 'ko');
xvals = repmat(1:2,size(bw1_prop2,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(2).XOffset;
hbw = scatter(xvaloff(:), bw1_prop2(:), 'ko');

set(gca,'XTickLabels',{'On','Off'})
ylabel('Proportion Total Cells')
legend(hbar,{'Same Arena', 'Diff. Arena'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

subplot(2,3,3)
hbar = bar([nanmean(PV_win1_bef(:)) nanmean(PV_bw1_ba(:))]);
hold on
xvaloff = ones(size(PV_win1_bef(:))) + 0.02*randn(size(PV_win1_bef(:)));
hwin = scatter(xvaloff,PV_win1_bef(:),'ko');
xvaloff = 2*ones(size(PV_bw1_ba(:))) + 0.02*randn(size(PV_bw1_ba(:)));
hbw = scatter(xvaloff,PV_bw1_ba(:),'ko');
ylim([-0.2 0.5]); xlim([0 3])

% Plot CIs
hCI = plot([1 2], [CI_win1_bef(2), CI_bw1_ba(2)], 'k-', ...
    [1 2], [CI_win1_bef([1 3]); CI_bw1_ba([1 3])], 'k--');

set(gca,'XTickLabels',{'Same','Diff'})
legend(hCI(1:2),{'mean CI','95% CI'})
ylabel('\rho_{PV,mean}')
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

% Run stats on above
pcoh_rks = ranksum(win1_prop1(:,1), bw1_prop1(:,1));
pgr_rks = ranksum(win1_prop1(:,2), bw1_prop1(:,2));
pon_rks = ranksum(win1_prop2(:,1), bw1_prop2(:,1));
poff_rks = ranksum(win1_prop2(:,2), bw1_prop2(:,2));
ponoff_win_rks = ranksum(win1_prop2(:,1),win1_prop2(:,2));
ponoff_bw_rks = ranksum(bw1_prop2(:,1),bw1_prop2(:,2));
pcoh_win = signtest(win1_prop1(:,1), 1/6);
pcoh_bw = signtest(win1_prop2(:,1), 1/6);
pPV_rks = ranksum(PV_win1_bef(:),PV_bw1_ba(:));
pPVbw_v_95CI = signtest(PV_bw1_ba(:), CI_bw1_ba(1));
pPVwin_v_95CI = signtest(PV_win1_bef(:), CI_win1_bef(1));

subplot(2,3,4)
title('ranksum test results')
text(0.1,0.9,['p_{coh} diff = ' num2str(pcoh_rks,'%0.3g')])
text(0.1,0.8,['p_{gr} diff = ' num2str(pgr_rks,'%0.3g')])
text(0.1,0.7,['p_{on} diff = ' num2str(pon_rks,'%0.3g')])
text(0.1,0.6,['p_{off} diff = ' num2str(poff_rks,'%0.3g')])
text(0.1,0.5,['p_{on~=off,win} = ' num2str(ponoff_win_rks,'%0.3g')])
text(0.1,0.4,['p_{on~=off,bw} = ' num2str(ponoff_bw_rks,'%0.3g')])
text(0.1,0.3, ['p_{coh,win} > chance = ' num2str(pcoh_win, '%0.3g')])
text(0.1,0.2, ['p_{coh,bw} > chance = ' num2str(pcoh_bw, '%0.3g')])
axis off

subplot(2,3,5)
text(0, 0.9, ['pPVdiff = ' num2str(pPV_rks, '%0.03g')])
text(0, 0.8, ['pPVwin>95%CI = ' num2str(pPVwin_v_95CI, '%0.03g')])
text(0, 0.7, ['pPVbw>95%CI = ' num2str(pPVbw_v_95CI, '%0.03g')])
text(0, 0.3, ['PC filter = ' filt_use])
text(0, 0.2, 'none = no pval or ntrans filt, keep all non-ambiguous silent cells')
text(0, 0.1, 'pval = pval < 0.05 and ntrans >= 5 only, no silent cells')
axis off

printNK(['Cell Class 1 day apart split filt_' num2str(filt_use)],'2env')

%% Should probably only do comparison of on/off vs global remap vs coherent for
% connected days since only there can I do same day comparisons without
% needing to worry about registration artifacts.

% Delegate indices out so that everything ends up in the appropriate place
% - within arena first
mat_ind_win = [1 3; 2 4]; half_win = [1 2; 1 2]; sesh_ind_win = [9 9; 10 10];
% between arenas 2nd - yes I know this could be done more efficiently by
% concatenating everything but this makes it easier on my brain
mat_ind_bw = [1 2; 2 3; 3 4; 1 4]; half_bw = [1 1; 1 2; 2 2; 1 2];
sesh_ind_bw = [9 10; 10 9; 9 10; 9 10];

ncells_conn = nan(8,4,4);
coh_ratio_conn = nan(8,4,4);

try close(650); end; try close(651); end

for m = 0:1
    figure(650+m); set(gcf,'Position', [2000, 270 - 200*m, 1820, 700])
    for j = 1:4
        for k = 1:2
            [~, ~, ~, ~, ncells_conn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)), ...
                coh_ratio_conn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2))] = ...
                plot_delta_angle_hist(all_sessions2(j,sesh_ind_win(k,1)+2*m), ...
                all_sessions2(j,sesh_ind_win(k,2)+2*m), all_sessions2(j,1), 'circ2square', ...
                true, 'bin_size', '_half_cm1_speed1_inMD', 'nshuf', 1000, ...
                'TMap_type', 'TMap_gauss', 'half_use', half_win(k,:),...
                'coh_ang_thresh', 30, 'h', subplot(4,6,6*(j-1)+k),...
                'plot_legend', false);
        end
        
        for k = 1:4
            [~, ~, ~, ~, ncells_conn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)), ...
                coh_ratio_conn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2))] = ...
                plot_delta_angle_hist(all_sessions2(j,sesh_ind_bw(k,1)+2*m), ...
                all_sessions2(j,sesh_ind_bw(k,2)+2*m), all_sessions2(j,1), 'circ2square', ...
                true, 'bin_size', '_half_cm1_speed1_inMD', 'nshuf', 1000, ...
                'TMap_type', 'TMap_gauss', 'half_use', half_bw(k,:),...
                'coh_ang_thresh', 30,  'h', subplot(4,6,6*(j-1)+k+2),...
                'plot_legend', false);
        end
    end
end

%% Get on/off cells
% Mouseconn2 = load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
%     '2env_PV_conn_1shuffles-2018-05-09.mat'));

Mouseconn2 = load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_PV_conn_1000shuffles-2018-05-17.mat'));

n_on_conn = nan(8,4,4);
n_off_conn = nan(8,4,4);
PVconn = nan(8,4,4);
% filt_use = 'none';
for m = 0:1
    for j = 1:4
        
        PVmax = squeeze(nanmax(reshape(Mouseconn2.Mouse(j).PV.connfilt.(filt_use),8,[],...
            size(Mouseconn2.Mouse(j).PV.connfilt.(filt_use),4)),[],2));
        PVcorrs = Mouseconn2.Mouse(j).PV_corrs.conn.(filt_use).PV_corr_mean;
        for k = 1:2
            DItemp = get_discr_ratio(PVmax(mat_ind_win(k,1)+4*m,:), ...
                PVmax(mat_ind_win(k,2)+4*m,:));
            n_on_conn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                sum(DItemp == 1);
            n_off_conn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                sum(DItemp == -1);
            PVconn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                PVcorrs(mat_ind_win(k,1)+4*m, mat_ind_win(k,2)+4*m);
        end
        
        for k = 1:4
            DItemp = get_discr_ratio(PVmax(mat_ind_bw(k,1)+4*m,:), ...
                PVmax(mat_ind_bw(k,2)+4*m,:));
            n_on_conn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                sum(DItemp == 1);
            n_off_conn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                sum(DItemp == -1);
            PVconn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                PVcorrs(mat_ind_bw(k,1)+4*m,mat_ind_bw(k,2)+4*m);
        end
    end
end

%% Get confidence intervals
CIconn = nan(4,8,8,3);
for j = 1:4
    mean_shuf = nanmean(reshape(Mouseconn2.Mouse(j).PV_corrs.conn.(filt_use)...
        .PV_corr_binshuffle,8,8,[],1000),3); % get mean of all spatial bin shuffle values for each shuffle
    CIconn(j,:,:,1) = quantile(mean_shuf,0.975,4);
    CIconn(j,:,:,3) = quantile(mean_shuf,0.025,4);
    CIconn(j,:,:,2) = mean(mean_shuf,4);
end

CIconn0 = cat(1,CIconn(:,1:4,1:4,:),CIconn(:,5:8,5:8,:));
CIconn01_mean = squeeze(mean(CIconn,1));
CIconn0_mean = squeeze(mean(CIconn0,1));

%% Reshape indices to make pulling out data easier
coh_ratio_conn_rs = reshape(coh_ratio_conn,8,[]);
ncells_conn_rs = reshape(ncells_conn,8,[]);
n_on_conn_rs = reshape(n_on_conn,8,[]);
n_off_conn_rs = reshape(n_off_conn,8,[]);
PVconn_rs = reshape(PVconn,8,[]);
CIconn0_mean_rs = reshape(CIconn0_mean,[],3);
win_inds = sub2ind([4,4],mat_ind_win(:,1),mat_ind_win(:,2));
bw_inds = sub2ind([4,4],mat_ind_bw(:,1),mat_ind_bw(:,2));

ncoh_conn_win = coh_ratio_conn_rs(:,win_inds).*ncells_conn_rs(:,win_inds);
ngr_conn_win = ncells_conn_rs(:,win_inds) - ncoh_conn_win;
non_conn_win = n_on_conn_rs(:,win_inds);
noff_conn_win = n_off_conn_rs(:,win_inds);
PVconn0_win = PVconn_rs(:,win_inds);

ncoh_conn_bw = coh_ratio_conn_rs(:,bw_inds).*ncells_conn_rs(:,bw_inds);
ngr_conn_bw = ncells_conn_rs(:,bw_inds) - ncoh_conn_bw;
non_conn_bw = n_on_conn_rs(:,bw_inds);
noff_conn_bw = n_off_conn_rs(:,bw_inds);
PVconn0_bw = PVconn_rs(:,bw_inds);

conn0_win_breakdown = cat(2, ncoh_conn_win(:), ngr_conn_win(:), ...
    non_conn_win(:), noff_conn_win(:));
conn0_win_prop = conn0_win_breakdown./sum(conn0_win_breakdown,2);
conn0_bw_breakdown = cat(2, ncoh_conn_bw(:), ngr_conn_bw(:), ...
    non_conn_bw(:), noff_conn_bw(:));
conn0_bw_prop = conn0_bw_breakdown./sum(conn0_bw_breakdown,2);

try close(303); end
figure(303)
set (gcf,'Position', [2026, 54, 1500, 800])

subplot(2,3,1)
bar(mean(conn0_win_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(conn0_win_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), conn0_win_prop(:))
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class Same Arena CONN1 CONN2')
ylabel('Proportion')

subplot(2,3,2)
bar(mean(conn0_bw_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(conn0_bw_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), conn0_bw_prop(:))
set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class Diff Arena CONN1 CONN2')
ylabel('Proportion')

subplot(2,3,3)
hbar = bar([mean(conn0_win_prop,1); mean(conn0_bw_prop,1)]'); xlim([0 5]);
xvals = repmat(1:4,size(conn0_win_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hold on
hwin = scatter(xvaloff(:), conn0_win_prop(:), 'ko');
xvals = repmat(1:4,size(conn0_bw_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(2).XOffset;
hbw = scatter(xvaloff(:), conn0_bw_prop(:), 'ko');

set(gca,'XTickLabels',{'Coh', 'Rand. Remap', 'On', 'Off'})
title('Cell Class Same Day (CONN1 CONN2)')
ylabel('Proportion')
hchance = plot([-0.4 0 0 0.4]+hbar(1).XData(1), [ones(1,2)*sum(hbar(1).YData(1:2))/6 ,...
    ones(1,2)*sum(hbar(2).YData(1:2))/6],'k--');
legend(cat(2,hbar,hchance),{'Same Arena', 'Diff. Arena', 'Chance'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

subplot(2,3,4)
text(-0.2, 0.9, 'Pop. significantly reorganizes')
text(-0.2, 0.8, 'Dec. Coh. pop, incr. rand remap , incr. on/off')
text(-0.2, 0.7, 'Still, a majority of sessions mainted a significant coherent population')
text(-0.2, 0.6, 'incr in on/off consistent with Leutgeb, but Ca2+ imaging underestimates rate remap')
text(-0.2, 0.5, '& only captures extreme rate changes')
text(-0.2, 0.4, 'however, decreased PV corrs on conn day reflect more subtle event rate changes')
text(-0.2, 0.3, ['PC filter = ' filt_use])
text(-0.2, 0.2, 'none = no pval or ntrans filt, keep all non-ambiguous silent cells')
text(-0.2, 0.1, 'pval = pval < 0.05 and ntrans >= 5 only, no silent cells')
axis off

% run stats
[~,pcoh] = ttest2(conn0_win_prop(:,1),conn0_bw_prop(:,1));
[~,pgr] = ttest2(conn0_win_prop(:,2),conn0_bw_prop(:,2));
[~,pon] = ttest2(conn0_win_prop(:,3),conn0_bw_prop(:,3));
[~,poff] = ttest2(conn0_win_prop(:,4),conn0_bw_prop(:,4));
[~,ponoff_win] = ttest2(conn0_win_prop(:,3),conn0_win_prop(:,4));
[~,ponoff_bw] = ttest2(conn0_bw_prop(:,3),conn0_bw_prop(:,4));

subplot(2,3,5)
title('t-test results')
text(0.1,0.9,['p_{coh} diff = ' num2str(pcoh,'%0.3g')])
text(0.1,0.8,['p_{gr} diff = ' num2str(pgr,'%0.3g')])
text(0.1,0.7,['p_{on} diff = ' num2str(pon,'%0.3g')])
text(0.1,0.6,['p_{off} diff = ' num2str(poff,'%0.3g')])
text(0.1,0.5,['p_{on~=off,win} = ' num2str(ponoff_win,'%0.3g')])
text(0.1,0.4,['p_{on~=off,bw} = ' num2str(ponoff_bw,'%0.3g')])
axis off

pcoh_rks = ranksum(conn0_win_prop(:,1),conn0_bw_prop(:,1));
pgr_rks = ranksum(conn0_win_prop(:,2),conn0_bw_prop(:,2));
pon_rks = ranksum(conn0_win_prop(:,3),conn0_bw_prop(:,3));
poff_rks = ranksum(conn0_win_prop(:,4),conn0_bw_prop(:,4));
ponoff_win_rks = ranksum(conn0_win_prop(:,3),conn0_win_prop(:,4));
ponoff_bw_rks = ranksum(conn0_bw_prop(:,3),conn0_bw_prop(:,4));
pcoh_win = signtest(conn0_win_prop(:,1), sum(hbar(1).YData(1:2))/6);
pcoh_bw = signtest(conn0_bw_prop(:,1), sum(hbar(2).YData(1:2))/6);

subplot(2,3,6)
title('ranksum test results')
text(0.1,0.9,['p_{coh} diff = ' num2str(pcoh_rks,'%0.3g')])
text(0.1,0.8,['p_{gr} diff = ' num2str(pgr_rks,'%0.3g')])
text(0.1,0.7,['p_{on} diff = ' num2str(pon_rks,'%0.3g')])
text(0.1,0.6,['p_{off} diff = ' num2str(poff_rks,'%0.3g')])
text(0.1,0.5,['p_{on~=off,win} = ' num2str(ponoff_win_rks,'%0.3g')])
text(0.1,0.4,['p_{on~=off,bw} = ' num2str(ponoff_bw_rks,'%0.3g')])
text(0.1,0.3, ['p_{coh,win} > chance = ' num2str(pcoh_win, '%0.3g')])
text(0.1,0.2, ['p_{coh,bw} > chance = ' num2str(pcoh_bw, '%0.3g')])
axis off

%% Make alternate plots with different axes for vertical
try close(305); end
figure(305); 
set(gcf,'Position',[1000 100 780 840])
means_plot = [mean(conn0_win_prop,1); mean(conn0_bw_prop,1)]';
means_plot1 = means_plot(1:2,:); means_plot2 = means_plot(3:4,:);
means_plot1 = means_plot1./sum(means_plot1,1);
conn_win_prop1 = conn0_win_prop(:,1:2); conn_win_prop2 = conn0_win_prop(:,3:4);
conn_win_prop1 = conn_win_prop1./sum(conn_win_prop1,2);

conn_bw_prop1 = conn0_bw_prop(:,1:2); conn_bw_prop2 = conn0_bw_prop(:,3:4);
conn_bw_prop1 = conn_bw_prop1./sum(conn_bw_prop1,2);

subplot(2,3,1)
hbar = bar(means_plot1); xlim([0 3]);
xvals = repmat(1:2,size(conn_win_prop1,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hold on
hwin = scatter(xvaloff(:), conn_win_prop1(:), 'ko');
xvals = repmat(1:2,size(conn_bw_prop1,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(2).XOffset;
hbw = scatter(xvaloff(:), conn_bw_prop1(:), 'ko');
ylim([0 0.9]); xlim([0.5 1.5])

set(gca,'XTickLabels',{'Coh', 'Rand. Remap'})
title('Cell Class Same Day (CONN1 CONN2) by halves','HorizontalAlignment',...
    'left')
ylabel('Proportion Co-active Cells')
hchance = plot([0.5 1.5], [1/6 1/6],'k--');
legend(cat(2,hbar,hchance),{'Same Arena', 'Diff. Arena', 'Chance'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

subplot(2,3,2)
hbar = bar(means_plot2); xlim([0 3]);
xvals = repmat(1:2,size(conn_win_prop2,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(1).XOffset;
hold on
hwin = scatter(xvaloff(:), conn_win_prop2(:), 'ko');
xvals = repmat(1:2,size(conn_bw_prop2,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + hbar(2).XOffset;
hbw = scatter(xvaloff(:), conn_bw_prop2(:), 'ko');

set(gca,'XTickLabels',{'On','Off'})
ylabel('Proportion Total Cells')
legend(hbar,{'Same Arena', 'Diff. Arena'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

subplot(2,3,3)
hbar = bar([mean(PVconn0_win(:)) mean(PVconn0_bw(:))]);
hold on
xvaloff = ones(size(PVconn0_win(:))) + 0.02*randn(size(PVconn0_win(:)));
hwin = scatter(xvaloff,PVconn0_win(:),'ko');
xvaloff = 2*ones(size(PVconn0_bw(:))) + 0.02*randn(size(PVconn0_bw(:)));
hbw = scatter(xvaloff,PVconn0_bw(:),'ko');
ylim([-0.1 0.5]); xlim([0 3])

% Plot CIs
win_CI = mean(CIconn0_mean_rs(win_inds,:),1);
bw_CI = mean(CIconn0_mean_rs(bw_inds,:),1);
hCI = plot([1 2], [win_CI(2), bw_CI(2)], 'k-', ...
    [1 2], [win_CI([1 3]); bw_CI([1 3])], 'k--');

set(gca,'XTickLabels',{'Same','Diff'})
ylabel('\rho_{PV,mean}')
legend(hCI(1:2),{'mean CI','95% CI'})
make_plot_pretty(gca)
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

% Run stats on above
pcoh_rks = ranksum(conn_win_prop1(:,1), conn_bw_prop1(:,1));
pgr_rks = ranksum(conn_win_prop1(:,2), conn_bw_prop1(:,2));
pon_rks = ranksum(conn_win_prop2(:,1), conn_bw_prop2(:,1));
poff_rks = ranksum(conn_win_prop2(:,2), conn_bw_prop2(:,2));
ponoff_win_rks = ranksum(conn_win_prop2(:,1),conn_win_prop2(:,2));
ponoff_bw_rks = ranksum(conn_bw_prop2(:,1),conn_bw_prop2(:,2));
pcoh_win = signtest(conn_win_prop1(:,1), 1/6);
pcoh_bw = signtest(conn_win_prop2(:,1), 1/6);
pPV_rks = ranksum(PVconn0_win(:),PVconn0_bw(:));
pPVbw_v_95CI = signtest(PVconn0_bw(:), bw_CI(1),'tail','right');
pPVbw_v_meanDI = signtest(PVconn0_bw(:), bw_CI(2));
pPVwin_v_95CI = signtest(PVconn0_win(:), win_CI(1));

subplot(2,3,4)
title('ranksum test results')
text(0.1,0.9,['p_{coh} diff = ' num2str(pcoh_rks,'%0.3g')])
text(0.1,0.8,['p_{gr} diff = ' num2str(pgr_rks,'%0.3g')])
text(0.1,0.7,['p_{on} diff = ' num2str(pon_rks,'%0.3g')])
text(0.1,0.6,['p_{off} diff = ' num2str(poff_rks,'%0.3g')])
text(0.1,0.5,['p_{on~=off,win} = ' num2str(ponoff_win_rks,'%0.3g')])
text(0.1,0.4,['p_{on~=off,bw} = ' num2str(ponoff_bw_rks,'%0.3g')])
text(0.1,0.3, ['p_{coh,win} > chance = ' num2str(pcoh_win, '%0.3g')])
text(0.1,0.2, ['p_{coh,bw} > chance = ' num2str(pcoh_bw, '%0.3g')])
axis off

subplot(2,3,5)
text(0, 0.9, ['pPVdiff = ' num2str(pPV_rks, '%0.03g')])
text(0, 0.8, ['pPVwin>95%CI = ' num2str(pPVwin_v_95CI, '%0.03g')])
text(0, 0.7, ['pPVbw>95%CI = ' num2str(pPVbw_v_95CI, '%0.03g')])
text(0, 0.3, ['PC filter = ' filt_use])
text(0, 0.2, 'none = no pval or ntrans filt, keep all non-ambiguous silent cells')
text(0, 0.1, 'pval = pval < 0.05 and ntrans >= 5 only, no silent cells')
axis off

printNK(['Cell Class same day CONN1 CONN2 only split filt_' num2str(filt_use)],'2env')

%% Get conn1 to conn2 cell classifications based on halves
% Delegate indices out so that everything ends up in the appropriate place
% - within arena first
mat_ind_win = [1 6; 1 8; 2 5; 2 7; 3 6; 3 8; 4 5; 4 7]; 
half_win =    [1 1; 1 2; 1 1; 1 2; 2 1; 2 2; 2 1; 2 2]; 
sesh_ind_win = [9 12; 9 12; 10 11; 10 11; 9 12; 9 12; 10 11; 10 11];
% between arenas 2nd - yes I know this could be done more efficiently by
% concatenating everything but this makes it easier on my brain
mat_ind_bw = [1 5; 1 7; 2 6; 2 8; 3 5; 3 7; 4 6; 4 8]; 
half_bw = [1 1; 1 2; 1 1; 1 2; 2 1; 2 2; 2 1; 2 2];
sesh_ind_bw = [9 11; 9 11; 10 12; 10 12; 09 11; 9 11; 10 12; 10 12];

ncells_conn12 = nan(8,8,8);
coh_ratio_conn12 = nan(8,8,8);

try close(652); end; try close(653); end;

for m = 0
    for j = 1:4
        
        figure(652); set(gcf,'Position', [2000, 270, 1820, 700])
        for k = 1:8
            [~, ~, ~, ~, ncells_conn12(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)), ...
                coh_ratio_conn12(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2))] = ...
                plot_delta_angle_hist(all_sessions2(j,sesh_ind_win(k,1)+2*m), ...
                all_sessions2(j,sesh_ind_win(k,2)+2*m), all_sessions2(j,1), 'circ2square', ...
                true, 'bin_size', '_half_cm1_speed1_inMD', 'nshuf', 1000, ...
                'TMap_type', 'TMap_gauss', 'half_use', half_win(k,:),...
                'coh_ang_thresh', 30, 'h', subplot(4,8,8*(j-1)+k),...
                'plot_legend', false);
        end
        
        figure(653); set(gcf,'Position', [2000, 70, 1820, 700])
        for k = 1:8
            [~, ~, ~, ~, ncells_conn12(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)), ...
                coh_ratio_conn12(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2))] = ...
                plot_delta_angle_hist(all_sessions2(j,sesh_ind_bw(k,1)+2*m), ...
                all_sessions2(j,sesh_ind_bw(k,2)+2*m), all_sessions2(j,1), 'circ2square', ...
                true, 'bin_size', '_half_cm1_speed1_inMD', 'nshuf', 1000, ...
                'TMap_type', 'TMap_gauss', 'half_use', half_bw(k,:),...
                'coh_ang_thresh', 30,  'h', subplot(4,8,8*(j-1)+k),...
                'plot_legend', false);
        end
    end
end

%% Make PV plot of same vs diff arenas
PVbw_all = squeeze(PVcorrs_all(3,:,:,:,1));
PVwin_all = cat(1,squeeze(PVcorrs_all(1,:,:,:,1)),...
    squeeze(PVcorrs_all(2,:,:,:,1)));
xPVall = cat(1,PVwin_all(:),PVbw_all(:));
grps_PVall = cat(1, ones(512,1), 2*ones(256,1));
CIbw_all = nanmean(reshape(CIall_mean(3,:,:,:),[],3),1);
CIwin_all = nanmean(reshape(CIall_mean(1:2,:,:,:),[],3),1);

try close(657); end
figure(657); set(gcf,'Position',[2500 420 600 380]);

subplot(1,2,1);
hbar = bar([nanmean(xPVall(grps_PVall == 1)), ...
    nanmean(xPVall(grps_PVall == 2))]);
hold on
xvaloff = ones(size(xPVall(grps_PVall == 1))) + ...
    0.06*randn(size(xPVall(grps_PVall == 1)));
hwin = scatter(xvaloff,xPVall(grps_PVall == 1),'ko');
xvaloff = 2*ones(size(xPVall(grps_PVall == 2))) + ...
    0.06*randn(size(xPVall(grps_PVall == 2)));
hbw = scatter(xvaloff,xPVall(grps_PVall == 2),'ko');
xlim([0 3])

hCI = plot([1 2], [CIwin_all(2), CIbw_all(2)], 'k-', ...
    [1 2], [CIwin_all([1 3]); CIbw_all([1 3])], 'k--');

title(['All PVs PCfilt=' filt_use])
set(gca,'XTickLabels',{'Same','Diff'})
legend(hCI(1:2),{'mean CI','95% CI'})
ylabel('\rho_{PV,mean}')
make_plot_pretty(gca)
set(gca,'Ylim',[-0.2 0.6])
hwin.MarkerEdgeAlpha = 0.5;
hwin.SizeData = 24;
hbw.MarkerEdgeAlpha = 0.5;
hbw.SizeData = 24;

subplot(1,2,2)
prs = ranksum(xPVall(grps_PVall == 1), xPVall(grps_PVall == 2));
text(0.1,0.5,['prksum = ' num2str(prs,'%0.2g')])
axis off

printNK(['PV Same v Diff Plot PCfilt=' filt_use],'2env')

%% Get DI
DIconn1conn2 = cell(8,8,4); % animal x day1 sesh x day2 sesh
for j = 1:4
    for k = 1:8 % use 1:3 eventually
        for ll = 1:8
            PVuse = Mouseconn2.Mouse(j).PV.connfilt.(filt_use)([k,ll],:,:,:);
            PVmax = nanmax(reshape(PVuse,2,[],size(PVuse,4)),[],2);
            DItemp = get_discr_ratio(PVmax(1,:),PVmax(2,:));
            DIconn1conn2{k,ll,j} = DItemp;
        end
    end
end

%% Generate DI plot of same v different arenas for connected days
same_conn0 = [1 3; 2 4; 5 7; 6 8]; 
diff_conn0 = [1 2; 1 4; 2 3; 3 4; 5 6; 5 8; 6 7; 7 8];


% Grab DI for all neurons on connected days (same day only), excluding any
% neurons with DI = +/-1 (already included as silent cells)
DIconn0_nosil = cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), DIconn1conn2);
DIconn0_nosil_rs = reshape(DIconn0_nosil,[],4);
DIconn0_same_nosil = DIconn0_nosil_rs(sub2ind([8,8],same_conn0(:,1),same_conn0(:,2)),:);
DIconn0_diff_nosil = DIconn0_nosil_rs(sub2ind([8,8],diff_conn0(:,1),diff_conn0(:,2)),:);

try close(681); end
figure(681); set(gcf,'Position',[2550 70 420 680])
subplot(2,1,1);
[~, ~, pDI] = barscatter(DIconn0_same_nosil(:), DIconn0_diff_nosil(:));
xlim([0 3])
set(gca,'XTickLabels',{'Same','Diff'},'YLim',[0 0.5],'YTick',0:0.25:0.5)
xlabel('Arena')
ylabel('|DI|_{mean}')
title('Conn1 and Conn2 DIs');
ylim([0 0.5])
make_plot_pretty(gca,'linewidth',1,'fontsize',7)

subplot(2,1,2);
text(0.1, 0.9, ['pval_filt=' filt_use])
text(0.1, 0.8, ['prks = ' num2str(pDI,'%0.2g')])
axis off

printNK(['DI with no silent cells during conn filt=' filt_use],'2env')
%%
n_on_conn12 = nan(8,8,8);
n_off_conn12 = nan(8,8,8);
for m = 0
    for j = 1:4
%         filt_use = 'none';
        PVmax = squeeze(nanmax(reshape(Mouseconn2.Mouse(j).PV.connfilt.(filt_use),8,[],...
            size(Mouseconn2.Mouse(j).PV.connfilt.(filt_use),4)),[],2));
        for k = 1:8
            DItemp = get_discr_ratio(PVmax(mat_ind_win(k,1)+4*m,:), ...
                PVmax(mat_ind_win(k,2)+4*m,:));
            n_on_conn12(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                sum(DItemp == 1);
            n_off_conn12(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                sum(DItemp == -1);
        end
        
        for k = 1:8
            DItemp = get_discr_ratio(PVmax(mat_ind_bw(k,1)+4*m,:), ...
                PVmax(mat_ind_bw(k,2)+4*m,:));
            n_on_conn12(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                sum(DItemp == 1);
            n_off_conn12(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                sum(DItemp == -1);
        end
    end
end
%% Generate ecdf of DI before/after vs during for circ2square to (hopefully)
% capture increased discrimination between arenas excluding on/off neurons
bef_sub = [1 1; 1 2; 2 1; 2 2; 3 3 ; 3 4; 4 3; 4 4];  % before subs - 1 day apart
aft_sub = [7 7; 7 8; 8 7; 8 8]; % after subs - 1 day apart
dur1_sub = [5 6; 6 5]; % during connection subs - 1 day apart
dur0_sub = [5 5; 6 6]; % during connection subs - same day

before_DI_all = []; after_DI_all = [];
during0_DI_all = []; during1_DI_all = [];
before_DI_allc = []; after_DI_allc = [];
during0_DI_allc = []; during1_DI_allc = [];
for j = 1:4
    
    DI_use = Mouse(j).DI.circ2square(2).DI(1:8,1:8);
    bef_all =  DI_use(sub2ind([8,8], bef_sub(:,1), bef_sub(:,2)));
    aft_all = DI_use(sub2ind([8,8], aft_sub(:,1), aft_sub(:,2)));
    dur0_all = DI_use(sub2ind([8,8], dur1_sub(:,1), dur1_sub(:,2)));
    dur1_all = DI_use(sub2ind([8,8], dur0_sub(:,1), dur0_sub(:,2)));
    
    % aggregate all DI values into one long list
    before_DI_all = cat(2, before_DI_all, bef_all{:});
    after_DI_all = cat(2, after_DI_all, aft_all{:});
    during1_DI_all = cat(2, during1_DI_all, dur0_all{:});
    during0_DI_all = cat(2, during0_DI_all, dur1_all{:});
    
    % Ditto but into a cell for getting individual means below
    before_DI_allc = cat(1, before_DI_allc, bef_all);
    after_DI_allc = cat(1, after_DI_allc, aft_all);
    during1_DI_allc = cat(1, during1_DI_allc, dur0_all);
    during0_DI_allc = cat(1, during0_DI_allc, dur1_all);
    
end

try close(309); end
figure(309); set(gcf,'Position',[2075 420 1880 465])

subplot(1,6,1:2)
[fb, xb] = ecdf(abs(before_DI_all)); [fa, xa] = ecdf(abs(after_DI_all));
[fd1, xd1] = ecdf(abs(during1_DI_all)); [fd0, xd0] = ecdf(abs(during0_DI_all));
h1 = plot(xb, fb, 'b-', xa, fa, 'c-', xd1, fd1, 'r--', xd0, fd0, 'g--');
xlabel('|DI|'); ylabel('f(|DI|)'); 
title('Including On/Off Cells from registration only')
legend(h1,{'Before 1 Day','After 1 Day','During Conn 1 day', ...
    'During Conn Same Day'},'Location','NorthWest')

subplot(1,6,3:4)
[fb, xb] = ecdf(abs(before_DI_all(abs(before_DI_all) ~= 1))); 
[fa, xa] = ecdf(abs(after_DI_all(abs(after_DI_all) ~= 1)));
[fd1, xd1] = ecdf(abs(during1_DI_all(abs(during1_DI_all) ~= 1))); 
[fd0, xd0] = ecdf(abs(during0_DI_all(abs(during0_DI_all) ~= 1)));
h1 = plot(xb, fb, 'b-', xa, fa, 'c-', xd1, fd1, 'r--', xd0, fd0, 'g--');
xlabel('|DI|'); ylabel('f(|DI|)'); 
title('No On/Off Cells')
legend(h1,{'Before 1 Day','After 1 Day','During Conn 1 day',...
    'During Conn Same Day'},'Location','SouthEast')

hsum = subplot(1,6,6);
DImean_nosilent = cat(1, cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), before_DI_allc),...
    cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), during0_DI_allc),...
    cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), during1_DI_allc),...
    cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), after_DI_allc));
grps = cat(1,ones(size(before_DI_allc)), 2*ones(size(during1_DI_allc)), ...
    2*ones(size(during1_DI_allc)), 3*ones(size(after_DI_allc)));
scatterBox(DImean_nosilent,grps, 'h', hsum, 'xLabels', {'Before','During Conn','After'},...
    'yLabel','|DI|_{mean}','transparency',0.8)

[pkw, ~, statskw] = kruskalwallis(DImean_nosilent,grps,'off');
cmult = multcompare(statskw,'display','off');
subplot(1,6,5)
text(0.1, 0.9, ['pkw = ' num2str(pkw,'%0.2g')]);
text(0.1, 0.7, ['pbd = ' num2str(cmult(1,6),'%0.2g')]);
text(0.1, 0.5, ['pba = ' num2str(cmult(2,6),'%0.2g')]);
text(0.1, 0.3, ['pda = ' num2str(cmult(3,6),'%0.2g')]);
axis off

make_figure_pretty(gcf)

%% Make Before-During-After and Conn v Not plots of PV, on/off prop, 
% coherent proportion, and mean DI of active cells (maybe don't put in DI
% of active cells since small changes in ca event rate are much less
% interperable than on/off)
day_lag = '1'; % options = 1 and '01' (0 day and 1 day apart)

day56bw = squeeze(cell_cat_breakdown_c2s(:,5,6,:));
day65bw = squeeze(cell_cat_breakdown_c2s(:,6,5,:));
day56win = cat(1,squeeze(cell_cat_breakdown_sq(:,5,6,:)),...
    squeeze(cell_cat_breakdown_oct(:,5,6,:)));

% Cell classifications
win01_bef = cat(1, sq1, sq2, oct1, oct2, win1_all); 
win01_bef_prop = win01_bef./sum(win01_bef,2);
win01_dur = cat(1, conn0_win_breakdown, day56win); % conn_win_breakdown is 0 day by halves (maybe remove?), 
win01_dur_prop = win01_dur./sum(win01_dur,2);
win01_aft = cat(1, sq3, oct3);
win01_aft_prop = win01_aft./sum(win01_aft,2);
if strcmpi(day_lag, '01')
    bw01_dur_prop = cat(1, bw0_dur_prop, day56bw./sum(day56bw,2), ...
        day65bw./sum(day65bw,2)); %Same day, 1 day apart, 1 day apart
elseif strcmpi(day_lag, '1')
    bw01_dur_prop = cat(1, day56bw./sum(day56bw,2), day65bw./sum(day65bw,2)); %1 day apart, 1 day apart
end
bw01_bef_prop = bw1_all_prop(1:32,:); % 1 day apart only
bw01_aft_prop = bw1_all_prop(33:48,:); % 1 day apart only

% PVs
PVwin0_1 = reshape(squeeze(PVcorrs_all(1:2,:,1,2,1)),[],1);
PVwin0_2 = reshape(squeeze(PVcorrs_all(1:2,:,3,4,1)),[],1);
PVwin0_3 = reshape(squeeze(PVcorrs_all(1:2,:,7,8,1)),[],1);
PVwin01_bef = cat(1, PV_win1_bef, PVwin0_1, PVwin0_2); % 1 day (oct day1-2), 0 day (sesh1-2), 0 day(sesh3-4)
PVwin01_aft = PVwin0_3;
PVwin01_dur = cat(1, reshape(squeeze(PVcorrs_all(1:2,:,5:6,5:6,1)),[],1),...
    PVconn0_win(:));
PVbw_bef = cat(1, PV1, PV2);
PVbw_aft = PV3;
if strcmpi(day_lag, '01')
    PVbw_dur = reshape(squeeze(PVcorrs_all(3,:,5:6,5:6,1)),[],1); % 0 and 1 days
elseif strcmpi(day_lag, '1')
    PVbw_dur = reshape(cat(1, squeeze(PVcorrs_all(3,:,5,6,1)), ...
        squeeze(PVcorrs_all(3,:,6,5,1))),[],1); % 1 day apart only
end

% DIs
DIbef_nosil = cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), before_DI_allc);
if strcmpi(day_lag, '01')
    DIdur_nosil = cat(1, cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), during0_DI_allc),...
        cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), during1_DI_allc));
elseif strcmpi(day_lag, '1')
    DIdur_nosil = cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), during1_DI_allc);
end
        
DIaft_nosil = cellfun(@(a) nanmean(abs(a(abs(a) ~= 1))), after_DI_allc);

try close(680); end
figure(680); set(gcf,'Position',[480 230 1340 700])

% NRK - need shuffled 95% CIs here...
subplot(2,4,1)
[~, ~, pkw_PVbda, cPV_bda] = barscatter(PVbw_bef, PVbw_dur, PVbw_aft);
set(gca,'XTick',1:3,'XTickLabel',{'Before', 'During', 'After'});
ylabel('\rho_{PV,mean}')
title(['Day Lag = ' day_lag ' all plots'])
make_plot_pretty(gca,'linewidth', 1, 'fontsize', 7)

subplot(2,4,5)
text(0.1, 0.9, ['pkw = ' num2str(pkw_PVbda,'%0.2g')]);
text(0.1, 0.8, 'Tukey tests results:')
text(0.1, 0.7, ['p_bd = ' num2str(cPV_bda(1,6),'%0.2g')]);
text(0.1, 0.6, ['p_ba = ' num2str(cPV_bda(2,6),'%0.2g')]);
text(0.1, 0.5, ['p_da = ' num2str(cPV_bda(3,6),'%0.2g')]);
text(0.1, 0.3, ['pval filt = ' filt_use])
axis off

subplot(2,4,2)
[hbar, ~, pkw_cohbda, c_cohbda] = barscatter(...
    bw01_bef_prop(:,1)./sum(bw01_bef_prop(:,1:2),2), ...
    bw01_dur_prop(:,1)./sum(bw01_dur_prop(:,1:2),2),...
    bw01_aft_prop(:,1)./sum(bw01_aft_prop(:,1:2),2));
set(gca,'XTick',1:3,'XTickLabel',{'Before', 'During', 'After'});
ylabel('Proportion Co-Active Cells')
title('Coherent (<30) Cells')
make_plot_pretty(gca,'linewidth', 1, 'fontsize', 7)

subplot(2,4,6)
text(0.1, 0.9, ['pkw = ' num2str(pkw_cohbda,'%0.2g')]);
text(0.1, 0.8, 'Tukey tests results:')
text(0.1, 0.7, ['p_bd = ' num2str(c_cohbda(1,6),'%0.2g')]);
text(0.1, 0.6, ['p_ba = ' num2str(c_cohbda(2,6),'%0.2g')]);
text(0.1, 0.5, ['p_da = ' num2str(c_cohbda(3,6),'%0.2g')]);
text(0.1, 0.3, ['pval filt = ' filt_use])
axis off

subplot(2,4,3)
[hbar, ~, pkw_onoffbda, c_onoffbda] = barscatter(bw01_bef_prop(:,3:4), ...
    bw01_dur_prop(:,3:4), bw01_aft_prop(:,3:4));
set(gca,'XTick',1:3,'XTickLabel',{'Before', 'During', 'After'});
ylabel('Proportion Total Cells')
title('On/Off Cells')
legend(hbar,{'On','Off'})
make_plot_pretty(gca,'linewidth', 1, 'fontsize', 7)

subplot(2,4,7)
text(0.1, 0.9, ['pkw = ' num2str(pkw_onoffbda,'%0.2g')]);
text(0.1, 0.8, 'Tukey tests results:')
text(0.1, 0.7, ['p_bd = ' num2str(c_onoffbda(1,6),'%0.2g')]);
text(0.1, 0.6, ['p_ba = ' num2str(c_onoffbda(2,6),'%0.2g')]);
text(0.1, 0.5, ['p_da = ' num2str(c_onoffbda(3,6),'%0.2g')]);
text(0.1, 0.3, ['pval filt = ' filt_use])
axis off

subplot(2,4,4)
[hbar, ~, pkw_DIbda, c_DIbda] = barscatter(DIbef_nosil,...
    DIdur_nosil, DIaft_nosil);
set(gca,'XTick',1:3,'XTickLabel',{'Before', 'During', 'After'});
ylabel('|DI|_{mean}')
title('No silent cells included')
make_plot_pretty(gca,'linewidth', 1, 'fontsize', 7)

subplot(2,4,8)
text(0.1, 0.9, ['pkw = ' num2str(pkw_DIbda,'%0.2g')]);
text(0.1, 0.8, 'Tukey tests results:')
text(0.1, 0.7, ['p_bd = ' num2str(c_DIbda(1,6),'%0.2g')]);
text(0.1, 0.6, ['p_ba = ' num2str(c_DIbda(2,6),'%0.2g')]);
text(0.1, 0.5, ['p_da = ' num2str(c_DIbda(3,6),'%0.2g')]);
text(0.1, 0.3, ['pval filt = ' filt_use])
axis off

printNK(['Cell Class between arenas BDA filt_' filt_use ' day_lag_' ...
    day_lag],'2env')

