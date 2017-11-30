%% Script to create manuscript figures

%% Figure 1b
sesh_use = G45_square(1); % G30_square(1);
proj_use = 'ICmovie_min_proj.tif';
trace_plot = 'LPtrace'; % 'RawTrace'; % 
neurons_plot = [56 69 161 392 1 2 3 4]; % [2 3 6 10 11 16 17 200 201]; % G30_square(1) % Neuron traces to plot

% Load image to use and NeuronROIs
dirstr = ChangeDirectory_NK(sesh_use,0);
im_use = imread(fullfile(dirstr,proj_use));
load(fullfile(dirstr,'FinalOutput.mat'),'NeuronImage','NeuronTraces'); % Load ROIs and traces

figure(1)
% Plot ROIs
hROI = subplot(8,8,[1:4 (1:4)+8 (1:4)+16 (1:4)+24 (1:4)+32 (1:4)+40 (1:4)+48 (1:4)+56]);
hROI = plot_allROIs( NeuronImage, im_use, hROI);
axis equal
axis off
colorbar off
[hROI, colors_used] = plot_neuron_outlines(nan,NeuronImage(neurons_plot),hROI);
hold off

htraces = subplot(8,8,[5:8 (5:8)+8 (5:8)+16 (5:8)+24 (5:8)+32 (5:8)+40 (5:8)+48 (5:8)+56]);
plot_neuron_traces( NeuronTraces.(trace_plot)(neurons_plot,:), colors_used, htraces );
hold off

%% Figure 2b - example tuning curve metholodogy
sesh_use = G45_square(1:2);
neuron_use = 50;
rot_array = 0:90:270;
base_dir = ChangeDirectory_NK(sesh_use(1),0);
load(fullfile(base_dir,'batch_session_map.mat'));
batch_session_map = fix_batch_session_map(batch_session_map);
corr_mat = corr_rot_analysis( sesh_use(1), sesh_use(2), batch_session_map, ...
    rot_array );

% plot all 4 rotations with correlation on them
figure;
set(gcf,'Position',[2100, 120, 450, 850]);
subplot(4,2,1)
load(fullfile(base_dir,'Placefields_rot0.mat'),'TMap_gauss')
imagesc_nan(TMap_gauss{neuron_use});
axis off
title(['Base session - Neuron ' num2str(neuron_use)])

sesh_index = arrayfun(@(a) get_session_index( a, batch_session_map.session ),...
    sesh_use);
map_use = get_neuronmap_from_batchmap(batch_session_map, sesh_index(1),...
    sesh_index(2));
sesh2_neuron = map_use(neuron_use);
corrs_plot = corr_mat(neuron_use,:);
for j = 1:length(rot_array)
    load(fullfile(ChangeDirectory_NK(sesh_use(2),0),['Placefields_rot' ...
        num2str(rot_array(j)) '.mat']),'TMap_gauss');
    subplot(4,2,2*j)
    imagesc_nan(TMap_gauss{sesh2_neuron});
    axis off
    title({['{\theta} = ' num2str(rot_array(j))],...
        ['r^2 = ' num2str(corrs_plot(j),'%0.2f')]})
end


%% Figure 2c - example cells + locations - see russek_day_poster.m

%% Figure 4 - connected occupancy maps with firing...
mouse_use = 2;
sesh_use = 6;
corr_cutoff = 0.5;
corr_mat_use = twoenv_squeeze(Mouse(mouse_use).corr_mat.circ2square);
corrs_use = corr_mat_use{sesh_use,sesh_use};
sesh_plot = Mouse(mouse_use).sesh.square(sesh_use);
dir_use = ChangeDirectory_NK(sesh_plot);
load(fullfile(dir_use,'Placefields_rot0.mat'),'PSAbool','x','y');
num_neurons = size(PSAbool,1);
figure(99); set(gcf,'Position',[2450 460 960 450]);
n_out = 1; stay_in = true;
neurons_use = find(corrs_use > corr_cutoff);
while stay_in
    neuron_plot = neurons_use(n_out);
    plot(x,y,'k',x(PSAbool(neuron_plot,:)),y(PSAbool(neuron_plot,:)),'r*'); 
    title(['Neuron ' num2str(neuron_plot) ' - ' mouse_name_title(sesh_plot.Animal) ' - ' ...
        mouse_name_title(sesh_plot.Date) ' - ' num2str(sesh_plot.Session)])
    axis off
    [n_out, stay_in] = LR_cycle(n_out, [1 length(neurons_use)]);
    
end

%% Figure 3 supplementals
%% Rubin replication
plot_all_mice = true;
cm = 'jet';
ticks = 1.5:2:15.5; % 1:16;
ticklabels = arrayfun(@num2str,1:8,'UniformOutput',false);% {'s' 's' 'c' 'c' 'c' 'c' 's' 's' 's' 'c' 'c' 's' 's' 's' 'c' 'c' };

mat_full = [];
for j = 1:4
    mat_use = Mouse(j).PV_corrs.circ2square.PV_corr_mean;
    mat_full = cat(3,mat_full,mat_use);
end
if plot_all_mice
    figure(300)
    set(gcf,'Position',[2170 120 790 830])

    for j = 1:4
        subplot(3,2,j);
        mat_plot = Mouse(j).PV_corrs.circ2square.PV_corr_mean;
        mat_plot(mat_plot == 1) = nan;
        imagesc_nan(Mouse(j).PV_corrs.circ2square.PV_corr_mean,cm);
       
        title(mouse_name_title(Mouse(j).sesh.circ2square(1).Animal));
        set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
            'YTick',ticks,'YTickLabel',ticklabels);
        make_plot_pretty(gca); 
        
    end
    subplot(3,2,5);
    mat_plot_all = nanmean(mat_full(:,:,[1 2 4]),3);
%     mat_plot_all(mat_plot_all == 1) = nan;
    imagesc_nan(mat_plot_all,cm);
    set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
        'YTick',ticks,'YTickLabel',ticklabels);
    title('All Mice')
    make_plot_pretty(gca)
end

