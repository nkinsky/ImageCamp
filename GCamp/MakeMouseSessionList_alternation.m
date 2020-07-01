function [MD, session_ref, session_ref2] = MakeMouseSessionList_alternation(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types
%
%.PIX2CM: pixels-to-cm conversion factor for xpos_interp and ypos_interp
%
%.perf: performance from lab notebook for comparison to automated
%calculation.

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

%% G31 Alternation Sessions

G31.alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_24_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\11_24_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_24_2014';
end
MD(i).Notes = 'Acclimation Session';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_25_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\11_25_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_25_2014';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_26_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\11_26_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_26_2014';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_02_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_02_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_02_2014';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 77.5;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_03_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_03_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_03_2014';
elseif strcmpi(userstr,'natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\Alternation\G31\12_03_2014s1';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 67.5;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_04_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_04_2014\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 70;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_05_2014\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 70;

% i = i+1;
% MD(i).Animal = 'GCamp6f_31';
% MD(i).Date = '12_05_2014';
% MD(i).Session = 2;
% MD(i).Env = 'alternation';
% MD(i).Room = '2 Cu 201B';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working\left trials';
% end
% MD(i).Notes = 'Correct Left Trials Only';
% MD(i).Pix2CM = 0.10;
% 
% 
% i = i+1;
% MD(i).Animal = 'GCamp6f_31';
% MD(i).Date = '12_05_2014';
% MD(i).Session = 3;
% MD(i).Env = 'alternation';
% MD(i).Room = '2 Cu 201B';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working\right trials';
% end
% MD(i).Notes = 'Correct Right Trials Only';
% MD(i).Pix2CM = 0.10;

% Bad Motion Correction for this session. only used for behavior
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_08_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_08_2014\Working';
end
MD(i).Notes = '';
MD(i).Pix2CM = 0.10;
MD(i).perf = 85;


% Bad imaging plane - only used for behavior
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_09_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_09_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_09_2014';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 77.5;

% Bad imaging plane - only used for behavior
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_10_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = '';
elseif (strcmp(userstr,'Will'))
   
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 75.0;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_11_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_11_2014\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 70;

%%% Bad imaging plane (Will lifted by tether halfway through by accident) 
%%% Use only for behavior!
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_12_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = '';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = 85;

G31.alternation(2) = i;
G31.all(2) = i;

%% Start of G30

G30.all(1) = i+1;
G30.alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_16_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_16_2014\Working';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_17_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_17_2014\Working';
end
MD(i).Notes = 'Looping + Forced Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_17_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_17_2014\Working\Looping';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_17_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_17_2014\Working\Forced';
end
MD(i).Notes = 'Forced Only';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;


i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_21_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_21_2014\Working';
end
MD(i).Notes = 'Looping + Forced Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_21_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_21_2014\Working\Looping';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_21_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_21_2014\Working\Forced';
end
MD(i).Notes = 'Forced ONly';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_23_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_23_2014\Working';
end
MD(i).Notes = 'Looping + Forced Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_23_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_23_2014\Working\Looping';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_23_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_23_2014\Working\Forced';
end
MD(i).Notes = 'Forced Only';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_28_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_28_2014\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_30_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_30_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_28_2014';
end
MD(i).Notes = 'Free Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_31_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_31_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_31_2014';
end
MD(i).Notes = 'Free alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 85;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_31_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_31_2014\Working\Forced Trials';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_31_2014';
end
MD(i).Notes = 'Forced part of session 1 (first part)';
MD(i).Pix2CM = 0.10;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_04_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_04_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_04_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 71.4;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_06_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_06_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_06_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 84.6;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_07_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_07_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_07_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 82.5;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_10_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_10_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_10_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 82.5;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_11_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_11_2014\Working';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_11_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_11_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 84;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_12_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_12_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 86;
% 
% i = i+1;
% MD(i).Animal = 'GCamp6f_30';
% MD(i).Date = '11_12_2014';
% MD(i).Session = 2;
% MD(i).Env = 'Alternation';
% MD(i).Room = '2 Cu 201B';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working\left trials';
% elseif (strcmp(userstr,'Nat_laptop'))
%     MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
% end
% MD(i).Notes = 'Correct Left Trials Only';
% MD(i).Pix2CM = 0.15;
% 
% i = i+1;
% MD(i).Animal = 'GCamp6f_30';
% MD(i).Date = '11_12_2014';
% MD(i).Session = 3;
% MD(i).Env = 'Alternation';
% MD(i).Room = '2 Cu 201B';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working\right trials';
% elseif (strcmp(userstr,'Nat_laptop'))
%     MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
% end
% MD(i).Notes = 'Correct Right Trials Only';
% MD(i).Pix2CM = 0.15;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working';
% elseif (strcmp(userstr,'Nat_laptop'))
%     MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_13_2014';
elseif strcmpi(userstr,'natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\Alternation\G30\11_13_2014s1';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.10;
MD(i).perf = 88.3;

% i = i+1;
% MD(i).Animal = 'GCamp6f_30';
% MD(i).Date = '11_13_2014';
% MD(i).Session = 2;
% MD(i).Env = 'Alternation';
% MD(i).Room = '2 Cu 201B';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\left trials';
% elseif (strcmp(userstr,'Nat_laptop'))
%     MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
% end
% MD(i).Notes = 'Correct Left Trials Only';
% MD(i).Pix2CM = 0.15;
% 
% i = i+1;
% MD(i).Animal = 'GCamp6f_30';
% MD(i).Date = '11_13_2014';
% MD(i).Session = 3;
% MD(i).Env = 'Alternation';
% MD(i).Room = '2 Cu 201B';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\right trials';
% elseif (strcmp(userstr,'Nat_laptop'))
%     MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
% end
% MD(i).Notes ='Correct Right Trials Only';
% MD(i).Pix2CM = 0.15;

G30.alternation(2) = i;

G30.all(2) = i;

%% Start G45

G45.all(1) = i+1;

%% G45 Alternation

G45.alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_18_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_18_2015\1 - alternation';
end
MD(i).Notes = '';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_08_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_08_2015\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_09_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_09_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_10_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_10_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_10_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_10_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan; % Not noted

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_11_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_11_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 70;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_11_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_11_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 82.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_15_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_15_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 72.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_15_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_15_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 63.33;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_16_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_16_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 67.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_17_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_17_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 65;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_17_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_17_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 72.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_18_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_18_2015\1 - alternation\Working';
elseif (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'O:\GCamp6f_45\09_18_2015\1 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 62.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_18_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_18_2015\2 - alternation\Working';
elseif (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'O:\GCamp6f_45\09_18_2015\2 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 70;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_19_2015';
MD(i).Session = 1;
MD(i).Location = 'D:\GCamp mice\G45\alternation\09_19_2015\1 - alternation\Working';
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_19_2015\1 - alternation\Working';
elseif (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'F:\GCamp6f_45\09_19_2015\1 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 57.5;


i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_22_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_22_2015\1 - alternation\Working';
elseif (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'F:\GCamp6f_45\09_22_2015\1 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 70;


% i = i+1;
% MD(i).Animal = 'GCamp6f_45';
% MD(i).Date = '09_22_2015';
% MD(i).Session = 2;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = '';
% elseif (strcmp(userstr,'mouseimage'))
%     MD(i).Location = 'M:\GCamp6f_45\09_22_2015\1 - alternation';
% end
% MD(i).Notes = 'Will Method';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = 70;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_23_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_23_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 75;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_23_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_23_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 75.8;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_24_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_24_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 72.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_24_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_24_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 75;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_29_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\alternation\09_29_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 75;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_29_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\alternation\09_29_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 74.2;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_30_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_30_2015\1 - alternation\Working';
elseif strcmpi(userstr, 'natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\Alternation\G45\09_30_2015s1';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 67.5;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_30_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_30_2015\2 - alternation\Processed Data';
end
% MD(i).exclude_frames = 14976:15233; % Should be taken care of by
% combine_tracking
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 85.3;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_01_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\10_01_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 75;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_01_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\10_01_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 80;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_02_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\10_02_2015\1 - alternation\Working';
end
% MD(i).exclude_frames = 13661:13980; should be taken care of by
% combine_tracking
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 80;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_02_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\10_02_2015\2 - alternation\Working';
elseif strcmpi(userstr,'mouseimage')
    MD(i).Location = 'M:\GCamp6f_45\10_02_2015\2 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 63;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_03_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\10_03_2015\1 - alternation\Working';
elseif strcmpi(userstr,'mouseimage')
    MD(i).Location = 'M:\GCamp6f_45\10_03_2015\1 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 72;

% Lots of weird drift between imaging and behavioral camera - scrap, can't
% figure out alignment
% i = i+1;
% MD(i).Animal = 'GCamp6f_45';
% MD(i).Date = '10_06_2015';
% MD(i).Session = 1;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'D:\GCamp mice\G45\alternation\10_06_2015\1 - alternation\Working';
% elseif strcmpi(userstr,'mouseimage')
%     MD(i).Location = 'M:\GCamp6f_45\10_06_2015\1 - alternation';
% end
% MD(i).Notes = 'Will Method';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = 71;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_07_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\10_07_2015\1 - alternation\Working';
elseif strcmpi(userstr,'mouseimage')
    MD(i).Location = 'M:\GCamp6f_45\10_07_2015\1 - alternation';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 68.6;

G45.alternation(2) = i;
%% Start G48
G48.all(1) = i+1;

%% G48 Alternation

G48.alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_10_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_10_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_11_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_11_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_15_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_15_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_15_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_15_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Looping';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

% No cineplex data for this session, so omit it!
% i = i+1;
% MD(i).Animal = 'GCamp6f_48';
% MD(i).Date = '09_16_2015';
% MD(i).Session = 1;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'D:\GCamp mice\G48\alternation\09_16_2015\1 - alternation\Processed Data';
% end
% MD(i).Notes = 'Will Method';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = 69.4;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_16_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_16_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 50;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_17_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_17_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 51.9;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_17_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_17_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 55;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_18_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_18_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 67.5;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_18_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_18_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 60;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_19_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_19_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 73;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_22_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_22_2015\1 - alternation\Processed Data';
elseif strcmpi(userstr, 'natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\Alternation\G48\09_22_201_s1';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 65;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_23_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\09_23_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 79.4;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_23_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\09_23_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 65.7;

% Don't have tracking data for this, but need it - good low performance
% point!
i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_24_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\09_24_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 77.5;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_24_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\09_24_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 54.5;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_29_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\09_29_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 65;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_30_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\09_30_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 70;

% NG - forced to free back to forced
% i = i+1;
% MD(i).Animal = 'GCamp6f_48';
% MD(i).Date = '10_01_2015';
% MD(i).Session = 1;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_01_2015\1 - alternation\Processed Data';
% end
% MD(i).Notes = 'Forced Alternation -> Will Method';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_01_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_01_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 50;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_01_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_01_2015\2 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_02_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_02_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_02_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_02_2015\1 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

% Forced to free with correction on wrong trials - n.g. for use
% i = i+1;
% MD(i).Animal = 'GCamp6f_48';
% MD(i).Date = '10_02_2015';
% MD(i).Session = 2;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'D:\GCamp mice\G48\alternation\10_02_2015\2 - alternation\Processed Data';
% end
% MD(i).Notes = 'Forced Alternation -> Will Method';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_03_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_03_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation Only';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_06_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_06_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation Only';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_06_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_06_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 66.7;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_06_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_06_2015\2 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_07_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_07_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 72.5;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_07_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_07_2015\1 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

% Forced to free back to forced - too weird to deal with right now 
% i = i+1;
% MD(i).Animal = 'GCamp6f_48';
% MD(i).Date = '10_07_2015';
% MD(i).Session = 2;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'D:\GCamp mice\G48\alternation\10_07_2015\2 - alternation\Processed Data';
% end
% MD(i).Notes = 'Forced Alternation -> Will Method';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_08_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_08_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 50;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_08_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_08_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 66;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_08_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_08_2015\1 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_08_2015';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_08_2015\2 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_09_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_09_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 70;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_09_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_09_2015\1 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_09_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_09_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 78;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_09_2015';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_09_2015\2 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_10_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_10_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 71;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_10_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_10_2015\1 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_12_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_12_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 73;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_12_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_12_2015\1 - alternation\Processed Data\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_13_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_13_2015\1 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 75;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_13_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_13_2015\1 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_13_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_13_2015\2 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 86;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_13_2015';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_13_2015\2 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_14_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_14_2015\1 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 71.4;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_14_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_14_2015\1 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_14_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_14_2015\2 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 70.7;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_14_2015';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_14_2015\2 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

% Too distracted (has an open wound that I treat afterward) to include
% i = i+1;
% MD(i).Animal = 'GCamp6f_48';
% MD(i).Date = '10_15_2015';
% MD(i).Session = 1;
% MD(i).Env = 'alternation';
% MD(i).Room = '201a - 2015';
% if (strcmp(userstr,'Nat'))
%     MD(i).Location = 'D:\GCamp mice\G48\alternation\10_15_2015\1 - alternation\Working';
% end
% MD(i).Notes = 'Forced';
% MD(i).Pix2CM = 0.0874;
% MD(i).perf = nan;


i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_15_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_15_2015\2 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 78.0;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_15_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_15_2015\2 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_16_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_16_2015\1 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 80.9;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_16_2015';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_16_2015\1 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 1 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_16_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_16_2015\2 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 76.2;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_16_2015';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_16_2015\2 - alternation\Working\Forced Trials';
end
MD(i).Notes = 'Forced Alternation portion of session 2 (first part)';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

G48.alternation(2) = i;
G48.all(2) = i;

%% Compile session_ref

session_ref.G30 = G30;
session_ref.G30_scalefix = G30_scalefix;
session_ref.G31 = G31;
session_ref.G41 = G41;
session_ref.G44 = G44;
session_ref.G45 = G45;
session_ref.G46 = G46;
session_ref.G48 = G48;
% session_ref.Marble3 = Marble3;
% session_ref.Marble7 = Marble7;

%% Compile session_ref
animal_sesh_list = arrayfun(@(a) a.Animal,MD,'UniformOutput',0);
unique_animals = unique(animal_sesh_list); % Get animal names

first_sesh = cellfun(@(a) find(strcmpi(a,animal_sesh_list),1,'first'),...
    unique_animals);
last_sesh = cellfun(@(a) find(strcmpi(a,animal_sesh_list),1,'last'),...
    unique_animals);

session_ref2 = cat(1,unique_animals, num2cell(first_sesh), num2cell(last_sesh));
session_ref2 = cat(1,{'Animal','1st sesh','last sesh'},session_ref2');


%%
save MasterDirectory.mat MD;

cd(CurrDir);

end

%% Sub-function to