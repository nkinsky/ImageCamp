function [ good_bool ] = bw_bool( array, bw_values, inc_flag )
% good_bool = bw_bool( array, bw_values, inc_flag )
%   Calculates all the values or array that fall between column 1 and 
%   column 2 in bw_values. Default behavior: < and > for comparisons. Set
%   inc_flag to true to change to <= and >=.
%
%   e.g. bw_values = [-1 3; 20 22] calculates all the values in array that
%   fall between -1 and 3 OR between 20 and 22. 
if nargin < 3
    inc_flag = false;
end

good_bool = false(size(array));
nconds = size(bw_values,1);
if ~inc_flag
    for j = 1:nconds
        bool_temp = (array > bw_values(j,1)) & (array < bw_values(j,2));
        good_bool = good_bool | bool_temp;
    end
elseif inc_flag
    for j = 1:nconds
        bool_temp = (array >= bw_values(j,1)) & (array <= bw_values(j,2));
        good_bool = good_bool | bool_temp;
    end
end


end

