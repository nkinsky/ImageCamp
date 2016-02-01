function [ out_logical ] = seshcmp(session1, session2)
% returns a 1 if the sessions are the same, 0 if they are different based
% on Animal, Date, and Session info

same_mouse = strcmp(session1.Animal,session2.Animal);
same_date = strcmp(session1.Date,session2.Date);
same_seshnum = session1.Session == session2.Session;

out_logical = same_mouse & same_date & same_seshnum;

end

