% 2env Figure 6: Temporal Lag

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

%% Circle same day Example Histogram
animal_use = 3;
rot_type = 'circle'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 1; % must be square if circ2square
sesh2 = 2; % must be circle if circ2square
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
arrayfun(@(a) set(a, 'Position', paper_pos), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 150])

figure(hh(2))
printNK('Same Day Rotation Histogram - Circle G45','2env','append',true)
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
printNK('Same Day Rotation Histogram - Circle G45','2env','append',true)

%% Circle same day
animal_use = 3;
rot_type = 'circle'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 1; % must be square if circ2square
sesh2 = 8; % must be circle if circ2square
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
arrayfun(@(a) set(a, 'Position', paper_pos), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 50])

figure(hh(2))
printNK('Six Day Rotation Histogram - Circle G45','2env','append',true)
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
printNK('Six Day Rotation Histogram - Circle G45','2env','append',true)

%% See twoenv_silent_cellPVs for PV vs day lag plots

%% Plot Coherency proportion vs time
plot_by_animal = false; %Suggest keeping false since not much is apparent on the animal level

coh_all = [];
gr_all = [];
loc_all = [];
hcomb = figure(34); set(gcf,'Position',[2240 390 710 400]);
days_ref =  0:7;
coh_prop_all = nan(8,3);
coh_prop_bymouse = nan(num_animals,length(sesh_type),8);
for mm = 1:length(sesh_type)
    
    days_plot = Mouse(1).coherent_v_days.rotation.(sesh_type{mm})(:,1);
    coh_total_comb = zeros(size(days_plot));
    gr_total_comb = zeros(size(days_plot));
    local_total_comb = zeros(size(days_plot));
    
    if plot_by_animal; figure(20+mm); end
    for j = 1:num_animals

        coh_total = zeros(size(days_plot));
        gr_total = zeros(size(days_plot));
        local_total = zeros(size(days_plot));
        for k = 1:length(rot_type)
            mat_temp = Mouse(j).coherent_v_days.(rot_type{k}).(sesh_type{mm});
            
            % Get coherent/global remapping probabilities for rotation/no
            % rotation
            total_sesh = sum(mat_temp(:,2:3),2);
            coh_prop = mat_temp(:,2)./total_sesh; 
            gr_prop = mat_temp(:,3)./total_sesh;
            local_prop = mat_temp(:,4)./total_sesh;
            
            % Aggregate coherent/global probs. agnostic to rotation/no
            % rotation
            coh_total = coh_total + mat_temp(:,2);
            gr_total = gr_total + mat_temp(:,3);
            local_total = local_total + mat_temp(:,4);
            
            % Plot rotation/no-rotation breakdown
            if plot_by_animal
                subplot(3,4,4*(k-1)+j)
                bar(days_plot,[coh_prop, local_prop]);
                xlabel('Days b/w'); ylabel('Probability')
                title(['Mouse ' num2str(j) ' ' sesh_type{mm} ' ' mouse_name_title(rot_type{k})])
                ylim([0 1.5])
                xlim([-1 8])
                set(gca,'XTick',0:7)
            end
        end
        coh_prop_bymouse(j,mm,arrayfun(@(a) find(a == days_ref),days_plot)) ...
            = coh_total./(coh_total + gr_total);
        % Compute agnostic probs and plot
        total_comb = coh_total + gr_total;
        if plot_by_animal
            subplot(3,4,8+j)
            bar(days_plot,[coh_total./total_comb, local_total./total_comb])
            xlabel('Days b/w'); ylabel('Probability')
            title(['Mouse ' num2str(j) ' ' sesh_type{mm} ' Rotation Agnostic'])
            ylim([0 1.5])
            xlim([-1 8])
            set(gca,'XTick',0:7)
        end
        
        % Aggregate across all mice!
        coh_total_comb = coh_total_comb + coh_total;
        gr_total_comb = gr_total_comb + gr_total;
        local_total_comb = local_total_comb + local_total;
    end
    total_comb2 = coh_total_comb + gr_total_comb;
    figure(24)
    subplot(3,1,mm)
    bar(days_plot,[coh_total_comb./total_comb2, local_total_comb./total_comb2])
    ylim([0 1.5])
    xlim([-1 8])
    set(gca,'XTick',0:7)
    xlabel('Days b/w'); ylabel('Probability')
    title(['Rotation Agnostic Coherency v Time Breakdown - ' sesh_type{mm}])
    legend('Coherent','Coherent - Local Cues')
    coh_prop_all(arrayfun(@(a) find(a == days_ref),days_plot),mm) = ...
        coh_total_comb./total_comb2; % Dump into combined mat
