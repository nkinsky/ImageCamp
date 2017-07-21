function [ ] = twoenv_coherent_topo(best_angle_corrs, batch_session_map,...
    sesh_ind, coh_thresh, plot_coh_only)
% twoenv_coherent_topo(best_angle_corrs, batch_session_map, sesh_ind, coh_thresh, plot_coh_only)
%   Plots cells with correlations above coh_thresh in red, with the rest in
%   blue.

%% Step 0: Assign defaults

if nargin < 4
    coh_thresh = 0.75;
    plot_coh_only = false;
elseif nargin < 5
    plot_coh_only = false;
end
%% Step 1: Setup variable with ROIs registered to each other

for j =1:2

% Load NeuronImage for each

% Register 2nd sesh to 1st
end

% Identify and create a boolean for cells in the 2nd session only

%% Step 2: Threshold correlations to identify good cells

% Identify all cells with non-nan correlations for potential plotting

% Identify cells with correlation above thresh

%% Step 3: Plot it

if ~plot_coh_only
% Plot all cells for session 1 and session 2 only cells
end

% Plot cells above thresh in red



end

