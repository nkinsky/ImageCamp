% Plot DNMP task PFs based on trial type and direction (L/R)

% Session you want to analyze
%{
Mouse = 'GCamp6f_45_DNMP';
Date = '04_04_2016';
Session = 1;
[dirstr, sesh_use] = ChangeDirectory(Mouse,Date,Session,0);

%}
dirstr= uigetdir('Choose Session Folder');   
cd(dirstr);

pval_thresh = 0.05;
hits_thresh = 3;

plot_types{1,1} = 'forced_left'; plot_title{1,1} = 'Sample Left';
plot_types{1,2} = 'forced_right'; plot_title{1,2} = 'Sample Right';
plot_types{2,1} = 'free_left'; plot_title{2,1} = 'Test Left';
plot_types{2,2} = 'free_right'; plot_title{2,2} = 'Test Right';

% Overwrite above to try different sessions


plot_types{1,1} = 'forced_left_025cmbins';
plot_types{1,2} = 'forced_right_025cmbins'; 
plot_types{2,1} = 'free_left_025cmbins'; 
plot_types{2,2} = 'free_right_025cmbins';

num_rows = size(plot_types,1);
num_cols = size(plot_types,2);

thisFolder=dir; isIt=zeros(1,length(thisFolder));
for fileHere=1:length(thisFolder)
    isIt(fileHere)=strcmpi(thisFolder(fileHere).name,'PlaceMapsv2');
end
if ~any(isIt)
    disp('Could not find place maps here. Where are they?')
    placeMapDir=uigetdir(dirstr,'Get folder with place maps');
elseif any(isIt)
    if sum(isIt)== 7
        placeMapDir=dirstr;
    elseif sum(isIt)==1 && thisFolder(isIt).isdir==1
        disp(['Assuming ' thisFolder(isIt).name 'contains place field fields'])
        %Guess we could run a check
        paceMapDir=fullfile(dirstr,thisFolder(isIt).name);
    else    
        disp('Could not find place maps here. Where are they?')
        placeMapDir=uigetdir(dirstr,'Get folder with place maps'); 
    end    
end

%% Filter - accept only neurons that have high spatial information and enough PF hits in at least ONE of the categories above!
load(fullfile(placeMapDir,['PlaceMapsv2_' plot_types{1,1} '.mat']),'pval');
NumNeurons = length(pval);

neurons_use_log = false(NumNeurons,1);
MaxPF_all = cell(num_rows,num_cols);
PFpixels_all = cell(num_rows,num_cols);
TMap_full_all = cell(num_rows,num_cols);
neuron_pass = cell(num_rows,num_cols);
for j = 1:num_rows
    pval_array = zeros(NumNeurons,1);
    NumHits_array = zeros(NumNeurons,1);
    for k = 1:num_cols
        load(fullfile(placeMapDir,['PlaceMapsv2_' plot_types{j,k} '.mat']),'pval','TMap_gauss');
        load(fullfile(placeMapDir,['PFstatsv2_' plot_types{j,k} '.mat']),'MaxPF','PFnumhits','PFpixels');
        MaxPF_all{j,k} = MaxPF;
        PFpixels_all{j,k} = PFpixels;
        TMap_full_all{j,k} = TMap_gauss;
        pval_array = 1 - pval' < pval_thresh; % (:,(j-1)*num_rows+k)
        NumHits_array(1:size(PFnumhits,1)) = PFnumhits(sub2ind(size(PFnumhits),1:size(PFnumhits,1),MaxPF(1:size(PFnumhits,1))))' >= hits_thresh; % Number of hits in max FR place field must be greater than hits_thresh to be included
        neuron_pass_bin(j,k,:) = pval_array & NumHits_array;
        neuron_pass{j,k} = find(pval_array & NumHits_array); % Get neurons passing each trial type/direction
        
        neurons_use_log = neurons_use_log | (pval_array & NumHits_array);
    end
end

neurons_use_filter = find(neurons_use_log);
num_filt = length(neurons_use_filter);

%% Get overlaps for each neuron's PF
bin_thresh = 0.95;