figure(301)
set(gcf,'Position',[1980 10 1310 990])
mat_plot_all = nanmean(mat_full,3);
mat_plot_all(mat_plot_all == 1) = nan;
imagesc_nan(mat_plot_all,cm);
imagesc_nan(mat_plot_all,cm);
hold on;
lw_out = 1.5;
lw_in = 3.5;
h = plot([0.5 16.5],[8.5 8.5],'r--',[0.5 16.5],[12.5 12.5],'r--'); 
[h.LineWidth] = deal(lw_out);
h = plot([8.5 8.5],[0.5 16.5],'r--',[12.5 12.5],[0.5 16.5],'r--');
[h.LineWidth] = deal(lw_out);
h = plot([8.5 12.5],[8.5 8.5],'r--',[8.5 12.5],[12.5 12.5],'r--'); 
[h.LineWidth] = deal(lw_in);
h = plot([8.5 8.5],[8.5 12.5],'r--',[12.5 12.5],[8.5 12.5],'r--');
[h.LineWidth] = deal(lw_in);
hold off
set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
    'YTick',ticks,'YTickLabel',ticklabels);
axis equal tight
hc = colorbar; hc.Ticks = hc.Limits;% hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
title('All Mice')
make_plot_pretty(gca); make_plot_pretty(hc);

%% Rubin et al replication for all days but comparing all cells vs. 
% cells active both days vs. cells active ALL days...

mat_full2{1} = mat_full;

% Make active_both matrix
mat_fullb = [];
for j = 1:4
    mat_use = Mouse(j).PV_corrs.active_both.circ2square.PV_corr_mean;
    mat_fullb = cat(3,mat_fullb,mat_use);
end
mat_full2{2} = mat_fullb;

% Make active_all matrix
mat_fullb = [];
for j = 1:4
    mat_use = Mouse(j).PV_corrs.active_all.circ2square.PV_corr_mean;
    mat_fullb = cat(3,mat_fullb,mat_use);
end
mat_full2{3} = mat_fullb;

figure(304)
set(gcf,'Position',[1980 10 1310 990])

title_text = {'All Mice - All Cells', 'All Mice - Cells Active Both Sessions' ,...
    'All Mice - Cells Active All Sessions'};
for j = 1:3
    subplot(2,2,j)
    mean_plot = nanmean(mat_full2{j},3);
    mean_plot(mean_plot == 1) = nan;
    imagesc_nan(mean_plot,cm);
    hold on;
    lw_out = 1.5;
    lw_in = 3.5;
    h = plot([0.5 16.5],[8.5 8.5],'r--',[0.5 16.5],[12.5 12.5],'r--');
    [h.LineWidth] = deal(lw_out);
    h = plot([8.5 8.5],[0.5 16.5],'r--',[12.5 12.5],[0.5 16.5],'r--');
    [h.LineWidth] = deal(lw_out);
    h = plot([8.5 12.5],[8.5 8.5],'r--',[8.5 12.5],[12.5 12.5],'r--');
    [h.LineWidth] = deal(lw_in);
    h = plot([8.5 8.5],[8.5 12.5],'r--',[12.5 12.5],[8.5 12.5],'r--');
    [h.LineWidth] = deal(lw_in);
    hold off
    set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
        'YTick',ticks,'YTickLabel',ticklabels);
    axis equal tight
    hc = colorbar; hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
    title(title_text{j})
    make_plot_pretty(gca); make_plot_pretty(hc);
end
%% Rubin et al replication for connected days only
plot_all_mice = false;
cm = 'jet';
ticks = 1:8; % 1:16;
ticklabels = {'5s','5c','5s','5c','6c','6s','6c','6s'}; %arrayfun(@num2str,5:6,'UniformOutput',false);% {'s' 's' 'c' 'c' 'c' 'c' 's' 's' 's' 'c' 'c' 's' 's' 's' 'c' 'c' };

mat_full = [];
for j = 1:4
    mat_use = Mouse(j).PV_corrs.conn.PV_corr_mean;
    mat_full = cat(3,mat_full,mat_use);
end

mat_use(logical(eye(8))) = nan;
if plot_all_mice
    figure(302)
    for j = 1:4
        subplot(3,2,j);
        imagesc_nan(mat_use,cm);
       
        title(mouse_name_title(Mouse(j).sesh.circ2square(1).Animal));
        set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
            'YTick',ticks,'YTickLabel',ticklabels);
    end
    subplot(3,2,5);
    imagesc_nan(mean(mat_full,3),cm);
    set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
        'YTick',ticks,'YTickLabel',ticklabels);
    title('All Mice')
end

figure(303)
set(gcf,'Position',[1980 10 800 700])
mean_plot = mean(mat_full,3);
mean_plot(logical(eye(8))) = nan;
% mean_plot(logical(eye(16))) = nan;
imagesc_nan(mean_plot,cm);
hold on;
% lw_out = 1.5;
% lw_in = 3.5;
% h = plot([0.5 16.5],[8.5 8.5],'r--',[0.5 16.5],[12.5 12.5],'r--'); 
% [h.LineWidth] = deal(lw_out);
% h = plot([8.5 8.5],[0.5 16.5],'r--',[12.5 12.5],[0.5 16.5],'r--');
% [h.LineWidth] = deal(lw_out);
% h = plot([8.5 12.5],[8.5 8.5],'r--',[8.5 12.5],[12.5 12.5],'r--'); 
% [h.LineWidth] = deal(lw_in);
% h = plot([8.5 8.5],[8.5 12.5],'r--',[12.5 12.5],[8.5 12.5],'r--');
% [h.LineWidth] = deal(lw_in);
hold off
set(gca,'XAxisLocation','top','XTick',ticks,'XTickLabel',ticklabels,...
    'YTick',ticks,'YTickLabel',ticklabels);
axis equal tight
hc = colorbar; % hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
title('All Mice')
make_plot_pretty(gca);
make_plot_pretty(hc)



%% p-value distribution by session
sesh_use2 = cat(1,G30_botharenas, G31_botharenas, G45_botharenas, ...
    G48_botharenas);
