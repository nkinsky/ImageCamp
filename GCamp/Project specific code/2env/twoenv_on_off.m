%% Two-env on/off analysis
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

load_existing = false; % Set to false if you want to run from scratch, true = run existing files


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
load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_PVsilent_cm4_local0-0shuffles-2018-05-03.mat'));
DIcutoff = 1; % cutoff of DI to be considered "silent" or "rate remapping"
arena = {'square', 'circle', 'circ2square'};
for j = 1:4
    for m = 1:3
        for k = 1:3 % use 1:3 eventually
            PVuse = Mouse(j).PVcorrs.(arena{m})(k).PV;
            PVmax = cellfun(@(a) nanmax(reshape(a,2,[],size(a,4)),[],2), ...
                PVuse,'UniformOutput',false);
            DItemp = cellfun(@(a) get_discr_ratio(a(1,:),a(2,:)),PVmax,...
                'UniformOutput', false);
            Mouse(j).DI.(arena{m})(k).DI = DItemp;
        end
    end
    
end


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
    cell_cat_breakdown_c2s(j,:,:,:) = cat(3,ncoh,ngr, n_on + nnew, n_off + nsilent);
end

cell_cat_breakdown_sq = nan(4,8,8,4); % mice x sesh_sq x sesh_sq x cat (ncoh, ngr, n_on, n_off)
for j = 1:4
    ncoh = squeeze(coh_ratio_sq(j,:,:)).*squeeze(ncells_sq(j,:,:)); % c
    ngr = squeeze(ncells_sq(j,:,:)) - ncoh;
    n_on = cellfun(@(a) sum(a == 1), Mouse(j).DI.square(1).DI(1:8,1:8));
    n_off = cellfun(@(a) sum(a == -1), Mouse(j).DI.square(1).DI(1:8,1:8));
    nsilent = cellfun(@length, squeeze(become_silent_sq(j,:,:)));
    nnew = cellfun(@length, squeeze(new_cells_sq(j,:,:)));
    cell_cat_breakdown_sq(j,:,:,:) = cat(3,ncoh,ngr, n_on + nnew, n_off + nsilent);
end

cell_cat_breakdown_oct = nan(4,8,8,4); % mice x sesh_oct x sesh_oct x cat (ncoh, ngr, n_on, n_off)
for j = 1:4
    ncoh = squeeze(coh_ratio_oct(j,:,:)).*squeeze(ncells_oct(j,:,:)); % c
    ngr = squeeze(ncells_oct(j,:,:)) - ncoh;
    n_on = cellfun(@(a) sum(a == 1), Mouse(j).DI.square(1).DI(1:8,1:8));
    n_off = cellfun(@(a) sum(a == -1), Mouse(j).DI.square(1).DI(1:8,1:8));
    nsilent = cellfun(@length, squeeze(become_silent_oct(j,:,:)));
    nnew = cellfun(@length, squeeze(new_cells_oct(j,:,:)));
    cell_cat_breakdown_oct(j,:,:,:) = cat(3,ncoh,ngr, n_on + nnew, n_off + nsilent);
end


% This gives me a breakdown for all circ2square sessions. Can do the same
% for circle and square sessions and compare 0 day and 1 day apart.

%% Make plot for connected day
try close(302); end
day5 = squeeze(cell_cat_breakdown_c2s(:,5,5,:))./...
    sum(squeeze(cell_cat_breakdown_c2s(:,5,5,:)),2);
day6 = squeeze(cell_cat_breakdown_c2s(:,6,6,:))./...
    sum(squeeze(cell_cat_breakdown_c2s(:,6,6,:)),2);
connday_breakdown = cat(1,day5,day6);

figure(302)
set (gcf,'Position', [2026, 54, 894, 800])
subplot(2,2,1)
bar(mean(connday_breakdown,1)); xlim([0 5]);
xvals = repmat(1:4,size(connday_breakdown,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), connday_breakdown(:))
set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class circ2square on CONN1 and CONN2')
ylabel('Proportion')

[pconn, ~, statsconn] = kruskalwallis(connday_breakdown(:), xvals(:), 'off');
cconn = multcompare(statsconn,'display','off');

% Make plot for same arena 0 days apart
sq1 = reshape(cell_cat_breakdown_sq(:,1,2,:),[],4);
sq2 = reshape(cell_cat_breakdown_sq(:,3,4,:),[],4);
sq3 = reshape(cell_cat_breakdown_sq(:,7,8,:),[],4);
oct1 = reshape(cell_cat_breakdown_oct(:,1,2,:),[],4);
oct2 = reshape(cell_cat_breakdown_oct(:,3,4,:),[],4);
oct3 = reshape(cell_cat_breakdown_oct(:,7,8,:),[],4);
win0_all = cat(1, sq1, sq2, sq3,oct1, oct2, oct3);
win0_all_prop = win0_all./sum(win0_all,2);

