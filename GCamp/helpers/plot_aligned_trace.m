function [] = plot_aligned_trace(psa, trace, varargin)
% Plots all calcium events for a given neuron aligned to onset

ip = inputParser;
ip.addRequired('psa', @islogical); % boolean of rising times
ip.addRequired('trace', @(a) length(a) == length(psa)); % Raw trace
ip.addParameter('SR', 20, @(a) a > 0 && round(a) == a); % Sample rate
ip.addParameter('offset', 10, @(a) a > 0 && round(a) == a); % time before/after start to plot
ip.addParameter('min_epoch_time', 0.2, @(a) a > 0); % exclude transients with rise times less than this long
ip.parse(psa, trace, varargin{:});

SR = ip.Results.SR;
offset = ip.Results.offset;
min_epoch_time = ip.Results.min_epoch_time;

figure; 
offset_frames = offset*SR; 
nframes = length(psa); 

epochs = NP_FindSupraThresholdEpochs(psa, eps);
nepochs = size(epochs,1);

traces_aligned = nan(nepochs, 2*offset_frames+1);
plot_times = (-offset_frames:1:offset_frames)/SR;

% Construct aligned traces
for j = 1:nepochs 
    onset_frame = epochs(j,1);
    plot_frames = onset_frame-offset_frames:1:onset_frame+offset_frames; 
    valid_frames = plot_frames > 0 & plot_frames <= nframes;
    traces_aligned(j, valid_frames) = trace(plot_frames(valid_frames));
end

% Check for smaller transients entirely within plotting window for larger
% transient? Or just show them? Plot both! Eliminate and don't!

% Plot
htraces = plot(plot_times, traces_aligned, 'b-');
arrayfun(@(a) set(a, 'Color', [0 0 1 0.5]), htraces)
xlabel('Time from onset (s)')
ylabel('DF/F')
hold on; 
plot (plot_times, nanmean(traces_aligned,1), 'k-')

% Calculate stats - half-life (half-max decay time?), max

end

