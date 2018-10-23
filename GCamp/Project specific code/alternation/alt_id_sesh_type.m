function [loop_bool, forced_bool, free_bool] = alt_id_sesh_type(sessions)
% [loop_bool, forced_bool, free_bool] = alt_id_sesh_type(sessions)
%  Identify control sessions (looping and/or forced alternation sessions)
%  in sessions data structure

loop_bool = arrayfun(@(a) ~isempty(regexpi(a.Notes,'looping')), sessions);
forced_bool = arrayfun(@(a) ~isempty(regexpi(a.Notes,'forced')), sessions);
free_bool = ~loop_bool & ~forced_bool;

end

