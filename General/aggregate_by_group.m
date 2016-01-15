function [ group_unique, output_cell ] = aggregate_by_group( input_array, group )
% output_array = aggregate_by_group( input_array, group )
%   Takes two arrays of the same length and aggregates each value into the
%   corresponding group.

group_unique = unique(group); % Get unique values in group

output_cell = cell(1,length(group_unique));
for j = 1:length(group_unique)
   output_cell{j} = input_array(group_unique(j) == group);
end


end

