function [ exist_bool ] = exist_file( MD, filename, subfolder )
% exist_bool  = exist_file( MD, filename, subfolder )
%   Checks for filename in working directory specified in all sessions
%   specified in MD, or in optional subfolder in working directory.

if nargin < 3
    subfolder = '';
end

num_sessions = length(MD);
exist_bool = false(1,num_sessions);
for j = 1:num_sessions
    dirstr = ChangeDirectory(MD(j).Animal, MD(j).Date, MD(j).Session,0);
    exist_bool(j) = exist(fullfile(dirstr,subfolder,filename),'file');
end


end

