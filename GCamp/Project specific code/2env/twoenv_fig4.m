%% Two-env manuscript Figure 4: Between Arena Coherency

% Load data if required
load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_batch_analysis4_workspace_1000shuffles_2018JAN11.mat'));

sesh_type = {'square','circle','circ2square'};

%% Keep limits the same for tuning curves
tuning_ylim = [-0.7 0.7];

% Paper positions - will need to scale by ~42% in illustrator after - I'm
% sure there is a better way
paper_pos = [2204 192 600 400]; % for square and circle
paper_pos2 = [2204 192 285 200]; % for circ2square

num_comps = [28 28 64];
% Note that you will need to adjust the histogram y-axes individually

%% Circ2square Coherent plot
animal_use = 4;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 5; % must be square if circ2square
sesh2 = 5; % must be circle if circ2square
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
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 50])

figure(hh(2))
printNK('Circ2square Coherency Example - G48','2env','append',true)
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
printNK('Circ2square Coherency Example - G48','2env','append',true)

%% Circ2square remapping plot 1
animal_use = 1;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 7; % must be square if circ2square
sesh2 = 5; % must be circle if circ2square
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
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 20])

figure(hh(2))
printNK('Circ2square Remapping Example - G30','2env','append',true)
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
printNK('Circ2square Remapping Example - G30','2env','append',true)

%% Circ2square coherent plot 2
animal_use = 3;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 2; % must be square if circ2square
sesh2 = 7; % must be circle if circ2square
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
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 30])

figure(hh(2))
printNK('Circ2square Coherent Example Rotated - G45','2env','append',true)
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
printNK('Circ2square Coherent Example Rotated - G45','2env','append',true)

%% Plot cells across days
% 1 = square, 2 = square rotated with cells following local cues, 3 =
% square rotated, 4 = circle
plot_local_aligned = 0; % true = plot with local cues aligned, false = as presented to mouse
% sesh_use = cat(2, G45_square(1), G45_oct([1 2 5])); 
sesh_use = cat(2, G45_square([1 3]), G45_oct([1 4])); 
base_sesh = sesh_use(1); 
num_cols = length(sesh_use);
best_angle_use = cat(2, G45_square_best_angle(1), G45_circle_best_angle([1 2 5])); 

[base_dir, base_sesh_full] = ChangeDirectory_NK(base_sesh,0);
load(fullfile(base_dir,'batch_session_map.mat'));
batch_session_map_win = batch_session_map;
load(fullfile(base_dir,'batch_session_map_trans.mat'));
base_index = match_session(batch_session_map.session, base_sesh);

% Assemble cells to plot
PF_plot = cell(1,length(sesh_use));
for j = 1:length(sesh_use)
    dirstr = ChangeDirectory_NK(sesh_use(j),0);
    if plot_local_aligned == 0
        [~, rot] = get_rot_from_db(sesh_use(j));
    elseif plot_local_aligned == 1
        rot = 0;
    elseif plot_local_aligned == 2
        rot = best_angle_use(j);
    end
    load(fullfile(dirstr,['Placefields_rot' num2str(rot) '.mat']),'TMap_gauss');
    sesh_use(j).tmap = TMap_gauss;
    sesh_use(j).nanmap = TMap_gauss{1};
    sesh_use(j).nanmap(~isnan(TMap_gauss{1})) = 0;
    sesh_use(j).sesh_index = match_session(batch_session_map.session, sesh_use(j));
    sesh_use(j).rot = rot;
end
% sparse_map = batch_session_map.map(:,arrayfun(@(a) a.sesh_index, sesh_use)+1); % get map for just the 4 days in question
% good_ind = find(sum(sparse_map ~= 0 & ~isnan(sparse_map),2) == num_cols); % neurons active on all 4 days
good_ind = [50 51 56 87]; [47 68 129 191]; %[50 128 212 268]; % Good for G45
num_rows = 4; 
% num_rows = length(good_ind);

figure; set(gcf,'Position',[2100 20 750 875]);

