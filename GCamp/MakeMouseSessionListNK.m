function [MD, session_ref] = MakeMouseSessionListNK(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

G31.all(1) = 1;

i = 1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '09_29_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\09_29_2014\working';
elseif strcmp(userstr,'Nat_laptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G31\09_29_2014';
elseif strcmp(userstr,'Nat')
    MD(i).Location = 'J:\GCamp Mice\Working\G31\09_29_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_01_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_01_2014\working';
elseif strcmp(userstr,'Nat_laptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G31\10_01_2014';
elseif strcmp(userstr,'Nat')
    MD(i).Location = 'J:\GCamp Mice\Working\G31\10_01_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_03_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_03_2014\working';
elseif strcmp(userstr,'Nat_laptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G31\10_03_2014';
elseif strcmp(userstr,'Nat')
    MD(i).Location = 'J:\GCamp Mice\Working\G31\10_03_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_06_2014';
MD(i).Session = 1;
MD(i).Env = 'Home Cage';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_06_2014\1 - homecage 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_06_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_06_2014\2 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_08_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_08_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_08_2014';
MD(i).Session = 2;
MD(i).Env = 'Home Cage';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_08_2014\2 - homecage 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_10_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201A';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_10_2014\1 - triangle track 201A\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_10_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_10_2014\2 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_14_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_14_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_14_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_14_2014\2 - triangle track rotated plus 120 201B\working';
end
MD(i).Notes = 'rotated +120 degrees';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_17_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_17_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_17_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_17_2014\2 - triangle open-field 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_20_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_20_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_22_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_22_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_22_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_22_2014\2 - triangle 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_24_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_24_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_27_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_27_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_29_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_29_2014\working';
end
MD(i).Notes = 'Rotated 90 deg CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_31_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_31_2014\1 - square 201B';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_03_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_03_2014\1 - square track\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_03_2014';
MD(i).Session = 2;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_03_2014\2 - square\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_10_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_10_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_12_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_12_2014\working';
end
MD(i).Notes = [];

%% G31 2 env sessions
G31.two_env(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_15_2014';
MD(i).Session = 1;
MD(i).Env = '2 env square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
end
MD(i).Notes = 'Right';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_15_2014';
MD(i).Session = 2;
MD(i).Env = '2 env square left 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\2 - 2env square left 90CCW\Working';
end
MD(i).Notes = 'Left, Rotated 90CCW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_16_2014';
MD(i).Session = 1;
MD(i).Env = '2 env octagon left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\1 - 2env octagon left\Working';
end
MD(i).Notes = 'Left';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_16_2014';
MD(i).Session = 2;
MD(i).Env = '2 env octagon right 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\2 - 2env octagon right 90CCW\Working';
end
MD(i).Notes = 'Right, Rotated 90CCW - TONS of dropped frames in 2nd session - see .mat file.  Because they are mostly intermittent the traces still look ok.';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_17_2014';
MD(i).Session = 1;
MD(i).Env = '2 env octagon right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_17_2014\1 - octagon right\Working';
end
MD(i).Notes = 'Right';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_17_2014';
MD(i).Session = 2;
MD(i).Env = '2 env octagon mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_17_2014\2 - octagon mid 90CW\Working';
end
MD(i).Notes = 'Mid, Rotated 90CW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_18_2014';
MD(i).Session = 1;
MD(i).Env = '2 env square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_18_2014\1 - 2env square right\Working';
end
MD(i).Notes = 'Right';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_18_2014';
MD(i).Session = 2;
MD(i).Env = '2 env square mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_18_2014\2 - 2env square mid 90CW\Working';
end
MD(i).Notes = 'Mid, Rotated 90CW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_19_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - standard square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_19_2014\2env standard\Working\square';
end
MD(i).Notes = 'Mid, Standard';
MD(i).Pix2CM = 0.136;
MD(i).half = 12645;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_19_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - standard octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_19_2014\2env standard\Working\octagon';
end
MD(i).Notes = 'Mid, Standard';
MD(i).Pix2CM = 0.136;
MD(i).half = 12645;


i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - 180 octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\octagon';
end
MD(i).Notes = 'Rotated 180 - Note that we lose basically half our data here because of the dropped frames, resulting in lower info scores, pvalues, etc.';
MD(i).exclude_frames = 13134:18969;
MD(i).Pix2CM = 0.136;
MD(i).half = 12655;


i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - 180 square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\square';
end
MD(i).Notes = 'Rotated 180';
MD(i).exclude_frames = 13134:18969;
MD(i).Pix2CM = 0.136;
MD(i).half = 12655;


i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_21_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_21_2014_nb\1 - 2env square left\Working';
end
MD(i).Notes = 'Left';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_21_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - square mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_21_2014_nb\2 - 2env square mid 90CW\Working';
end
MD(i).Notes = 'Mid, Rotated 90CW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_22_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - octagon mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_22_2014_nb\1 - 2env octagon mid\Working';
end
MD(i).Notes = 'Mid';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_22_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - octagon left 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_22_2014_nb\2 - 2env octagon left 90CW\Working';
end
MD(i).Notes = 'Left, Rotated 90CW';
MD(i).Pix2CM = 0.136;

G31.two_env(2) = i;

%%

G31.two_env_debug(1) = i + 1;
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 3;
MD(i).Env = '2 env - 180 square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\debug square';
end
MD(i).Notes = 'Rotated 180 - trying to look at only first time in the square';
MD(i).exclude_frames = 24000:31614;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 4;
MD(i).Env = '2 env - 180 octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\debug octagon';
end
MD(i).Notes = 'Rotated 180 - trying to look at only first time in the octagon';
MD(i).exclude_frames = 6500:31614;

G31.two_env_debug(2) = i;

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
MD(i).Pix2CM = 0.15;
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
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
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
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
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
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
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
end
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
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
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
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
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
MD(i).perf = 70;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working\left trials';
end
MD(i).Notes = 'Correct Left Trials Only';
MD(i).Pix2CM = 0.15;


i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working\right trials';
end
MD(i).Notes = 'Correct Right Trials Only';
MD(i).Pix2CM = 0.15;


i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_09_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_09_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_09_2014';
end
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
MD(i).perf = 77.5;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_11_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G31\alternation\12_11_2014\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G31\alternation\12_11_2014\Working';
end
MD(i).Notes = '';
MD(i).Pix2CM = 0.15;
MD(i).perf = 70;

G31.alternation(2) = i;
G31.all(2) = i;

%% Transient Tweaking
G31.transient_tweak(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = 'G31_trans_tweak';
MD(i).Session = 1;
MD(i).Env = '2 env square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
end
MD(i).Notes = 'Use this folder for QCing transient length limit tweaking';

G31.transient_tweak(2) = i;

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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
MD(i).perf = [];

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
MD(i).Notes = 'Regular Alternation/Partial Free';
MD(i).Pix2CM = 0.15;
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
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.15;
MD(i).perf = 85;

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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
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
MD(i).Pix2CM = 0.15;
MD(i).perf = 86;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_12_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working\left trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
end
MD(i).Notes = 'Correct Left Trials Only';
MD(i).Pix2CM = 0.15;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_12_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working\right trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
end
MD(i).Notes = 'Correct Right Trials Only';
MD(i).Pix2CM = 0.15;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_13_2014';
end
MD(i).Notes = 'Regular Alternation';
MD(i).Pix2CM = 0.15;
MD(i).perf = 88.3;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\left trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
end
MD(i).Notes = 'Correct Left Trials Only';
MD(i).Pix2CM = 0.15;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\right trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
end
MD(i).Notes ='Correct Right Trials Only';
MD(i).Pix2CM = 0.15;

G30.alternation(2) = i;

%% G30 2env experiment

G30.two_env(1) = (i+1);

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_19_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working';
end
MD(i).Notes = 'Left';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_19_2014';
MD(i).Session = 2;
MD(i).Env = '2env - square mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\2 - 2env square mid 201B\Working';
end
MD(i).Notes = 'Mid';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_20_2014';
MD(i).Session = 1;
MD(i).Env = '2env - octagon left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working';
end
MD(i).Notes = 'Left';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_20_2014';
MD(i).Session = 2;
MD(i).Env = '2env - octagon right 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Working';
end
MD(i).Notes = 'Right, Rotated 90CCW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_21_2014';
MD(i).Session = 1;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working';
end
MD(i).Notes = 'Mid';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_21_2014';
MD(i).Session = 2;
MD(i).Env = '2env - octagon left 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working';
end
MD(i).Notes = 'Left, rotated 90CW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_22_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_22_2014\1 - 2env square right 201B\Working';
end
MD(i).Notes = 'Right';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_22_2014';
MD(i).Session = 2;
MD(i).Env = '2env - square mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working';
end
MD(i).Notes = 'Mid 90CW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_23_2014';
MD(i).Session = 1;
MD(i).Env = '2env - combined square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_23_2014\2env standard\Working\square';
end
MD(i).Notes = 'Mid - Standard';
MD(i).Pix2CM = 0.136;
MD(i).half = 13460;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_23_2014';
MD(i).Session = 2;
MD(i).Env = '2env - combined octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_23_2014\2env standard\Working\octagon';
end
MD(i).Notes = 'Mid - Standard';
MD(i).Pix2CM = 0.136;
MD(i).half = 13460;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_24_2014';
MD(i).Session = 1;
MD(i).Env = '2env - combined octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_24_2014\rotate 180\Working\octagon';
end
MD(i).Notes = 'Mid, Rotated 180';
MD(i).Pix2CM = 0.136;
MD(i).half = 13152;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_24_2014';
MD(i).Session = 2;
MD(i).Env = '2env - combined square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_24_2014\rotate 180\Working\square';
end
MD(i).Notes = 'Mid, Rotated 180';
MD(i).Pix2CM = 0.136;
MD(i).half = 13152;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_25_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_25_2014\1 - 2env square left 201B\Working';
end
MD(i).Notes = 'Mid';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_25_2014';
MD(i).Session = 2;
MD(i).Env = '2env - square right 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_25_2014\2 - 2env square right 90CCW 201B\Working';
end
MD(i).Notes = 'Right 90CCW';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_26_2014';
MD(i).Session = 1;
MD(i).Env = '2env - octagon right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_26_2014\1 - 2env octagon right 201B\Working';
end
MD(i).Notes = 'Right';
MD(i).Pix2CM = 0.136;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_26_2014';
MD(i).Session = 2;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_26_2014\2 - 2 env octagon mid 201B\Working';
end
MD(i).Notes = 'Mid';
MD(i).Pix2CM = 0.136;

G30.two_env(2) = i;
G30.all(2) = i;

%% G30 FC Pilot - note listed ast 30_2 because imaging looks very different than original G30 recordings...

G30.FC_pilot(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 1;
MD(i).Env = 'FC';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\1 - shock baseline\Working';
end
MD(i).Notes = 'Day 1 - FC environment baseline';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 2;
MD(i).Env = 'neutral';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\2 - neutral baseline\Working';
end
MD(i).Notes = 'Day 1 - neutral environment baseline';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 3;
MD(i).Env = 'shock';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\3 - shock shock\Working';
end
MD(i).Notes = 'Day 1 - FC environment shock session';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 4;
MD(i).Env = 'neutral';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\4 - neutral 3 hr\Working';
end
MD(i).Notes = 'Day 1 - neutral environment 3hr session';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 5;
MD(i).Env = 'shock';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\5 - shock 3 hr\Working';
end
MD(i).Notes = 'Day 1 - FC environment 3hr session';

G30.FC_pilot(2) = i;

%% GCamp6f_44 starts here

G44.all(1) = (i+1);

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_08_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = 'surgery';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_08_2015\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_09_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_09_2015\Session 1';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_10_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_10_2015\Session 1';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_10_2015';
MD(i).Session = 2;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_10_2015\Session 2\Working';
end
MD(i).Notes = '';

G44_homecage(2) = i;

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_13_2015';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_13_2015\Session 1\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_13_2015';
MD(i).Session = 2;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_13_2015\Session 2\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_14_2015';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_14_2015\Session 1\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_14_2015';
MD(i).Session = 2;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_14_2015\Session 2\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_15_2015';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_15_2015\Session 1\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_15_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_15_2015\Session 2\Working';
end
MD(i).Notes = 'Continuous reward';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_16_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_16_2015\Session 1\Working';
end
MD(i).Notes = 'continuous reward';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_16_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_16_2015\Session 2\Working';
end
MD(i).Notes = 'Rotated 120 CW, continuous reward';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_17_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_17_2015\Session 1\Working';
end
MD(i).Notes = 'Rotated 120 CW, fixed reward location';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_17_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_17_2015\Session 2\Working';
end
MD(i).Notes = 'fixed reward location';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_20_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_20_2015\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_21_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_21_2015\Session 1 - square\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_21_2015';
MD(i).Session = 2;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_21_2015\Session 2 - square track\Working';
end
MD(i).Notes = '';



i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_22_2015';
MD(i).Session = 1;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_22_2015\Session 1 - square track\Working';
end
MD(i).Notes = '';


i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_22_2015';
MD(i).Session = 2;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_22_2015\Session 2 - square\Working';
end
MD(i).Notes = '';

G44.all(2) = i;

%% Start G45

G45.all(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\1 - triangle\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\08_05_2015\1 - triangle\Working';
end
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_05_2015\1 - triangle';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2 - triangle\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\08_05_2015\2 - triangle\Working';
end
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_05_2015\2 - triangle';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_06_2015';
MD(i).Session = 1;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_06_2015\1 - square track';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_06_2015';
MD(i).Session = 2;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_06_2015\2 - square track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_10_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_10_2015\1 - square open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_11_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_11_2015\1 - triangle open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_12_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_12_2015\1 - triangle open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_12_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_12_2015\2 - triangle track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_13_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_13_2015\1 - triangle track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_13_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_13_2015\2 - triangle open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_14_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_14_2015\1 - triangle track';
end
MD(i).Notes = '';

%% G45 2env
G45.twoenv(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_28_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\1 - square right\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 1\1 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square right';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_28_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square left 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\2 - square left 90CCW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 1\2 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square left 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_29_2015';
MD(i).Session = 1;
MD(i).Env = '2env - octagon right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_29_2015\1 - oct right\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 2\1 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon right';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_29_2015';
MD(i).Session = 2;
MD(i).Env = '2env - octagon mid 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_29_2015\2 - oct mid 90CCW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 2\2 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon mid 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_30_2015';
MD(i).Session = 1;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_30_2015\1 - oct mid\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 3\1 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon mid';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_30_2015';
MD(i).Session = 2;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_30_2015\2 - oct left 90CW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 3\2 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon left 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_31_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_31_2015\1 - square left\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 4\1 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square left';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_31_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_31_2015\2 - square mid 90CW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 4\2 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square mid 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_01_2015';
MD(i).Session = 1;
MD(i).Env = '2env - standard';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_01_2015\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'Standard Connected';


i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_01_2015';
MD(i).Session = 2;
MD(i).Env = '2env - standard square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_01_2015\Working\square';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 5\2env std\1 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'Standard, square';
MD(i).half = 12750;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_01_2015';
MD(i).Session = 3;
MD(i).Env = '2env - standard octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_01_2015\Working\octagon';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 5\2env std\2 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'Standard, octagon';
MD(i).half = 12750;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_02_2015';
MD(i).Session = 1;
MD(i).Env = '2env - connected 180';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_02_2015\2 env 180\Working';

end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = '2env connected - 180';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_02_2015';
MD(i).Session = 2;
MD(i).Env = '2env - connected 180 octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_02_2015\2 env 180\Working\octagon';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 6\2env 180\1 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'Rotated 180, Octagon';
MD(i).half = 13015;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_02_2015';
MD(i).Session = 3;
MD(i).Env = '2env - connected 180 square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_02_2015\2 env 180\Working\square';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 6\2env 180\2 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'Rotated 180, Square';
MD(i).half = 13015;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_03_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_03_2015\1 - square mid\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 7\1 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square mid';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_03_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square right 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_03_2015\2 - square right 90CCW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 7\2 - square\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square right 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 1;
MD(i).Env = '2env - octagon left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\1 - oct left\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 8\1 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon left';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 2;
MD(i).Env = '2env - octagon right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\2 - oct right 90CW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2env duplication\day 8\2 - octagon\Working';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon right 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 3;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\3 - octagon mid\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = '';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon mid';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 4;
MD(i).Env = '2env - octagon left 180';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\4 - octagon left 180\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = '';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'octagon left 180';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_05_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_05_2015\1 - square right\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = '';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square right';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_05_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square mid 180';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_05_2015\2 - square mid 180\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = '';
end
MD(i).Pix2CM = 0.0874;
MD(i).Notes = 'square mid 180';

G45.twoenv(2) = i;

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
MD(i).perf = 'unknown';

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

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_30_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G45\alternation\09_30_2015\1 - alternation\Working';
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

G45.alternation(2) = i;

%% Start of G45 Continuous-Delay Alternation Data
G45.alternation_delay_pilot(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_13_2016';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_13_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_13_2016\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_14_2016';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_14_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_14_2016\1 - all blocks combined\Working';
end
MD(i).Notes = '';
MD(i).exclude_frames = [12725:15025, 34405:36185, 49425:52245];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_14_2016';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_14_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_14_2016\2 - continuous\Working';
end
MD(i).Notes = 'Continuous blocks only';
MD(i).exclude_frames = [12725:36185, 49425:77637];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_14_2016';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_14_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_14_2016\3 - delay\Working';
end
MD(i).Notes = 'Delay blocks only';
MD(i).exclude_frames = [1:15025, 34405:52245];

G45.alternation_delay_pilot_good(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_18_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\1 - alternation combined\Working';
end
MD(i).Notes = '';
MD(i).exclude_frames = [10971:11371, 35211:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_18_2016\2 - continuous only\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\2 - continuous only\Working';
end
MD(i).Notes = 'Continuous Data Only';
MD(i).exclude_frames = [10971:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_18_2016\3 - delay only\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\3 - delay only\Working';
end
MD(i).Notes = 'Delay Data Only';
MD(i).exclude_frames = [1:11371, 35211:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\4 - 1st block continuous vs 1st block delay\Working';
end
MD(i).Notes = '1st continuous block and 1st delay block only';
MD(i).exclude_frames = [10971:11371, 35211:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 5;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\5 - 1st continuous block only\Working';
end
MD(i).Notes = '1st continuous block only';
MD(i).exclude_frames = [10971:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 6;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\6 - 2nd block continuous vs 1st block delay\Working';
end
MD(i).Notes = '2nd continuous block and 1st delay block only';
MD(i).exclude_frames = [1:11371, 35211:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 6;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\7 - 2nd continuous block only\Working';
end
MD(i).Notes = '2nd continuous block only';
MD(i).exclude_frames = [1:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 7;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\1 - alternation combined\Working T2';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [10971:11371, 35211:35441, 45871:46175];

G45.alternation_delay_pilot(2) = i;
G45.alternation_delay_pilot_good(2) = i;

%% G45 DNMP Task 
G45.DNMP(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_01_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_01_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_01_2016\Working';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_04_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_04_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_04_2016\Working';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [2679:2975, 4592:4863, 6806:7040, 8295:10420, ...
    15850:16075, 17113:17318, 17520:18336, 25831:26053, 28009:29419, ...
    29668:31476, 33282:33661, 36544:36986];

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_05_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_05_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_05_2016';
MD(i).Session = 2;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_05_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working after Nat_T2edits';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [];



G45.DNMP(2) = i;
G45.all(2) = i;

%% Start G41

G41.all(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_41';
MD(i).Date = '08_05_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G41\08_05_2015\1 - square\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_41';
MD(i).Date = '08_05_2015';
MD(i).Session = 2;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G41\08_05_2015\2 - square\Working';
end
MD(i).Notes = '';

G41.all(2) = i;

%% Start G46

G46.all(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_46';
MD(i).Date = '08_14_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G46\08_14_2015\1 - homecage plus 1_25\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_46';
MD(i).Date = '08_14_2015';
MD(i).Session = 2;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G46\08_14_2015\2 - homecage plus 2_25\Working';
end
MD(i).Notes = '';

G46.all(2) = i;

%% Start G48
G48.all(1) = i+1;

%% Start G48 2env
G48.twoenv(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_29_2015';
MD(i).Session = 1;
MD(i).Env = 'square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\08_29_2015\1 - square right\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 1\1 - square\Working';
elseif strcmpi(userstr,'eichentron2')
    MD(i).Location = 'E:\Nat\G48\08_29_2015\1 - square right\Working';
end
MD(i).Notes = 'square right';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_29_2015';
MD(i).Session = 2;
MD(i).Env = 'square left 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\08_29_2015\2 - square left 90CCW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 1\2 - square\Working';
end
MD(i).Notes = 'square left 90CCW';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_30_2015';
MD(i).Session = 1;
MD(i).Env = 'octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\08_30_2015\1 - oct mid\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 2\1 - octagon\Working';
end
MD(i).Notes = 'octagon mid';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_30_2015';
MD(i).Session = 2;
MD(i).Env = 'octagon left 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\08_30_2015\2 - oct left 90CCW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 2\2 - octagon\Working';
end
MD(i).Notes = 'octagon left 90CCW';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_31_2015';
MD(i).Session = 1;
MD(i).Env = 'octagon right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\08_31_2015\1 - oct right\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 3\1 - octagon\Working';
end
MD(i).Notes = 'octagon right';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_31_2015';
MD(i).Session = 2;
MD(i).Env = 'octagon mid 90CW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\08_31_2015\2 - oct mid 90CW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 3\2 - octagon\Working';
end
MD(i).Notes = 'octagon mid 90CW';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_01_2015';
MD(i).Session = 1;
MD(i).Env = 'square left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_01_2015\1 - square left\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 4\1 - square\Working';
end
MD(i).Notes = 'square left';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_01_2015';
MD(i).Session = 2;
MD(i).Env = 'square mid 90CW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_01_2015\2 - square mid 90CW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 4\2 - square\Working';
end
MD(i).Notes = 'square mid 90CW';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_02_2015';
MD(i).Session = 1;
MD(i).Env = '2env standard - square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_02_2015\2env standard\Working\square';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 5\2env std\1 - square\Working';
end
MD(i).Notes = '2env standard - square';
MD(i).Pix2CM = 0.0874;
MD(i).half = 13035;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_02_2015';
MD(i).Session = 2;
MD(i).Env = '2env standard - octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_02_2015\2env standard\Working\octagon';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 5\2env std\2 - octagon\Working';
end
MD(i).Notes = '2env standard - octagon';
MD(i).Pix2CM = 0.0874;
MD(i).half = 13035;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_03_2015';
MD(i).Session = 1;
MD(i).Env = '2env 180 - octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_03_2015\2env 180\Working\octagon';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 6\2env 180\1 - octagon\Working';
end
MD(i).Notes = '2env - Octagon Rotated 180';
MD(i).Pix2CM = 0.0874;
MD(i).half = 12790;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_03_2015';
MD(i).Session = 2;
MD(i).Env = '2env 180 - square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_03_2015\2env 180\Working\square';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 6\2env 180\2 - square\Working';
end
MD(i).Notes = '2env - Square Rotated 180';
MD(i).Pix2CM = 0.0874;
MD(i).half = 12790;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_04_2015';
MD(i).Session = 1;
MD(i).Env = 'square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_04_2015\1 - square right\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 7\1 - square\Working';
end
MD(i).Notes = 'square right';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_04_2015';
MD(i).Session = 2;
MD(i).Env = 'square mid 90CW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_04_2015\2 - square mid 90CW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 7\2 - square\Working';
end
MD(i).Notes = 'square mid 90CW';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_05_2015';
MD(i).Session = 1;
MD(i).Env = 'octagon left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_05_2015\1 - oct left\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 8\1 - octagon\Working';
end
MD(i).Notes = 'octagon left';
MD(i).Pix2CM = 0.0874;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_05_2015';
MD(i).Session = 2;
MD(i).Env = 'octagon right 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp Mice\G48\2env\09_05_2015\2 - oct right 90CCW\Working';
elseif strcmpi(userstr,'Natlaptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G48\2env duplication\day 8\2 - octagon\Working';
end
MD(i).Notes = 'octagon right 90CCW';
MD(i).Pix2CM = 0.0874;

G48.twoenv(2) = i;
%% G48 from Will for QC

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '02_17_2017';
MD(i).Session = 1;
MD(i).Env = 'NA';
MD(i).Room = 'NA';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\Will session';
end
MD(i).Notes = 'Example session from Will to compare to my data';


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
i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_16_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\09_16_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 69.4;

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

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_01_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_01_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_01_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_01_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_02_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_02_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_02_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_02_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_03_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_03_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_06_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_06_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_06_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_06_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_07_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_07_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_07_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_07_2015\2 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_08_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_08_2015\1 - alternation\Processed Data';
end
MD(i).Notes = 'Forced Alternation -> Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = [];

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
MD(i).Date = '10_15_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_15_2015\1 - alternation\Working';
end
MD(i).Notes = 'Forced';
MD(i).Pix2CM = 0.0874;
MD(i).perf = nan;

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
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'D:\GCamp mice\G48\alternation\10_16_2015\2 - alternation\Working';
end
MD(i).Notes = 'Will Method';
MD(i).Pix2CM = 0.0874;
MD(i).perf = 76.2;

G48.alternation(2) = i;
G48.all(2) = i;

%% G50

i = i+1;
MD(i).Animal = 'GCamp6f_50';
MD(i).Date = '07_31_2017';
MD(i).Session = 1;
MD(i).Env = '';
MD(i).Room = '721A';
if strcmpi(userstr,'eichentron2')
    MD(i).Location = 'E:\Evan\G50\07-31-17\Working';
end
MD(i).Notes = '8in square box';
MD(i).Pix2CM = nan; % Need to figure this out...

%% Other Folks Data

i = i+1;
MD(i).Animal = 'KC_DRG';
MD(i).Date = '12_15_2016';
MD(i).Session = 1;
MD(i).Env = '';
MD(i).Room = '';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Desktop\SummerSchool_2017\Kim Data';
end
MD(i).Notes = 'Kim Chisolm - DRG data';

i = i+1;
MD(i).Animal = 'Liya';
MD(i).Date = '06_18_2017';
MD(i).Session = 1;
MD(i).Env = 'context1';
MD(i).Room = '';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Desktop\SummerSchool_2017\Liya Data\context1_10min\movie_context1';
end
MD(i).Notes = 'Liya';

i = i+1;
MD(i).Animal = 'Selin';
MD(i).Date = '09_28_2016';
MD(i).Session = 1;
MD(i).Env = 'nan';
MD(i).Room = '';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Desktop\SummerSchool_2017\Data_Analysis_Session2\selin_data';
end
MD(i).Notes = 'Selin';

i = i+1;
MD(i).Animal = 'Tadpole';
MD(i).Date = '06_19_2017';
MD(i).Session = 1;
MD(i).Env = 'nan';
MD(i).Room = '';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Desktop\SummerSchool_2017\Tadpoles';
end
MD(i).Notes = '';

%% Eraser - Marble3
Marble3(1) = i+1;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_05_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field -2';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180205_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_05_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box -2';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180205_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_06_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field -1';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180206_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_06_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box -1';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180206_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 0';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 0';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 3;
MD(i).Env = 'Square Open Field 4hr';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_3_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 4;
MD(i).Env = 'Shock Box 4hr';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_4_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_08_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 1';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180208_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_08_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 1';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180208_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_09_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 2';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180209_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_09_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 2';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180209_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_15_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 7';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180215_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_15_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 7';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble3\20180215_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

Marble3(2) = i;

%% Eraser - Marble7
Marble7(1) = i+1;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_19_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field -2';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180319_1_openfield\imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_19_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box -2';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180319_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_20_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field -1';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180320_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_20_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box -1';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180320_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 0';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180321_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 0';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180321_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 3;
MD(i).Env = 'Square Open Field 4hr';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180321_3_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_21_2018';
MD(i).Session = 4;
MD(i).Env = 'Shock Box 4hr';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180321_4_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_22_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 1';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180322_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_22_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 1';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180322_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_23_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 2';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180323_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_23_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 2';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180323_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_28_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 7';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180328_1_openfield\Imaging';
end
MD(i).Notes = [];
MD(i).Pix2CM = 0.27;

i = i+1;
MD(i).Animal = 'Marble7';
MD(i).Date = '03_28_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 7';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\Eraser\Marble7\20180328_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';
MD(i).Pix2CM = 0.0969;

Marble7(2) = i;

%% Compile session_ref

session_ref.G30 = G30;
session_ref.G31 = G31;
session_ref.G41 = G41;
session_ref.G44 = G44;
session_ref.G45 = G45;
session_ref.G46 = G46;
session_ref.G48 = G48;
session_ref.Marble3 = Marble3;
session_ref.Marble7 = Marble7;

%%
save MasterDirectory.mat MD;

cd(CurrDir);