overlap_ratio = nan(num_filt,num_rows);
overlap_ratio_maxPF = nan(num_filt,num_rows);
corr_all = nan(num_filt,num_rows);
corr_maxPF = nan(num_filt,num_rows);
corr_maxPF_nofire = nan(num_filt,num_rows);
% TMap_size = size(TMap_full_all{1,1}{1});
TMap_maxPF = cell(2,2);
TMap_binary_all = cell(2,2);
TMap_binary_maxPF = cell(2,2);
for k = 1:num_rows
    %%% Calc overlap between full PF map (includes multiple PFs) %%%
    % Make binary TMaps
    for n = 1:2
        TMap_binary_all{n,k} = cellfun(@(a) make_binary_TMap(a,bin_thresh),...
            TMap_full_all{n,k}(neurons_use_log),'UniformOutput',0);
    end
    % Calc overlaps
    overlap_ratio(:,k) = calc_PF_overlap(TMap_binary_all{1,k}, ...
        TMap_binary_all{2,k});
    corr_all(:,k) = cellfun(@(a,b) corr(a(:), b(:),'type','Spearman'),...
        TMap_full_all{1,k}(neurons_use_log), TMap_full_all{2,k}(neurons_use_log))';
    
    %%% Calc overlap between highest FR fields only %%%
    for n = 1:2
        TMap_maxPF{n,k} = make_maxPF_TMap(PFpixels_all{n,k}, MaxPF_all{n,k}, TMap_full_all{n,k});
        TMap_binary_maxPF{n,k} = cellfun(@(a) make_binary_TMap(a,bin_thresh),...
            TMap_maxPF{n,k}(neurons_use_log),'UniformOutput',0);
    end
    %overlap_ratio_maxPF(:,k) = calc_PF_overlap(TMap_binary_maxPF{1,k}(neurons_use_log),...
    %    TMap_binary_maxPF{2,k}(neurons_use_log)));
    overlap_ratio_maxPF(:,k) = calc_PF_overlap(TMap_binary_maxPF{1,k},...
        TMap_binary_maxPF{2,k});
    corr_maxPF(:,k) = cellfun(@(a,b) corr(a(:), b(:),'type','Spearman'),...
        TMap_maxPF{1,k}(neurons_use_log), TMap_maxPF{2,k}(neurons_use_log));
    
    % Now, identify any TMaps that don't fire on BOTH study and test trials
    corr_maxPF_nofire(:,k) = cellfun(@(a,b) isnan(sum(a(:))) & isnan(sum(b(:))),...
        TMap_maxPF{1,k}(neurons_use_log), TMap_maxPF{2,k}(neurons_use_log));
end

%% Calc correlation between odd v even minutes for all times on the maze
cd(placeMapDir)
load('PlaceMapsv2_onmaze.mat', 'TMap_half')
for n = 1:2
        TMap_binary_half{n} = cellfun(@(a) make_binary_TMap(a,bin_thresh),...
            TMap_half(n).TMap_gauss(neurons_use_log),'UniformOutput',0);  
end
overlap_ratio_half = calc_PF_overlap(TMap_binary_half{1}, ...
    TMap_binary_half{2});
corr_half = cellfun(@(a,b) corr(a(:), b(:),'type','Spearman'),...
    TMap_half(1).TMap_gauss(neurons_use_log), TMap_half(2).TMap_gauss(neurons_use_log))';

%% Plot the above
corr_bins = -0.2:0.025:1;
overlap_bins = 0:0.025:1;
figure(50)
subplot(2,1,1)
histogram(corr_all(:),corr_bins); %,'Normalization','probability'); 
hold on ; 
histogram(corr_maxPF(:),corr_bins) %,'Normalization','probability'); 
hold off; 
legend('All PFs','MaxPF only')
xlabel('Spearman Correlation between Sample and Test PlaceFields')
ylabel('Count')

subplot(2,1,2)
histogram(overlap_ratio(:),overlap_bins); %,'Normalization','probability'); 
hold on ; 
histogram(overlap_ratio_maxPF(:),overlap_bins) %,'Normalization','probability'); 
hold off; 
legend('All PFs','MaxPF only')
xlabel('Overlap ratio between Sample and Test PlaceFields')
ylabel('Count')

