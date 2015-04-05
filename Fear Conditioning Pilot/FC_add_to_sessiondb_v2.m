% Add Files to session struct file...

% clear all
close all

% Import session database to add files to and get missing files
[ new_file_cell, db_fullpath ] = find_missing_files_f();
start_dir = cd; % save start directory

% Archive existing database file
if sum(db_fullpath) == 0
    testgroup = [];
else
    testgroup = importdata(db_fullpath);
    savepath = [db_fullpath(1:end-4) '_archive_' datestr(now,30) '.mat'];
    save(savepath,'testgroup');
end

filename = cellfun(@(a) a(max(regexp(a,'\'))+1:end),new_file_cell,'UniformOutput',0);

% Get animal name, context name, and session name for each file
animal_names = cellfun(@(a) a(1:3), filename,'UniformOutput',0);
break_indices = cellfun(@(a) regexp(a,'_'),filename,'UniformOutput',...
    0); % Get indices for underscores
lengths = cellfun(@(a) diff(a),break_indices,'UniformOutput',0); % Get lengths of text between underscores
context_names = cellfun(@(a,b,c) a(b(1)+1:b(1)+c(1)-1),filename,...
    break_indices,lengths,'UniformOutput',0);
session_names = cellfun(@(a,b,c) a(b(2)+1:b(2)+c(2)-1),filename,...
    break_indices,lengths,'UniformOutput',0);
tod = cellfun(@(a) a(end-7:end-4),filename,'UniformOutput',0);
all_info = cellfun(@(a,b,c) [a '_' b '_' c],animal_names,...
    context_names,session_names,'UniformOutput',0);

% Pull out only unique info from the above arrays
animal_unique = unique(animal_names); num_animals = size(animal_unique,2);
contexts_unique = unique(context_names); num_contexts = size(contexts_unique,2);
sessions_unique = unique(session_names); num_sessions = size(sessions_unique,2);

% Create database variable if not there already
if ~exist('testgroup')
    testgroup(1).name = [];
else
end

% Check to see if session_databse structure has the name field, if not, set
% up properly
if ~isfield(testgroup,'name') || ~isfield(testgroup,'session')
        testgroup(num_animals).name = [];
        for j = 1:num_animals
            testgroup(j).name = animal_unique{j};
            testgroup(j).session(1).session_name = 'Blank';
            testgroup(j).session(1).DVTfilename = 'Blank';
            testgroup(j).session(1).context = 'Blank';
            
        end
else
end

% Cycle through animals to update appropriate info
% Check for name already existing
% Check for session & context already existing

for j = 1:size(animal_names,2)
    % Get info out of the session_database structure
    db_animals = arrayfun(@(a) a.name,testgroup,'UniformOutput',0);
    
    match = 0; % stays 0 if the first file is not already in the database file, 1 if it is already there.
    db_animal_index = find(strcmp(db_animals,animal_names(j)));
    num_sessions = size(testgroup(db_animal_index).session,2);
    % Adjust number of sessions if this is the first time running the
    % database file.
    if isempty(db_animal_index)
        num_sessions = 0;
        match = 0;
        db_animal_index = size(db_animals,2) + 1;
        testgroup(db_animal_index).name = animal_names{j};
    elseif num_sessions == 1 && strcmp(testgroup(db_animal_index).session(1).session_name,'Blank')
        num_sessions = 0;
        match = 0;
    else
        % Check if this session has already been entered
        for k = 1:num_sessions
            all_info_db = [testgroup(db_animal_index).name '_' ...
                testgroup(db_animal_index).session(k).context '_' ...
                testgroup(db_animal_index).session(k).session_name];
            if strcmp(all_info_db,all_info(j))
                match = 1;
            else
            end
        end
    end
    
   if match == 1
   elseif match == 0
       testgroup(db_animal_index).session(num_sessions + 1).session_name = session_names{j};
       testgroup(db_animal_index).session(num_sessions + 1).date = ...
           [filename{j}(4:5) '-' filename{j}(6:7) '-' filename{j}(8:11)];
       testgroup(db_animal_index).session(num_sessions + 1).time = tod{j};
       testgroup(db_animal_index).session(num_sessions + 1).context = context_names{j};
       testgroup(db_animal_index).session(num_sessions + 1).DVTfilename = ...
           new_file_cell{j};
   end
   
end

if sum(db_fullpath) == 0
    display('Save updated database file')
%     save_folder = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\Fear Conditioning Pilot\Database Files\';
%     db_savename = input('Please enter a filename for this database file: ','s');
%     db_fullpath = [save_folder db_savename];
%     save(db_fullpath,'testgroup')
    uisave('testgroup')
elseif sum(db_fullpath) ~= 0
    save(db_fullpath,'testgroup')
end
cd(start_dir);

