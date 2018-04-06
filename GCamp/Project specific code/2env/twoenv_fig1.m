% Two-env Figure 1: Calcium Imaging and Experiment outline

%% Figure 1b
j = 8;
sesh_use = G45_square(1); % G30_square(1);
proj_use = 'ICmovie_max_proj.tif';
trace_plot = 'RawTrace'; % 'RawTrace'; % 
neurons_plot = [703 562 115 289 622 488 311 202 417];
% find(max(NeuronTraces.LPtrace,[],2) < 0.15 & max(NeuronTraces.LPtrace,[],2) > 0.13)

%find(max(NeuronTraces.LPtrace,[],2) < 0.25 & max(NeuronTraces.LPtrace,[],2) > 0.23)
%8*(j-1)+ (1:8) %[56 69 161 392 1 2 3 4]; % [2 3 6 10 11 16 17 200 201]; % G30_square(1) % Neuron traces to plot

% Load image to use and NeuronROIs
dirstr = ChangeDirectory_NK(sesh_use,0);
im_use = imread(fullfile(dirstr,proj_use));
load(fullfile(dirstr,'FinalOutput.mat'),'NeuronImage','NeuronTraces'); % Load ROIs and traces

figure(1); set(gcf,'Position',[2180 225 1300 640])
% Plot ROIs
hROI = subplot(8,8,[1:4 (1:4)+8 (1:4)+16 (1:4)+24 (1:4)+32 (1:4)+40 (1:4)+48 (1:4)+56]);
% hROI = plot_allROIs( NeuronImage, im_use, hROI);
axis equal
axis off
colorbar off
[hROI, colors_used] = plot_neuron_outlines(im_use,NeuronImage(neurons_plot),hROI);
hold off

htraces = subplot(8,8,[5:8 (5:8)+8 (5:8)+16 (5:8)+24 (5:8)+32 (5:8)+40 (5:8)+48 (5:8)+56]);
plot_neuron_traces( NeuronTraces.(trace_plot)(neurons_plot,:), colors_used, htraces );
hold off
make_figure_pretty(gcf);

%% Figure 1b with rising phase of transients identified
sesh_use = G45_square(1); % G30_square(1);
proj_use = 'ICmovie_min_proj.tif';
trace_plot = 'RawTrace'; %'LPtrace'; % 'RawTrace'; % 
neurons_plot = [622 488]; %[292 703 562 115 289 622 488 311 202 417]; % [622 488]; %[56 69 161 392 1 2 3 4]; % [2 3 6 10 11 16 17 200 201]; % G30_square(1) % Neuron traces to plot
time_plot = [275 360];
frames_use = (time_plot(1)*20):(time_plot(2)*20);

% Load image to use and NeuronROIs
dirstr = ChangeDirectory_NK(sesh_use,0);
im_use = imread(fullfile(dirstr,proj_use));
load(fullfile(dirstr,'FinalOutput.mat'),'NeuronImage','NeuronTraces',...
    'PSAbool'); % Load ROIs and traces
figure(2); set(gcf,'Position',[2400 420 960 420]);
htraces = gca;
plot_neuron_traces( NeuronTraces.(trace_plot)(neurons_plot,frames_use), colors_used(5:6,:), ...
    htraces, 'PSAbool', PSAbool(neurons_plot,frames_use));
hold off
make_plot_pretty(gca);

%% Fig 1d: Neuron registration
reg_stats = reg_qc_plot_batch(G45_square(1), G45_botharenas(2:end), ...
    'num_shuffles', 1000, 'name_append', '_trans');

save(fullfile(ChangeDirectory_NK(G45_square(1),0),'manuscript_reg_stats'),...
    'reg_stats')

% Do ks-test for each reg session vs base
[h,p] = cellfun(@(a) kstest2(abs(a.orient_diff), ...
    abs(reg_stats{1}.shuffle.orient_diff),'tail','larger'),reg_stats);

%% Plot PF density maps
plot_all_PFdens = false;
plot_comb_PFdens = true;

