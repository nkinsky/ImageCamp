function [ conn_hw_mean, conn_hw_sem, conn_hw_all, conn_nonhw_mean, conn_nonhw_sem, conn_nonhw_all ] = ...
    twoenv_get_hallway_PFincrease( grid_sum_comb, hw_grid_row, hw_grid_col, arena_type, before_after )
% [ conn_hw_mean, conn_hw_sem, conn_hw_all, conn_nonhw_mean, conn_nonhw_sem, conn_nonhw_all ] = ...
% twoenv_get_hallway_PFincrease( grid_sum_comb, hw_grid_row, hw_grid_col, arena_type, before_after)
%
%   Breaks apart increases in place field density near the hallway versus
%   the rest of the grids.  IMPORTANT: this ONLY works for an input that is
%   equal to mean(grid_sum_all,6), where grid_sum_all is a (num_arenas x 
%   num_sessions x num_sessions x num_grids x num_grids x num_animals)
%   vector with of size (2 x 8 x 8 x anything x anything x anything)
%
%   INPUTS:
%
%   grid_sum_comb, a num_arenas x num_sessions x num_sessions x num_grids 
%   x num_grids array with the mean PFincrease values for all mice.
%
%   hw_grid_row, hw_grid_col: location of the grid near the hallway
%
%   arena_type: 1 = square, 2 = circle
%
%   before_after (optional): 0(default) = get connected sessions -
%   unconnected sessions, 1 = get session 7 minus session 4, 2 = get
%   sessions 7-8 minus sessions 1-4

if nargin < 5
    before_after = 0;
end

if before_after == 0
    ind_use1 = sub2ind(size(grid_sum_comb),arena_type*ones(8,1),[1:4 1:4]',...
        [5 5 5 5 6 6 6 6]', hw_grid_row*ones(8,1), hw_grid_col*ones(8,1)); % get indices to 
    temp1 = grid_sum_comb(ind_use1); % all values for grid by hallway in session 5 and 6 versus sessions 1-4
    ind_use2 = sub2ind(size(grid_sum_comb),arena_type*ones(4,1),[5:6 5:6]',...
        [7 7 8 8]', hw_grid_row*ones(4,1), hw_grid_col*ones(4,1));
    temp2 = grid_sum_comb(ind_use2);
    conn_hallwaygrid_PFdensincrease = [temp1; -temp2];
    conn_hw_ind = [ind_use1; ind_use2];
elseif before_after == 1
     temp1 = squeeze(grid_sum_comb(arena_type,4,7,hw_grid_row,hw_grid_col));
     conn_hallwaygrid_PFdensincrease = temp1(:);
elseif before_after == 2
    conn_hallwaygrid_PFdensincrease = grid_sum_comb(sub2ind(size(grid_sum_comb),arena_type*ones(8,1),[1:4 1:4]',...
        [7 7 7 7 8 8 8 8]', hw_grid_row*ones(8,1), hw_grid_col*ones(8,1)));
end

conn_hw_mean = mean(conn_hallwaygrid_PFdensincrease);
conn_hw_sem = std(conn_hallwaygrid_PFdensincrease)/...
    sqrt(length(conn_hallwaygrid_PFdensincrease));
conn_hw_all = conn_hallwaygrid_PFdensincrease;

if before_after == 0
    temp3 = squeeze(grid_sum_comb(arena_type,1:4,5:6,:,:)); % All values for sessions 5 and 6 versus sessions 1-4
    temp4 = squeeze(grid_sum_comb(arena_type,5:6,7:8,:,:)); % All values for sessions 5 and 6 versus sessions 7-8
    conn_allgrid_PFdensincrease = [temp3(:); -temp4(:)];
elseif before_after == 1
    temp3 = squeeze(grid_sum_comb(arena_type,4,7,:,:));
    conn_allgrid_PFdensincrease = temp3(:);
elseif before_after == 2
    temp3 = squeeze(grid_sum_comb(arena_type,1:4,7:8,:,:));
    conn_allgrid_PFdensincrease = temp3(:);
end
% Now, exclude all the values in the grid near the hallway from the ALL
% values - this is a HACK, need to fix to grab indices, not final values.
% Probably works though.
exclude_logical = false(size(conn_allgrid_PFdensincrease));
for j = 1:length(conn_hallwaygrid_PFdensincrease)
    exclude_logical = exclude_logical | (conn_hallwaygrid_PFdensincrease(j) == ...
        conn_allgrid_PFdensincrease);
end
conn_allgrid_PFdensincrease = conn_allgrid_PFdensincrease(~exclude_logical);
conn_nonhw_mean = mean(conn_allgrid_PFdensincrease);
conn_nonhw_sem = std(conn_allgrid_PFdensincrease)/...
    sqrt(length(conn_allgrid_PFdensincrease));
conn_nonhw_all = conn_allgrid_PFdensincrease;

end

