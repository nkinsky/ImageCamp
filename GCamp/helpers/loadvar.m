function [ ] = loadvar( MD, filename, varargin)
% all_out = loadvar( MD, filename, varargin)
%   Loads variables in filename located in directory for session indicated
%   in MD.  varargin specifies variables to load.  if left blank, loads all
%   variables in filename to output variable.

dirstr = ChangeDirectory(MD.Animal, MD.Date, MD.Session, 0);
file_load = fullfile(dirstr,filename);

if isempty(varargin)
    temp = load(file_load);
    matObj = matfile(file_load);
    details = whos(matObj);
    arrayfun(@(a) assignin('base', a.name, temp.(a.name)), details)
elseif ~isempty(varargin)
    
    for j = 1:length(varargin)
        temp = load(file_load, varargin{j});
        assignin('base', varargin{j},  temp.(varargin{j}));
    end
end


end

