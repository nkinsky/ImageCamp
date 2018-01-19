function [MD, session_ref] = MakeMouseSessionListER(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

%% 1 DREADDS cohort
i = 1;
MD(i).Animal = 'DREADDS_VHPC_1';
MD(i).Date = 'pre-exposure1';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'E:\Evan\0.25mA protocol\01_15_18_1_shock\01_15_18_1_exposure\DREADDS_VHPC_1';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Shockdur = []; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_3_4hr\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf15';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_5_rexposure\PF15';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Shockdur = ''; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_3_4hr\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf16';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_5_rexposure\PF16';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Shockdur = ''; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_3_4hr\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf17';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '3';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_5_rexposure\PF17';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Freezing = '';
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
MD(i).Shockdur = ''; 
MD(i).Shocklevel = .25;

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = '4hr';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_18_17_3_4hr\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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
MD(i).Freezing = '';
MD(i).Shockdur = NaN;
MD(i).Shocklevel = NaN; 

i = i+1;
MD(i).Animal = 'pf18';
MD(i).Date = 're-exposure2';
MD(i).Session = 1;
MD(i).Env = '4';
MD(i).Room = 'CILSE 721 F';
if (strcmp(userstr,'Eichentron'))
    MD(i).Location = 'e:\Evan\0.25mA protocol\12_18_17_1_shock\12_21_17_5_rexposure\PF18';
end
MD(i).Notes = 'Control';
MD(i).Freezing = '';
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