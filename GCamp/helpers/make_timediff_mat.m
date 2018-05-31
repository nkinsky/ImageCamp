function [ timediff_mat ] = make_timediff_mat( sessions )
% timediff_mat = make_timediff_mat( sessions )
%   Gets time difference (in days) between all sessions in 'sessions'

num_sessions = length(sessions);
timediff_mat = nan(num_sessions);
for j = 1:(num_sessions - 1)
    sesh1 = sessions(j);
    for k = (j+1):num_sessions
        sesh2 = sessions(k);
        timediff_mat(j,k) = get_time_bw_sessions(sesh1, sesh2);
    end
end

end

