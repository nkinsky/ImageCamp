%% Alternation reference
% File listing alternation sessions by mouse.
MD = MakeMouseSessionListNK('Nat');
clear G30_alt G31_alt G45_alt G48_alt alt_all alt_all_cell

j = 1; 
% G30_start = '10_16_2014';
G30_start = '10_17_2014';
% G30_alt(j).Date = '10_28_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '10_17_2014'; G30_alt(j).Session = 1; j = j+1; % Loop + forced
G30_alt(j).Date = '10_21_2014'; G30_alt(j).Session = 1; j = j+1; % Loop + forced
G30_alt(j).Date = '10_23_2014'; G30_alt(j).Session = 1; j = j+1; % Loop + forced
G30_alt(j).Date = '10_28_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '10_30_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '10_31_2014'; G30_alt(j).Session = 1; j = j+1; % forced part
G30_alt(j).Date = '10_31_2014'; G30_alt(j).Session = 2; j = j+1;
G30_alt(j).Date = '11_04_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_06_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_07_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_10_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_11_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_12_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_13_2014'; G30_alt(j).Session = 1; j = j+1;
[G30_alt(:).Animal] = deal('GCamp6f_30');

j = 1; 
G31_start = '11_24_2014';
% G31_alt(j).Date = '11_24_2014'; G31_alt(j).Session = 1; j = j+1; % Acclimation (free roaming) no good lap data
G31_alt(j).Date = '11_25_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '11_26_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_02_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_03_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_04_2014'; G31_alt(j).Session = 1; j = j+1;
% G31_alt(j).Date = '12_04_2014'; G31_alt(j).Session = 1; j = j+1; % Bad imaging plane
G31_alt(j).Date = '12_11_2014'; G31_alt(j).Session = 1; j = j+1;
[G31_alt(:).Animal] = deal('GCamp6f_31'); 

j = 1;
G45_start = '09_08_2015';
G45_alt(j).Date = '09_08_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_09_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_10_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_10_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_11_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_11_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_15_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_15_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_16_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_17_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_17_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_18_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_18_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_19_2015'; G45_alt(j).Session = 1; j = j+1; 
G45_alt(j).Date = '09_22_2015'; G45_alt(j).Session = 1; j = j+1; 
G45_alt(j).Date = '09_23_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_23_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_24_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_24_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_29_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_30_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_30_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '10_01_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '10_01_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '10_02_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '10_03_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '10_07_2015'; G45_alt(j).Session = 1; j = j+1;
[G45_alt(:).Animal] = deal('GCamp6f_45'); 
 
j = 1; 
G48_start = '09_10_2015';
G48_alt(j).Date = '09_10_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_11_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_15_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_15_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '09_16_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '09_17_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_17_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '09_18_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_18_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '09_19_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_22_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_23_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_23_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '09_24_2015'; G48_alt(j).Session = 1; j = j+1;
% G48_alt(j).Date = '09_24_2015'; G48_alt(j).Session = 2; j = j+1; % No pos file!!
G48_alt(j).Date = '09_29_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '09_30_2015'; G48_alt(j).Session = 1; j = j+1;
% G48_alt(j).Date = '10_01_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_01_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_01_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_02_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_02_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
% G48_alt(j).Date = '10_02_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_03_2015'; G48_alt(j).Session = 1; j = j+1; % All Forced
G48_alt(j).Date = '10_06_2015'; G48_alt(j).Session = 1; j = j+1; % All Forced
G48_alt(j).Date = '10_06_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_06_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_07_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_07_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
% G48_alt(j).Date = '10_07_2015'; G48_alt(j).Session = 2; j = j+1; forced->free->forced
G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 3; j = j+1; % forced part
% G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 2; j = j+1; no T4
G48_alt(j).Date = '10_09_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_09_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_09_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_09_2015'; G48_alt(j).Session = 4; j = j+1; % Forced part
G48_alt(j).Date = '10_10_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_10_2015'; G48_alt(j).Session = 2; j = j+1; % Forced part
G48_alt(j).Date = '10_12_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_12_2015'; G48_alt(j).Session = 2; j = j+1; % Forced part
G48_alt(j).Date = '10_13_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_13_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_13_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_13_2015'; G48_alt(j).Session = 4; j = j+1; % Forced part
G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
% Bad frames need to be corrected for 10/14 #2 - include when done
% G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 2; j = j+1; 
% G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 1; j = j+1; % Session 1 super distracted
G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 4; j = j+1; % Forced part
[G48_alt(:).Animal] = deal('GCamp6f_48'); 

alt_all_cell{1} = G30_alt; alt_all_cell{2} = G31_alt; %Parsed out by mouse
alt_all_cell{3} = G45_alt; alt_all_cell{4} = G48_alt;
alt_all = cat(2,alt_all_cell{:}); % All together
alt_all = complete_MD(alt_all);