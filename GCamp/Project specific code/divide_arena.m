function [grid_binary, grid_sum] = divide_arena( TMap, num_grids, num_grids2 )
% arena_map_binary = divide_arena( TMap, num_grids )
%   Takes the grid from TMap and divides it up into a num_grids x num_grids
%   Alternatively, if the syntax ..., num_grids, num_grids2) is used, you
%   will get num_grids x num_grids2.  Spits out a cell grid_binary
%   where each entry is the same size as TMap with ones in the appropriate
%   grid.  grid_sum is the sum of values in each of the grids.
%   If no num_grids is specified, it will default to 3.  Uses MATLAB syntax
%   for rows/columns (e.g. num_grids = 3 and num_grids2 = 4 gives you a 3
%   row x 4 column grid)

% Pull out number of grids in each direction
if nargin == 1
    num_grids = 3;
    num_grids2 = 3;
elseif nargin == 2
    num_grids2 = num_grids;
end

% Get number of bins in TMap
num_row = size(TMap,1);
num_col = size(TMap,2);

% Pre-allocate
base_grid = zeros(size(TMap));
grid_binary = cell(num_grids,num_grids2);
grid_sum = nan(num_grids,num_grids2);
for j = 1:num_grids
   for k = 1:num_grids2
       % Delegate appropriate row and column indices
       row_start = 1+round(num_row*(j-1)/num_grids);
       row_end = round(num_row*j/num_grids);
       col_start = 1+round(num_col*(k-1)/num_grids2);
       col_end = round(num_col*k/num_grids2);
       
       temp = base_grid;
       temp(row_start:row_end, col_start:col_end) = 1;
       grid_binary{j,k} = logical(temp);
       grid_sum(j,k) = nanmean(TMap(logical(temp(:))));
   end
end

end

