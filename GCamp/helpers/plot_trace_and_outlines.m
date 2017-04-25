function [ ] = plot_trace_and_outlines( base_image, NeuronImage, NeuronTraces, neurons_to_plot, nframes_plot )
% plot_trace_and_outlines( base_image, NeuronImage, NeuronTraces, neurons_to_plot, nframes_plot )
% plots neuron outlines on top of base image with corresponding traces next
% to it

figure
h1 = subplot(1,2,1);
h2 = subplot(1,2,2);
NeuronImage = NeuronImage(neurons_to_plot);
traces = NeuronTraces(neurons_to_plot,1:nframes_plot);
[~, colors] = plot_neuron_outlines(base_image, NeuronImage, h1);
plot_neuron_traces(traces, colors, h2);

end

