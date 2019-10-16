% Eraser imaging figure creation

%% Plot 10 neurons
[MD, ref, ref2] = MakeMouseSessionListEraser('Nat');
neurons_plot = [1 13 16 206 222 221 510 722 714 730];
neurons_plot = neurons_plot(randperm(10));
plot_trace_and_outlines3(MD(30), neurons_plot, 11993, true)

%% Plot 25 neurons during shock session!
[MD, ref, ref2] = MakeMouseSessionListEraser('natlaptop');
plot_trace_and_outlines3(MD(34), randperm(170,20), 1200, true)