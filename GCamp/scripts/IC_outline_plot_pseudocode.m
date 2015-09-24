% pseudocode to Victor for getting/plotting individual neuron outlines

%% Load your image
background = imread('ICMovie_max_projection.tif'); % Should match the size of your ICs
im_size = size(background);

% Plot it
figure(10)
imagesc(background); % might have to set this to grayscale: colormap(gca,gray), but then you'll have to futz to turn back on colors later on perhaps, not sure

%% Set up your colors for plotting
colors = rand(length(num_neurons),3);
%% Get all IC perimeters
% ... in a for loop ...
% 1) Load each IC
load('I:\GCamp Mice\G30\9_23_2014\1 - triangle track 201B\IC600-Objects\Obj_1\Obj_1_1 - IC filter 1.mat')

% 2) Threshold it - quick and dirty for now could be 0.25*max (shown here) or 5 stdevs,
% you'll need to play with this parameter to see what matches your data the
% best...

IC = Object.Data;
thresh_max = 0.25; 
IC_thresh = IC > 0.25*max(IC(:));

% 3) Get the perimeter

% stolen from Dave's code PlotNeuronOutlines
b = bwboundaries(IC_thresh);
x{i} = b{1}(:,1);
x{i} = x{i}+(rand(size(x{i}))-0.5)/2;
y{i} = b{1}(:,2);
y{i} = y{i}+(rand(size(y{i}))-0.5)/2;
plot(y{i},x{i},'Color',colors(clusterlist(i),:));hold on;

%% That's it, more or less.  I know you probably didn't need this much but the functions
% imread, bwboundaries, and thresholding the filter should come in handy



