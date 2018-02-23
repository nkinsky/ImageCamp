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
ip.addParameter('SR',20,@(a) a == round(a)); % Frames/sec
ip.addParameter('PSAbool',false(size(traces)),@islogical); % Putative spiking activity to match size of traces
ip.parse(traces, varargin{:});

color_table = ip.Results.color_table;
h = ip.Results.h;
SR = ip.Results.SR;
PSAbool = ip.Results.PSAbool;

if ~ishandle(h)
    figure; h = gca;
end

num_neurons = size(traces,1);
num_frames = size(traces,2);
% SR = 20; % frames/sec
time_bar = round(num_frames/SR/6,-1); % seconds
%% Construct traces

baseline = mean(traces,2);
trace_adj = traces - baseline; % Subtract out baseline to zero everything
time_plot = (1:num_frames)/SR;

% NK attempt to make everything more or less equally spaced
trace_max = max(trace_adj,[],2);
offset = median(trace_max);
% trace_adj = trace_adj./trace_max;
% trace_adj = trace_adj/trace_max(1); % Normalize everything to max height of the 1st trace.

axes(h)
% y_base = 0;

colors_used = nan(num_neurons,3);
for j = 1:num_neurons
    trace_use = trace_adj(j,:) + (j-1)*offset; %trace_adj(j,:) + (j-1)*trace_max(1); %(trace_adj(j,:) + y_base;
    PSA_use = PSAbool(j,:);
    if ~isnan(color_table)
        plot(time_plot, trace_use, 'Color', color_table(j,:));
    else
        hline = plot(time_plot, trace_use);
        colors_used(j,:) = hline.Color;
    end
    hold on
    
    % Plot putative spiking epochs if specified 
    epochs = NP_FindSupraThresholdEpochs(PSA_use,eps);
    if ~isempty(epochs)
        hpsa = arrayfun(@(a,b) plot(time_plot(a:b), trace_use(a:b),'r'), epochs(:,1), epochs(:,2),...
            'UniformOutput', false);
        cellfun(@(a) set(a,'LineWidth',2), hpsa);
    end
end

% y_data = arrayfun(@(a) max(a.XData),htraces.Children(2:end));

if ~isnan(color_table)
    colors_used = color_table;
end

% Plot time scale bar at bottom
y_loc = min(trace_adj(1,:)) - 0.1*range(trace_adj(1,:));
FLbar_time = round(num_frames+100,-2)/SR;
plot([FLbar_time - time_bar FLbar_time], [y_loc y_loc],'LineWidth',2,'Color','k');
text(FLbar_time - time_bar - 5,double(y_loc),[num2str(time_bar) ' s'],...
    'HorizontalAlignment','right')
% Plot fluorescence scale bar at bottom
FLht = round(100*offset,-1); % % double(round(max(trace_adj(1,:))*100,-1)); % Get approx. height of max trace fluorescence
plot([FLbar_time FLbar_time], double([y_loc y_loc + FLht/100]),'LineWidth',2,'Color','k');
text(FLbar_time + 5, double((y_loc + FLht/100)-0.05), ...
    [num2str(FLht) '% DF/F'])
hold off
axis tight
axis off

end