for j = 1:4
    sesh_use = sesh_use2(j,:);
    figure(400+j)
    ylim_vec = zeros(1,16);
    for k = 1:16
        ChangeDirectory_NK(sesh_use(k));
        load('Placefields_rot0.mat','pval');
        subplot(4,4,k)
        histogram(pval,30);
        xlim([0 1.05])
        xlabel('pval')
        ylabel('Count')
        if k == 1
            title(mouse_name_title(sesh_use(k).Animal))
        end
        temp = get(gca,'YLim');
        ylim_vec(k) = max(temp);
    end
    ymax = max(ylim_vec);
    for k = 1:16
        subplot(4,4,k)
        ylim([0 ymax])
    end
end

%% Aggregrate p-value distribution across all sessions
sesh_use3 = cat(1,G30_botharenas, G31_botharenas, G45_botharenas, G48_botharenas);
pthresh = 0.05;
name_append = '_cm4_trans_rot0';
PFpct = nan(size(sesh_use3,1),size(sesh_use3,2));

% Get percentages of PFs
cmperbin_all = nan(1,size(sesh_use3,1));
for k = 1:size(sesh_use3,1)
    sesh_use_temp = sesh_use3(k,:);
    for j = 1:length(sesh_use_temp)
        dirstr = ChangeDirectory_NK(sesh_use_temp(j));
        try
            load(fullfile(dirstr,['Placefields' name_append '.mat']),...
                'pval','cmperbin')
            PFpct(k,j) = sum(pval < pthresh)/length(pval);
        catch
            disp(['No file for ' dirstr])
        end
    end
    cmperbin_all(k) = cmperbin;
end

% Plot pie charts of each
PFmean_ind = nanmean(PFpct,2);
PFmean_all = nanmean(PFpct(:));
figure
plot_ind = [ 1 2 4 5 ];
for k = 1:size(sesh_use3,1)
   subplot(2,3,plot_ind(k))
   pie([PFmean_ind(k) 1 - PFmean_ind(k)])
   title(['PF breakdown - ' mouse_name_title(sesh_use3(k,1).Animal)])
end

subplot(2,3,3)
pie([PFmean_all 1 - PFmean_all])
title('PF breakdown - All Mice')
legend('Place Cells', 'Non-place cells')

subplot(2,3,6)
text(0.1,0.8,['pval thresh = ' num2str(pthresh)])
text(0.1,0.6, ['cmperbin = ' num2str(mean(cmperbin_all))])
text(0.1,0.4, ['mean = ' num2str(nanmean(PFpct(:)))])
text(0.1,0.2, ['std = ' num2str(nanstd(PFpct(:)))])
if any(isnan(PFpct(:))); title(['Incomplete Run - ' num2str(sum(isnan(PFpct(:)))) ...
        ' missing sessions']); end
axis off

%% Silly plot to get mean # neurons per 10 min session for each animal - not a figure but a stat in paragraph 1
sesh_use = cat(1,G30_botharenas, G31_botharenas, G45_botharenas,...
    G48_botharenas);
n_neurons = nan(size(sesh_use));
for j = 1:size(sesh_use,1)
    for k = 1:size(sesh_use,2)
        loadvar(sesh_use(j,k),'FinalOutput.mat','NumNeurons');
        n_neurons(j,k) = NumNeurons;
    end
end

n_mean_sep = mean(n_neurons(:,[1:8 13:16]),2);
n_mean_conn = mean(n_neurons(:,10:11),2);
n_mean_sq = mean(n_neurons(:,[1 2 7 8 13 14]),2);
n_mean_circ = mean(n_neurons(:,[3:6, 10 11 15 16]),2);
n_std_sep = std(n_neurons(:,[1:8 13:16]),1,2);
n_std_conn = std(n_neurons(:,10:11),1,2);
n_std_sq = std(n_neurons(:,[1 2 7 8 13 14]),1,2);
n_std_circ = std(n_neurons(:,[3:6, 10 11 15 16]),1,2);

n_all_sep = n_neurons(:,[1:8 13:16]);
n_all_conn = n_neurons(:,10:11);
n_mean_sep_all = mean(n_all_sep(:));
n_std_sep_all = std(n_all_sep(:));
n_mean_conn_all = mean(n_all_conn(:));
n_std_conn_all = std(n_all_conn(:));

%% Neuron reg plot
mouse_use = Mouse(1);
sesh_use = mouse_use.sesh.circ2square;
reg_stats = reg_qc_plot_batch(sesh_use(1), sesh_use(2:end), ...
    'batch_mode', 1, 'name_append', '_trans');



%% Bar plot of mean abs orientation diff for coherent v remapping 
% Very rough - only looks at session 1 versus all the rest

% Pull-out circ2square comparisons
square_ind = [ 2 7 8 9 12 13 14]-1;
circ_ind = [3 4 5 6 10 11 15 16]-1;
maod = nan(3,15);
maod(1,:) = cellfun(@(a) median(abs(a.orient_diff)), reg_stats)';
maod(2,square_ind) = mouse_use.coherency.square.hmat(1,2:end);
maod(2,circ_ind) = mouse_use.coherency.circ2square.hmat(1,:);
maod(3,square_ind) = ~mouse_use.remapping_type.global.square(1,2:end);
maod(3,circ_ind) = ~mouse_use.remapping_type.global.circ2square(1,:);

figure
set(gcf,'Position',[1980 200 1725 680])
subplot(2,2,1)
bar([0 1], [mean(maod(1,maod(2,:) == 0)), mean(maod(1,maod(2,:) == 0))])
hold on

plot(maod(2,:),maod(1,:),'o'); 
set(gca,'XTick',[0 1],'XTickLabel',{'Remapping','Coherent'}); 
xlim([-1 2])
ylabel('Mean Absolute Orientation Difference')
title({'Is Remapping a result of poor registration quality?', ...
    '\chi^2 test'})

subplot(2,2,2)
bar([0 1], [mean(maod(1,maod(3,:) == 0)), mean(maod(1,maod(3,:) == 0))])
hold on

plot(maod(3,:),maod(1,:),'o'); 
set(gca,'XTick',[0 1],'XTickLabel',{'Remapping','Coherent'}); 
xlim([-1 2])
ylabel('Mean Absolute Orientation Difference')
title({'Is Remapping a result of poor registration quality?',...
    'Tuning Curve Permutation Test'})


