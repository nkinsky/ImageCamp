% Eraser imaging figure creation
[MD, ref, ref2] = MakeMouseSessionListEraser('Nat');
neurons_plot = [1 13 16 206 222 221 510 722 714 730];
neurons_plot = neurons_plot(randperm(10));
plot_trace_and_outlines3(MD(30), neurons_plot, 11993, true)