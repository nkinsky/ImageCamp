function [ categories, cat_nums, cat_names ] = alt_parse_cell_category( sesh, pval_thresh,...
    ntrans_thresh, sigthresh, PFname )
% [categories, names] = alt_parse_cell_category( sesh, pval_thresh, ntrans_thresh, sigthresh... )
%
%   Breaks out cells in sesh into 6 categories identified by number in
%   categories (num_neurons x 1 vector): splitters, stem place
%   cells (sPCs), stem non-place cells (sNPCS), arm PCs, arm
%   NPCs, does not pass number transients threshold.
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

if nargin < 5
    PFname = 'Placefields.mat';
end

cat_nums = 0:5;
cat_names = { ['ntrans < ' num2str(ntrans_thresh)], 'Splitters', ...
    'Stem PCs', 'Arm PCs', 'Stem NPCs', 'Arm NPCs'};

load(fullfile(sesh.Location,'sigSplitters.mat'),'neuronID','sigcurve');
stem_cells = false(length(sigcurve),1);
categories = zeros(length(sigcurve),1);
stem_cells(neuronID) = true;
[pctemp, ntrans_pass] = pf_filter(sesh, pval_thresh, ntrans_thresh, ...
    PFname);
categories(stem_cells & cellfun(@(a) sum(a) >= sigthresh, sigcurve) & ...
    ntrans_pass) = 1; % Splitters
categories(stem_cells & pctemp & ~cellfun(@any,sigcurve) & ...
    ntrans_pass) = 4; % Stem PCs
categories(~stem_cells & pctemp & ntrans_pass) = 2; % Arm PCs
categories(stem_cells & ~pctemp & ~cellfun(@any,sigcurve) & ...
    ntrans_pass) = 5; % Stem NPCs
categories(~stem_cells & ~pctemp & ntrans_pass) = 3; % Arm NPCs

end

