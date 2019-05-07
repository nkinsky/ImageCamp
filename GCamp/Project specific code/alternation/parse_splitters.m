function [ rely_val, delta_max, sigbool, stem_bool, dmax_norm, nactive_stem ,...
    dint_norm, curve_corr, rely_mean] = parse_splitters( dir_use, sigthresh, cnoise )
% [ rely_val, delta_max, sigbool, stem_bool, dmax_norm, nactive_stem ] = ...
%       parse_splitters( dir_use, sigthresh )
%
%   INPUTS: 
%       dir_use: working directory with sigSplitters file
%
%       sigthresh: # bins of delta tuning curve above chance (default = 3)
%
%       cnoise: true = inject a low level of random noise into each tuning
%       curve so that splitters firing no transients on one type of trial
%       don't spit out an NaN.  default = false.
%
%   OUTPUTS:
%   "Splittiness" metrics: 
%       rely_val: max(1-p) for entire curve
%
%   delta_max: (maximum diff b/w L/R tuning curves) for all splitters
%
%   sigbool: boolean identifying which are significant
%
%   stem_bool: boolean identifying which neurons are active on stem 
%
%   dmax_norm: delta_max divided by the sum of the maximum of L and R
%   tuning curves. 1 = fires only on one trial type, 0 = no diff.
%
%   dint_norm_mean: the integral of abs(delta_max) divided by the sum of the L
%   and R tuning curves. 1 = fires only on one trial type, 0 = no diff.
%
%   curve_corr: correlation between L and R tuning curves.
%
%   rely_mean: mean(1-p) for entire curve

if nargin < 3
    cnoise = false;
    if nargin < 2
        sigthresh = 3;
    end
end

load(fullfile(dir_use,'sigSplitters'),'pvalue','sigcurve','deltacurve', ...
    'tuningcurves');
load(fullfile(dir_use,'splitters.mat'), 'cellResps')
nactive_stem = cellfun(@(a) sum(sum(a,2) > 0), cellResps);
nneurons_sesh = length(pvalue); % get number of neurons in sesh_use
sigbool = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters

% Add noise to tuning curves if specified
if cnoise
    tuningcurves = cellfun(@(a) a + 0.01*abs(randn(size(a))), ...
        tuningcurves, 'UniformOutput',false);
end

% Identify cells active on the stem
stem_bool = ~cellfun(@isempty, pvalue); % in sesh(j) numbering

% Assigns splitter metric vlaues to the appropriate neurons
rely_val = nan(nneurons_sesh, 1); 
rely_mean = nan(nneurons_sesh, 1); 
delta_max = nan(nneurons_sesh, 1);
dmax_norm = nan(nneurons_sesh, 1);
dint_norm = nan(nneurons_sesh, 1);
curve_corr = nan(nneurons_sesh, 1);
rely_val(stem_bool) = cellfun(@(a) 1 - min(a), pvalue(stem_bool));
rely_mean(stem_bool) = cellfun(@(a) mean(1 - a), pvalue(stem_bool));
delta_max(stem_bool) = cellfun(@(a) max(abs(a)),deltacurve(stem_bool));
dmax_norm(stem_bool) = delta_max(stem_bool)./cellfun(@(a) sum(max(a,[],2)),...
    tuningcurves(stem_bool));
dint_norm(stem_bool) = cellfun(@(a,b) sum(abs(a))./sum(b(:)), ...
    deltacurve(stem_bool), tuningcurves(stem_bool));
curve_corr(stem_bool) = cellfun(@(a) corr(a(1,:)', a(2,:)'), ...
    tuningcurves(stem_bool));
    
% Legacy code using std to normalize the dmax curves (maybe it should have
% been named dmax_z?
% dmax_norm(stem_bool) = delta_max(stem_bool)./cellfun(@(a) sum(std(a(:))),...
%     tuningcurves(stem_bool));

end

