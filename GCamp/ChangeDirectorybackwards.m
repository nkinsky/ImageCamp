function [ animal_id, sess_date, sess_num] = ChangeDirectorybackwards( working_folder )
% Pulls the animal name, session date, and session number from your MD
% file.

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

load MasterDirectory.mat;

cd(CurrDir);

load(fullfile(MasterDirectory,'MasterDirectory.mat'));

% Fix issue where stupid MATLAB uigetfile puts a "\" at the end of the path
if strcmpi(fileparts(working_folder),working_folder(1:end-1))
    working_folder = fileparts(working_folder);
end

%Get index of MD that matches working_folder. 
try 
    MDind = find(strcmpi(working_folder,{MD.Location}));
    animal_id = MD(MDind).Animal; 
    sess_date = MD(MDind).Date;
    sess_num = MD(MDind).Session; 
catch
    error('Directory not found!');
end

end