subplot(2,2,3)
[~,p] = ttest2(maod(1,maod(2,:) == 0), maod(1,maod(2,:) == 1));
title(['Stats for ' mouse_name_title(mouse_use.sesh.circ2square(1).Animal)])
text(0.1,0.7,'Un-paired t-test')
text(0.1,0.5,['p = ' num2str(p)]) 
axis off

subplot(2,2,4)
[~,p] = ttest2(maod(1,maod(3,:) == 0), maod(1,maod(3,:) == 1));
title(['Stats for ' mouse_name_title(mouse_use.sesh.circ2square(1).Animal)])
text(0.1,0.7,'Un-paired t-test')
text(0.1,0.5,['p = ' num2str(p)]) 
axis off

% mean_mat = nan(16,16);
% mean_mat(1,2:16) = cellfun(@(a) mean(abs(a.orient_diff)), reg_stats)'; % dump values into
% mean_mat = twoenv_squeeze(mean_mat);

%% Do Mice use stripes to align between arenas?
h1 = figure; h2 = figure;
best_angle_all_sesh = []; best_angle_all_neurons = [];
for j = 1:num_animals
    dirstr = ChangeDirectory_NK(Mouse(j).sesh.circ2square(1),0);
    load(fullfile(dirstr,'full_rotation_analysis_circ2square_shuffle1000.mat'),...
        'best_angle','best_angle_all')
    
   figure(h1)
   subplot(2,3,j)
   best_angle_plot = best_angle(:);
   best_angle_all_sesh = [best_angle_all_sesh; best_angle_plot];
   histogram(best_angle_plot,0:15:360)
   xlabel('Local Cue Mismatch')
   ylabel('Count')
   title(['\theta_{max} Histogram - Session Mean: ' ...
       mouse_name_title(Mouse(j).sesh.circ2square(1).Animal)])
   
   figure(h2)
   subplot(2,3,j)
   best_angle_neurons_plot = cat(1,best_angle_all{:});
   best_angle_all_neurons = [best_angle_all_neurons; best_angle_neurons_plot];
   histogram(best_angle_neurons_plot,0:15:360)
   xlabel('Local Cue Mismatch')
   ylabel('Count')
   title(['\theta_{max} Histogram - All Neurons: ' ...
       mouse_name_title(Mouse(j).sesh.circ2square(1).Animal)])
end

figure(h1)
subplot(2,3,5)
histogram(best_angle_all_sesh,0:15:360)
xlabel('Local Cue Mismatch')
ylabel('Count')
title('\theta_{max} Histogram - Session Mean: All Mice')
subplot(2,3,6)
text(0.1,.5,'Stripes match at 135\circ and 225\circ')
axis off

figure(h2)
subplot(2,3,5)
histogram(best_angle_all_neurons,0:15:360)
xlabel('Local Cue Mismatch')
ylabel('Count')
title('\theta_{max} Histogram - All Neurons: All Mice')
subplot(2,3,6)
text(0.1,.5,'Stripes match at 135\circ and 225\circ')
axis off

%% Generate PV correlation maps for sq only v circ only v both cells 
disc_thresh = 0.5; % Cells above/below this are considered to fire preferentially in one arena over the other
same_thresh = 0.5; % Cells with abs(DI) below this are considered to fire equally in each arena
sq_ind = [9 12]; circ_ind = [10 11]; % Indices of square and circle sessions to compare
num_comps = length(sq_ind);
PVfilt_corrs = nan(num_animals,num_comps,5,5,3); % # Animals x # sessions x #Xbins x # Ybins x #cell groups
DI_counts = nan(num_animals,num_comps);
min_use = nan; max_use = nan;
for j = 1:num_animals
    for k = 1:2
        % ID sq, circ, and both cells
        DI_use = squeeze(Mouse(j).DI(k+4,k+4,:)); % Get discrimination index for connected day
        cell_filt_bool{1} = DI_use > disc_thresh; % square cells
        cell_filt_bool{2} = DI_use < -disc_thresh; % circle cells
        cell_filt_bool{3} = abs(DI_use) <= same_thresh; % Both env cells
        
        PV_use = Mouse(j).PV.circ2square([sq_ind(k) circ_ind(k)],:,:,:);
        for ll = 1:3
            PV_env{ll} = PV_use(:, :, :, cell_filt_bool{ll});
                        % Can't get below to work so I'm for looping it
            %             PV_corrs = arrayfun(@(a,b) corr(a,b),squeeze(PV_env{ll}(1,:,:,:)),...
            %                 squeeze(PV_env{ll}(2,:,:,:)));
            for mm = 1:5
                for nn = 1:5
                    PV1 = squeeze(PV_env{ll}(1,mm,nn,:));
                    PV2 = squeeze(PV_env{ll}(2,mm,nn,:));
                    PVfilt_corrs(j,k,mm,nn,ll) = corr(PV1,PV2,'type','Spearman');
                    
                end
            end
        end
        
    end
    min_use = nanmin([min_use PVfilt_corrs(j,:)]);
    max_use = nanmax([max_use PVfilt_corrs(j,:)]);
    
end

% Now plot them all out
clear h
disc_type = {'Square Cells', 'Circle Cells', 'Both Arena Cells'};
for day = 1:2
    h{day} = figure;
    for j = 1:3
        for k = 1:4
            mouse_name = Mouse(k).sesh.circ2square(1).Animal;
            PV_plot = squeeze(PVfilt_corrs(k,day,:,:,j));
            subplot(3,5,5*(j-1)+k)
            imagesc_nan(PV_plot);
            set(gca,'CLim',[min_use max_use])
            title({['Day: ' num2str(day+4) ' ' mouse_name_title(mouse_name)...
                ' - ' disc_type{j}],['Mean = ' num2str(nanmean(PV_plot(:)),'%0.2f')]})
            axis off
        end
    end
end