neurons_plot = 1:num_rows;
base_dir = ChangeDirectory_NK(sesh_use(1),0);
for m = 1:(floor(length(good_ind)/num_rows))
    for k = 1:length(sesh_use)
        map_use = get_neuronmap_from_batchmap(batch_session_map.map, ...
            base_index, sesh_use(k).sesh_index);
        %%% Run Correlation Analysis to eventually put into the plot? %%%
%         if k > 1 
%             [~, sesh_use_full] = ChangeDirectory_NK(sesh_use(k),0);
%             if regexpi(base_sesh_full.Env,'square') && regexpi(sesh_use_full.Env,'square') 
%                 batch_map_use = batch_session_map_win;
%                 rot_array = 0:90:270;
%                 trans = false;
%             elseif regexpi(base_sesh_full.Env,'octagon') && regexpi(sesh_use_full.Env,'octagon')
%                 batch_map_use = batch_session_map_win;
%                 rot_array = 0:15:345;
%                 trans = false;
%             else
%                 batch_map_use = batch_session_map;
%                 rot_array = 0:15:345;
%                 trans = true;
%             end
%             corr_mat = corr_rot_analysis( sesh_use(1), sesh_use(k), batch_map_use, ...
%                 rot_array, 'trans', trans);
%         end
        for j = 1:length(neurons_plot)
            neuron_use = map_use(good_ind(neurons_plot(j)));
%             corr_use = 
            subplot(num_rows + 1, num_cols, num_cols*(j-1)+k)
            if isnan(neuron_use)
                title('Sketchy neuron mapping')
            elseif neuron_use == 0
                imagesc_nan(rot90(sesh_use(k).nanmap,1));
                title('Neuron not active')
            elseif neuron_use > 0
                if sum(isnan(sesh_use(k).tmap{neuron_use}(:))) == length(sesh_use(k).tmap{neuron_use}(:)) % edge case where bug in Placefields has cause TMap_gauss to be all NaNs
                    imagesc_nan(rot90(sesh_use(k).nanmap,1));
                else
                    imagesc_nan(rot90(sesh_use(k).tmap{neuron_use},1));                    
                end
                if k == 1 % only label neuron in first session
                       title({['Neuron ' num2str(neuron_use)], ['Rot = ' ...
                           num2str(sesh_use(k).rot)]})
                elseif j == 1 && k ~= 1
                    title(['Rot = ' num2str(sesh_use(k).rot)])
                end
                title({['Neuron ' num2str(neuron_use)], ['Rot = ' ...
                           num2str(sesh_use(k).rot)]})
            end
%             axis equal 
            axis tight
            axis off
            try
            if j == 1
                dirstr = ChangeDirectory_NK(sesh_use(k),0);
                load(fullfile(dirstr,'FinalOutput.mat'),'NeuronImage');
                reg_filename = fullfile(base_dir,['RegistrationInfo-' sesh_use(k).Animal '-' sesh_use(k).Date '-session' num2str(sesh_use(k).Session) '.mat']);
                load(reg_filename);
                if neuron_use ~= 0 && ~isnan(neuron_use)
                    ROI_reg = imwarp_quick(NeuronImage{neuron_use}, RegistrationInfoX);
                    b = bwboundaries(ROI_reg,'noholes');
                    
                    subplot(num_rows + 1, num_cols, num_cols*num_rows+k)
                    plot(b{1}(:,2),b{1}(:,1));
                    if k == 1
                        cent_ROI = mean(b{1},1);
                        xlims = [cent_ROI(2) - 15, cent_ROI(2) + 15];
                        ylims = [cent_ROI(1) - 15, cent_ROI(1) + 15];
                    end
                    xlim(xlims); ylim(ylims);
                elseif neuron_use == 0 || isnan(neuron_use)
                    subplot(num_rows + 1, num_cols, num_cols*num_rows+k)
                    text(0.1,0.5,'Bad Neuron Mapping - no ROI out')
                end