scroll_through = false;
scroll_all = true;

neurons_scroll = neurons_use_filter(overlap_ratio(:,1) == 0 & overlap_ratio(:,2) == 0);
if scroll_through
    figure(51)
    for j = 1:length(neurons_scroll)
        neuron_plot = neurons_scroll(j);
        for kk = 1:2
            for ll = 1:2
                subplot(2,2,(kk-1)*2+ll)
                imagesc(TMap_full_all{kk,ll}{neuron_plot});
                title(['TMap for neuron ' num2str(neuron_plot) ' - ' plot_title{kk,ll}])
            end
        end
        waitforbuttonpress
    end
end
%% Try to plot all neuron outlines
debug = false;
ds_factor = 1;
plot_type = 9;
stable_thresh = 0.7;

full_plot_type{1} = 'forced_025cmbins'; full_plot_title{1} = 'Sample';
full_plot_type{2} = 'free_025cmbins'; full_plot_title{2} = 'Test';

full_plot_type2 = 'onmaze_025cmbins';

full_plot_type3 = {'forced_left_025cmbins', 'forced_right_025cmbins';...
    'free_left_025cmbins', 'free_right_025cmbins'};

% Calculate various filters to try
neuron_filter2{1} = neurons_use_filter(corr_maxPF(:,1) < 0 & corr_maxPF(:,2) < 0); % potential remappers type 1
neuron_filter2{2} = neurons_use_filter(corr_maxPF(:,1) < 0 | corr_maxPF(:,2) < 0); % potential remappers type 2
neuron_filter2{3} = neurons_use_filter(overlap_ratio(:,1) == 0 & overlap_ratio(:,2) == 0); % potential remappers type 3
neuron_filter2{4} = neurons_use_filter(overlap_ratio(:,1) == 0 | overlap_ratio(:,2) == 0); % potential remappers type 4
neuron_filter2{5} = neurons_use_filter(overlap_ratio_maxPF(:,1) == 0 & overlap_ratio_maxPF(:,2) == 0); % potential remappers type 5
neuron_filter2{6} = neurons_use_filter(overlap_ratio_maxPF(:,1) == 0 | overlap_ratio_maxPF(:,2) == 0); % potential remappers type 6

neuron_filter2{7} = neurons_use_filter(corr_all(:,1) > stable_thresh & corr_all(:,2) > stable_thresh);
neuron_filter2{8} = neurons_use_filter(corr_all(:,1) > stable_thresh | corr_all(:,2) > stable_thresh);
neuron_filter2{9} = neurons_use_filter(corr_maxPF(:,1) > stable_thresh & corr_maxPF(:,2) > stable_thresh);
neuron_filter2{10} = neurons_use_filter(corr_maxPF(:,1) > stable_thresh | corr_maxPF(:,2) > stable_thresh);

% LR stable cells
neuron_filter_LR{1,1} = neurons_use_filter(corr_maxPF(:,1) > stable_thresh);
neuron_filter_LR{1,2} = neurons_use_filter(corr_maxPF(:,2) > stable_thresh);
% LR remappers
neuron_filter_LR{2,1} = neurons_use_filter(corr_maxPF(:,1) < 0);
neuron_filter_LR{2,2} = neurons_use_filter(corr_maxPF(:,2) < 0);

% Down-sample neurons if desired
if ds_factor ~= 1
    neurons_use = sort(neurons_use_filter(randperm(round(length(neurons_use_filter)/ds_factor))));
else
    if plot_type == 0
        neurons_use = neurons_use_filter;
    else
        neurons_use = neuron_filter2{plot_type};
    end
end