end
figure(hcomb)
% bar(days_ref',coh_prop_all)
win_env = mean(coh_prop_all(:,1:2),2); diff_env = coh_prop_all(:,3);
plot(days_ref(~isnan(win_env))', win_env(~isnan(win_env)), 'ko-', ...
    days_ref(~isnan(diff_env))', diff_env(~isnan(diff_env)), 'ro--')
ylim([0 1.1])
xlim([-0.5 7.5]); xlabel('Day lag'); ylabel('Coherent Ratio')
legend('Same Arena', 'Different Arena')
make_plot_pretty(gca)

% Run ANOVA to get stats on whether or not there is any drop-off with time
same_prop = [squeeze(coh_prop_bymouse(:,1,:)); squeeze(coh_prop_bymouse(:,2,:))];
[p_same, t_same, stats_same] = anova1(same_prop, [], 'off');
figure; [c_same, m_same, h_same] = multcompare(stats_same);

diff_prop = squeeze(coh_prop_bymouse(:,3,:));
[p_diff, t_diff, stats_diff] = anova1(diff_prop, [], 'off');
figure; [c_diff, m_diff, h_diff] = multcompare(stats_diff);

% Run ANOVA to get stats on whether the two groups are different
[panova, tab, stats] = anova1(cat(1,same_prop(:),diff_prop(:)),...
    cat(1,ones(length(same_prop(:)),1),2*ones(length(diff_prop(:)),1)),'off');

%% Make Cell overlap ratio vs time plot
try; close 505; end; try; close 506; end; try; close 507; end
try; close 508; end;
hind = figure(505); hall = figure(506); hcomb = subplot(2,2,4);
hconf = figure(508); set(gcf,'Position',[2130 50 1360 920]);
overlap_ratio_all.square = nan(8,8);
overlap_ratio_all.circle = nan(8,8);
overlap_ratio_all.circ2square = nan(16,16);
for k = 1:length(sesh_type)
    if k == 3
        filt_use = true(16);
        filt_use(sub2ind([16,16],[9 11],[10 12])) = false;
    else
        filt_use = true(size(Mouse(1).PV_corrs.(sesh_type{k}).PV_corr_mean));
    end
    for j = 1:num_animals
        mouse_name = mouse_name_title(Mouse(j).sesh.square(1).Animal);
        ratio_use = Mouse(j).cell_overlap.(sesh_type{k}).overlap_ratio;
        figure(hind)
        hax = subplot(4,4,4*(k-1)+j);
        twoenv_plot_PVcurve(ratio_use, sesh_type{k},[],hax, true, filt_use);
        title([mouse_name ' - ' sesh_type{k}])
        
        % Assemble into one big matrix for all mice
        overlap_ratio_all.(sesh_type{k}) = cat(3,overlap_ratio_all.(sesh_type{k}), ...
            ratio_use);
        
        % Plot all mice on one plot
        figure(hall)
        hold on
        hax_all = subplot(2,2,k);
        twoenv_plot_PVcurve(ratio_use, sesh_type{k}, [], hax_all, false, filt_use);
        hold on
        twoenv_plot_PVcurve(ratio_use, sesh_type{k}, [], hcomb, false, filt_use);
        hold on
    end
    
    figure(hall);

    overlap_ratio_all_use = nanmean(overlap_ratio_all.(sesh_type{k}),3);
    [~, unique_lags_all{k}, mean_oratio_all{k}] = twoenv_plot_PVcurve(...
        overlap_ratio_all_use, sesh_type{k}, [], hax_all, ...
        true, filt_use); 
    ylim([0 0.8])
    title(['All Mice - ' sesh_type{k}])
    make_plot_pretty(gca)
    twoenv_plot_PVcurve(overlap_ratio_all_use, sesh_type{k}, [], hcomb, ...
        true, filt_use);
    hold on
    ylim([0 0.8])
    hold off
    make_plot_pretty(gca)
    
    figure(hconf)
    subplot(2,2,k)
    plot_use = overlap_ratio_all_use;
    if k == 3 % Hack to combine sessions 9 and 10 and 11 and 12
        filt = true(16);
        filt(9,:) = false;
        filt(:,9) = false;
        filt(:,11) = false;
        filt(11,:) = false;
        plot_use =  reshape(plot_use(filt),14,14);
    end
    plot_use(logical(eye(size(plot_use,1)))) = nan;
    imagesc_nan(plot_use)
    title(['All Mice - ' sesh_type{k} ' Overlap Ratio'])
    cbar = colorbar;
    make_plot_pretty(gca);
    make_plot_pretty(cbar);
end

% Plot same env overlap and different env overlap
figure(507); set(gcf,'Position',[2150 430 760 470]);
same_env = cellfun(@(a,b) [a; b], mean_oratio_all{1}, mean_oratio_all{2},...
    'UniformOutput',false);
diff_env = mean_oratio_all{3};
errorbar(unique_lags_all{1}, cellfun(@mean, same_env), ...
    cellfun(@std, same_env), 'k.-');
hold on
errorbar(unique_lags_all{3}, cellfun(@mean, diff_env), ...
    cellfun(@std, diff_env), 'r-');
xlabel('Day lag')
ylabel('Mean overlap ratio')
xlim([-0.5 7.5]); ylim([0 0.6])
make_plot_pretty(gca)
legend('Same Arena','Circle-to-square')

%% Get number of neurons active per session across time
% Only include days 1-4 and 7-8 since all sessions are the same length (10
% min).  Exclude days 5 and 6 since they have 20 minute sessions.
sessions_use = [1:8 13:16];
nneurons_all = nan(4,length(sessions_use));
for j = 1:4
    for k = 1:length(sessions_use)
        sesh_use = sessions_use(k);
        dirstr = ChangeDirectory_NK(Mouse(j).sesh.circ2square(sesh_use),0);
        load(fullfile(dirstr, 'FinalOutput.mat'),'NumNeurons');
        nneurons_all(j,k) = NumNeurons;
    end
    
end

days = [1 1 2 2 3 3 4 4 5 5 6 6];
% Reorganize into days
n_by_days = nan(4,length(days));
for j = 1:max(days)
    temp = nneurons_all(:,days == j);
    n_by_days(:,j) = temp(:);
end

figure(35); set(gcf,'Position', [2200 620 480 340]) 
errorbar(mean(n_by_days,1), std(n_by_days,1)/sqrt(8)); ylim([0 600])
xlim([0.5 6.5])
set(gca,'XTick',1:6,'XTickLabel',{'SQ1', 'CIR1', 'CIR2', 'SQ2', 'SQ3', 'CIR3'})
make_plot_pretty(gca)
xlabel('# Neurons Active')
ylabel('# Neurons Active')
printNK('Num Active Neurons vs Days','2env')

% Fit linear model
lm = fitlm(days_mat(:),n_by_days(:));

% Run ANOVA
panova = anova1(n_by_days(:), days_mat(:),'off');
pkw = kruskalwallis(n_by_days(:), days_mat(:),'off');
       