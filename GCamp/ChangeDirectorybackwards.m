function [ animal_id, sess_date, sess_num] = ChangeDirectorybackwards( working_folder )
% Pulls the animal name, session date, and session number from your MD
% file.

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

load MasterDirectory.mat;

cd(CurrDir);

NumEntries = length(MD);

% Fix issue where stupid MATLAB uigetfile puts a "\" at the end of the path
if strcmpi(fileparts(working_folder),working_folder(1:end-1))
    working_folder = fileparts(working_folder);
end

for i = 1:NumEntries

    if strcmpi(working_folder,MD(i).Location)
        animal_id = MD(i).Animal;
        sess_date = MD(i).Date;
        sess_num = MD(i).Session;
        return;
    end
end

display('Directory not found');

end
