function [ dirstr ] = ChangeDirectory_NK(MD_in,change_dir_flag)
% dirstr = ChangeDirectory_NK(MD_in)
%
% Lazy man's ChangeDirectory - takes only the appropriate session from MD as
% input.  
%
% change_dir_flag: 1 (default if left blank) - change to this directory in
% MATLAB workspace, 0 - just spit out dirstr withoug changing directory

if ~exist('change_dir_flag','var')
    change_dir_flag = 1; % default value
end

dirstr = ChangeDirectory(MD_in.Animal,MD_in.Date,MD_in.Session,change_dir_flag);

end

