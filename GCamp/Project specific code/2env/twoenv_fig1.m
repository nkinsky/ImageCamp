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
    
