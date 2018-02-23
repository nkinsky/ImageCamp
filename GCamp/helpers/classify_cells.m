function [ good_map, become_silent, new_cells, ambig_silent, ambig_new] = ...
    classify_cells( MD1, MD2, overlap_thresh, name_append, varargin )
% [ good_map, become_silent, new_cells] = classify_cells( ...
%     MD1, MD2, overlap_thresh, name_append )
%   Classifies cells mapped between MD1 and MD2 into categories: 1) good
%   mapped cells, those that become silent in the 2nd session, those that
%   are new in the 2nd session, and those that are overlapping by more than
%   the overlap_thresh but ARENT'T mapped between the two and thus might be
%   the same cells miscategorized as new or silent. overlap_thresh sets the
%   level for ambiguous mappings (i.e. 0.25 means cells must have < 25%
%   overlapping pixels with their nearest neighbor to be considered silent,
%   nan means no good silent/new cells - all get thrown into ambig_silent
%   and ambig_new).

if nargin < 4
    name_append = '';
    if nargin < 3
        overlap_thresh = 0.25;
    end
end

%% Load each session and register ROIs from MD2 to MD1 (write new function
% based on code in plot_registration to do this)
[ROIs1, ROIs2] = register_ROIs_simple(MD1 ,MD2, name_append); 

%% Get map between sessions using neuron_map_simple and id all the
% categories
[good_map, become_silent, new_cells]  = neuron_map_simple(MD1, MD2, ...
    'name_append', name_append, 'suppress_output', true, varargin{:});

%% Above but only using closest neighbor
cm_dist = get_ROIdist_simple(MD1, MD2, name_append); % Get distance to all other cells
[~, near_neighbors2] = min(cm_dist,[],2); % Get nearest neighbors in session 2
ROIsilent2 = ROIs1(become_silent);
ROIneighbors2 = ROIs2(near_neighbors2);
ROIneighbors2 = ROIneighbors2(become_silent);

ymax2 = cellfun(@(a,b) sum(a(:) & b(:)), ROIsilent2, ROIneighbors2);
silent_overlap = ymax2./cellfun(@(a) sum(a(:)), ROIsilent2);

if ~isnan(overlap_thresh)
    silent_pass = silent_overlap <= overlap_thresh;
    ambig_silent = become_silent(~silent_pass);
    become_silent = become_silent(silent_pass);
elseif isnan(overlap_thresh) % Make
    ambig_silent = become_silent;
    become_silent = [];
end

%% Same as above but only using closest neighbors
[~, near_neighbors1] = min(cm_dist,[],1); % Get nearest neighbors in session 1
ROInew = ROIs2(new_cells);
ROIneighbors1 = ROIs1(near_neighbors1);
ROIneighbors1 = ROIneighbors1(new_cells);

ymax3 = cellfun(@(a,b) sum(a(:) & b(:)), ROInew, ROIneighbors1);
new_overlap2 = ymax3./cellfun(@(a) sum(a(:)), ROInew);

if ~isnan(overlap_thresh)
    new_pass = new_overlap2 <= overlap_thresh;
    ambig_new = new_cells(~new_pass);
    new_cells = new_cells(new_pass);
elseif isnan(overlap_thresh)
   ambig_new = new_cells;
   new_cells = [];
end

end

%% Old (Very Slow) Code just in case
%% Now do new cells
% tic
% new_overlap = nan(length(new_cells),1);
% ROInew = ROIs2(new_cells);
% parfor j = 1:length(new_cells)
%     ymax = max(cellfun(@(a) sum(ROInew{j}(:) & a(:)), ...
%         ROIs1));
%     new_overlap(j) = ymax/sum(ROInew{j}(:));
% end
% toc
% new_pass = new_overlap <= overlap_thresh;
% ambig_new = new_cells(~new_pass);
% new_cells2 = new_cells(new_pass);

%% Calculate cell ROI overlap with 1st session ROIs and calculate overlap
% ratio (# overlapping pixels / smaller ROI pixels). Do silent cells first
% tic
% silent_overlap = nan(length(become_silent),1); % imax = ymax;
% ROIsilent = ROIs1(become_silent);
% parfor j = 1:length(become_silent)
%     ymax = max(cellfun(@(a) sum(ROIsilent{j}(:) & a(:)), ...
%         ROIs2));
%     silent_overlap(j) = ymax/sum(ROIsilent{j}(:));
% end
% toc
% silent_pass = silent_overlap <= overlap_thresh;
% ambig_silent = become_silent(~silent_pass);
% become_silent = become_silent(silent_pass);

