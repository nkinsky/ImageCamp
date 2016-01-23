function [array_var ] = make_cell_array( cell_var, replace_empty_with, replace_nan_with)
% array_var = make_cell_array( cell_var)
% 
% Takes an input cell array ('cell_var') with empty values, numerical values, 
% and nan values, and converts it to a normal array with whatever numerical 
% value you wish to replace emptys and nans with (variables 'replace_empty_with'
% and 'replace_nan_with') in lieu of empty arrays.

array_var = zeros(size(cell_var)); % Pre-allocate
for j = 1:size(cell_var,1)
    for k = 1:size(cell_var,2)
        if ~isempty(cell_var{j,k}) && ~isnan(cell_var{j,k})
            array_var(j,k) = cell_var{j,k};
        elseif ~isempty(cell_var{j,k}) && isnan(cell_var{j,k})
            array_var(j,k) = replace_nan_with;
        elseif isempty(cell_var{j,k})
            array_var(j,k) = replace_empty_with;
        else
            error(['Error at entry row = ' num2str(j) ' column = ' ...
                num2str(k)])
        end
    end
end

end

