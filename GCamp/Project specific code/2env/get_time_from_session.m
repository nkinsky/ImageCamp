function [ time_out ] = get_time_from_session( index_use, time_index )
% time_out  = get_time_from_session( index_use, time_index )
%  Takes indices in index_use (column 1 = arena, column 2 = 1st session, columb 3 =
%  2nd session) and compares it to the time_index array (same as index_use
%  but with column 4 = time in days between sessions)

time_logical = [];
time_out = nan(size(index_use,1),1);
for j = 1: size(index_use,1)
   time_logical = index_use(j,1) == time_index(:,1) & ...
       index_use(j,2) == time_index(:,2) & index_use(j,3) == time_index(:,3);
   time_out(j) = time_index(time_logical,4);
end

end