for day = 1:2
    figure(h{day})
    for j = 1:3
        subplot(3,5,5*j)
        PV_plot = PVfilt_corrs(:,day,:,:,j);
        imagesc_nan(squeeze(nanmean(PV_plot,1)));
        set(gca,'CLim',[min_use max_use])
        title({['Day: ' num2str(day+4) ' All Mice Combined'],...
            ['Mean = ' num2str(nanmean(PV_plot(:)),'%0.2f')]})
        axis off
        colorbar
        
    end
end

%% Get number of sq v circ v both cells for each session
try; close hh hm; clear hh hm; end % Close and clear figure handles
% Indices of square and circle sessions to compare
plot_all_mice = true;
sq_ind_full = [2 7 8 9 12 13 14]; sq_ind_sm = [2 3 4 5 6 7 8];
circ_ind_full = [3 6 10 10 11 11 15]; circ_ind_sm = [1 4 5 5 6 6 7];

num_comps = length(sq_ind);

% Calculate discrimination type proportions for before/during/after
% connection
discrim_count = nan(num_animals,num_comps,3);
discrim_prop = nan(num_animals,num_comps,3);
for j = 1:num_animals
    for k = 1:num_comps
        % ID sq, circ, and both cells
        
        DI_use = squeeze(Mouse(j).DI(sq_ind_sm(k),circ_ind_sm(k),:)); % Get discrimination index for connected day
        cell_filt_bool{1} = DI_use > disc_thresh; % square cells
        cell_filt_bool{2} = DI_use < -disc_thresh; % circle cells
        cell_filt_bool{3} = abs(DI_use) <= same_thresh; % Both env cells
        discrim_count(j,k,:) = cellfun(@sum,cell_filt_bool);
        discrim_prop(j,k,:) = discrim_count(j,k,:)/sum(squeeze(discrim_count(j,k,:)));
    end
end
    
% Pie chart before/during/after of DI types of neurons - Pie charts are
% silly but what the heck, simplest for now.
h_all = figure;

disc_prop_all = squeeze(mean(discrim_prop,1));
title_use = {'Before','Before','Day4s-Day5c','Day5','Day6','Day6c-Day7s','After'};
for j = 1:length(sq_ind_full)
   subplot(2,4,j)
   pie(disc_prop_all(j,:))
   if j == 1
       legend({'Square cells','Circle Cells','Both'})
   end
   title(title_use{j})
   
end
subplot(2,4,8)
text(0.1,0.5,'All Mice')
axis off

if plot_all_mice
    for k = 1:num_animals
        hm{k} = figure;
        for j = 1:length(sq_ind_full)
            subplot(2,4,j)
            pie(squeeze(discrim_prop(k,j,:)))
            if j == 1
                legend({'Square cells','Circle Cells','Both'})
            end
            title(title_use{j})
            
        end
        subplot(2,4,8)
        text(0.1,0.5,mouse_name_title(Mouse(k).sesh.circ2square(1).Animal)) 
        axis off
        
    end
end

%% Generate PV Methodology plot (Figure 4D)
Mouse_use = 4;
arena_type = 'square';
sesh_use = Mouse(Mouse_use).sesh.(arena_type)(1:2);

dirstr = ChangeDirectory_NK(sesh_use(1),0);
load(fullfile(dirstr,'Placefields_rot0.mat'),'TMap_gauss');
[Nybins, Nxbins] = size(TMap_gauss{1});

figure
set(gcf,'Position',[2000 100 1000 900])
hPV = subplot(4,2,[1 3 5 7]);
hPV = makePVexample( TMap_gauss(1:5), hPV);

%%% PLOT example PV corr at ~1cm bin resolution (to match PFs above)
% Load stuff
load(fullfile(dirstr,'batch_session_map'))
batch_session_map = fix_batch_session_map(batch_session_map);
sesh_inds = arrayfun(@(a) get_session_index(a,batch_session_map.session),...
    sesh_use);
best_angle_use = Mouse(4).best_angle.(arena_type)(sesh_inds);
pos_file_use = arrayfun(@(a) ['Pos_align_rot' num2str(a) '.mat'],...
    best_angle_use,'UniformOutput',false);
[~, PVcorr_plot] = get_PV_and_corr(sesh_use, batch_session_map,...
    'alt_pos_file', pos_file_use,'use_TMap','gauss','TMap_name_append',...
    arrayfun(@(a) ['_rot' num2str(a)],Mouse(Mouse_use).best_angle.(arena_type),...
    'UniformOutput',false)); % Get PVcorrs
subplot(4,2,[4 6])
imagesc_nan(squeeze(PVcorr_plot.PV_corr(1,2,:,:))); % plot it out
axis off
c = colorbar; set(c,'ytick',c.Limits,'TickLabels', arrayfun(@(a) sprintf(...
    '%0.2g',a),c.Limits,'UniformOutput',false))

%% Figure 5 b-f: PV vs day plots
%%% NK NOTE: need to add in minimum number of cells filter...
overlap_num_thresh = 25; % Exclude all comparisons with less than 25 common cells between session.
sesh_type = {'square', 'circle', 'circ2square'};
shuffle_types = {'PV_corr_shuffle','PV_corr_binshuffle'};
shuf_ind = 1;
PV_corr_all.square = nan(8,8);
PV_corr_all.circle = nan(8,8);
PV_corr_all.circ2square = nan(16,16);
PV_corr_local_all = PV_corr_all;
PV_shuf_all = PV_corr_all;
try; close 500; end; try; close 501; end; try; close 502; end
hind = figure(500); hall = figure(501); hcomb = subplot(2,2,4);
for k = 1:length(sesh_type)
    for j = 1:length(Mouse)
        mouse_name = mouse_name_title(Mouse(j).sesh.square(1).Animal);
        overlap_filter = Mouse(j).cell_overlap.(sesh_type{k}).overlap_num ...
            > overlap_num_thresh;
        
        % Plot broken down by mouse
        figure(hind);
        hax = subplot(4,4,4*(k-1)+j);
        PV_corr_use = Mouse(j).PV_corrs.(sesh_type{k}).PV_corr_mean;
        PV_corr_local_use = Mouse(j).PV_corrs.local_aligned.(sesh_type{k}).PV_corr_mean;
        PV_shuf_use = squeeze(nanmean(nanmean(Mouse(j).PV_corrs.(sesh_type{k})...
            .(shuffle_types{shuf_ind}),3),4));
        [~,~,~, hCI{j,k}] = twoenv_plot_PVcurve(PV_corr_use, sesh_type{k}, PV_shuf_use, hax,...
            true, overlap_filter);
        title([mouse_name ' - ' sesh_type{k}])
