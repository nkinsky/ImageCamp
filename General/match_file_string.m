% Get all filenames containing match_string

match_string = 'filter'; % Here is the term you are looking for

[filename pathname] = uigetfile('*.*','Pick a folder:','MultiSelect','On');

temp = find(cellfun(@(a) ~isempty(regexp(a,'filter')),filename)); % Get indices of filenames with match_string contained in them

num_files = size(temp,2);

for j = 1:num_files
    matched_files{j} = [pathname filename{temp(j)}];
end

