function [ new_file_cell, db_fullpath ] = find_missing_files_f()
%find_missing_files_f Compare all the files in a given directory to files
%listed in a given db file, and ouput files that are not included in the db
%file.
%
% OUTPUTS
% new_file_cell:    a cell array that contains all the filepaths to files
% that are not included in the db file
% db_fullpath:      full pathname to the db file chosen

start_dir = cd; % save starting directory 
[db_file, db_path] = uigetfile('*.mat','Select Database file to which you want to add files: ');
db_fullpath = [db_path db_file];
if db_file == 0
    testgroup = [];
    curr_dir = uigetdir('','Select Folder from which you want to add files to db file: ');
else
    testgroup = importdata(db_fullpath);
    curr_dir = uigetdir(db_path,'Select Parent folder for file comparison: ');
end

cd(curr_dir);
f_temp = dir;
n = 1;
for i = 1:size(f_temp,1) % Pull out only folders, get rid of any files

    if f_temp(i).isdir == 1
        folders_temp{1,n} = f_temp(i).name;
        n = n + 1;
        
    else
    end
end

% Get rid of '.' and '..'
x = arrayfun(@(a) a.isdir == 1 && ~strcmp(a.name,'.') && ~strcmp(a.name,'..'),f_temp);

folders = folders_temp(x);
% % Get rid of whitespace at end (Not sure this is necessary if we use DIR to
% % get folder names...
% folders = cell(1,size(folders_temp,1));
% for j = 1:size(folders_temp,1)
%     if isempty(regexp(folders_temp{j,1},'\s','once'))
%         folders{j} = folders_temp{j,1};
%     elseif ~isempty(regexp(folders_temp{j,:},'\s','once'))
%         folders{j} = folders_temp{j,1}(1:min(regexp(folders_temp{j,1},'\s'))-1);
%     end
% end

% Get the names of the all the files currently referenced in the database
% file
existing_file_list = [];
for j = 1:size(testgroup,2)
    ex_size = size(existing_file_list,2);
    curr_an_sess_size = size(testgroup(j).session,2);
    for k = 1:curr_an_sess_size
    existing_file_list{ex_size+k} = testgroup(j).session(k).DVTfilename;
    end
    
end

% Get names of all the DVT files located in this directory
n = 1;
folders_cell = cell(1,size(folders,2));
for j = 1:size(folders,2)
   clear temp
   folders_cell{j} = [curr_dir '\' folders{j}]; 
   
   cd(folders_cell{j});
   temp = ls('*.dvt'); % get all DVT files
   for k = 1: size(temp,1)
       % Get rid of whitespace at end
       if isempty(regexp(temp(k,:),'\s','once'))
           file_use{n} = temp(k,:);
       elseif ~isempty(regexp(temp(k,:),'\s','once'))
           file_use{n} = temp(k,1:min(regexp(temp(k,:),'\s'))-1); 
       end
       
       files_cell{n} = [folders_cell{j} '\' file_use{n}];
       
       % Identify files that are missing from the database
       new_file(n) = sum(arrayfun(@(a) strcmp(files_cell{n},a),existing_file_list));
       n = n + 1;
   end
   new_file_index = find(new_file == 0); 
end

n = 1;
for j = 1: length(new_file_index)
       new_file_cell{j} = files_cell{new_file_index(j)};   
end

cd(start_dir)

end

