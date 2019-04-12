function [MD, session_ref] = MakeMouseSessionListER(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types
%define userstr as the computer being used ie: 'eichentron' or 'mouseimage'

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

%% 2 Shock cohort pilots
i = 1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\Imaging\Marble_3\20180205_1_exposure';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 'pre-open_1';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\Imaging\Marble_3\20180205_squareopen';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\Imaging\Marble_3\20180206_2_exposure\20180206_2_exposure';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 'pre-open_2';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\Imaging\Marble_3\20180206_squareopen';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180207_open_.25shock\20180207_3_shock';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 'shock-open';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180207_open_.25shock';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180207_open_4hr\20180207_4_4hr';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = '4hr-open';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180207_open_4hr';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180208_open_5_reexposure\5_reexposure';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 're-open_1';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180208_open_5_reexposure\open field';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180209_open_6_reexposure\6_reexposure';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_3';
MD(i).Date = 're-open_2';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\Imaging\Marble_3\20180209_open_6_reexposure\open field';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;



%% 1 DREADDS cohort
i = i+1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_15_18_1_exposure\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 2.23;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_16_18_2_exposure\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 16.12;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_3_shock\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_4_4hr\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 39.78;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_18_18_5_postexposure\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 50.11;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_19_18_6_postexposure_2\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 51.75;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'DREADDS_VHPC_2';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_15_18_1_exposure\DREADDS_VHPC_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 1.47;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_2';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_16_18_2_exposure\DREADDS_VHPC_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 6.60;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_2';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_3_shock\DREADDS_VHPC_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_2';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_4_4hr\DREADDS_VHPC_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 40.06;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_2';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_18_18_5_postexposure\DREADDS_VHPC_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 32.59;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_2';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_19_18_6_postexposure_2\DREADDS_VHPC_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 23.16;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_3';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_15_18_1_exposure\DREADDS_VHPC_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 0;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_3';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_16_18_2A_exposure\DREADDS_VHPC_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 6.02;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_3';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_3_shock\DREADDS_VHPC_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_3';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_4_4hr\DREADDS_VHPC_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 20.01;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_3';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_18_18_5_postexposure\DREADDS_VHPC_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 24.23;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_3';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_19_18_6_postexposure_2\DREADDS_VHPC_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 32.73;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;



i = i+1;
MD(i).Animal = 'DREADDS_VHPC_4';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_15_18_1_exposure\DREADDS_VHPC_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 1.02;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_4';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_16_18_2A_exposure\DREADDS_VHPC_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 4.948;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_4';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_3_shock\DREADDS_VHPC_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_4';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_17_18_4_4hr\DREADDS_VHPC_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 38.37;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_4';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_18_18_5_postexposure\DREADDS_VHPC_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 30.01;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'DREADDS_VHPC_4';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_19_18_6_postexposure_2\DREADDS_VHPC_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 38.87;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% 2 Shock cohort pilots
i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_1_exposure\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 11.66;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_19_17_2_exposure\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 4.10;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_shock\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_4hr\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 18.17;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_4_rexposure\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 31.56;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_22_17_5_rexposure\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 13.57;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_1_exposure\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 4.68;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_19_17_2_exposure\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 6.50;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_shock\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_4hr\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 44.08;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_4_rexposure\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 44.78;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_22_17_5_rexposure\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 16.79;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_1_exposure\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 6.55;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_19_17_2_exposure\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 9.5;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_shock\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_4hr\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 12.73;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_4_rexposure\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 19.59;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_22_17_5_rexposure\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 10.56;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_1_exposure\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 6.72;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\12_18_17_1_shock\12_19_17_2_exposure\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 2.80;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_shock\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
MD(i).Shockdur = 2; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_20_17_3_4hr\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 12.93;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_4_rexposure\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 18.88;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_22_17_5_rexposure\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 9.04;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

%% 1 Shock cohort pilots
i = i + 1; 
MD(i).Animal = 'pf10';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '1';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF10\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 9.3;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf10';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '1';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_28_17\PF10\pre_exposure2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 27.4;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf10';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '1';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.5mA protocol\2017-11-27_1_shock\11_29_2017\PF10\shock';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 54.02;
MD(i).Shockdur = 15; 
MD(i).Shocklevel = .05;

i = i+1;
MD(i).Animal = 'pf10';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '1';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.5mA protocol\2017-11-27_1_shock\11_29_2017\PF10\4hr';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 77.95;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf10';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '1';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.5mA protocol\2017-11-27_1_shock\11_30_17_1_rexposure\1_PF_10';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 81.90;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf10';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '1';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.5mA protocol\2017-11-27_1_shock\12_1_17_2_rexposure\1_PF10';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 88.87;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf11';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '2';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_28_17\PF11\pre_exposure2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 7.17;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf11';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '2';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_28_17\PF11\pre_exposure2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 22.1;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf11';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '2';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_29_17\PF10\shock';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 20.98;
MD(i).Shockdur = 15; 
MD(i).Shocklevel = .05;

i = i+1;
MD(i).Animal = 'pf11';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '2';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF11\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 61.33;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf11';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '2';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF11\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 51.39;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf11';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '2';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF11\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 61.62;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf12';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF12\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 4.3;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf12';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_28_17\PF12\pre_exposure2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 17.6;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf12';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_29_17\PF10\shock';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 8.48;
MD(i).Shockdur = 15; 
MD(i).Shocklevel = .05;

i = i+1; % 
MD(i).Animal = 'pf12';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF12\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 45.45;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf12';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF12\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 47.71;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf12';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF12\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 70.26;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf13';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF13\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 4.5;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf13';
MD(i).Date = 'pre-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_28_17\PF13\pre_exposure2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 8.7;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'pf13';
MD(i).Date = 'shock';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_29_17\PF10\shock';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 16.96;
MD(i).Shockdur = 15;
MD(i).Shocklevel = .05;

i = i+1; % 
MD(i).Animal = 'pf13';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF13\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 33.79;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf13';
MD(i).Date = 're-exposure1';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF13\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 29.23;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

i = i+1; % 
MD(i).Animal = 'pf13';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.5mA protocol\2017-11-27_1_shock\11_27_17_1_shock\PF13\pre_exposure1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = 44.53;
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN;

%% first round of pilots
i = i+1; % 
MD(i).Animal = '3pf3';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF3 2 Shocks';
end
MD(i).Notes = '2 Shocks';
MD(i).Freezing = 21.68;

i = i+1;
MD(i).Animal = '3pf3';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF3 2 Shocks\Pre exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '3pf3';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF3 2 Shocks\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 21.68;

i = i+1; % 
MD(i).Animal = '3pf2';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = '';
MD(i).Room = '';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF2 2 Shocks';
end
MD(i).Notes = '2 Shocks';
MD(i).Freezing = 41.99;

i = i+1; % 
MD(i).Animal = '3pf2';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = '';
MD(i).Room = '';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF2 2 Shocks\Pre Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '3pf2';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = '';
MD(i).Room = '';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF2 2 Shocks\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 41.99;

i = i+1; % 
MD(i).Animal = '3pf1';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF1 2 Shocks';
end
MD(i).Notes = '2 Shocks';

i = i+1; % 
MD(i).Animal = '3pf1';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF1 2 Shocks\Pre Exposure';
end
MD(i).Notes = 0;
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '3pf1';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF1 2 Shocks\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 31.23;

i = i+1; % 
MD(i).Animal = '2pf9';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF9 2 Shocks';
end
MD(i).Notes = '2 Shocks';
MD(i).Freezing = 30.27;

i = i+1; % 
MD(i).Animal = '2pf9';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF9 2 Shocks\Pre Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '2pf9';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF9 2 Shocks\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 30.27;

i = i+1; % 
MD(i).Animal = '2pf8';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF8 2 Shocks';
end
MD(i).Notes = '2 Shocks';
MD(i).Freezing = 4.14;

i = i+1; % 
MD(i).Animal = '2pf8';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF8 2 Shocks\Pre Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '2pf8';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF8 2 Shocks\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 4.14;

i = i+1; % 
MD(i).Animal = '2pf6';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF6 2 Shocks';
end
MD(i).Notes = '2 Shocks';
MD(i).Freezing = 41.90;

i = i+1; % 
MD(i).Animal = '2pf6';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF6 2 Shocks\Pre Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '2pf6';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF6 2 Shocks\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 41.90;

i = i+1; % 
MD(i).Animal = '2pf7';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF7 1 Shock';
end
MD(i).Notes = '1 Shock';
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '2pf7';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF7 1 Shock\Pre Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '2pf7';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\2PF7 1 Shock\Exposure';
end
MD(i).Notes = [];
MD(i).Freezing = 13.85;

i = i+1; % 
MD(i).Animal = '3pf4';
MD(i).Date = 'base';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF4 1 Shock';
end
MD(i).Notes = '1 Shock';
MD(i).Freezing = [];

i = i+1; % 
MD(i).Animal = '3pf4';
MD(i).Date = 'pre-exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF4 1 Shock\Pre Exposure';
end
MD(i).Notes = '1 Shock';
MD(i).Freezing = 0;

i = i+1; % 
MD(i).Animal = '3pf4';
MD(i).Date = 'exposure';
MD(i).Session = 1;
MD(i).Env = 'Shock box #?';
MD(i).Room = 'CILSE 71??';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Nat\3PF4 1 Shock\Exposure';
end
MD(i).Notes = '1 Shock';
MD(i).Freezing = 12.02;

%% Marble7
i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_19_2018';
MD(i).Session = 1;
MD(i).Env = 'Open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180319_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_19_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180319_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_20_2018';
MD(i).Session = 1;
MD(i).Env = 'Open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180320_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_20_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180320_2_fcbox\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180321_1_openfield\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180321_2_fcbox\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180321_3_openfield\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180321_4_openfield\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_22_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180322_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_22_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180322_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_23_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180323_1_openfield\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_23_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180323_2_fcbox\Imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_28_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180328_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_28_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_7_final\20180328_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;
%% Marble 6
i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_17_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180417_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_17_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180417_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_18_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180418_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_18_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180418_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_19_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180419_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_19_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180419_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_19_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180419_3_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_19_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180419_4_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_20_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180420_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_20_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180420_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_21_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180421_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_21_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180421_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_26_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180426_1_openfield\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble6';
MD(i).Date = '04_26_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_6_final\20180426_2_fcbox\imaging';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 11

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_28_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180528_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_28_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180528_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_29_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180529_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_29_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180529_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_30_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180530_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_30_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180530_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_30_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180530_3_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_30_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180530_4_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_31_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180531_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '05_31_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180531_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '06_01_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180601_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '06_01_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180601_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '06_06_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180606_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble11';
MD(i).Date = '06_06_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\marble_11_final\20180606_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;
%% Marble 12 Some have been run through tenaspis but not finished
i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_13_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180513_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_13_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180513_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_14_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180514_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_14_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180514_2_fc';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_15_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180515_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_15_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180515_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_15_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180515_3_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_15_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180515_4_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_16_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180516_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_16_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180516_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_17_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180517_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_17_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180517_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_22_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180522_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble12';
MD(i).Date = '05_22_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'I:\Imaging\Marble_12_final_inside\Marble_12_final\20180522_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;
%% Marble 17
i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_17_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180917_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_17_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180917_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_18_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180918_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_18_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180918_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_19_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180919_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_19_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180919_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_19_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180919_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_19_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180919_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_20_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180920_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_20_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180920_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_21_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180921_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_21_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180921_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_26_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180926_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble17';
MD(i).Date = '09_26_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_17\Marble_17_final\20180926_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 14
i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_14_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180814_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_14_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180814_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_15_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180815_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_15_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180815_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_16_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180816_1_openfield';
end
MD(i).Notes = 'Control' ;
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_16_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180816_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_16_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180816_3_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_16_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180816_4_fcbox';
end
MD(i).Notes = 'Control poor motion correction';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_17_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180817_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_17_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180817_2_fcbox';
end
MD(i).Notes = 'Control poor motion correction';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_18_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180818_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;
%%%% SECOND SESSION ON 08-18-2018 DOES NOT HAVE A GOOD MIN PROJECTION
%%i = i+1;
%%MD(i).Animal = 'Marble14';
%%MD(i).Date = '08_18_2018';
%%MD(i).Session = 2;
%%MD(i).Env = 'shock';
%%MD(i).Room = 'CILSE 721 F';
%%if (strcmp(userstr,'Eichentron'))
%%MD(i).Location = '';
%%elseif strcmp(userstr, 'mouseimage')
%%MD(i).Location =  'M:\Marble_14\Marble_14_final\20180818_1_openfield';
%%end
%%MD(i).Notes = 'Control';
%%MD(i).Freezing = NaN;
%%MD(i).Shockdur = NaN; 
%%MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_23_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180823_1_openfield';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble14';
MD(i).Date = '08_23_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'M:\Marble_14\Marble_14_final\20180823_2_fcbox';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 19
i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_24_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180924_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_24_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180924_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_25_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180925_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_25_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180925_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_26_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180926_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_26_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180926_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_26_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180926_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_26_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180926_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_27_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180927_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_27_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180927_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_28_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180928_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '09_28_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
MD(i).Location =  'D:\Marble_19\Marble_19_Final\20180928_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '10_03_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20181003_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble19';
MD(i).Date = '10_03_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_19\Marble_19_Final\20181003_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 20
i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_08_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181008_from_scratch\20181008_1_fromscratch';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_08_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181008_from_scratch\20181008_2_fromscratch';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_09_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181009_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_09_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181009_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_10_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181010_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_10_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181010_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_10_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181010_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_10_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181010_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_11_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181011_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_11_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181011_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_12_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181012_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_12_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181012_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_17_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181017_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble20';
MD(i).Date = '10_17_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_20\Marble_20_final\20181017_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 18

% i = i+1;
% MD(i).Animal = 'Marble18';
% MD(i).Date = '09_17_2018';
% MD(i).Session = 1;
% MD(i).Env = 'open';
% MD(i).Room = 'CILSE 721 F';
% if (strcmp(userstr,'Eichentron'))
%     MD(i).Location = '';
% elseif strcmp(userstr, 'mouseimage')
%     MD(i).Location =  'D:\Marble_18\Marble_18_final\20180917';
% end
% MD(i).Notes = 'Control';
% MD(i).Freezing = NaN;
% MD(i).Shockdur = NaN; 
% MD(i).Shocklevel = NaN;
% 
% i = i+1;
% MD(i).Animal = 'Marble18';
% MD(i).Date = '09_17_2018';
% MD(i).Session = 2;
% MD(i).Env = 'shock';
% MD(i).Room = 'CILSE 721 F';
% if (strcmp(userstr,'Eichentron'))
%     MD(i).Location = '';
% elseif strcmp(userstr, 'mouseimage')
%     MD(i).Location =  'D:\Marble_18\Marble_18_final\20180917_2';
% end
% MD(i).Notes = 'Control';
% MD(i).Freezing = NaN;
% MD(i).Shockdur = NaN; 
% MD(i).Shocklevel = NaN;
% 
% 
% i = i+1;
% MD(i).Animal = 'Marble18';
% MD(i).Date = '09_18_2018';
% MD(i).Session = 1;
% MD(i).Env = 'open';
% MD(i).Room = 'CILSE 721 F';
% if (strcmp(userstr,'Eichentron'))
%     MD(i).Location = '';
% elseif strcmp(userstr, 'mouseimage')
%     MD(i).Location =  'D:\Marble_18\Marble_18_final\20180918_1';
% end
% MD(i).Notes = 'Control';
% MD(i).Freezing = NaN;
% MD(i).Shockdur = NaN; 
% MD(i).Shocklevel = NaN;
% 
% i = i+1;
% MD(i).Animal = 'Marble18';
% MD(i).Date = '09_18_2018';
% MD(i).Session = 2;
% MD(i).Env = 'shock';
% MD(i).Room = 'CILSE 721 F';
% if (strcmp(userstr,'Eichentron'))
%     MD(i).Location = '';
% elseif strcmp(userstr, 'mouseimage')
%     MD(i).Location =  'D:\Marble_18\Marble_18_final\20180918_2';
% end
% MD(i).Notes = 'Control';
% MD(i).Freezing = NaN;
% MD(i).Shockdur = NaN; 
% MD(i).Shocklevel = NaN;
% 
% i = i+1;
% MD(i).Animal = 'Marble18';
% MD(i).Date = '09_19_2018';
% MD(i).Session = 1;
% MD(i).Env = 'open';
% MD(i).Room = 'CILSE 721 F';
% if (strcmp(userstr,'Eichentron'))
%     MD(i).Location = '';
% elseif strcmp(userstr, 'mouseimage')
%     MD(i).Location =  'D:\Marble_18\Marble_18_final\20180919_1';
% end
% MD(i).Notes = 'Control';
% MD(i).Freezing = NaN;
% MD(i).Shockdur = NaN; 
% MD(i).Shocklevel = NaN;
% 
% i = i+1;
% MD(i).Animal = 'Marble18';
% MD(i).Date = '09_19_2018';
% MD(i).Session = 2;
% MD(i).Env = 'shock';
% MD(i).Room = 'CILSE 721 F';
% if (strcmp(userstr,'Eichentron'))
%     MD(i).Location = '';
% elseif strcmp(userstr, 'mouseimage')
%     MD(i).Location =  'D:\Marble_18\Marble_18_final\20180919_2';
% end
% MD(i).Notes = 'Control';
% MD(i).Freezing = NaN;
% MD(i).Shockdur = NaN; 
% MD(i).Shocklevel = NaN;

%% Marble_24
i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_26_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181126_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_26_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181126_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_27_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181127_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_27_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181127_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_28_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181128_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_28_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181128_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_28_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181128_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_29_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181129_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_29_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181129_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_30_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181130_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_30_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181130_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_05_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181205_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble24';
MD(i).Date = '11_05_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_24\Marble_24_final\20181205_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


%% Marble 25

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_03_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181203_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_03_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181203_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_04_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181204_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_04_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181204_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_05_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181205_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%%shock recording is crap 

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_05_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181205_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_05_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181205_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_06_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181206_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_06_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181206_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_07_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181207_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_07_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181207_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_12_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181212_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble25';
MD(i).Date = '12_12_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_25\Marble_25_final\20181212_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%%G_D_6

i = i+1;
MD(i).Animal = 'G_D_6';
MD(i).Date = '01_14_2019';
MD(i).Session = 1;
MD(i).Env = 'octogon';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\G_d_6\G_D_6_final\20190114_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'G_D_6';
MD(i).Date = '01_14_2019';
MD(i).Session = 2;
MD(i).Env = 'octogon';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\G_d_6\G_D_6_final\20190114_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'G_D_6';
MD(i).Date = '01_15_2019';
MD(i).Session = 1;
MD(i).Env = 'octogon';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\G_d_6\G_D_6_final\20190115_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'G_D_6';
MD(i).Date = '01_15_2019';
MD(i).Session = 2;
MD(i).Env = 'octogon';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\G_d_6\G_D_6_final\20190115_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 26

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_03_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181203_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_03_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181203_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_04_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181204_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_04_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181204_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_05_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181205_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

% Not enough cells to run plot_traces_outlines2
i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_05_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181205_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_05_2018';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181205_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_05_2018';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181205_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_06_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181206_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_06_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181206_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_07_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181207_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_07_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181207_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_12_2018';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181212_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_26';
MD(i).Date = '12_12_2018';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_26\Marble_26_final\20181212_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

%% Marble 29

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_14_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190114_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_14_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190114_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_15_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190115_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_15_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190115_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_16_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190116_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_16_2019';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190116_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_16_2019';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190116_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_17_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190117_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_17_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190117_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_18_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190118_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_18_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190118_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_25_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190125_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_29';
MD(i).Date = '01_25_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_29\Marble_29_final\20190125_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


%% Marble 27 
i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_28_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190128_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_28_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190128_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_29_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190129_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_29_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190129_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_30_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190130_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_30_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190130_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_30_2019';
MD(i).Session = 3;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190130_3';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_30_2019';
MD(i).Session = 4;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190130_4';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_31_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190131_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '01_31_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190131_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '02_01_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190201_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '02_01_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190201_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;


i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '02_06_2019';
MD(i).Session = 1;
MD(i).Env = 'open';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190206_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;

i = i+1;
MD(i).Animal = 'Marble_27';
MD(i).Date = '02_06_2019';
MD(i).Session = 2;
MD(i).Env = 'shock';
MD(i).Room = 'CILSE 721 A';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = '';
elseif strcmp(userstr, 'mouseimage')
    MD(i).Location =  'D:\Marble_27\Marble_27_final\20190206_2';
end
MD(i).Notes = 'Control';
MD(i).Freezing = NaN;
MD(i).Shockdur = NaN; 
MD(i).Shocklevel = NaN;
%% 
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