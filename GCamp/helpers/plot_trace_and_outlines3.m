function [hfig, neurons_use] = plot_trace_and_outlines3(sesh, n, ...
    nframes_plot, PSA_plot, trace_type)
% [hfig, neurons_use] = plot_trace_and_outlines3(sesh, n, nframes_plot, ...
%       plot_PSA)
%   Quick plot of n randomly selected neurons and their corresponding
%   traces in sesh. More control than plot_trace_and_outlines.
%   INPUTS:
%       n: # neurons to plot. optional and defaults to 10 if left blank. 
%   n can also be an array containing the exact numbers of neurons you wish to
%   plot. 
%   
%   nframes_plot (optional): default is all frames in the session. 
%
%   plot_PSA (optional):true = plot putative spiking events for all
%   neurons. default = false.
%
%   OUTPUTS: neurons_use: neurons plotter, hfig: figure handle

dir_use = ChangeDirectory_NK(sesh,0);
load(fullfile(dir_use,'FinalOutput.mat'),'NeuronImage','NeuronTraces',...
    'PSAbool')
[nneurons, nframes] = size(PSAbool);
SR = 20;

if nargin < 5
    trace_type = 'lowpass';
    if nargin < 4
        PSA_plot = false; % default don't ID PS epochs.
        if nargin < 3
            nframes_plot = nframes;
            if nargin < 2
                n = 10;
            end
        end
    end
end

try
    base_image = imread(fullfile(dir_use,'ICmovie_max_proj.tif'));
catch
    try
        base_image = imread(fullfile(dir_use,'ICmovie_min_proj.tif'));
    catch
        base_image = nan;
    end
end


if length(n) == 1
    neurons_use = randperm(nneurons,n); % Randomly select n neurons from pool
else
    neurons_use = n;
end
NeuronImage_use = NeuronImage(neurons_use);
switch trace_type
    case'lowpass'
        traces_use = NeuronTraces.LPtrace(neurons_use,1:nframes_plot);
    case 'raw'
        traces_use = NeuronTraces.RawTrace(neurons_use,1:nframes_plot);
end

PSAbool_use = PSAbool(neurons_use,1:nframes_plot);
if ~PSA_plot
    PSAbool_use = false(size(PSAbool_use));
end
hfig = figure; set(gcf,'Position',[120 50 1550 600]);
h1 = subplot(1,2,1); h2 = subplot(1,2,2);

[~, colors] = plot_neuron_outlines(base_image, NeuronImage_use, h1);
plot_neuron_traces(traces_use, colors, h2, 'SR', SR, 'PSAbool', PSAbool_use);

end


