function [ rely_val, delta_max, sigbool, stem_bool, dmax_norm ] = parse_splitters( ...
    dir_use, sigthresh )
% [ rely_val, delta_max, sigcbool ] = parse_splitters( dir_use, sigthresh )
%
%   INPUTS: 
%       dir_use: working directory with sigSplitters file
%
%       sigthresh = # bins of delta tuning curve above chance (default = 3)
%
%   OUTPUTS:
%   "Splittiness" metrics: 
%       rely_val: (1-p)
%
%   delta_max: (maximum diff b/w L/R tuning curves) for all splitters
%
%   sigbool: boolean identifying which are significant
%
%   stem_bool: boolean identifying which neurons are active on stem 
%
%   dmax_norm: delta_max divided by the sum of the maximum of L and R
%   tuning curves. 1 = fires only on one trial type, 0 = no diff.

if nargin < 3
    sigthresh = 3;
end

load(fullfile(dir_use,'sigSplitters'),'pvalue','sigcurve','deltacurve', ...
    'tuningcurves');
nneurons_sesh = length(pvalue); % get number of neurons in sesh_use
sigbool = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters

% Identify cells active on the stem
stem_bool = ~cellfun(@isempty, pvalue); % in sesh(j) numbering

% Assign reliability and delta_max values to the appropriate neurons
rely_val = nan(nneurons_sesh, 1); 
delta_max = nan(nneurons_sesh, 1);
dmax_norm = nan(nneurons_sesh, 1);
rely_val(stem_bool) = cellfun(@(a) 1 - min(a), pvalue(stem_bool));
delta_max(stem_bool) = cellfun(@(a) max(abs(a)),deltacurve(stem_bool));
dmax_norm(stem_bool) = delta_max(stem_bool)./cellfun(@(a) sum(max(a,[],2)),...
    tuningcurves(stem_bool));
% dmax_norm(stem_bool) = delta_max(stem_bool)./cellfun(@(a) sum(std(a(:))),...
%     tuningcurves(stem_bool));

end

