function [h, neurons_use] = plot_trace_and_outlines2(sesh)
% [h, neurons_plotted] = plot_trace_and_outlines2(sesh)
%   Plots neuron outlines and traces of 10 randomly selected neurons. Good
%   for quality control plots for a session. Super basic.

dir_use = ChangeDirectory_NK(sesh,0);
load(fullfile(dir_use,'FinalOutput.mat'),'NeuronImage','NeuronTraces',...
    'PSAbool')

try
    base_image = imread(fullfile(dir_use,'ICmovie_max_proj.tif'));
catch
    try
        base_image = imread(fullfile(dir_use,'ICmovie_min_proj.tif'));
    catch
        base_image = nan;
    end
end
nneurons = size(PSAbool,1);
% nframes = size(PSAbool,2);
neurons_use = randperm(nneurons,10);
traces = NeuronTraces.LPtrace(neurons_use,:);
PSA_use = PSAbool(neurons_use,:);
h = figure; set(gcf,'Position',[120 220 1550 600]);
h1 = subplot(1,2,1); h2 = subplot(1,2,2);
plot_neuron_outlines(base_image, NeuronImage, h1)
plot_neuron_traces(traces, nan, h2, 'SR', 20, 'PSAbool', PSA_use);

end

