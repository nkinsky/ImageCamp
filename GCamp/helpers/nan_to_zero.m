function [cell_or_array_out] = nan_to_zero(cell_or_array_in)
% [cell_or_array_out] = nan_to_zero(cell_or_array_in)
%   Converts cell (or single array) with nans in each array to zeros

cell_or_array_out = cell_or_array_in;
if iscell(cell_or_array_in)
    ncells = length(cell_or_array_in(:));
    for j = 1:ncells
        cell_or_array_out{j}(isnan(cell_or_array_in{j})) = 0;
    end
else
    cell_or_array_out(isnan(cell_or_array_in)) = 0;
end
end

