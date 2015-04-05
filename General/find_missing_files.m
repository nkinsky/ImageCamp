% Find files not included in session_database

clear all
close all

testgroup = importdata('C:\Users\kinsky.AD\Documents\Lab\Imaging\Fear Conditioning Pilot\Database Files\Controlgroup_db.mat');


% curr_dir = cd;
curr_dir = uigetdir('','Select Parent folder for file comparison: ');
cd(curr_dir);
folders_temp = ls;
folders_temp = folders_temp(3:end,:); % Get rid of . and .. 
% Get rid of whitespace at end
for j = 1:size(folders_temp,1)
    if isempty(regexp(folders_temp(j,:),'\s'))
        folders{j} = folders_temp(j,:);
    elseif ~isempty(regexp(folders_temp(j,:),'\s'))
        folders{j} = folders_temp(j,1:min(regexp(folders_temp(j,:),'\s'))-1);
    end
end

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
for j = 1:size(folders,2)
   clear temp
   folders_cell{j} = [curr_dir '\' folders{j}]; 
   
   cd(folders_cell{j});
   temp = ls('*.dvt'); % get all DVT files
   for k = 1: size(temp,1)
       % Get rid of whitespace at end
       if isempty(regexp(temp(k,:),'\s'))
           file_use{n} = temp(k,:);
       elseif ~isempty(regexp(temp(k,:),'\s'))
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

