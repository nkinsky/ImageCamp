function [MD, session_ref] = MakeMouseSessionList_FC(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types, and currently are:
%   'G31_2env', 'G30_alternation'

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

%% Start G35
G35.all(1) = 1;

i = 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 1\1 - Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 1\2 - Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 1\3 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 1\4 - Control 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 1\5 - Shock 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 2\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 2\2 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_08_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 8\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G35';
MD(i).Date = '12_08_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G35\Day 8\2 - Shock';
end
MD(i).Notes = [];

G35.all(2) = i;

%% Start G36
G36.all(1) = i+1;

i = i+1;
MD(i).Animal = 'G36';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 1\1 - Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 1\2 - Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 1\3 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 1\4 - Control 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 1\5 - Shock 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 2\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 2\2 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_08_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 8\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G36';
MD(i).Date = '12_08_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G36\Day 8\2 - Shock';
end
MD(i).Notes = [];

G36.all(2) = i;

%% Start G40
G40.all(1) = i+1;

i = i+1;
MD(i).Animal = 'G40';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 1\1 - Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 1\2 - Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 1\3 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 1\4 - Control 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 1\5 - Shock 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 2\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 2\2 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_08_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 8\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G40';
MD(i).Date = '12_08_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G40\Day 8\2 - Shock';
end
MD(i).Notes = [];

G40.all(2) = i;

%% Start G41
G41.all(1) = i+1;

i = i+1;
MD(i).Animal = 'G41';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 1\Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 1\Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 1\Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 1\Control 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 1\Shock 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 2\Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 2\Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_08_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 8\Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G41';
MD(i).Date = '12_08_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G41\Day 8\Shock';
end
MD(i).Notes = [];

G41.all(2) = i;

%% Start G44
G44.all(1) = i+1;

i = i+1;
MD(i).Animal = 'G44';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 1\Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G44';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 1\Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G44';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 1\Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G44';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 1\Control 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G44';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 1\Shock 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G44';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 2\Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G44';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G44\Day 2\Shock';
end
MD(i).Notes = [];

%% Start G46
G46.all(1) = i+1;

i = i+1;
MD(i).Animal = 'G46';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 1\1 - Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G46';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 1\2 - Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G46';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 1\3 - Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G46';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 1\4 - Control 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G46';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 1\5 - Shock 4 hrs';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G46';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 2\1 - Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'G46';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\G46\Day 2\2 - Shock';
end
MD(i).Notes = [];

%% Start FC10
FC10.all(1) = i+1;

i = i+1;
MD(i).Animal = 'FC10';
MD(i).Date = '11_30_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Habituation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 0\Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '11_30_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Habituation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 1\Control';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_01_2015';
MD(i).Session = 1;
MD(i).Env = 'Shock Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 1\Shock baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Control Baseline';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 1\Control baseline';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Shock';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 1\Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Control 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 1\Control 4 hours';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_01_2015';
MD(i).Session = 5;
MD(i).Env = 'Shock 4 hrs';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 1\Shock 4 hours';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 2\Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 1 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 2\Shock';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_08_2015';
MD(i).Session = 1;
MD(i).Env = 'Control 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 8\Control';
end
MD(i).Notes = [];

i = i + 1;
MD(i).Animal = 'FC10';
MD(i).Date = '12_08_2015';
MD(i).Session = 2;
MD(i).Env = 'Shock 8 day';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Natlaptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\FC Pilot\FC10\Day 8\Shock';
end
MD(i).Notes = [];

FC10.all(2) = i;

%% Compile session_ref

session_ref.G35 = G35;
session_ref.G36 = G36;
session_ref.G40 = G40;
session_ref.G41 = G41;
session_ref.G44 = G44;
session_ref.G46 = G46;
    
%%
save MasterDirectory.mat MD;

cd(CurrDir);