function [ sigmat, relymat, deltamaxmat, neuronID ] = get_splitter_metrics( ...
    pvalue, sigcurve, deltacurve, sigthresh )
%   [ sigmat, relymat, deltamaxmat, neuronID ] = get_splitter_metrics( ...
%       pvalue, sigcurve, deltacurve, sigthresh )
% 
%   Organizes metrics on splitter reliability into a matrix including only
%   significant splitting neurons (# significant bins > sigthresh). STILL
%   IN CONSTRUCTION

%% Above is taken from track_splitters and has not been debugged yet
nneurons_sesh = length(pvalue); % get number of neurons in sesh_use
valid_bool = ~isnan(map_use) & map_use ~= 0; % Get boolean for validly mapped cells
sigsplitter_bool = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters

% Identify cells active on the stem
stem_bool = ~cellfun(@isempty, pvalue); % in sesh(j) numbering
valid_stem_bool = false(num_neurons,1);
valid_stem_bool(valid_bool) = stem_bool(map_use(valid_bool)); % in batch_map numbering

% Assign reliability and delta_max values to the appropriate neurons
rely_val = nan(nneurons_sesh,1); delta_max = nan(nneurons_sesh,1);
rely_val(stem_bool) = cellfun(@(a) 1 - min(a), pvalue(stem_bool));
delta_max(stem_bool) = cellfun(@(a) max(abs(a)),deltacurve(stem_bool));
%     delta_val = cell2mat(deltacurve(stem_bool));

% Dump all the values into the matrices
sigmat(valid_stem_bool) = sigsplitter_bool(map_use(valid_stem_bool)); % Map sig
relymat(valid_stem_bool) = rely_val(map_use(valid_stem_bool)); % Map sig
deltamaxmat(valid_stem_bool) = delta_max(map_use(valid_stem_bool)); % Map sig

end