disp('Plotting Neurons outlines for each trial type - side combination')
figure(100)
for j = 1:num_rows
    for k = 1:num_cols
        
        % Get appropriate files to load
        if ~debug
            PMfile_use = ['PlaceMapsv2_' plot_types{j,k} '.mat'];
            PMstatsfile_use = ['PFstatsv2_' plot_types{j,k} '.mat'];
        elseif debug
            PMfile_use = ['PlaceMapsv2_' plot_types{1,1} '.mat'];
            PMstatsfile_use = ['PFstatsv2_' plot_types{1,1} '.mat'];
        end
        
        h = subplot(num_rows, num_cols, (j-1)*num_rows + k);
        if j == 1 && k == 1
            [custom_colors, neurons_use] = draw_PF_outline(placeMapDir,'PMfile' ,PMfile_use, 'PMstatsfile', ...
                PMstatsfile_use, 'custom_colors', [], 'ax_handle', h,...
                'neurons_use', neurons_use, 'dir_use', placeMapDir);
        else
            draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
                PMstatsfile_use, 'custom_colors', custom_colors,'ax_handle', h,...
                'neurons_use', neurons_use, 'dir_use', placeMapDir);
        end
            title(plot_title{j,k})
        
    end
end

% Plot Sample v Test for both sides
figure(102)
for j = 1:2
    
    PMfile_use = ['PlaceMapsv2_' full_plot_type{j} '.mat'];
    PMstatsfile_use = ['PFstatsv2_' full_plot_type{j} '.mat'];
    
    h = subplot(1,2,j);
    draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
        PMstatsfile_use, 'custom_colors', custom_colors,'ax_handle', h,...
        'neurons_use', neurons_use, 'dir_use', placeMapDir);
    title(full_plot_title{j})
end

figure(103)
PMfile_use = ['PlaceMapsv2_' full_plot_type2 '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type2 '.mat'];
neurons_plot2{1} = neurons_use_filter;
neurons_plot2{2} = neuron_filter2{9};
plot_titles2 = {'All Neurons', ['Stable Neurons (R^2 > ' num2str(stable_thresh) ')']};
for j = 1:2
   
    h = subplot(1,2,j);
    draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
        PMstatsfile_use, 'custom_colors', custom_colors,'ax_handle', h,...
        'neurons_use', neurons_plot2{j}, 'dir_use', placeMapDir);
    title(plot_titles2{j})
    
end

%%
figure(104)
neurons_plot2 = {neuron_filter2{2}, neuron_filter2{2}; ...
    neuron_filter_LR{1}, neuron_filter_LR{2}};

% neurons_plot2{1} = neurons_use_filter;
% neurons_plot2{2} = neuron_filter2{10}; % stable on L AND R trials % neuron_filter2{10}; % stable on L OR R trials
plot_titles2 = {['Remapping Neurons (R^2 < 0) - Left Trials'],...
    ['Remapping Neurons (R^2 < 0) - Right Trials']; ...
    ['Stable Neurons (R^2 > ' num2str(stable_thresh) ') - Left Trials'],...
    ['Stable Neurons (R^2 > ' num2str(stable_thresh) ') - Right Trials']};
for j = 1:2
    for k = 1:2
    
        PMfile_use = ['PlaceMapsv2_' full_plot_type3{j,k} '.mat'];
        PMstatsfile_use = ['PFstatsv2_' full_plot_type3{j,k} '.mat'];
        
        h = subplot(2,2,2*(j-1)+k);
        draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
            PMstatsfile_use, 'custom_colors', custom_colors,'ax_handle', h,...
            'neurons_use', neurons_plot2{j,k}, 'dir_use', placeMapDir);
        title(plot_titles2{j})
    end
    
end

%% 
figure(105)
neurons_plot2 = neuron_filter_LR;

% neurons_plot2{1} = neurons_use_filter;
% neurons_plot2{2} = neuron_filter2{10}; % stable on L AND R trials % neuron_filter2{10}; % stable on L OR R trials
plot_titles2 = {'Left Trials', 'Right Trials'};

custom_colors2 = [1 0.55 0; 0 1 0; ]; % [ green ; orange];
for k = 1:2
    for j = 1:2
    
        PMfile_use = ['PlaceMapsv2_' full_plot_type3{j,k} '.mat'];
        PMstatsfile_use = ['PFstatsv2_' full_plot_type3{j,k} '.mat'];
        
        h = subplot(1,2,k);
        hold on
        draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
            PMstatsfile_use, 'custom_colors', custom_colors2(j,:),'ax_handle', h,...
            'neurons_use', neurons_plot2{j,k}, 'dir_use', placeMapDir);
        hold off
        title(plot_titles2{j})
    end
