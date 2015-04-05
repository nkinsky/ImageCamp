function [files_out, sizes_out] = get_all_files_win(directory, file_filter, files_in, sizes_in)
% This function takes a directory and gets all the files in it.  My first
% attempt to write a recursive function.

% Need a file type filter, otherwise it's going to blow up the computer
% running it.

% NEED TO COMMENT BELOW FOR IT TO MAKE SENSE IN THE FUTURE

% file_filter = '*.h5';

if nargin == 1 || nargin == 2
   files_in = cell(0);
   sizes_in = [];
   if nargin == 1
      file_filter = '*.*'; 
   end
else
end

% Get all directory info
dir_struct = dir(directory);
files_filt_struct = dir([directory '\' file_filter]); % Get only specific file types
curr_dir = cd;

% Find all directories
names_all = arrayfun(@(a) a.name,dir_struct,'UniformOutput',0);
sizes_all = arrayfun(@(a) a.bytes,dir_struct);
files_filtered = arrayfun(@(a) a.name,files_filt_struct,'UniformOutput',0);
sizes_filtered = arrayfun(@(a) a.bytes,files_filt_struct);

% Get rid of '.' and '..' directories
index_use = ~(strcmp('..',names_all) + strcmp('.',names_all));
file_index = arrayfun(@(a) ~a.isdir,dir_struct);
dir_index = arrayfun(@(a) a.isdir,dir_struct);

names_file = names_all(index_use & file_index);
sizes_file = sizes_all(index_use & file_index);

full_file_names = cellfun(@(a) [directory '\' a], names_file,...
    'UniformOutput',0);
full_files_filtered = cellfun(@(a) [directory '\' a], files_filtered,...
    'UniformOutput',0);
names_dir = names_all(index_use & dir_index);

num_dirs = size(names_dir,1);

if num_dirs > 0
    for j = 1:num_dirs
        [temp_files, temp_sizes] = get_all_files_win([directory '\' names_dir{j}],...
            file_filter, files_in, sizes_in);
        files_in = temp_files;
        sizes_in = temp_sizes;
        
    end
else
    
end

if isempty(file_filter)
    files_in = [files_in ; full_file_names];
    sizes_in = [sizes_in; sizes_file];
else
    files_in = [files_in ; full_files_filtered];
    sizes_in = [sizes_in; sizes_filtered];
end

files_out = files_in;
sizes_out = sizes_in;




end