%                 axis equal
                axis tight
                axis off
            end
            catch
                disp('Some error in plotting ROIs')
            end
                
        end

    end
    neurons_plot = (max(neurons_plot)+1):(max(neurons_plot)+num_rows);
    waitforbuttonpress
end

% Plot figure showing neuron outlines from above
ncolors = [1 0 0; 0 1 0; 0 0 1; 1 0 1]; % Plot example neurons as r g b cyan
ncolors = resize(ncolors, [length(good_ind), 3]); % Add in more intermediate colors if needed
% figure; set(gcf,'Position',[2500 150 950 770])
% h = gca;
% load(fullfile(base_dir,'FinalOutput.mat'),'NeuronImage')
% hall = plot_neuron_outlines(nan,NeuronImage,h,'colors',[0.5 0.5 0.5]);
% hold on
% [~, ~, hneuron] = plot_neuron_outlines(nan,NeuronImage(good_ind((end-3):end)),hall,...
%     'colors', ncolors, 'scale_bar', false);
% legend(hneuron,arrayfun(@(a) ['Neuron ' num2str(a)], ...
%     good_ind,'UniformOutput',false))
% axis tight

%% Plot MI of circle vs square sessions
MImean_comb = [];
for k = 1:4
    mouse_use = k;
    mouse_name = Mouse(mouse_use).sesh.square(1).Animal;
    sesh_use = cat(1,Mouse(mouse_use).sesh.square, ...
        Mouse(mouse_use).sesh.circle);
    
    dirstr_all = arrayfun(@(a) ChangeDirectory_NK(a,0),...
        sesh_use,'UniformOutput',false);
    
    MImean_all = nan(size(sesh_use));
    for j = 1:length(dirstr_all(:))
        load(fullfile(dirstr_all{j},'SpatialInfo_cm4_rot0.mat'),'MI');
        MImean_all(j) = mean(MI);
    end
    MImean_comb = cat(3,MImean_comb,MImean_all);
    
    scatterBox(MImean_all(:),repmat((1:2)',8,1),'xLabels',{'Square','Circle'},...
        'yLabel', 'Mutual Information (bits)','position',[2280 420 450 290],...
        'transparency', 0.7);
    title(mouse_name_title(mouse_name));
    
    printNK(['MI square vs circle for ' mouse_name],'2env')
end

groups = repmat(cat(1,ones(1,8),2*ones(1,8)),1,1,4);
scatterBox(MImean_comb(:),groups(:),'xLabels',{'Square','Circle'},...
    'yLabel', 'Mutual Information (bits)','position',[2280 420 450 290],...
    'transparency', 0.7);
title('All Mice');
set(gca,'tickdir','in')

printNK('MI square vs circle for All Mice','2env')

[panova, anovatab, stats] = anova1(MImean_comb(:),groups(:),'off');

%% Plot center-out histos

[~, delta_mean_c2s, ~, pc2s, ~, coh_ratio_c2s] = plot_delta_angle_hist(...
    G48_square(5), G48_oct(5), G48_square(1), 'TMap_type', 'TMap_gauss',...
    'bin_size', 1, 'nshuf', 1000, 'circ2square',true);
% ylims = get(gca,'YLim');
make_plot_pretty(gca,'linewidth',1,'fontsize',14)
set(gca,'YLim',[0 50],'YTick',0:25:50,'XLim',[-10 370])
printNK('Octagon to Square histo example 1 - coherent','2env')

[~, delta_mean_gr, ~, pgr, ~, coh_ratio_gr] = plot_delta_angle_hist(...
    G30_square(7), G30_oct(5), G30_square(1), 'TMap_type', 'TMap_gauss',...
    'bin_size', 1, 'nshuf', 1000, 'circ2square',true);
% ylims = get(gca,'YLim');
make_plot_pretty(gca,'linewidth',1,'fontsize',14)
set(gca,'YLim',[0 30],'YTick',0:15:30,'XLim',[-10 370])
printNK('Octagon to Square histo example 2 - global remapper','2env')

%% See twoenv_pop_stats for PVs same v diff

%% See twoenv_mismatch_histograms for Coh Ratio Same v Diff.


