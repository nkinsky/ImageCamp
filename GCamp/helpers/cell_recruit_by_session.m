function [ new_cells ] = cell_recruit_by_session( batch_map)
% new_cells  = cell_recruit_by_session( batch_map)
%   Gets the number of new cells recruited each session.  Input =
%   batch_session_map.map.  Output corresponds to sessions in
%   batch_session_map.session
num_sessions = size(batch_map,2)-1;
last_cell_index = [0 nan(1,num_sessions)];
for j = 1:num_sessions
    last_cell_index(j+1) = find(batch_map(:,j+1),1,'last'); % Get index to last new cell for each day.
end

new_cells = diff(last_cell_index);

end

