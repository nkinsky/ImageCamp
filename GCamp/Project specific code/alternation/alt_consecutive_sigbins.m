function [min_num_cons, max_num_cons, total_sig_bins, curvesum] = ...
    alt_consecutive_sigbins(sigcurve, deltacurve)
% [min_num_cons, max_num_cons, total_sig_bins, curvesum] = ...
%   alt_consecutive_sigbins(sigcurve, deltacurve)
%
%   Gets minimum and maximum number of significant bins that are
%   consecutive along the track for a given splitter neuron. sigcurve =
%   boolean of significantly trajectory-modulated bins along the stem.
%
%   curvesum = Cumulative sum of sig bins in a given direction.  0 = equal in each
   % direction, 3 = 3 more left than right, etc.

epochs = NP_FindSupraThresholdEpochs(sigcurve == 1, eps, false);

cons_bins = diff(epochs,1,2) + 1;
min_num_cons = min(cons_bins);
max_num_cons = max(cons_bins);
total_sig_bins = sum(sigcurve);

%% Do l v r bias analysis if deltacurve is specified
if nargin == 2
    curvesign = zeros(size(deltacurve));
    curvesign(deltacurve < 0) = -1;
    curvesign(deltacurve > 0) = 1;
    
    % Cumulative sum of sig bins in a given direction.  0 = equal in each
    % direction, 3 = 3 more left than right, etc.
    
    curvesum = sum(curvesign.*sigcurve);
else
    curvesum = nan;
end

end
