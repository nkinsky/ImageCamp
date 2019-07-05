% Alternation scratchpad


%% Run Tenaspis
% sesh_use = cat(2,G30_alt(1),G31_alt(1),G45_alt(1),G48_alt(1));
% pause(3600)
alternation_reference;
sesh_use = cat(2,G30_alt(1:end), G31_alt(1:end), G45_alt(1:end), G48_alt(1:end));

success_bool = [];
for j = 1:length(sesh_use)
   try
       [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
       if exist(fullfile(pwd,'FinalOutput.mat'),'file')
           disp(['Sesiion #' num2str(j) ' - already run'])
           success_bool(j) = true;
       else
           Tenaspis4(sesh_run)
           success_bool(j) = true;
       end
   catch
       success_bool(j) = false;
   end
    
end

%% Check above

success_bool = [];
for j = 1:length(sesh_use)
    try
        [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
        success_bool(j) = exist(fullfile(pwd,'FinalOutput.mat'),'file');
    catch
        success_bool(j) = false;
    end
    
end

%% Run placefields on a bunch of data

%% Make Example splitting plots for ontogeny diagram for Progress Report Talk
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
%% Register all sessions to one another pair-wise fashion
fail_bool = cell(4,1);
num_sessions_all = cellfun(@length,alt_all_cell);
nsesh_total = sum(num_sessions_all.*(num_sessions_all-1))/2;
hw = waitbar(0,'Running pair-wise registrations...');
n = 1;
for j = 1:length(alt_all_cell)
    MD_use = alt_all_cell{j};
    num_sessions = length(MD_use);
    fail_bool{j} = false(num_sessions, num_sessions);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            try
                neuron_map_simple(MD_use(k),MD_use(ll), ...
                    'suppress_output', true);
            catch
                fail_bool{j}(k,ll) = true;
            end
            waitbar(n/nsesh_total,hw);
            n = n+1;
        end
    end
end
close(hw)

%% When done with above, run to qc registrations - use plot_registration
for j = 3
    MD_use = alt_all_cell{j};
    num_sessions = length(MD_use);
    fail_bool{j} = false(num_sessions, num_sessions);
    num_comps = (num_sessions-1)*num_sessions/2;
    disp(['Running pair-wise registration check for Mouse ' num2str(j)])
    hw = waitbar(0,'Registration Check Progress!');
    n = 0;
    for k = 1%:num_sessions - 1
        hfig = figure;
        for ll = k+1%:num_sessions
            plot_registration(MD_use(k) ,MD_use(ll));
            if ll == num_sessions %&& k == (num_sessions - 1)
                num_shuffles = 100;
            else
                num_shuffles = 0;
            end
            n = n+1;
            waitbar(n/num_comps,hw);
        end
        reg_qc_plot_batch(MD_use(k), MD_use(k+1:num_sessions), 'hfig', hfig,...
            'num_shuffles', num_shuffles);
        make_figure_pretty(hfig)
        printNK([MD_use(1).Animal ' - Registration QC plot' ...
            num2str(k)],'alt')
    end
    close(hw)
end

%% Run sigSplitterplots
binthresh = 3;
success_bool = false(1,length(alt_all));
for j = 1:length(alt_all)
    try
        close all
        sesh_use = alt_all(j);
        filename =  fullfile(sesh_use.Location, ['Splitters - ' ...
            sesh_to_text(sesh_use,'file') ' - binthresh' num2str(binthresh) '.ps']);
        if ~exist(filename,'file')
            plotSigSplitters(sesh_use, 'plot_type', 7, 'invert_raster_color',2)
        end
        success_bool(j) = true;
    catch
    end
    
end

%% First attempt to get group stats on corrs_v_cat

rhos_all = [];
coactive_all = [];
for j = 1:4
    sesh_use = alt_all_cell{j};
    num_sessions = length(sesh_use);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            [~, rho_mean] = alt_plot_corrs_v_cat(sesh_use(k),sesh_use(ll),...
                'plot_flag',false);
            rhos_all = [rhos_all; rho_mean];
            
            [~, ~, coactive_prop] = alt_stability_v_cat(sesh_use(k),sesh_use(ll),...
                'plot_flag',false);
            coactive_all = [coactive_all; coactive_prop];
        end
    end
end

% Might be better to not use scatterBox if this is plotting means and not
% individual points
cats = repmat(1:5,size(rhos_all,1),1);
scatterBox(rho_all(:), cats(:))
cat2 = repmat(1:5,size(coactive_all,1),1);
scatterBox(coactive_all(:),cats2(:))

%% Check if all the sessions have a pos.mat, pos_align, and Placefields file
% sesh_check = MD(ref.G48.alternation(1):ref.G48.alternation(2));
sesh_check = G48_alt;
num_sesh = length(sesh_check);

pos_bool = false(1, num_sesh);
pos_align_bool = false(1, num_sesh);
split_sesh_bool = false(1, num_sesh);
pf_bool = false(1, num_sesh);
pf_bool1 = false(1, num_sesh);
alt_bool = false(1, num_sesh);

for j = 1:length(sesh_check)
    dir_use = ChangeDirectory_NK(sesh_check(j),0);
    if ~isempty(dir_use)
        pos_bool(j) = exist(fullfile(dir_use,'Pos.mat'),'file');
        pos_align_bool(j) = exist(fullfile(dir_use,'Pos_align.mat'),'file');
        split_sesh_bool(j) = exist(fullfile(dir_use,'part1'),'dir');
        pf_bool1(j) = exist(fullfile(dir_use,'Placefields_cm1.mat'),'file');
        pf_bool(j) = exist(fullfile(dir_use,'Placefields.mat'),'file');
        alt_bool(j) = exist(fullfile(dir_use,'Alternation.mat'),'file');
    end
    
end

gtg = sesh_check(pf_bool1);
change_pf_name = sesh_check(pf_bool & ~pf_bool1);
run_pos_align = sesh_check(~pf_bool1 & ~pf_bool & ~pos_align_bool & pos_bool);
run_pos_comb = sesh_check(~pf_bool1 & ~pf_bool & ~pos_bool & split_sesh_bool);
no_pos_file = sesh_check(~pos_bool & ~pf_bool1 & ~pf_bool & ~split_sesh_bool);
run_pf = sesh_check(~pf_bool & ~pf_bool1 & pos_align_bool);
disp('ran')

%% Fix bad G31 registration sessions by registering by masks
dates_run1 = arrayfun(@(a) a.Date, G31_alt, 'UniformOutput', false);
for j = 1:5
    neuron_register('GCamp6f_31', dates_run1{j}, 1, '12_05_2014', 1, ...
        'use_neuron_masks', 1, 'name_append', '_masks')
end
neuron_register('GCamp6f_31','12_05_2014',1,'12_11_2014',1, ...
    'use_neuron_masks', 1, 'name_append', '_masks')
neuron_register('GCamp6f_31','12_03_2014',1,'12_11_2014',1, ...
    'use_neuron_masks', 1, 'name_append', '_masks')

%%
neuron_register('GCamp6f_45','09_08_2015',1,'10_07_2015',1, ...
    'use_neuron_masks', 1, 'name_append', '_masks')

%% Run pairwise qc for each mouse and save reg_stats with 1000 shuffles...
nreps = cellfun(@length, alt_all_cell).*(cellfun(@length, alt_all_cell) -1)/2;
for m = 3
    sesh_use = alt_all_cell{m}; 
    hw = waitbar(0, ['Calculating reg quality metrics for ' ...
        mouse_name_title(sesh_use(1).Animal)]);
    n = 1;
    for j = 17:length(sesh_use)-1 
        base_sesh = sesh_use(j);
        for k = (j+1):length(sesh_use)
            reg_sesh = sesh_use(k);
            if j == k
                continue
            else
                reg_stats = neuron_reg_qc(base_sesh, reg_sesh, 'shuffle', ...
                    1000, 'orient_only', true);
                save(fullfile(sesh_use(j).Location,['reg_stats_' ...
                    sesh_use(k).Date '_s' num2str(sesh_use(k).Session)]), ...
                    'reg_stats', 'base_sesh', 'reg_sesh');
                waitbar(n/nreps(m), hw);
                n = n + 1;
            end
        end
    end
    close(hw)
%     save(fullfile(sesh_use(1).Location,'reg_pvalue_mat'), 'reg_pval_mat')
end

%% Calculate p-value versus shuffled after above is finished
for m = 1:4
    sesh_use = alt_all_cell{m};
    reg_pval_mat = nan(length(sesh_use));
    for j = 1:length(sesh_use)-1
        base_sesh = sesh_use(j);
        for k = (j+1):length(sesh_use)
            reg_sesh = sesh_use(k);
            load(fullfile(sesh_use(j).Location,['reg_stats_' ...
                sesh_use(k).Date '_s' num2str(sesh_use(k).Session)]), ...
                'reg_stats');
            reg_pval_mat(j,k) = reg_calc_pvalue(reg_stats);
        end
    end
    save(fullfile(sesh_use(1).Location,'reg_pvalue_mat'), 'reg_pval_mat')
end


%% Run batch registration for all FINAL files
batch_session_map31 = neuron_reg_batch(G31_alt(1), G31_alt(2:end));
batch_session_map45 = neuron_reg_batch(G45_alt(1), G45_alt(2:end));
batch_session_map48 = neuron_reg_batch(G48_alt(1), G48_alt(2:end));
save(fullfile(G30_alt(1).Location,'batch_maps_all_mice.mat'), 'batch_session_map30',...
    'batch_session_map31', 'batch_session_map45', 'batch_session_map48')

%% Run G48 batch_map in two different sections since registrations before/after
% session 16 clump together.
batch_session_map48a = neuron_reg_batch(G48_alt(1), G48_alt(2:16));
batch_session_map4b8 = neuron_reg_batch(G48_alt(17), G48_alt(18:end));

%% Plot out and save reg qc for each half of G48 since you forgot to do it
% after above ran
reg_qc_plot_batch(G48_alt(1), G48_alt(2:16), 'batch_mode', 1);
reg_qc_plot_batch(G48_alt(17), G48_alt(18:end), 'batch_mode', 1);

%% Run G45 batch_map in two different sections since registrations before/after
% session 15 clump together.
batch_session_map45a = neuron_reg_batch(G45_alt(1), G45_alt(2:15));
batch_session_map45b = neuron_reg_batch(G45_alt(16), G45_alt(17:end));

%% Save all G30 and G31 files with slightly too large scaling (pix2cm = 0.15)
% so that you can later run with pix2cm = 0.10.
% Done for session 13 and 14 for G30...

sesh_fix = cat(2,G30_alt, G31_alt);
pf_files = {'Placefields_cm1', 'PlacefieldStats_cm1', ...
    'SpatialInfo_cm1'}; 
pf_make_files = {'Pos_align.mat', 'Pos.mat'};
split_files = {'sigSplitters', 'splitters', 'splittersByTrialType', ...
    'Alternation', 'centerarm_manual'};
for j = 13:14% :length(sesh_fix)
    mkdir(ChangeDirectory_NK(sesh_fix(j)), 'scale_fixed');
    cellfun(@(a) copyfile(fullfile(sesh_fix(j).Location, a), ...
        fullfile(sesh_fix(j).Location, 'scale_fixed', a)), pf_make_files);
%     cellfun(@(a) copyfile(fullfile(sesh_fix(j).Location,[a '.mat']), ...
%         fullfile(sesh_fix(j).Location, 'scale_fixed', [a(1:(end-1)) '0_67.mat']), pf_files);
%     cellfun(@(a) copyfile([a '.mat'], [a '0_67.mat']), split_files);
%     cellfun(@(a) movefile([a '.mat'], [a '_smallscale_archive.mat']), pf_files);
%     cellfun(@(a) movefile([a '.mat'], [a '_smallscale_archive.mat']), split_files);
end

%% Re-run everything for G30 and G31
 % Run 2, 2.5, 2.95, and 3 in alternation_workflow - DONE
 
 %% Check results - does slightly larger scaling factor change results?
 todo_sesh = MD(ref.G30_scalefix);
 
 % Recurrence v splittiness results.. highly correlated!!!
 [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, pco_v_relym, ~, rely_bin_bool] = ...
     plot_split_v_recur(G30_alt(13), G30_alt(14), 'rely_mean_edges', 0:0.1:1);
[~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, pco_v_relym_sf, ~, rely_bin_bool_sf] = ...
    plot_split_v_recur(todo_sesh(1), todo_sesh(2), 'rely_mean_edges', 0:0.1:1);
figure; plot(pco_v_relym_sf(rely_bin_bool_sf), pco_v_relym(rely_bin_bool), 'o');
[r,p] = corr(pco_v_relym_sf(rely_bin_bool_sf)', pco_v_relym(rely_bin_bool)');

% stability_v_category. Look basically the same. Highly correlated answers!
[ ha, stay_prop, coactive_prop, cat_names, coactive_bool] = ...
    alt_stability_v_cat(G30_alt(13), G30_alt(14), 'PFname', 'Placefields_cm1.mat');
[ ha, stay_prop_sf, coactive_prop_sf, cat_names, coactive_bool_sf] = ...
    alt_stability_v_cat(todo_sesh(1), todo_sesh(2), 'PFname', 'Placefields_cm1.mat');
[rc, pc] = corr(coactive_prop', coactive_prop_sf');