function [ h, colors_used ] = plot_neuron_traces( traces, varargin)
% [ h, colors_used ] = plot_neuron_traces( traces, color_table, h )
%   Plot neuron traces with colors in rgb color_table onto handle h.
%   color_table and h are options inputs.  Assumes 20 fps for now;
%
%   INPUTS:
%       traces: Either NeuronTraces.RawTrace or NeuronTraces.LPtrace from
%       FinalOutput.mat
%
%       color_table (optional): Add in color table from
%       plot_neuron_outlines to match ROI outlin colors or any other custom
%       colors you want (rgb format, rows = neuron color, #rows must match
%       #rows traces
%
%       h (optional): axes handle to plot into
%
%   OUTPUTS:
%       h: axes handle to plot
%
%       colors_used: color table matching plotted traces

%% Parse inputs
ip = inputParser;
ip.addRequired('traces',@isnumeric);
ip.addOptional('color_table',nan,@isnumeric);
ip.addOptional('h', nan, @ishandle);
ip.parse(traces, varargin{:});

color_table = ip.Results.color_table;
h = ip.Results.h;

if ~ishandle(h)
    figure; h = gca;
end

num_neurons = size(traces,1);
num_frames = size(traces,2);
SR = 20; % frames/sec

%% Construct traces

baseline = mean(traces,2);
trace_adj = traces - baseline; % Subtract out baseline to zero everything
time_plot = (1:num_frames)/SR;

% NK attempt to make everything more or less equally spaced
trace_max = max(trace_adj,[],2);
trace_adj = trace_adj./trace_max;

axes(h)
y_base = 0;

colors_used = nan(num_neurons,3);
for j = 1:num_neurons
    trace_use = trace_adj(j,:) + y_base;
    if ~isnan(color_table)
        plot(time_plot, trace_use, 'Color', color_table(j,:));
    else
        hline = plot(time_plot, trace_use);
        colors_used(j,:) = hline.Color;
    end
    hold on
    
    % Get increment to next neuron's base y value
    if j ~= num_neurons
        y_base = max(trace_use) - min(trace_adj(j+1,:));
    else 
        y_base = max(trace_use);
    end
%     printNK(['testing' num2str(j)],'2env')
end

if ~isnan(color_table)
    colors_used = color_table;
end

% Plot scale bar at bottom
y_loc = min(trace_adj(1,:)) - 0.5*range(trace_adj(1,:));
plot([time_plot(1) time_plot(30*SR)], [y_loc y_loc],'LineWidth',3,'Color','k');
text(time_plot(10+30*SR),double(y_loc),'30 s')
hold off
axis tight
axis off
end