%     legend({['Stable (R^2 > ' num2str(stable_thresh) ')'], '', 'Remappers (R^2 < 0)' , ''});
end

%% Another plot
% 1st row: Study L, Study R
% 2nd row: Test L, Test R
% 3rd row: High correlation L, high correlation R
% 4th row: All PFs, merge of row 3

% Get neurons to plot
neuron_filter6{1,1} = neuron_pass{1,1}; neuron_filter6{1,2} = neuron_pass{1,2}; % Study L, Study R
neuron_filter6{2,1} = neuron_pass{2,1}; neuron_filter6{2,2} = neuron_pass{2,2}; % Test L, Test R
neuron_filter6{3,1} = neurons_use_filter(corr_maxPF(:,1) > stable_thresh); % High corr L
neuron_filter6{3,2} = neurons_use_filter(corr_maxPF(:,2) > stable_thresh); % High corr R
neuron_filter6{4,1} = neurons_use_filter; % All neurons with valid place fields in one of the four conditions
neuron_filter6{4,2} = neurons_use_filter(corr_maxPF(:,1) > stable_thresh | ...
    corr_maxPF(:,2) > stable_thresh); % neurons with high correlations between study and test on either L or R trials
neuron_filter6{5,1} = neurons_use_filter(corr_maxPF(:,1) > stable_thresh & ...
    corr_maxPF(:,2) > stable_thresh); % neurons with high correlations between study and test on either L or R trials

% Set up files to use for grabbing place fields
full_plot_type6 = ...
    {'forced_left', 'forced_right';...
    'free_left', 'free_right'; ...
    'free_left', 'free_right';...
    'onmaze', {'free_left', 'free_right'}}; % 'onmaze_025cmbins'}; %% ;

titles6 = ...
    {'Sample L', 'Sample R';...
    'Test L', 'Test R';
    'Stable L', 'Stable R';
    'All Place Fields', 'Stable Place Fields'};

custom_colors3 = ...
    {[1 0.55 0], [1 0.55 0];...
    [1 0.55 0], [1 0.55 0]; ...
    [0 1 0], [0 0.5 0];...
    [0 0 1], [0 1 0]}; % [o o ; o o ; g g; r g]

figure(106)
for j = 1:4
    for k = 1:2
        
        PMfile_use = ['PlaceMapsv2_' full_plot_type6{j,k} '.mat'];
        PMstatsfile_use = ['PFstatsv2_' full_plot_type6{j,k} '.mat'];
        
        h = subplot(4,2,2*(j-1)+k);
        hold on
        
        % hack to plot high correlation condition
        if j == 4 && k == 2
            for mm = 1:2
                PMfile_use = ['PlaceMapsv2_' full_plot_type6{mm,1} '.mat'];
                PMstatsfile_use = ['PFstatsv2_' full_plot_type6{mm,1} '.mat'];
                draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
                    PMstatsfile_use, 'custom_colors', custom_colors3{3,1},'ax_handle', h,...
                    'neurons_use', neuron_filter6{3,1}, 'dir_use', placeMapDir);
                PMfile_use = ['PlaceMapsv2_' full_plot_type6{mm,2} '.mat'];
                PMstatsfile_use = ['PFstatsv2_' full_plot_type6{mm,2} '.mat'];
                draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
                    PMstatsfile_use, 'custom_colors', custom_colors3{3,2},'ax_handle', h,...
                    'neurons_use', neuron_filter6{3,2}, 'dir_use', placeMapDir);
            end
        else
            draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
                PMstatsfile_use, 'custom_colors', custom_colors3{j,k},'ax_handle', h,...
                'neurons_use', neuron_filter6{j,k}, 'dir_use', placeMapDir);
        end
        hold off
        title(titles6{j,k});
    end
end


