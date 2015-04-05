function [ ind ] = get_nearest_indices( row, col, n_rows, n_cols, m )
% [ ind ] = get_nearest_indices( row, col, n_rows, n_cols, dist )
% This function takes a row and column in a given array and finds the
% indices to the m adjacent values in the array.  For example, if m = 1,
% you will get the indices of the 8 spots surrounding the row,col value.

row_mat = repmat([1:n_rows]',1,n_cols);
col_mat = repmat(1:n_cols,n_rows,1);

row_pos = []; col_pos = [];

find_mat = zeros(n_rows,n_cols);
for j = 0:m
    for k = 0:m
        temp = (abs(row_mat-row) == j & abs(col_mat-col) == k);
        find_mat = find_mat + temp;

    end
end


ind = find(find_mat);

end

