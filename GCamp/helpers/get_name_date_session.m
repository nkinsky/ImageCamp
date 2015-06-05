function [ mouse_name, session_date, session_num ] = get_name_date_session( folder_path )
% [ mouse_name, session_data, session_num ] = get_name_date_session( folder_path )
%   Gets mouse name, session date, and session number from folder path.
%   All values are strings

% Formats for pulling files and sessions
date_format = '(?<month>\d+)_(?<day>\d+)_(?<year>\d+)';
session_format = '(?<sesh_number>\d?) -';
mouse_format = '\\(?<name>G\w+\d+)';

% Get date.
temp = regexp(folder_path,date_format,'names');
temp_start = regexp(folder_path,date_format); % Get start index of date folder
session_date = [temp.month '_' temp.day '_' temp.year]

% Get session number
temp_folder =folder_path(temp_start + 9:end); % Grab everything after date
temp2 = regexp(temp_folder,session_format,'names');
if isempty(temp2)
    % Assign session number as 1 if there are no subfolders within
    % the date folder
    session_num = num2str(1);
else
    session_num = temp2.sesh_number
end
%Get mouse name.
temp3 = regexp(folder_path,mouse_format,'names');

mouse_name = temp3(1).name;

end