%% qc above
qc = true;
side_qc = 'left';
side_ref = {'left','right'};
side_use = find(strcmpi(side_qc,side_ref));
if qc
   figure(116)
   
   for j = 1:length(neuron_filter6{3,side_use})
       for k = 1:2
           PMfile_use = ['PlaceMapsv2_' full_plot_type6{k,side_use} '.mat'];
           PMstatsfile_use = ['PFstatsv2_' full_plot_type6{k,side_use} '.mat'];
           h = subplot(1,2,k);
           draw_PF_outline(placeMapDir,'PMfile', PMfile_use, 'PMstatsfile', ...
               PMstatsfile_use, 'custom_colors', custom_colors3{3,side_use},'ax_handle', h,...
               'neurons_use', neuron_filter6{3,side_use}(j), 'dir_use', placeMapDir);
           title(['Neuron ' num2str(neuron_filter6{3,side_use}(j))]);
           
       end
       waitforbuttonpress
   end
end

%% Plot - I’d like to be able to show what the place field overlaps look 
% like in that high overlap panel, and I think we can do that because there 
% are so few of them.  Can you make all 4 place field outlines for each 
% cell in a distinct color, and distinguish L and R by the light-dark 
% intensity?  So, for example, light green for L study and L test and dark 
% green for R study and R test for one cell, and then the same for each 
% other cell except with a distinct color for each cell (e.g, all red for 
% the next cell).

stable_thresh = 0.5; % correlation AND overlap criteria

% ds_list = 1:length(neuron_filter6{4,2}); % plot all = ds_list = 1:length(neuron_filter6{4,2});
figure(107)
h = gca;
    
sesh_use=placeMapDir;
% Plot left study in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{1,1} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{1,1} '.mat'];
colors_use = draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'ax_handle', h,'neurons_use', neuron_filter6{3,1},...
    'alpha_use',0.5, 'dir_use', placeMapDir);

% Plot left test in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{2,1} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{2,1} '.mat'];
draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'custom_colors', colors_use,'ax_handle', h,...
    'neurons_use', neuron_filter6{3,1}, 'alpha_use', 0.5, 'dir_use', placeMapDir);

% Plot right study in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{1,2} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{1,2} '.mat'];
draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'custom_colors', colors_use,'ax_handle', h,...
    'neurons_use', neuron_filter6{3,2}, 'alpha_use', 1, 'dir_use', placeMapDir);

% Plot right test in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{2,2} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{2,2} '.mat'];
draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'custom_colors', colors_use,'ax_handle', h,...
    'neurons_use', neuron_filter6{3,2}, 'alpha_use', 1, 'dir_use', placeMapDir);

title(['Stable neurons (corr > ' num2str(stable_thresh) ' on either L or R trials)'])

%% Yet another plot

neuron_filter7 = neurons_use_filter((corr_maxPF(:,1) > stable_thresh & corr_maxPF(:,2) > stable_thresh) ...
    | (corr_maxPF(:,1) > stable_thresh & corr_maxPF_nofire(:,2) == 1) ...
    | (corr_maxPF(:,2) > stable_thresh & corr_maxPF_nofire(:,1) == 1));

neuron_filter8 = neurons_use_filter((overlap_ratio_maxPF(:,1) > stable_thresh & overlap_ratio_maxPF(:,2) > stable_thresh) ...
    | (overlap_ratio_maxPF(:,1) > stable_thresh & corr_maxPF_nofire(:,2) == 1) ...
    | (overlap_ratio_maxPF(:,2) > stable_thresh & corr_maxPF_nofire(:,1) == 1));

figure(108)
h = gca;
    
% Plot left study in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{1,1} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{1,1} '.mat'];
colors_use = draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'ax_handle', h,'neurons_use', neuron_filter7,...
    'alpha_use',0.5, 'dir_use', placeMapDir);

% Plot left test in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{2,1} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{2,1} '.mat'];
draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'custom_colors', colors_use,'ax_handle', h,...
    'neurons_use', neuron_filter7, 'alpha_use', 0.5, 'dir_use', placeMapDir);

% Plot right study in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{1,2} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{1,2} '.mat'];
draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'custom_colors', colors_use,'ax_handle', h,...
    'neurons_use', neuron_filter7, 'alpha_use', 1, 'dir_use', placeMapDir);

