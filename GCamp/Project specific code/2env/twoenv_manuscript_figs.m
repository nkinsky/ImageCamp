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
ticks = 9.5:2:11.5; % 1:16;
ticklabels = arrayfun(@num2str,5:6,'UniformOutput',false);% {'s' 's' 'c' 'c' 'c' 'c' 's' 's' 's' 'c' 'c' 's' 's' 's' 'c' 'c' };

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
set(gcf,'Position',[1980 10 1310 990])
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