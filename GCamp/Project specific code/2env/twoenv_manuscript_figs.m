%% Script to create manuscript figures

%% Figure 1b
sesh_use = G30_square(1);
proj_use = 'ICmovie_min_proj.tif';
trace_plot = 'LPtrace'; % 'RawTrace'; % 
neurons_plot = [2 3 6 10 11 16 17 200 201]; % Neuron traces to plot

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
plot_neuron_traces( NeuronTraces.(trace_plot)(neurons_plot,:), colors_used, htraces )
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