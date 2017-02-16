function [ session_index ] = match_session( session_ref, session_in )
% session_index = match_session( session_ref, session_in )
%   Spits out the index for the session matching session_in in session_ref.
%   Nan means that session_in is NOT contained in session_ref

num_sessions = length(session_ref);

[animal_array{1:num_sessions}] = deal(session_ref.Animal);
[date_array{1:num_sessions}] = deal(session_ref.Date);
session_array = arrayfun(@(a) a.Session, session_ref);

session_index = find(strcmpi(session_in.Animal, animal_array) & ...
    strcmpi(session_in.Date, date_array) & session_in.Session == session_array);

if isempty(session_index)
    session_index = nan;
end



end

