function [ id1, id2 ] = get_lin_bounds(val, array )
% [ id1, id2 ] = get_lin_bounds(val, array )
%   finds indices of points that bound val in monotonic inccreasing/
%   decreasing array (e.g. val = 3.3, array = 1:5 -> id1 = 3, id2 = 4).

id1 = find(val >= array,1,'last');
id2 = find(val <= array,1,'first');


end