subplot(2,2,2)
bar(mean(win0_all_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(win0_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), win0_all_prop(:))
set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class within arena same day')
ylabel('Proportion')

% MMake plot for same arena 1 days apart (octagon only) - this is not
% correct - need more sessions!
win1_1 = reshape(cell_cat_breakdown_oct(:,2:3,2:3,:),[],4);
win1_2 = reshape(cell_cat_breakdown_oct(:,[2 4],[2 4],:),[],4);
win1_3 = reshape(cell_cat_breakdown_oct(:,[1 4],[1 4],:),[],4);
win1_4 = reshape(cell_cat_breakdown_oct(:,[1 3],[1 3],:),[],4);
win1_all = cat(1, win1_1, win1_2, win1_3, win1_4);
win1_all_prop = win1_all./sum(win1_all,2);

subplot(2,2,4)
hold off
bar(nanmean(win1_all_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(win1_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), win1_all_prop(:))
set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class within arena 1 day apart')
ylabel('Proportion')

% Make plot for c2s 1 day apart
c2s1 = reshape(cell_cat_breakdown_c2s(:,1:2,1:2,:),[],4);
c2s2 = reshape(cell_cat_breakdown_c2s(:,3:4,3:4,:),[],4);
c2s3 = reshape(cell_cat_breakdown_c2s(:,7:8,7:8,:),[],4);
c2s1_all = cat(1,c2s1,c2s2,c2s3);
c2s1_all_prop = c2s1_all./sum(c2s1_all,2);

subplot(2,2,3)
bar(mean(c2s1_all_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(c2s1_all_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), c2s1_all_prop(:))
set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class circ2square Sq1 v Cir1, Sq2 v Cir2, Sq3 v Cir3')
ylabel('Proportion')

[pc2s1, ~, statc2s1] = kruskalwallis(c2s1_all_prop(:), xvals(:), 'off');
c_c2s1 = multcompare(statsconn,'display','off');

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
Mouseconn = load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_PV_conn_1shuffles-2018-05-09.mat'));

n_on_conn = nan(8,4,4);
n_off_conn = nan(8,4,4);
for m = 0:1
    for j = 1:4
        filt_use = 'none';
        PVmax = squeeze(nanmax(reshape(Mouseconn.Mouse(j).PV.connfilt.(filt_use),8,[],...
            size(Mouse(j).PV.connfilt.(filt_use),4)),[],2));
        for k = 1:2
            DItemp = get_discr_ratio(PVmax(mat_ind_win(k,1)+4*m,:), ...
                PVmax(mat_ind_win(k,2)+4*m,:));
            n_on_conn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                sum(DItemp == 1);
            n_off_conn(j+4*m, mat_ind_win(k,1), mat_ind_win(k,2)) = ...
                sum(DItemp == -1);
        end
        
        for k = 1:4
            DItemp = get_discr_ratio(PVmax(mat_ind_bw(k,1)+4*m,:), ...
                PVmax(mat_ind_bw(k,2)+4*m,:));
            n_on_conn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                sum(DItemp == 1);
            n_off_conn(j+4*m, mat_ind_bw(k,1), mat_ind_bw(k,2)) = ...
                sum(DItemp == -1);
        end
    end
end

%% Reshape indices to make pulling out data easier
coh_ratio_conn_rs = reshape(coh_ratio_conn,8,[]);
ncells_conn_rs = reshape(ncells_conn,8,[]);
n_on_conn_rs = reshape(n_on_conn,8,[]);
n_off_conn_rs = reshape(n_off_conn,8,[]);
win_inds = sub2ind([4,4],mat_ind_win(:,1),mat_ind_win(:,2));
bw_inds = sub2ind([4,4],mat_ind_bw(:,1),mat_ind_bw(:,2));

ncoh_conn_win = coh_ratio_conn_rs(:,win_inds).*ncells_conn_rs(:,win_inds);
ngr_conn_win = ncells_conn_rs(:,win_inds) - ncoh_conn_win;
non_conn_win = n_on_conn_rs(:,win_inds);
noff_conn_win = n_off_conn_rs(:,win_inds);

ncoh_conn_bw = coh_ratio_conn_rs(:,bw_inds).*ncells_conn_rs(:,bw_inds);
ngr_conn_bw = ncells_conn_rs(:,bw_inds) - ncoh_conn_bw;
non_conn_bw = n_on_conn_rs(:,bw_inds);
noff_conn_bw = n_off_conn_rs(:,bw_inds);

conn_win_breakdown = cat(2, ncoh_conn_win(:), ngr_conn_win(:), ...
    non_conn_win(:), noff_conn_win(:));
conn_win_prop = conn_win_breakdown./sum(conn_win_breakdown,2);
conn_bw_breakdown = cat(2, ncoh_conn_bw(:), ngr_conn_bw(:), ...
    non_conn_bw(:), noff_conn_bw(:));
conn_bw_prop = conn_bw_breakdown./sum(conn_bw_breakdown,2);

try close(303); end
figure(303)
set (gcf,'Position', [2026, 54, 1020, 800])

subplot(2,2,1)
bar(mean(conn_win_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(conn_win_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), conn_win_prop(:))
set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class Same Arena CONN1 CONN2')
ylabel('Proportion')

subplot(2,2,2)
bar(mean(conn_bw_prop,1)); xlim([0 5]);
xvals = repmat(1:4,size(conn_bw_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02;
hold on
scatter(xvaloff(:), conn_bw_prop(:))
set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class Diff Arena CONN1 CONN2')
ylabel('Proportion')

subplot(2,2,3)
h = bar([mean(conn_win_prop,1); mean(conn_bw_prop,1)]'); xlim([0 5]);
xvals = repmat(1:4,size(conn_win_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + h(1).XOffset;
hold on
scatter(xvaloff(:), conn_win_prop(:), 'ko')
xvals = repmat(1:4,size(conn_bw_prop,1),1);
xvaloff = xvals + randn(size(xvals))*0.02 + h(2).XOffset;
scatter(xvaloff(:), conn_bw_prop(:), 'ko')

set(gca,'XTickLabels',{'Coh', 'Gl. Remap', 'On', 'Off'})
title('Cell Class CONN1 CONN2')
ylabel('Proportion')
legend(h,'Same Arena', 'Diff Arena')


