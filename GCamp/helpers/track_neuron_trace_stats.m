function [hf, ha] = track_neuron_trace_stats(MD1, MD2, ha)
% [hf, ha] = track_neuron_trace_stats(MD1, MD2, ha)
%   Track neuron half-lives and baseline fluorescence between sessions MD1
%   and MD2. ha (optional) is a length 2 array of axes handles to plot
%   into. Otherwise it plots

sessions = cat(1, MD1, MD2); % combine session into one variable

%% First, get mapping between sessions
neuron_map = neuron_map_simple(MD1, MD2);

%% Second, get trace stats between sessions
[half_all_mean, half_mean, LPerror_all, legit_trans_all] = ...
    arrayfun(@(a) get_session_trace_stats(a, 'spam', false, ...
    'use_saved_data', true), sessions, 'UniformOutput', false); 

%% Third, calculate baseline fluoresence from min projection for each neuron
[F0, error_flag] = arrayfun(@(a) get_ROIbaseline_fluor(a), sessions,...
    'UniformOutput', false);

%% Now map each to the other!
coactive_bool = ~isnan(neuron_map) & neuron_map ~= 0;
ncoactive = sum(coactive_bool);
[F0reg, half_all_reg] = deal(nan(ncoactive, 2)); % pre-allocate
F0reg(:,1) = F0{1}(coactive_bool);
F0reg(:,2) = F0{2}(neuron_map(coactive_bool));
half_all_reg(:,1) = half_all_mean{1}(coactive_bool);
half_all_reg(:,2) = half_all_mean{2}(neuron_map(coactive_bool));

%% Now plot!
hf = nan;
if nargin < 3
    hf = figure; set(hf, 'Position', [ 57   185   840   420]);
    ha(1) = subplot(1,2,1); ha(2) = subplot(1,2,2);
end
grps = repmat([1,2],ncoactive,1);
paired_inds = repmat((1:ncoactive)',1, 2);
[~, ~, ~, hpaired] = scatterBox(F0reg(:), grps(:), 'xLabels', ...
    {'First', 'Last'}, 'ylabel', 'F0', 'h', ha(1), ...
    'paired_ind', paired_inds(:), 'circlesize', 12);
arrayfun(@(a) set(a,'Color',[0 0 0 0.1]), hpaired);
xlabel(ha(1), 'Session')

[~, ~, ~, hpaired] = scatterBox(half_all_reg(:), grps(:), 'xLabels', ...
    {'First', 'Last'}, 'ylabel', '\tau_{1/2} (sec)', 'h', ha(2), ...
    'paired_ind', paired_inds(:), 'circlesize', 12);
arrayfun(@(a) set(a,'Color',[0 0 0 0.1]), hpaired);
xlabel(ha(2), 'Session')


end

