function [dirstr] = ChangeDirectory_NK(animal_id,sess_date,sess_num)
% [dirstr] = ChangeDirectory(animal_id,sess_date,sess_num)

if(~exist('sess_num'))
    sess_num = 1;
end

CurrDir = pwd;

MasterDirectory = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice';
cd(MasterDirectory);

load MasterDirectory.mat;

cd(CurrDir);

NumEntries = length(MD);

for i = 1:NumEntries

    if (strcmp(MD(i).Date,sess_date) & (MD(i).Session == sess_num) & strcmp(MD(i).Animal,animal_id))
        cd(MD(i).Location);
        dirstr = (MD(i).Location);
        return;
    end
end

display('Directory not found');