% Alternation figure 1: Behavior and Imaging

%% Neuron ROIs and outlines - do for all, put 45 in full figure (others 
% could go in supplemental if journal allows)

% These look ok for G30
neurons_plotG30 = [213 261 365 240 598 319 158 76 176 206 162];
plot_trace_and_outlines3(G30_alt(11), neurons_plotG30, 4*60*20, true);

% G31
neurons_plotG31 = [];
plot_trace_and_outlines3(G31_alt(5), neurons_plotG31, 4*60*20, true);


% G45 is best - 651 and 281 are good examples of neighboring neurons where
% Tenaspsis disambiguates crosstalk between the two. use this one
neurons_plot45 = [370 522 363 275 165 56 317 752 452 651 281]; 
plot_trace_and_outlines3(G45_alt(23), neurons_plot45, 4*60*20, true);
% Zoom into top two traces to show crosstalk.

% G48
neurons_plot48 = [101 213 287 340 19 101 168 290 56 109 146 46];
plot_trace_and_outlines3(G48_alt(45), neurons_plot48, 4*60*20, true);

%% Activation patterns during potential crosstalk events
crosstalk_neurons = [651 281];

% Identify crosstalk frames
load(fullfile(G45_alt(23).Location,'FinalOutput.mat'),'NeuronTraces', ...
    'NeuronImage');

figure; 
for j = 1:2 
    ha(j) = subplot(2,1,j); plot(NeuronTraces.LPtrace(crosstalk_neurons(j),:));
end
linkaxes(ha,'x')

% Might need to create BPDFF movie for this to look good.
% Yes! The code below produces things that look garbagey.
ct_ROIs = NeuronImage(crosstalk_neurons);
movie_file = fullfile(G45_alt(23).Location,'MotCorrMovie-Objects',...
    'Obj_1 - recording_20151001_163242.h5');
bp_movie_file = fullfile(G45_alt(23).Location,'MotCorrMovie-Objects',...
    'BPDFF.h5');
ct_frame_nums = [753 883 1032];
ct_frames = LoadFrames(movie_file, ct_frame_nums);
ct_bp_frames = LoadFrames(bp_movie_file, ct_frame_nums);

% Get neuron ROI boundaries
for j = 1:2; b{j} = bwboundaries(ct_ROIs{j},'noholes'); end

%% Plot ROIs on top of each frame
for j = length(ct_frame_nums)
    figure; set(gcf,'Position', [2210 400 650 500]);
    title(['CT event #' num2str(j)])
    imagesc_gray(squeeze(ct_frames(:,:,j))); 
    hold on
    cellfun(@(a) plot(a{1}(:,2), a{1}(:,1), 'r'), b); 
    set(gca,'XLim',[140 183],'YLim',[172 205])
end
% Run imcontrast and save

%% Neuron registration quality control

G30regstats = reg_qc_plot_batch(G30_alt(1), G30_alt(2:end), ...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);

G31regstats = reg_qc_plot_batch(G31_alt(1), G31_alt(2:end), ...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);

%%
G45regstats = reg_qc_plot_batch(G45_alt(1), G45_alt(2:end), ...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);

%% G48 is more complicated since the field of view moves a few times over the 1.5
% months. Below lists the registrations for the 4 good chunks of data. Very
% conservative.

G48_alt_nf = G48_alt(~G48_forced_bool); %  get non-forced sessions
G48regstats_2to9 = reg_qc_plot_batch(G48_alt_nf(1), G48_alt_nf(2:9), ...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);
G48regstats_3to13 = reg_qc_plot_batch(G48_alt_nf(2), G48_alt_nf(3:13),...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);
G48regstats_12to16 = reg_qc_plot_batch(G48_alt_nf(11), G48_alt_nf(12:16), ...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);
G48regstats_18to30 = reg_qc_plot_batch(G48_alt_nf(17), G48_alt_nf(18:30), ...
    'num_shuffles', 1000, 'shift_dist', 6, 'num_shifts', 1000);

%%


