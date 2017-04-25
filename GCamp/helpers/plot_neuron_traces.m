function [ h, colors_used ] = plot_neuron_traces( traces, varargin)
% [ h, colors_used ] = plot_neuron_traces( traces, color_table, h )
%   Plot neuron traces with colors in rgb color_table onto handle h.
%   color_table and h are options inputs.  Assumes 20 fps for now;

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

