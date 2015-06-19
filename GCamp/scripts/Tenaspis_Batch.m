function [  ] = Tenaspis_Batch( infile,session_struct,no_movie_process )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% keyboard
for j = 1: length(session_struct)
   Tenaspis_NK2(infile, 'animal_id',session_struct(j).Animal,'sess_date',...
       session_struct(j).Date,'sess_num',session_struct(j).Session,...
       'no_movie_process', no_movie_process);
end

end

