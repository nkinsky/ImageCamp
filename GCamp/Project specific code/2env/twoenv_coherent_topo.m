function [ h ] = twoenv_coherent_topo(best_angle_or_corrs, batch_session_map,...
    sesh_ind1, sesh_ind2, thresh_type, plot_coh_only)
% h = twoenv_coherent_topo(best_angle_or_corrs, batch_session_map, sesh_ind1, sesh_ind2, ...
%   coh_thresh, plot_coh_only)
%   Plots cells with correlations above coh_thresh in red, with the rest in
%   blue.

%% Step 0: Assign defaults

if nargin < 6
    plot_coh_only = false;
    coh_thresh = 30;
    if nargin < 5
        thresh_type = 'angle';
    end
end

if strcmpi(thresh_type,'angle')
    coh_thresh = 30; % degrees
elseif strcmpi(thresh_type,'corr')
   coh_thresh = 0.75; % correlation 
end

sesh_ind = [sesh_ind1 sesh_ind2];
batch_session_map = fix_batch_session_map(batch_session_map);
%% Step 1: Setup variable with ROIs registered to each other
neuron_map = get_neuronmap_from_batchmap(batch_session_map, sesh_ind(1),...
    sesh_ind(2)); % Get map between sessions

for j = 1:2
    [~, sesh_temp] = ChangeDirectory_NK(batch_session_map.session(sesh_ind(j)),0);
    [sesh(j)] = deal(sesh_temp); %#ok<AGROW>
end

for j =1:2
    % Load NeuronImage for each
    
    load(fullfile(sesh(j).Location,'FinalOutput.mat'),'NeuronImage');
    sesh(j).num_neurons = length(NeuronImage);
    % Register 2nd sesh to 1st
    if j == 1
        sesh(j).ROIs = NeuronImage;
    elseif j == 2
        sesh(j).ROIs = ROIwarp(sesh(1), sesh(2));
    end
end

% Identify and create a boolean for cells in the 1st and 2nd session only
only{1} = isnan(neuron_map) | (neuron_map == 0);
only{2} = (~ismember(1:sesh(2).num_neurons, neuron_map))';

%% Step 2: Threshold correlations to identify good cells

if strcmpi(thresh_type,'angle')
    valid_neurons = ~isnan(best_angle_or_corrs);
    coherent_cells{1} = abs(best_angle_or_corrs) <= coh_thresh & valid_neurons;
elseif strcmpi(thresh_type,'corr')
    % Identify all cells with non-nan correlations for potential plotting
    valid_neurons = ~isnan(best_angle_or_corrs); % Should be all neurons active in both sessions...
    % Identify cells with correlation above thresh
    coherent_cells{1} = best_angle_or_corrs > coh_thresh & valid_neurons;
end


incoherent_cells{1} = valid_neurons & ~coherent_cells{1}; 
coherent_cells{2} = neuron_map(coherent_cells{1});
incoherent_cells{2} = neuron_map(incoherent_cells{1});

%% Step 3: Plot it
figure; 
set(gcf,'Position', [2270, 50, 1100, 850]);
h = gca;

scale_bar = true;
if ~plot_coh_only % Plot session 1 and session 2 only cells in grey
    for j = 1:2
        [~, ~, h_either] = plot_neuron_outlines(nan, sesh(j).ROIs(only{j}), h,...
            'colors', [0.5 0.5 0.5],'scale_bar', scale_bar);
        scale_bar = false;
    end
else
    h_either = [];
end


for j = 1:2
    % Plot cells above thresh in red
    [~, ~, h_coh] = plot_neuron_outlines(nan, sesh(j).ROIs(coherent_cells{j}), h,...
        'colors', [1 0 0], 'scale_bar', scale_bar);
    scale_bar = false;
    % Plot cells below thresh in green
    [~, ~, h_incoh] = plot_neuron_outlines(nan, sesh(j).ROIs(incoherent_cells{j}), h,...
        'colors', [0 0 1], 'scale_bar', scale_bar);
end
legend(cat(2, h_coh(1), h_incoh(1), h_either(1)), {'Coherent', 'Not Coherent', ...
    'Active 1 Session Only'})
axis tight
    
end

