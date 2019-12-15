function [session_match] = compare_sessions(session1, session2)
% session_match = compare_session(session1, session2)
%  Compares animal name, date, and session # in session1 and session2 to
%  see if they match. Spits out boolean true if they do, false if they
%  don't

session_match = strcmpi(session1.Animal, session2.Animal) & ...
    strcmpi(session1.Date, session2.Date) & ...
    session1.Session == session2.Session;

end

