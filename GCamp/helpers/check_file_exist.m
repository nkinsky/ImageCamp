function [ exist_bool] = check_file_exist(sesh, varargin)
% [ pos_bool, pos_align_bool] = check_pos_exist(sesh, file1, file2, ...)
%   spits out a boolean indicating if pos.mat and pos_align.mat exist for
%   each session in sesh

nsesh = length(sesh);
nfiles = length(varargin);
exist_bool = false(nfiles,nsesh);

for j = 1:nsesh
    dir_use = ChangeDirectory_NK(sesh(j),0);
    for k = 1:nfiles
        if isempty(regexpi(varargin{k},'*.'))
            filename = varargin{k};
            file_check = fullfile(dir_use, filename);
            exist_bool(k,j) = exist(file_check,'file');
        elseif ~isempty(regexpi(varargin{k},'*.'))
            filename = ls(fullfile(dir_use, varargin{k}));
            if isempty(filename)
                exist_bool(k,j) = false;
            else
                file_check = fullfile(dir_use, filename);
                exist_bool(k,j) = exist(file_check,'file');
            end
        end
        
    end
end
    


end

