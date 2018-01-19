function [ corrs, PV1_use, PV2_use, final_filter ] = pairwise_PVcorr( MD1, MD2, varargin )
% [corrs, PV1_use, PV2_use, final_filter] = pairwise_PVcorr( MD1, MD2, ... )
%   Gets pairwise PV correlations between MD1 and MD2. Spits out PV
%   correlations (Spearman) at each spatial bin and nBinsX x nBinsy x
%   num_neurons arrays of mean calcium event rate in each bin for all
%   neurons mapped between sessions.  
%
%   Optional name-value inputs:
%
%   silent_thresh: nan (default) = include only cells active in BOTH
%   sessions that pass pval and ntrans thresholds in EITHER session, 
%   0<= silent_thresh <= 1 = include all silent cells passing pval/ntrans 
%   thresholds in either session that have less than 100*silent_thresh%
%   overlapping pixels with a cell in another session (e.g. 1 = include all
%   silent/new cells, 0 = include only unambiguous ones that have no ROI
%   nearby)
%
%   map_name_append: text appended to end of neuron_map file (note that
%   batch_session_map functionality is NOT yet enabled. 1x2 cell array.
%
%   PFname_append: text appended to end of Placefields file for each
%   session.  1x2 cell array.
%
%   TMap_use: 'unsmoothed' (default) or 'gauss'
%
%   half_flag: use Placefield_half and spit out a 4d PV (not really checked
%   yet)
%
%   silent_thresh:  sets the level for ambiguous mappings (i.e. 0.25 means 
%   cells must have < 25% overlapping pixels with their nearest neighbor to 
%   be included as silent cells, nan means no cells get included as silent
%   cells). default = nan (don't include any silent neurons)
%
%   pval_thresh: only include cells with pval < pval_thresh in one of the
%   sessions.  default = .05.
%
%   ntrans_thresh: only include cells with ntrans < ntrans_thresh in one of
%   the sessions. default = 3 (ok for open field, too low for linear track)
%
%   batch_map: add to use batch_map for neuron registration instead of
%   pairwise.  default = [] (use pairwise registration)

%% Step 0: InputParser
% Need MD1, MD2, placefield files to use, thresholds (ntrans and pval), and
% PFname_append, map_name_append, overlap_thresh (silent_thresh?)
ip = inputParser;
ip.addRequired('MD1',@isstruct);
ip.addRequired('MD2',@isstruct);
ip.addParameter('map_name_append',cell(1,2),@iscell); % name appened to neuron_map file
ip.addParameter('PFname_append',cell(1,2),@iscell);
ip.addParameter('TMap_use','unsmoothed',@(a) ischar(a) && strcmpi(a,'gauss') || ...
    strcmpi(a,'unsmoothed'));
ip.addParameter('half_flag',false, @islogical); 
% nan = don't include silent cells, a = include only those with < a%
% overlapping pixels with the second session
ip.addParameter('silent_thresh', nan, @(a) isnan(a) || a >=0 && a <= 1); 
ip.addParameter('pval_thresh', 0.05, @(a) a > 0 & a <= 1);
ip.addParameter('ntrans_thresh', 3, @(a) a >= 0 & round(a) == a);
ip.addParameter('batch_map',[], @(a) isempty(a) || isstruct(a)); % specify to use batch map instead of pairwise reg
% ip.addParameter('skip_corr'
ip.addParameter('custom_filter', nan, @(a) islogical(a) || isnan(a)); % nan = don't use custom filter
ip.KeepUnmatched = true;
ip.parse(MD1, MD2, varargin{:});
map_name_append = ip.Results.map_name_append;
PFname_append = ip.Results.PFname_append;
TMap_use = ip.Results.TMap_use;
half_flag = ip.Results.half_flag;
silent_thresh = ip.Results.silent_thresh;
pval_thresh = ip.Results.pval_thresh;
ntrans_thresh = ip.Results.ntrans_thresh;
custom_filter = ip.Results.custom_filter;


%% Step 1: Complete MDs and load in tmaps
sesh = complete_MD(MD1); sesh(2) = complete_MD(MD2);
for j = 1:2
    sesh(j).PV = get_PV_from_TMap(sesh(j), 'PFname_append', PFname_append{j},...
        'TMap_use', TMap_use, 'half_flag', half_flag);
    load(fullfile(sesh(j).Location,['Placefields' PFname_append{j} '.mat']),...
        'PSAbool','pval');
    sesh(j).pval_filt = pval < pval_thresh;
    sesh(j).ntrans_filt = get_num_trans(PSAbool) >= ntrans_thresh;
end

%% Step 2: Classify cells / map cells
[ good_map, become_silent, new_cells, ambig_silent, ambig_new ] = classify_cells( ...
    MD1, MD2, silent_thresh, map_name_append{j}, varargin{:} ); %#ok<ASGLU>
% Note that no silent/new cells are included if overlap_thresh = nan
valid_map_ind = ~isnan(good_map) & good_map ~= 0;
nnew = length(new_cells); % number of good new cells

%% Step 3: Create paired PVs consisting of all cells (active each + become 
% silent mixed at top of array, new cells at bottom of array)
[nBinsx, nBinsy, n1] = size(sesh(1).PV);

% Neurons mapped between each session and all cells going silent in session
% 2 are mixed at the top, new cells in session 2 at the bottom
PV1 = cat(3, sesh(1).PV, zeros(nBinsx, nBinsy, length(new_cells)));
temp = register_PV(sesh(2).PV, good_map, true);
PV2 = cat(3, temp, sesh(2).PV(:,:,new_cells));

%% Step 4: Filter out cells based on silent/new, or not meeting pval or ntrans
% thresholds

% Silent cell filter
silent_include = true(n1+nnew,1);
silent_include(ambig_silent) = false; 
% Note that ambiguous new cells are already excluded above in step 3

pval_filt1 = false(n1+nnew,1); ntrans_filt1 = false(n1+nnew,1);
pval_filt1(1:n1) = sesh(1).pval_filt';
ntrans_filt1(1:n1) = sesh(1).ntrans_filt';

% Map session 2 pval and ntrans filts to session 1
pval_filt2 = false(length(sesh(1).pval_filt),1); ntrans_filt2 = pval_filt2;
pval_filt2(valid_map_ind) = sesh(2).pval_filt(good_map(valid_map_ind));
pval_filt_new = sesh(2).pval_filt(new_cells)';
pval_filt2 = cat(1, pval_filt2, pval_filt_new); % Add in new cells to end of array

ntrans_filt2(valid_map_ind) = sesh(2).ntrans_filt(good_map(valid_map_ind))';
ntrans_filt_new = sesh(2).ntrans_filt(new_cells);
ntrans_filt2 = cat(1, ntrans_filt2, ntrans_filt_new); % Add in new cells to end of array

% Combine them all - must pass pval & ntrans filt in at least one session &
% silent cell filter
final_filter = ((pval_filt1 & ntrans_filt1) | ...
    (pval_filt2 & ntrans_filt2)) & silent_include;

%% Calculate correlations using only cells that pass the filter
PV1_use = PV1(:,:,final_filter);
PV2_use = PV2(:,:,final_filter);

corrs = corr3d(PV1_use, PV2_use);

% corrs = nan(nBinsx,nBinsy);
% for j = 1:nBinsx
%     for k = 1:nBinsy
%         PVa = squeeze(PV1_use(j,k,:));
%         PVb = squeeze(PV2_use(j,k,:));
%         corrs(j,k) = corr(PVa,PVb,'type','Spearman','rows','complete');
%     end
% end

end

