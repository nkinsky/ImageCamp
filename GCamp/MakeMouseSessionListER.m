function [MD, session_ref] = MakeMouseSessionListER(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

i = 1;
MD(i).Animal = '3pf3';
MD(i).Date = '09_??_2017';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF3 2 Shocks\Pre-exposure';
end
MD(i).Notes = [];

i = i+1; % 
MD(i).Animal = '3pf3';
MD(i).Date = '09_28_2017';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF3 2 Shocks\Exposure';
end
MD(i).Notes = [];

i = i+1; % 
MD(i).Animal = '3pf2';
MD(i).Date = '';
MD(i).Session = 1;
MD(i).Env = '';
MD(i).Room = '';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
end
MD(i).Notes = [];

%% Compile session_ref
animal_sesh_list = arrayfun(@(a) a.Animal,MD,'UniformOutput',0);
unique_animals = unique(animal_sesh_list); % Get animal names

first_sesh = cellfun(@(a) find(strcmpi(a,animal_sesh_list),1,'first'),...
    unique_animals);
last_sesh = cellfun(@(a) find(strcmpi(a,animal_sesh_list),1,'last'),...
    unique_animals);

session_ref = cat(1,unique_animals, num2cell(first_sesh), num2cell(last_sesh));
session_ref = cat(1,{'Animal','1st sesh','last sesh'},session_ref');


%%
save MasterDirectory.mat MD;

cd(CurrDir);

end

%% Sub-function to