% Plot individual mouse PFdensity plots
if plot_all_PFdens
    for ll = 1:num_animals
        figure(149 + ll);
        for j = 1:2
            for k = 1:8
                subplot(2,8,8*(j-1)+k)
                imagesc_nan(Mouse(ll).PFdens_map{j,k});
                title(['Mouse ' num2str(ll) ' - session ' num2str(k)])
            end
        end
    end
    
    % Get base size of image for later resizing, after removing nan padding
    base_size = nan(2);
    for j = 1:2
        xspan = (find(sum(~isnan(Mouse(1).PFdens_map{j,1}),1) > 5,1,'first')-1):...
            (find(sum(~isnan(Mouse(1).PFdens_map{j,1}),1) > 5,1,'last')+1);
        yspan = (find(sum(~isnan(Mouse(1).PFdens_map{j,1}),2) > 5,1,'first')-1):...
            (find(sum(~isnan(Mouse(1).PFdens_map{j,1}),2) > 5,1,'last')+1);
        
        base_size(j,:) = size(Mouse(1).PFdens_map{j,1}(yspan,xspan));
    end
end
    
    
if plot_comb_PFdens
%     figure(154)
    temp_all = cell(2,8);
    for j = 1:2
        for k = 1:8
            for ll = 1:num_animals % num_animals %num_animals
                % First, find span to remove nan-padding at edges
                xspan = max([(find(sum(~isnan(Mouse(ll).PFdens_map{j,k}),1) > 5,1,'first')-1),1]):...
                    min([(find(sum(~isnan(Mouse(ll).PFdens_map{j,k}),1) > 5,1,'last')+1),...
                    size(Mouse(ll).PFdens_map{j,k},2)]);
                yspan = max([(find(sum(~isnan(Mouse(ll).PFdens_map{j,k}),2) > 5,1,'first')-1),1]):...
                    min([(find(sum(~isnan(Mouse(ll).PFdens_map{j,k}),2) > 5,1,'last')+1),...
                    size(Mouse(ll).PFdens_map{j,k},1)]);
                
                % Now, resize each and concatenate
                h = fspecial('gaussian',[5 5],3);
                temp2 = resize(Mouse(ll).PFdens_map{j,k}(yspan,xspan), ...
                    base_size(j,:));
                temp3 = conv2(temp2,h,'same');
                temp2(isnan(temp2)) = nan;
                temp_all{j,k} = cat(3,temp_all{j,k},temp2);
                
            end
%             subplot(2,8,8*(j-1)+k)
%             imagesc_nan(nanmean(temp_all{j,k},3));
%             axis off
        end
    end

    % Plot combined!!!
    try; close 155; close 156; close 157; close 158; close 159; catch; end %#ok<NOSEM>
    for zz = 1:1 % num_animals+1
        figure(154+zz)
        set(gcf,'Position',[2150 30 720 860])
    end
    bda_ind = {1:4,5:6,7:8};
    for j = 1:2
        clim_use = [];
        for k = 1:3
            temp_all_comb = [];
            for ll = bda_ind{k}
                temp_all_comb = cat(3,temp_all_comb, temp_all{j,ll});
            end
            figure(155)
            subplot(3,3,3*(k-1)+j)
            temp_comb_smooth = nanmean(temp_all_comb,3);
            imagesc_nan(rot90(temp_comb_smooth,1));
            axis off
            clim_use = [clim_use; ...
                [nanmin(temp_comb_smooth(:)) nanmax(temp_comb_smooth(:))]];
            
%             for zz = 1:num_animals
%                 figure(155+zz)
%                 subplot(3,2,2*(k-1)+j)
%                 temp_all_comb = [];
%                 for ll = bda_ind{k}
%                     temp_all_comb = cat(3,temp_all_comb, temp_all{j,ll}(:,:,zz));
%                 end
%                 temp_comb_smooth = nanmean(temp_all_comb,3);
%                 imagesc_nan(rot90(temp_comb_smooth,1));
%                 axis off
%             end
        end   
        for k = 1:3
            subplot(3,3,3*(k-1)+j)
            set(gca,'CLIM',[0 max(clim_use(:,2))])
        end
    end
%     subplot(3,3,4); h = colorbar('manual','Position',[0.37 0.4093 0.018 0.216]);
    subplot(3,3,5); h2 = colorbar('manual','Position',[0.65 0.4093 0.018 0.216]);
end

%             nan_log = isnan(temp_comb_smooth);
%             temp_comb_smooth = conv2(temp_comb_smooth, h, 'same');
%             temp_comb_smooth(nan_log) = nan;
%             temp_comb_smooth = conv2(nanmean(temp_all_comb,3),ones(2),'same');
%             temp_comb_smooth(isnan(nanmean(temp_all_comb,3))) = nan;
%             h = fspecial('gaussian',[5 5],4);
    
