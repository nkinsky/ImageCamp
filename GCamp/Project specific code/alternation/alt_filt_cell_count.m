function [exclude_ratio, exclude_number, exclude_lateral, exclude_trace, exclude_both] = alt_filt_cell_count(session)
%[exclude_lateral, exclude_trace, exclude_both] = alt_filt_cell_count(session)
%   Gets booleans of cells to exclude based on lateral position modulation,
%   excessively long decay times, or both

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

% First ID any cells to exclude with extra long transients
[half_all_mean, ~, ~, ~] = get_session_trace_stats(session, ...
    'use_saved_data', true);
exclude_trace = half_all_mean > half_thresh; 

% ID stem cells that are modulated by lateral position. These are ones that
% have significant trajectory modulation after accounting for speed/lateral
% position.
p = alt_wood_analysis(session,'use_saved_data',true);
exclude_lateral = (p(:,1) >= lateral_alpha) & (p(:,3) >= lateral_alpha);

exclude_both = exclude_lateral | exclude_trace;
exclude_ratio = sum(exclude_both)/length(exclude_both);
exclude_number = sum(exclude_both);

end

