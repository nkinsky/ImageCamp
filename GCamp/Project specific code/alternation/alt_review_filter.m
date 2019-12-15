function [exclude_bool] = alt_review_filter(session, half_life_thresh, ...
    lateral_alpha) 
% DONT USE - instead implement code below in alt_parse_cell_category OR
% parse_splitters - keeping because it's a useful reference
% [exclude_bool] = alt_review_filter(session, half_life_thresh, splitter_filt)
%  Spits out a boolean of cells to exclude (based on review comments) if:
%       a) their transient half-life exceeds the specified threshold, and/or if
%
%       b)  they are not considered to be splitters after
%           running the emma wood analysis to account for lateral position 
%           modulated neurons (plateral > lateral_alpha)

% Don't do the filter if only one argument is entered
if nargin == 1
    half_life_thresh = 100;
    lateral_alpha = 1;
end

% Exclude those with abnormally long transients
[half_all_mean, ~, ~, ~] = get_session_trace_stats(session, ...
    'use_saved_data', true);
exclude_trace = half_all_mean > half_life_thresh; 

% Now exclude any neurons modulated by lateral position...
[p, ~, ~, ~] = alt_wood_analysis(session, 'use_saved_data', true);
exclude_lateral = p(:,5) > lateral_alpha;



end

