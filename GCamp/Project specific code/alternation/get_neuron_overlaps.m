function [overlap_ratio] = get_neuron_overlaps(sesh1, sesh2, ...
    overlap_thresh, name_append)
% [overlap_ratio] = get_neuron_overlaps(sesh1, sesh2, overlap_thresh, name_append)
%   Gets ratio of overlapping nuerons from sesh1 to sesh2

if nargin < 4
    name_append = '';
    if nargin < 3
        overlap_thresh = 1;
    end
end

%%
[good_map, become_silent, new_cells] = classify_cells(sesh1, sesh2, ...
    overlap_thresh, name_append);

ntotal = length(good_map) + length(become_silent) + length(new_cells);
overlap_ratio = length(good_map)/ntotal;

end

