function [  ] = Tenaspis_Batch( infile,session_struct,no_movie_process )
% Tenaspis_Batch(infile, session_struct, no_movie_process)
% Runs Tenaspis in batch mode
% 
% INPUTS
%   infile: name of imaging movie to process.  Must be the same for all
%   sessions
%   session_struct: structure with 3 fields (.Animal, .Date, and .Session)
%   that matches structure MD in MakeMouseSessionList
%   no_movie_process: 0 if you are processing the ICmovie that has been
%   spatially smoothed only, 1 if you already have the temporal 1st
%   derivative movie in the directory

% keyboard
for j = 1: length(session_struct)
   Tenaspis(infile, 'animal_id',session_struct(j).Animal,'sess_date',...
       session_struct(j).Date,'sess_num',session_struct(j).Session,...
       'no_movie_process', no_movie_process);
end

end