%         make_plot_pretty(gca)
        
        % Assemble into one big matrix for all mice
        PV_corr_filt = PV_corr_use; 
        PV_corr_filt(~overlap_filter) = nan; % Filter out sessions that don't have enough cells
        PV_corr_all.(sesh_type{k}) = cat(3,PV_corr_all.(sesh_type{k}), ...
            PV_corr_filt); %PV_corr_use);
        
        PV_corr_local_filt = PV_corr_local_use; 
        PV_corr_local_filt(~overlap_filter) = nan; % Filter out sessions that don't have enough cells
        PV_corr_local_all.(sesh_type{k}) = cat(3,PV_corr_local_all.(sesh_type{k}), ...
            PV_corr_local_filt); %PV_corr_use);
        
        PV_shuf_filt = reshape(PV_shuf_use, size(PV_shuf_use,1)*...
            size(PV_shuf_use,2),size(PV_shuf_use,3));
        PV_shuf_filt(reshape(~overlap_filter, length(overlap_filter(:)),1),:) = nan;
        PV_shuf_filt = reshape(PV_shuf_filt, size(PV_shuf_use));
        PV_shuf_all.(sesh_type{k}) = cat(3,PV_shuf_all.(sesh_type{k}), ...
            PV_shuf_filt); %PV_shuf_use);
        
        % Plot all mice on one plot
        figure(hall)
        hold on
        hax_all = subplot(2,2,k);
        twoenv_plot_PVcurve(PV_corr_use, sesh_type{k}, PV_shuf_use, hax_all,...
            false, overlap_filter);
        hold on
        twoenv_plot_PVcurve(PV_corr_use, sesh_type{k}, PV_shuf_use, hcomb,...
            false, overlap_filter);
        hold on
        
    end
    figure(hall);

    PV_corr_all_use = nanmean(PV_corr_all.(sesh_type{k}),3);
    PV_corr_local_all_use = nanmean(PV_corr_local_all.(sesh_type{k}),3);
    
    PV_shuf_all_use = PV_shuf_all.(sesh_type{k});
    [~, unique_lags_all{k}, mean_PVcorr_all{k},~, ~, day_lag_all{k}] = twoenv_plot_PVcurve(...
        PV_corr_all_use, sesh_type{k}, PV_shuf_all_use, hax_all, true);
    [~, unique_days_check{k}, mat_ind_all{k}] = group_mat(PV_corr_all_use, ...
        day_lag_all{k});
    ylim([-0.1 0.7])
    title(['All Mice - ' sesh_type{k}])
    make_plot_pretty(gca)
%     keyboard
    [~, CI_lags{k} ,~ ,~, CI{k}] = twoenv_plot_PVcurve(PV_corr_all_use, ...
        sesh_type{k}, PV_shuf_all_use, hcomb, true);
    hold on
    ylim([-0.1 0.7])
    hold off
    
    [~, ~, mean_PVcorr_local_all{k}] = twoenv_plot_PVcurve(...
        PV_corr_local_all_use, sesh_type{k}, [], 'dont_plot', true);
    
end
figure(hind)
subplot(4,4,13)
text(0.1,0.1,['Pval filt = ' num2str(inclusion_criteria.pval_filt)]);
text(0.1,0.3,['Pval thresh = ' num2str(inclusion_criteria.pval_thresh)]);
text(0.1,0.5,['ntrans thresh = ' num2str(inclusion_criteria.ntrans_thresh)]);
axis off

% Make CIs as max/min of all animals CIs in unncessarily complicated way
CI_lines_ind = arrayfun(@(a) all(a.Color == [1 0 1]),...
    hcomb.Children(arrayfun(@(a) isgraphics(a,'line'),hcomb.Children)));
CI_handles = hcomb.Children(arrayfun(@(a) isgraphics(a,'line'),hcomb.Children));
CI_handles = CI_handles(CI_lines_ind);
% CImat = cell2mat(arrayfun(@(a) a.YData,CI_handles,'UniformOutput',false));
% CI_min = min(CImat,[],1);
% CI_max = max(CImat,[],1);
% CI_min_mean = nanmean(CImat([1 4 7],:),1);
% CI_max_mean = nanmean(CImat([2 5 8],:),1);
% CI_mean_mean = nanmean(CImat([3 6 9],:),1);
% CIx = CI_handles(1).XData;
% delete(CI_handles(3:end));
% CI_handles(1).YData = CI_max;
% CI_handles(2).YData = CI_min;
make_plot_pretty(hcomb)

% Plot same env overlap and different env overlap
figure(502); set(gcf,'Position',[2150 20 760 940]);
subplot(2,1,1);
same_env = cellfun(@(a,b) [a; b], mean_PVcorr_all{1}, mean_PVcorr_all{2},...
    'UniformOutput',false);
diff_env = mean_PVcorr_all{3};
errorbar(unique_lags_all{1}, cellfun(@mean, same_env), ...
    cellfun(@std, same_env)./sqrt(cellfun(@length, same_env)), 'k.-');
hold on
errorbar(unique_lags_all{3}, cellfun(@mean, diff_env), ...
    cellfun(@std, diff_env)./sqrt(cellfun(@length, diff_env)), 'r.-');

local_mat = cell(8,3);
for j = 1:3
    local_mat(arrayfun(@(a) find(a == 0:7), unique_lags_all{j}),j) = ...
        mean_PVcorr_local_all{j};
end
local_comb = cellfun(@(a,b,c) cat(1,a,b,c), local_mat(:,1), local_mat(:,2), ...
    local_mat(:,3),'UniformOutput',false);
errorbar((0:7)',cellfun(@mean, local_comb), cellfun(@std, local_comb)./...
    sqrt(cellfun(@length,local_comb)), 'c:')
