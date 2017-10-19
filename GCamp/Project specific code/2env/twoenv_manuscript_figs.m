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
plot_all_mice = false;
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

    for j = 1:4
        subplot(3,2,j);
        imagesc_nan(Mouse(j).PV_corrs.circ2square.PV_corr_mean,cm);
       
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

figure(301)
set(gcf,'Position',[1980 10 1310 990])
mean_plot = mean(mat_full,3);
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
title('All Mice')

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
hc = colorbar; hc.Ticks = [min(mean_plot(:)) 1]; hc.TickLabels = {'min' '1'};
title('All Mice')



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
mouse_use = Mouse(3);
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
sq_ind = [9 12]; circ_ind = [10 11]; % Indices of square and circle sessions
PVfilt_corrs = nan(num_animals,2,5,5,3); % # Animals x # sessions x #Xbins x # Ybins x #cell groups
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

%% Generate PV plot (Figure 4D)
sesh_use = G45_square(1);
num_cells = 5;
spacing = 20;
cm = 'jet';
norm_er = true; % flag to normalize calcium event rates to 1 for each neuron 
% - makes plot prettier but make sure it matches the way you calc PVs 
% (e.g. true if you z-score, false if you don't)

dirstr = ChangeDirectory_NK(sesh_use,0);
load(fullfile(dirstr,'Placefields_rot0.mat'),'TMap_gauss');

if exist('hPV','var'); try; close(hPV); catch; disp('some error closing hPV'); end; end
hPV = figure;
z_use = num_cells*spacing;
for j = 1:num_cells
    if norm_er
        tmap_use = TMap_gauss{j}/max(TMap_gauss{j}(:)); % Normalize it so that peak FR shows up as red for each cell...
    else
        tmap_use = TMap_gauss{j};
    end
    imagesc_nan(tmap_use,cm,'z',z_use)
    hold on
    z_use = z_use - spacing;
end
axis off