% Plot right test in half color
PMfile_use = ['PlaceMapsv2_' full_plot_type6{2,2} '.mat'];
PMstatsfile_use = ['PFstatsv2_' full_plot_type6{2,2} '.mat'];
draw_PF_outline(sesh_use,'PMfile', PMfile_use, 'PMstatsfile', ...
    PMstatsfile_use, 'custom_colors', colors_use,'ax_handle', h,...
    'neurons_use', neuron_filter7, 'alpha_use', 1, 'dir_use', placeMapDir);

title(['Stable neurons (corr > ' num2str(stable_thresh) ')'])


%% QC above
disp('Loading PlaceMap files')
for j = 1:2
    for k = 1:2
        load(['PlaceMapsv2_' full_plot_type6{j,k} '.mat'],'TMap_gauss','RunOccMap');
        TMap_qc{j,k} = TMap_gauss;
        RunOccMap_qc{j,k} = RunOccMap;
    end
end

%% QC odd v even minutes
load('PlaceMapsv2_onmaze.mat', 'TMap_half','RunOccMap')
cm = colormap('jet');
neurons_to_use = neurons_use_filter;
half_title = {'Odd' 'Even'};
figure(119)
for j = 1:length(neurons_to_use)
    neuron_plot = neurons_to_use(j);
    for k = 1:2
       [~, TMap_nan] = make_nan_TMap(RunOccMap,TMap_half(k).TMap_gauss{neuron_plot});
       subplot(1,2,k)
       imagesc_nan(TMap_nan,cm,[1 1 1])
       title(['Neuron ' num2str(neuron_plot) ' ' half_title{k} ' Minutes'])
    end
    waitforbuttonpress
end

%%

neurons_use_filter2 = neuron_filter7;
figure(118)
cm = colormap('jet');
for i = 1:length(neurons_use_filter2)
    for j = 1:2
        for k = 1:2
            
            neuron_plot = neurons_use_filter2(i);
            filter_neuron_plot = find(neuron_plot == neurons_use_filter);
            [~, TMap_nan] = make_nan_TMap(RunOccMap_qc{j,k}, ...
                TMap_qc{j,k}{neuron_plot});
            subplot(2,2,2*(j-1)+k)
            imagesc_nan(TMap_nan,cm,[1 1 1])
            title([' neuron = ' num2str(neuron_plot) ', i = ' num2str(i) ...
                ' corr = ' num2str(corr_maxPF(filter_neuron_plot,k))])
            
        end
    end
    waitforbuttonpress
end
    
%% Ditto but for PF density maps

close 101
figure(101)
disp('Plotting PF density maps');
clims = [];
for j = 1:num_rows
    for k = 1:num_cols

%         if ~debug
%             PMfile_use = ['PlaceMapsv2_' plot_types{j,k} '.mat'];
%             PMstatsfile_use = ['PFstatsv2_' plot_types{j,k} '.mat'];
%         elseif debug
%             PMfile_use = ['PlaceMapsv2_' plot_types{1,1} '.mat'];
%             PMstatsfile_use = ['PFstatsv2_' plot_types{1,1} '.mat'];
%         end
        
        load(fullfile(dirstr,['PlaceMapsv2_' plot_types{j,k} '.mat']),'TMap_gauss','RunOccMap');
        
        temp = create_PFdensity_map(cellfun(@(a) ...
            make_binary_TMap(a),TMap_gauss(neurons_use_filter),'UniformOutput',0)); % create density map from binary TMaps
        [~, PFdensMap{j,k}] = make_nan_TMap(RunOccMap,temp); % Make non-occupied pixels white
        
        h = subplot(num_rows, num_cols, (j-1)*num_rows + k);
        cm = colormap('jet');
        imagesc_nan(PFdensMap{j,k},cm,[1 1 1]);
        colorbar
        title(['PF Density - ' plot_title{j,k}])
        clims = [clims, get(gca,'CLim')];
    end
end

% Set same clims for each subplot
clim_use = [min(clims), max(clims)];
for j = 1:num_rows
    for k = 1:num_cols
        subplot(num_rows, num_cols, (j-1)*num_rows + k);
        set(gca,'CLim',clim_use)
    end
end