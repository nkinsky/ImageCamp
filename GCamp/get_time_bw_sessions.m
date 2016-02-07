function [days_bw ] = get_time_bw_sessions( session1, session2 )
% days_bw = get_time_bw_sessions( session1, session2 )
%   Gets time in days between two sessions.
session = session1;
session(2) = session2;

date_use = nan(1,2);
for j = 1:2
    % Get datenum for each date
    date_use(j) = datenum(str2double(session(j).Date(7:10)), ...
        str2double(session(j).Date(1:2)),str2double(session(j).Date(4:5)));
end

% Get days between by subtracting
days_bw = abs(diff(date_use));

end

