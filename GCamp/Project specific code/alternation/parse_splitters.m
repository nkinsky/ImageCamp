function [ rely_val, delta_max, sigbool, stem_bool ] = parse_splitters( dir_use, sigthresh )
% [ rely_val, delta_max, sigcbool ] = parse_splitters( dir_use, sigthresh )
%   Pull out "splittiness" metrics: reliability value (1-p), and delta_max
%   (maximum diff b/w L/R tuning curves) for all splitters, and boolean
%   identifying which are significant and which aren't. sigthresh = # bins
%   of delta tuning curve above chance (default = 3);

if nargin < 3
    sigthresh = 3;
end

load(fullfile(dir_use,'sigSplitters'),'pvalue','sigcurve','deltacurve');
nneurons_sesh = length(pvalue); % get number of neurons in sesh_use
sigbool = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters

% Identify cells active on the stem
stem_bool = ~cellfun(@isempty, pvalue); % in sesh(j) numbering

% Assign reliability and delta_max values to the appropriate neurons
rely_val = nan(nneurons_sesh,1); delta_max = nan(nneurons_sesh,1);
rely_val(stem_bool) = cellfun(@(a) 1 - min(a), pvalue(stem_bool));
delta_max(stem_bool) = cellfun(@(a) max(abs(a)),deltacurve(stem_bool));

end

