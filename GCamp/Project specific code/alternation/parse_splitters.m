function [ rely_val, delta_max, sigbool, stem_bool, dmax_norm, nactive_stem ,...
    dint_norm, curve_corr, rely_mean, sigbin_prop] = parse_splitters( dir_use, ...
    sigthresh, cnoise )
% [ rely_val, delta_max, sigbool, stem_bool, dmax_norm, nactive_stem ,...
%    dint_norm, curve_corr, rely_mean, sigbin_prop] = parse_splitters( dir_use, ...
%    sigthresh, cnoise )
%
%   Gets splittiness metrics for all cells active on the stem
%.
%   Set global variables WOOD_FILT to true and HALF_LIFE_THRESH to desired
%   cutoff to filter out any cells not meeting the Emma Wood et al. (2000)
%   splitter criteria (i.e. cells modulated by lateral position NOT
%   trajectory) or with trace half-life decay times greater than the
%   threshold you specify...
%
%
%   INPUTS: 
%       dir_use: working directory with sigSplitters file. Could also input
%       session_db file (dir_use = session_db.Location)
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
%   dint_norm: the integral of abs(delta_max) divided by the sum of the L
%   and R tuning curves. 1 = fires only on one trial type, 0 = no diff.
%
%   curve_corr: correlation between L and R tuning curves.
%
%   rely_mean: mean(1-p) for entire curve
%
%   nactive_stem: # trials with activity on the stem
%
%   sigbin_prop: proportion of stem bins with significant splitting...

if nargin < 3
    cnoise = false;
    if nargin < 2
        sigthresh = 3;
    end
end

if isstruct(dir_use)
    session = dir_use;
    dir_use = session.Location;
end
%% Load in global variables for cell filtering
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

% Exclude those with abnormally long transients
[half_all_mean, ~, ~, ~] = get_session_trace_stats(session, ...
    'use_saved_data', true);
exclude_trace = half_all_mean > half_thresh; 

% Now exclude any neurons modulated by lateral position...
[p, ~, ~, ~] = alt_wood_analysis(session, 'use_saved_data', true);
exclude_lateral = (p(:,1) >= lateral_alpha) & (p(:,3) >= lateral_alpha); 


%% Now run the actual function
load(fullfile(dir_use,'sigSplitters'),'pvalue','sigcurve','deltacurve', ...
    'tuningcurves');
load(fullfile(dir_use,'splitters.mat'), 'cellResps')
nactive_stem = cellfun(@(a) sum(sum(a,2) > 0), cellResps);
nneurons_sesh = length(pvalue); % get number of neurons in sesh_use
sigbooltemp = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters
% exclude any neurons that don't meet Wood criteria or have abnormally long
% transients
sigbool = sigbooltemp & ~exclude_lateral & ~exclude_trace;

% Add noise to tuning curves if specified
if cnoise
    tuningcurves = cellfun(@(a) a + 0.01*abs(randn(size(a))), ...
        tuningcurves, 'UniformOutput',false);
end

% Identify cells active on the stem
stem_bool = ~cellfun(@isempty, pvalue); % in sesh(j) numbering
% Exclude any cells with abnormally long transients and cells that are
% modulated by lateral position (these are weird cells that look like
% splitters but aren't really)
stem_bool = stem_bool & ~(sigbooltemp & exclude_lateral) & ~exclude_trace;

% Assigns splitter metric vlaues to the appropriate neurons
rely_val = nan(nneurons_sesh, 1); 
rely_mean = nan(nneurons_sesh, 1); 
delta_max = nan(nneurons_sesh, 1);
dmax_norm = nan(nneurons_sesh, 1);
dint_norm = nan(nneurons_sesh, 1);
curve_corr = nan(nneurons_sesh, 1);
sigbin_prop = nan(nneurons_sesh, 1);
rely_val(stem_bool) = cellfun(@(a) 1 - min(a), pvalue(stem_bool));
rely_mean(stem_bool) = cellfun(@(a) mean(1 - a), pvalue(stem_bool));
delta_max(stem_bool) = cellfun(@(a) max(abs(a)),deltacurve(stem_bool));
dmax_norm(stem_bool) = delta_max(stem_bool)./cellfun(@(a) sum(max(a,[],2)),...
    tuningcurves(stem_bool));
dint_norm(stem_bool) = cellfun(@(a,b) sum(abs(a))./sum(b(:)), ...
    deltacurve(stem_bool), tuningcurves(stem_bool));
curve_corr(stem_bool) = cellfun(@(a) corr(a(1,:)', a(2,:)'), ...
    tuningcurves(stem_bool));
sigbin_prop(stem_bool) = cellfun(@sum, sigcurve(stem_bool))...
    /max(cellfun(@length, sigcurve(stem_bool)));
    
% Legacy code using std to normalize the dmax curves (maybe it should have
% been named dmax_z?
% dmax_norm(stem_bool) = delta_max(stem_bool)./cellfun(@(a) sum(std(a(:))),...
%     tuningcurves(stem_bool));

end

