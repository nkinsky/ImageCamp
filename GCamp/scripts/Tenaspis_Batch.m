function [  ] = Tenaspis_Batch( infile,session_struct,no_movie_process,varargin )
% Tenaspis_Batch(infile, session_struct, no_movie_process,varargin)
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
%   varargins: see MakeTransients

% keyboard

%% Get varargins
for j = 1:length(varargin)
   if strcmpi(varargin{j},'min_trans_length')
       min_trans_length = varargin{j+1};
   end
end

%% First, check to make sure all the appropriate files are there so that 
% you don't get an error halfway through the run

if no_movie_process == 0
    movie_name = infile;
elseif no_movie_process == 1
    movie_name = 'D1Movie.h5';
end

for j = 1:length(session_struct)
    ChangeDirectory_NK(session_struct(j));
    proj_exist(j) = exist('ICmovie_min_proj.tif','file') == 2;
    movie_exist(j) = exist(movie_name,'file') == 2;
end

if sum(movie_exist & proj_exist) == length(movie_exist) % proceed if all is ok
    disp('All required files are in the working directories - proceeding!')
else
    movie_missing = find(movie_exist == 0);
    proj_missing = find(proj_exist == 0);
    for k = 1:length(movie_missing)
        disp([movie_name ' missing for ' session_struct(movie_missing(k)).Date])
    end
    
    for k = 1:length(proj_missing)
       disp(['ICmovie_min_proj.tif missing for ' session_struct(proj_missing(k)).Date ...
           ' session #' num2str(session_struct(proj_missing(k)).Session)]) 
    end
    return
end
%% Do the batch run
for j = 1: length(session_struct)
    if ~exist('min_trans_length','var')
        Tenaspis(infile, 'animal_id',session_struct(j).Animal,'sess_date',...
            session_struct(j).Date,'sess_num',session_struct(j).Session,...
            'no_movie_process', no_movie_process);
    else
        Tenaspis(infile, 'animal_id',session_struct(j).Animal,'sess_date',...
            session_struct(j).Date,'sess_num',session_struct(j).Session,...
            'no_movie_process', no_movie_process,'min_trans_length',min_trans_length);
    end
end

end