% same_env_local = cellfun(@(a,b) [a; b], mean_PVcorr_local_all{1}, mean_PVcorr_local_all{2},...
%     'UniformOutput',false);
% diff_env_local = mean_PVcorr_local_all{3};
% errorbar(unique_lags_all{1}, cellfun(@mean, same_env_local), ...
%     cellfun(@std, same_env_local)./sqrt(cellfun(@length, same_env_local)), 'k.--');
% hold on
% errorbar(unique_lags_all{3}, cellfun(@mean, diff_env_local), ...
%     cellfun(@std, diff_env_local)./sqrt(cellfun(@length, diff_env_local)), 'r.--');


xlabel('Day lag')
ylabel('Mean PV correlation')
title(mouse_name_title(shuffle_types{shuf_ind}))
xlim([-0.5 7.5]); ylim([-0.1 0.7])

% Hack to get mean CIs from all three comparisons
CImin = nan(8,3); CImax = nan(8,3);
for j = 1:3
   CImin(arrayfun(@(a) find(a == 0:7),CI_lags{j}),j) = CI{j}(:,2);
   CImax(arrayfun(@(a) find(a == 0:7),CI_lags{j}),j) = CI{j}(:,1);
end

% hshufline = plot(CIx, CI_mean_mean);
hshufline = plot((0:7)',[nanmean(CImin,2) nanmean(CImax,2)],'Color',...
    CI_handles(1).Color, 'LineStyle', CI_handles(1).LineStyle);
% set(hshufline,'Color',CI_handles(1).Color, 'LineStyle', ...
%         CI_handles(1).LineStyle);
make_plot_pretty(gca)
legend('Same Arena','Circle-to-square','Local Cues Aligned',...
    'Shuffled')

%% GLM the above to pull out differences due to: day lag, same/diff arena, 
% connected or not, before/during/after, and local cues aligned v best
% angle


% Make connected indices
conn_indsep = false(8);
conn_indsep(5:6,:) = true;
conn_indsep(:,5:6) = true;
conn_indsep = conn_indsep & ~isnan(day_lag_all{1});
conn_indcomb = false(16);
conn_indcomb(9:12,:) = true;
conn_indcomb(:,9:12) = true;
conn_indcomb = conn_indcomb & ~isnan(day_lag_all{3});
conn_ind_cell{1} = conn_indsep; conn_ind_cell{2} = conn_indsep;
conn_ind_cell{3} = conn_indcomb;

temp = cat(1,mean_PVcorr_all{:});
PVvec = cat(1,temp{:});

% construct vectors of design matrix
day_vec = [];
% same_vec = [];
conn_vec = [];
bda_vec = []; % before/during/after is weird - ignore for now
for j = 1:3
    nsesh(j) = sum(cellfun(@length, mat_ind_all{j}));
    day_vec = [day_vec; day_lag_all{j}(cat(1,mat_ind_all{j}{:}))];
    conn_vec = [conn_vec; conn_ind_cell{j}(cat(1,mat_ind_all{j}{:}))];
    
end
% 1s if the same, 0 if no
same_vec = ones(length(day_vec),1);
same_vec(sum([nsesh(1:2),1]):end) = 0;
nsesh_cum = cumsum(nsesh);
square_vec = zeros(sum(nsesh),1); square_vec(1:nsesh_cum(1)) = 1;
circle_vec = zeros(sum(nsesh),1); circle_vec((nsesh_cum(1)+1):nsesh_cum(2)) = 1;
diff_vec = ~same_vec;
%% Perform GLM on day, same/diff arena, & connected/not (should probably include square v circle too...
fittype = 'interactions'; % 'interactions' could be used also if we assume there is an interaction between same_arena and day_lag
design_mat{1} = ones(size(PVvec));
design_mat{2} = same_vec; %day_vec;
design_mat{3} = [same_vec conn_vec]; % [day_vec same_vec];
design_mat{4} = [same_vec conn_vec day_vec]; %[day_vec same_vec conn_vec];
design_mat{5} = [design_mat{4} binornd(1,0.5,size(design_mat{4},1),1)];

[B{1}, dev(1), stats{1}] = glmfit(design_mat{1}, PVvec, 'normal','constant',...
    'off');
GLM{1} = fitglm(design_mat{1}, PVvec, fittype, 'Intercept', false);
for j = 2:length(design_mat)
    [B{j}, dev(j), stats{j}] = glmfit(design_mat{j}, PVvec, 'normal');
    GLM{j} = fitglm(design_mat{j}, PVvec, fittype);
end

% Do some sort of significance testing to determine if all the predictors
% you added are actually legit
for j = 1:length(B)-1
    p2 = length(B{j+1}); % # parameters in model 1
    p1 = length(B{j}); % # parameters in model 2
    F(j) = (sum(stats{j}.resid.^2) - sum(stats{j+1}.resid.^2))/(p2-p1)/...
        (sum(stats{j+1}.resid.^2)/stats{j+1}.dfe);
    pval(j) = 1 - fcdf(F(j),p2-p1,stats{j+1}.dfe);
end

%% Model - need to include before, during, after AND
fittype = 'linear'; % explicitly modeling interactions below
% What is the mean of the data?
design_mat = cell(0); GLM = cell(0);
mm = 1;
design_mat{mm} = ones(size(PVvec)); mm = mm + 1;
% Are same v diff arena comparisons different?
design_mat{mm} = same_vec; mm = mm + 1;
% 2) Are square v circle different different?
% design_mat{mm} = [design_mat{mm-1} circle_vec]; mm = mm + 1;
% 3) Does connecting the arena affect coherency?
design_mat{mm} = [design_mat{mm-1} conn_vec]; mm = mm + 1;
% 4) Is there a drift with time overall?
% design_mat{mm} = [design_mat{mm-1} day_vec]; mm = mm + 1;
% 5) Is there a diferent drift in same arena than in different arenas?
design_mat{mm} = [design_mat{mm-1} day_vec.*same_vec]; mm = mm + 1;
 % 6) Control sanity check - does adding in some randomly designated group make 
 % a better model? (Answer should be no)
