function [ day_num, CPP_log ] = NO_get_day(session )
% day_num = NO_get_day(Animal )
%   Gets day number of an experiment (1,2,3) as well as CPP status (CPP_log
%   = true or false).  Note that this comes from the folder names for the
%   posfile for each mouse, so these must be correct and contain the phrase
%   "day#" or "Day#" for this to work.  Same for CPP - "CPP" must be in the
%   posfile name.
%
%   Inputs:
%       session - a single session data structure, e.g. Mouse1(3).
%   

day_num = session.posfile(regexpi(session.posfile,'day','end')+1);

CPP_log = ~isempty(regexpi(session.posfile,'cpp'));


end

