function [ categories, cat_nums, cat_names ] = alt_parse_cell_category( ...
    sesh, pval_thresh, ntrans_thresh, sigthresh, PFname)
% [ categories, cat_nums, cat_names ] = alt_parse_cell_category( ...
%    sesh, pval_thresh, ntrans_thresh, sigthresh, PFname)
%
%   Breaks out cells in sesh into 6 categories identified by number in
%   categories (num_neurons x 1 vector): splitters, stem place
%   cells (sPCs), stem non-place cells (sNPCS), arm PCs, arm
%   NPCs, does not pass number transients threshold.
%
%   Set global variables WOOD_FILT to true and HALF_LIFE_THRESH to desired
%   cutoff to filter out any cells not meeting the Emma Wood et al. (2000)
%   splitter criteria (i.e. cells modulated by lateral position NOT
%   trajectory) or with trace half-life decay times greater than the
%   threshold you specify...
%
%   INPUTS
%
%       sesh: session db with Animal, Date, and Session at minimum. Must
%       have run sigtuningAllCells
%
%       pval_thresh: pval for MI in Placefields.mat to be considered a
%       place cell
%
%       ntrans_thresh: minimum number of transients to be considered at all
%
%       sigthresh: minimum number of signicant splitting bins required to 
%       be considered a splitter. Must be >= 1
%
%       PFname (optional): Placefields filename (default =
%       Placefields.mat')
%
%       exclude_bool: nneurons x 1 boolean - true = exclude, false =
%       include in categorization. 

global WOOD_FILT
global HALF_LIFE_THRESH

if ~isempty(WOOD_FILT) && WOOD_FILT
    lateral_alpha = 0.05;
else
    lateral_alpha = 1;
end

if ~isempty(HALF_LIFE_THRESH) && HALF_LIFE_THRESH
    half_thresh = HALF_LIFE_THRESH;
else
    half_thresh = 100;
end

% First ID any cells to exlucd with extra long transients
[half_all_mean, ~, ~, ~] = get_session_trace_stats(sesh, ...
    'use_saved_data', true);
exclude_trace = half_all_mean > half_thresh; 

% ID stem cells that are modulated by lateral position. These are ones that
% have significant trajectory modulation after accounting for speed/lateral
% position.
p = alt_wood_analysis(sesh,'use_saved_data',true);
exclude_lateral = (p(:,1) >= lateral_alpha) & (p(:,3) >= lateral_alpha); 

% ID good splitters based on sig diff b/w tuning curves and no lateral
% position modulation.
load(fullfile(sesh.Location,'sigSplitters.mat'),'neuronID','sigcurve');
stem_cells = false(length(sigcurve),1);
categories = zeros(length(sigcurve),1);
stem_cells(neuronID) = true;
splitters = cellfun(@(a) sum(a) >= sigthresh, sigcurve);
good_splitters = splitters & ~exclude_lateral;
not_splitters = splitters & exclude_lateral | ~splitters;

if nargin < 5
    PFname = 'Placefields_cm1.mat';
end

cat_nums = 0:5;
% cat_names = { ['ntrans < ' num2str(ntrans_thresh) 'or bad transients'], 'Splitters', ...
%     'Stem PCs', 'Arm PCs', 'Stem NPCs', 'Arm NPCs'};  % Old scheme

cat_names = { ['ntrans < ' num2str(ntrans_thresh) 'or bad transients'], 'Splitters', ...
    'Arm PCs', 'Arm NPCs', 'Stem PCs', 'Stem NPCs'}; % New scheme

[pctemp, ntrans_pass] = pf_filter(sesh, pval_thresh, ntrans_thresh, ...
    PFname);
categories(stem_cells & good_splitters & ntrans_pass & ~exclude_trace) = 1; % Splitters
% categories(stem_cells & pctemp & ~cellfun(@any,sigcurve) & ...
%     ntrans_pass) = 4; % Stem PCs
categories(stem_cells & pctemp & not_splitters & ntrans_pass & ...
    ~exclude_trace) = 4; % Stem PCs
categories(~stem_cells & pctemp & ntrans_pass & ~exclude_trace) = 2; % Arm PCs
% categories(stem_cells & ~pctemp & ~cellfun(@any,sigcurve) & ...
%     ntrans_pass) = 5; % Stem NPCs
categories(stem_cells & ~pctemp & not_splitters & ntrans_pass & ...
    ~exclude_trace) = 5; % Stem NPCs
categories(~stem_cells & ~pctemp & ntrans_pass & ~exclude_trace) = 3; % Arm NPCs

end

