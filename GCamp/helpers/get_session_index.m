function [ sesh_index ] = get_session_index( session, ref_struct )
% sesh_index = get_session_index( session, ref_struct )
%   Gets index of session in ref_struct

animal_id = session.Animal;
sess_date = session.Date;
sess_num = session.Session;

%Concatenate fields for searching. 
animals = {ref_struct.Animal};
dates = {ref_struct.Date};
sessions = [ref_struct.Session];

%Find MD entry that matches the input animal, date, AND session.
sesh_index = find(strcmp(animals,animal_id) & strcmp(dates,sess_date) ...
    & sessions == sess_num);


end

