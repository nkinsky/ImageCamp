function [ h ] = twoenv_DI_topo( DI_use, batch_session_map, sesh_ind, varargin )
% h = twoenv_DI_topo( DI_use, batch_map, sesh1_ind, sesh2_ind, varargin )
%   Plot neuron ROIs with color coding for discrimination ratio.

high_DI_thresh = 0.75;
low_DI_thresh = 0.25;

if nargin < 4
   neuron_filter = nan;
end

%% ID valid neurons and classify as high DI or low DI
% ID valid neurons
valid_neurons = find(~isnan(DI_use));
if ~any(isnan(neuron_filter))
    valid_neurons = valid_neurons & neuron_filter;
end

DI_valid = DI_use(valid_neurons);

% Identify high DI (Discriminator) neurons and low DI neurons (could later
% be classified as coherent or not...)
high_DI = abs(DI_valid) <= 1 & abs(DI_valid) > high_DI_thresh;
low_DI = abs(DI_valid) < low_DI_thresh;
neither = abs(DI_valid) >= low_DI_thresh & abs(DI_valid) <= high_DI_thresh;

%% Dump everything into sesh variable
for j = 1:2
    % neurons active in either session
    sesh(j).neurons = batch_session_map.map(valid_neurons, sesh_ind(j)+1);
    
    % high DI and low DI neurons in each session, and those that are
    % neither
    sesh(j).high_DI = batch_session_map.map(valid_neurons(high_DI), sesh_ind(j)+1);
    sesh(j).low_DI = batch_session_map.map(valid_neurons(low_DI), sesh_ind(j)+1);
    
    % Load in ROIs for each session
    sesh_dir = ChangeDirectory_NK(batch_session_map.session(sesh_ind(j)),0);
    load(fullfile(sesh_dir,'FinalOutput.mat'),'NeuronImage');
    if j == 1
        sesh(j).ROIs = NeuronImage;
    elseif j == 2
        sesh(j).ROIs = ROIwarp(batch_session_map.session(sesh_ind(1)),...
            batch_session_map.session(sesh_ind(2)));
    end
    %%% Need to register 2nd session to 1st before plotting
end

% neurons active in both sessions
% active_both_log = (sesh(1).neurons ~= 0 & sesh(2).neurons ~= 0);

%% Plot everything
figure; 
set(gcf,'Position', [2270, 50, 1100, 850]);
h = gca;

% Plot all neuron outlines
scale_bar = true;
for j=1:2
    [~, ~, h_neither] = plot_neuron_outlines(nan, sesh(j).ROIs, h, ...
        'colors', [0 0 1],'scale_bar', scale_bar);
        scale_bar = false; % Plot all neurons
end

% Plot high DI in red, low DI in green for each session
for j=1:2
    [~, ~, h_high] = plot_neuron_outlines(nan, sesh(j).ROIs(sesh(j).high_DI(sesh(j).high_DI ~= 0)), ...
        h, 'colors', [1 0 0],'scale_bar', scale_bar);
        scale_bar = false; % Plot high DI red
    [~, ~, h_low] = plot_neuron_outlines(nan, sesh(j).ROIs(sesh(j).low_DI(sesh(j).low_DI ~= 0)), ...
        h, 'colors', [0 1 0], 'scale_bar', scale_bar); % Plot low DI green
end

legend(cat(2,h_high(1),h_low(1),h_neither(1)),{'High DI','Low DI','tweener'})
axis tight

%% Potentially a bit cleaner looking plots, but not validated yet
% 
% plot_neuron_outlines(nan, sesh(1).ROIs, h, 'colors', [0 0 1]); % Plot all neurons
% plot_neuron_outlines(nan, sesh(2).ROIs(valid_neurons(~active_both_log)), ...
%     h, 'colors', [0 0 1]); % Plot all neurons
% 
% plot_neuron_outlines(nan, sesh(1).ROIs(sesh(1).high_DI(sesh(j).high_DI ~= 0)), ...
%     h, 'colors', [1 0 0]); % Plot high DI red
% plot_neuron_outlines(nan, sesh(1).ROIs(sesh(j).low_DI(sesh(j).low_DI ~= 0)),...
%     h, 'colors', [0 1 0]); % Plot low DI green
% 
% plot_neuron_outlines(nan, sesh(2).ROIs(sesh(1).high_DI(sesh(j).high_DI ~= 0)), ...
%     h, 'colors', [1 0 0]); % Plot high DI red
% plot_neuron_outlines(nan, sesh(2).ROIs(sesh(j).low_DI(sesh(j).low_DI ~= 0)),...
%     h, 'colors', [0 1 0]); % Plot low DI green

end