design_mat{mm} = [design_mat{mm-1} binornd(1,0.5,size(design_mat{4},1),1)]; mm = mm + 1;


[B{1}, dev(1), stats{1}] = glmfit(design_mat{1}, PVvec, 'normal','constant',...
    'off');
GLM{1} = fitglm(design_mat{1}, PVvec, fittype, 'Intercept', false);
for j = 2:length(design_mat)
    [B{j}, dev(j), stats{j}] = glmfit(design_mat{j}, PVvec, 'normal');
    GLM{j} = fitglm(design_mat{j}, PVvec, fittype);
end

% Do some sort of significance testing to determine if all the predictors
% you added are actually legit
for j = 1:length(B)-1
    p2 = length(B{j+1}); % # parameters in model 1
    p1 = length(B{j}); % # parameters in model 2
    F(j) = (sum(stats{j}.resid.^2) - sum(stats{j+1}.resid.^2))/(p2-p1)/...
        (sum(stats{j+1}.resid.^2)/stats{j+1}.dfe);
    pval(j) = 1 - fcdf(F(j),p2-p1,stats{j+1}.dfe);
end

cellfun(@(a) a.ModelCriterion.AIC,GLM)
[~, model_use] = min(cellfun(@(a) a.ModelCriterion.AIC,GLM))
% Take home seems to be that model including square v circle v circ2square,
% connected/not, and drift for same arena but NOT circ2square best explains
% the data.  This means that the two main effects are same/different arena,
% then connecting the arena, followed by a small drift with time for the
% circle/square arenas. Need to vet this to see if there is a drift with
% time for all arenas... Also need to do full model analysis (did a greedy
% search by eliminating one predictor at a time) to look at ALL possible
% combinations and see which set works best. Why is there no drift for the
% circ2square? My guess is that in sessions close to one another there is
% an acceleration of drift/separation. However, at longer time scales
% generalization takes over and the environments become more similar. Could
% explain how things happening in two different places a long time ago
% might get confounded. Now need to run this on 5b and 5d (coherent
% probability vs time by same/different, and % cell overlap vs time vs day
% lag - quadratic?)
%%
figure(503); set(gcf,'Position',[1960 50 1730 930]);
subplot(2,2,1)
hold off
plot(day_vec(same_vec & ~conn_vec), PVvec(same_vec & ~conn_vec),'bo'); hold on
plot(day_vec(~same_vec & ~conn_vec), PVvec(~same_vec & ~conn_vec),'ro'); 
legend('Same Arena - Not Connected', 'Different Arena - Not Connected')
xlim([-0.5 7.5])

subplot(2,2,2)
plot(day_vec(same_vec & conn_vec), PVvec(same_vec & conn_vec),'bx'); hold on
plot(day_vec(~same_vec & conn_vec), PVvec(~same_vec & conn_vec),'rx');
legend('Same Arena - Connected', 'Different Arena - Connected')
xlim([-0.5 7.5])

subplot(2,2,3)
hold off
plot(day_vec(same_vec & ~conn_vec), PVvec(same_vec & ~conn_vec),'bo'); hold on
plot(day_vec(same_vec & conn_vec), PVvec(same_vec & conn_vec),'bx');
plot(day_vec(~same_vec & ~conn_vec), PVvec(~same_vec & ~conn_vec),'ro'); 
plot(day_vec(~same_vec & conn_vec), PVvec(~same_vec & conn_vec),'rx');
legend('Same Arena - Not Connected', 'Same Arena - Connected',...
    'Different Arena - Not Connected', 'Different Arena - Connected')
xlim([-0.5 7.5])

yhat = glmval(B, design_mat, 'identity');

% T
% Now do it with local aligned data too

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
    cellfun(@std, diff_env), 'g.--');
xlabel('Day lag')
ylabel('Mean overlap ratio')
xlim([-0.5 7.5]); ylim([0 0.6])
make_plot_pretty(gca)
legend('Same Arena','Circle-to-square')


       

%% Generate bar chart of average PV corr at 1 day lag before and after connection
across.before = [1 1 2 2 7 7 8 8; 3 4 3 4 5 6 5 6];
across.during = [9 12; 10 11];
across.after = [13 13 14 14; 15 16 15 16];
win.before = [ 3 3 4 4 ; 5 6 5 6];
win.during = [9 10; 12 11]; %[8 9 10 12; 9 12 11 13];
win.after = [14;14]; %[12 12; 13 14]; % This will read out a NaN value

comps = {'before', 'during', 'after'};
pair_type = {'across','win'};
PV_corr_all_use(logical(eye(16))) = nan;

for j = 1:3
    across_ind_use = sub2ind(size(PV_corr_all_use), across.(comps{j})(1,:),...
        across.(comps{j})(2,:));
    win_ind_use = sub2ind(size(PV_corr_all_use), win.(comps{j})(1,:),...
        win.(comps{j})(2,:));
    PV_across_lag1.(comps{j}) = PV_corr_all_use(across_ind_use);
    PV_win_lag1.(comps{j}) = PV_corr_all_use(win_ind_use);
    across_mean(j,1) = mean(PV_across_lag1.(comps{j}));
    across_sem(j,1) = std(PV_across_lag1.(comps{j}))/...
        sqrt(length(PV_across_lag1.(comps{j})));
    win_mean(j,1) = mean(PV_win_lag1.(comps{j}));
    win_sem(j,1) = std(PV_win_lag1.(comps{j}))/...
        sqrt(length(PV_win_lag1.(comps{j})));
    
end

figure(510); set(gcf,'Position', [2120 480 670 460]);
hbar = bar((1:3)',[win_mean across_mean]);
title('PV similarity at 1 day lag')
set(gca,'XTickLabel',capitalize(comps));
hold on
errorbar(hbar(1).XData + hbar(1).XOffset, hbar(1).YData, win_sem','k.');
errorbar(hbar(2).XData + hbar(2).XOffset, hbar(2).YData, across_sem','k.');
hold off
ylabel('Mean PV Corr')
make_plot_pretty(gca)
legend('Within Arena', 'Circle-to-square')
