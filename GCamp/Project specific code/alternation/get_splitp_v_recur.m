function [pco_v_splitp, pstaybec_v_splitp, splitp_bin_bool, edges] = ...
    get_splitp_v_recur(sesh1, sesh2, varargin)
%  [pco_v_splitp, pstaybec_v_splitp, splitp_bin_bool, edges] = ...
%       get_splitp_v_recur(sesh1, sesh2, varargin)
%   Calculates the probability a neuron in sesh1 recurs (pco) or stays/becomes a
%   splitter (pstaybec) in sesh2 based on its p-value for the 4 covariates
%   calculated in alt_wood_analysis. covariates = L/R trial, stem bin
%   position, speed, lateral (y) position on stem.

ip = inputParser;
ip.addRequired('sesh1',@isstruct);
ip.addRequired('sesh2',@isstruct);
ip.addParameter('edges', 0:0.1:1, @(a) all(a >= 0 & a <= 1)); % bin edges
% # bins that must be above chance in delta tuning curve to be considered 
% a splitter
ip.addParameter('sigthresh', 3, @(a) a > 0 && (round(a) == a));
ip.addParameter('PF_filename', 'Placefields_cm1.mat', @ischar);
ip.addParameter('bin_num_thresh', 5, @(a) a > 0 && (round(a) == a));
% Neuron must be active on this many trials to be considered
ip.addParameter('nthresh', 5, @(a) isnumeric(a) && a > 0 && (round(a) == a));
% true = consider only splitters! true will give you funky results for
% staying/becoming a splitter.
ip.addParameter('splitters_only', false, @islogical); 

ip.parse(sesh1, sesh2, varargin{:});
edges = ip.Results.edges;
sigthresh = ip.Results.sigthresh;
PF_filename = ip.Results.PF_filename;
nthresh = ip.Results.nthresh;
splitters_only = ip.Results.splitters_only;
bin_num_thresh = ip.Results.bin_num_thresh; 

%% 0) Get map between sessions
neuron_map = neuron_map_simple(sesh1, sesh2, 'suppress_output', true);

%% 1) Get pvalues from session 1
pvals = alt_wood_analysis(sesh1);

%% 2) Get "stability" of splitters from session 1 to session 2
[categories, cat_nums, ~] = arrayfun(@(a) alt_parse_cell_category(a, ...
    0.05, 5, sigthresh, PF_filename), cat(1, sesh1, sesh2), ...
    'UniformOutput', false);
[~, ~, ~, coactive_bool, category2] = ...
    get_cat_stability(categories, neuron_map, cat_nums{1});
% Get all cells that either stay or become splitters
become_split_bool = category2 == 1;

%% 3) Threshold to only include neurons that are sufficiently active. Also 
% remove non-splitters if specified

[~, ~, sigsplit_bool, ~, ~, nactive_stem] = parse_splitters(sesh1.Location);
if splitters_only
    
   keep_bool = sigsplit_bool;
elseif ~splitters_only
    keep_bool = true(size(nactive_stem));
end

active_bool = nactive_stem >= nthresh;
pvals = pvals(active_bool & keep_bool, :);
coactive_bool = coactive_bool(active_bool & keep_bool);
become_split_bool = become_split_bool(active_bool & keep_bool);

%% 4) Bin neurons and get recurrence probabilities
nbins = length(edges) - 1;
pco_v_splitp = nan(6, nbins);
pstaybec_v_splitp = nan(6, nbins);
splitp_bin_bool = nan(6, nbins);
for j = 1:6
    if ismember(j,1:5)
        pvals_use = pvals(:,j);
    elseif j == 6
        pvals_use = min(pvals(:,[1 3]),[], 2);
    end
    [n, ~, bin] = histcounts(pvals_use, edges);
    pco_v_splitp(j,:) = arrayfun(@(a) sum(coactive_bool(bin == a)),1:length(n))...
        ./arrayfun(@(a) sum(bin == a),1:length(n));
    % pstay_v_rely = arrayfun(@(a) sum(stay_bool(bin == a)),1:length(n_rely))...
    %     ./arrayfun(@(a) sum(bin == a),1:length(n_rely));
    pstaybec_v_splitp(j,:) = arrayfun(@(a) sum(become_split_bool(bin == a)),1:length(n))...
        ./arrayfun(@(a) sum(bin == a), 1:length(n));
    splitp_bin_bool(j,:) = n >= bin_num_thresh; % only include bins with min # neurons
end 

% Keep only rows 6, 2, 4, 5 (min(LR, LRxsector), sector, speed, ypos)
pco_v_splitp = pco_v_splitp([6 2 4 5],:);
pstaybec_v_splitp = pstaybec_v_splitp([6 2 4 5],:);
splitp_bin_bool = splitp_bin_bool([6 2 4 5],:);

end

