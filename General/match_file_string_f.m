function [ matched_files ] = match_file_string_f( match_string )
%UNTITLED3 Get all filenames containing match_string
%   match_string:   the string you want to match in selected filed

[filename, pathname] = uigetfile('*.*','Pick a folder:','MultiSelect','On');

temp = find(cellfun(@(a) ~isempty(regexp(a,match_string,'once')),filename)); % Get indices of filenames with match_string contained in them

num_files = size(temp,2);

matched_files = cell(1,num_files);
for j = 1:num_files
    matched_files{j} = [pathname filename{temp(j)}];
end

end

