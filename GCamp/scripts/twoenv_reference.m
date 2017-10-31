%% References for running 2env task
% botharenas_square = [1 2 7 8 9 12 13 14]; % [1 1 0 0 0 0 1 1 1 0 0 1 1 1 0 0];
% botharenas_oct = [ 3 4 5 6 10 11 15 16]; % [ 0 0 1 1 1 1 0 0 0 1 1 0 0 0 1 1];
% 
% G31_start = ref.G31.two_env(1); % start index in MD for G31
% G31_square_sesh = [0 1 6 7 8 11 12 13] + G31_start;
% G31_oct_sesh = [2 3 4 5 9 10 14 15] + G31_start;
% G31_manual_limits = [0 0 0 0 1 1 0 0];
% G31_rot = [0 1 0 1 0 1 0 1 0 0 1 1 0 1 0 1]; % Indices for all the sessions that were rotated
% G31_botharenas = [0:1:15] + G31_start;
% G31_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0];
% 
% G30_start = ref.G30.two_env(1);
% G30_square_sesh = [0 1 6 7 8 11 12 13] + G30_start;
% G30_oct_sesh = [2 3 4 5 9 10 14 15] + G30_start;
% G30_manual_limits = [0 0 0 0 1 1 0 0];
% G30_rot = [0 0 0 1 0 1 0 1 0 0 1 1 0 1 0 0]; % Indices for all the sessions that were rotated
% G30_botharenas = [0:1:15] + G30_start;
% G30_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0];
% 
% G45_start = ref.G45.twoenv(1);
% G45_square_sesh = [0 1 6 7 9 13 14 15] + G45_start;
% G45_oct_sesh = [2 3 4 5 10 12 16 17] + G45_start;
% G45_manual_limits = [0 0 0 0 1 1 0 0];
% G45_botharenas = [0:7 9 10 12 13 14:17] + G45_start;
% G45_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0];
% 
% G48_start = ref.G48.twoenv(1);
% G48_square_sesh = [0 1 6 7 8 11 12 13] + G48_start;
% G48_oct_sesh = [2 3 4 5 9 10 14 15] + G48_start;
% G48_manual_limits = [0 0 0 0 1 1 0 0];
% G48_botharenas = [0:1:15] + G48_start;
% G48_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0];

%% G30
G30_square(1).Date = '11_19_2014'; G30_square(1).Session = 1;
G30_square(2).Date = '11_19_2014'; G30_square(2).Session = 2;
G30_square(3).Date = '11_22_2014'; G30_square(3).Session = 1;
G30_square(4).Date = '11_22_2014'; G30_square(4).Session = 2;
G30_square(5).Date = '11_23_2014'; G30_square(5).Session = 1;
G30_square(6).Date = '11_24_2014'; G30_square(6).Session = 2;
G30_square(7).Date = '11_25_2014'; G30_square(7).Session = 1;
G30_square(8).Date = '11_25_2014'; G30_square(8).Session = 2;
[G30_square(:).Animal] = deal('GCamp6f_30');

G30_oct(1).Date = '11_20_2014'; G30_oct(1).Session = 1;
G30_oct(2).Date = '11_20_2014'; G30_oct(2).Session = 2;
G30_oct(3).Date = '11_21_2014'; G30_oct(3).Session = 1;
G30_oct(4).Date = '11_21_2014'; G30_oct(4).Session = 2;
G30_oct(5).Date = '11_23_2014'; G30_oct(5).Session = 2;
G30_oct(6).Date = '11_24_2014'; G30_oct(6).Session = 1;
G30_oct(7).Date = '11_26_2014'; G30_oct(7).Session = 1;
G30_oct(8).Date = '11_26_2014'; G30_oct(8).Session = 2;
[G30_oct(:).Animal] = deal('GCamp6f_30');

G30_manual_limits = [0 0 0 0 1 1 0 0];
G30_botharenas = cat(2,G30_square, G30_oct);
G30_botharenas = G30_botharenas([1 2 9 10 11 12 3 4 5 13 14 6 7 8 15 16]);
G30_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0];

% Note that 0 = local cues aligned
G30_square_best_angle = [0 0 270 0 0 270 0 180]; % Note only session 6 looks sketchy/global remappery (still probably legit though)
G30_circle_best_angle = [0 165 0 0 60 285 150 150]; % All good except session 5 - global remapping?
G30_circ2square_best_angle = [300 105 300 300 30 240 105 90]; % Note all but session 5 have good mapping between circle and square
G30_both_best_angle = [0 0 300 105 300 300 270 0 0 30 240 270 0 180 105 90];

% Hack to quantify global remapping!!! - Need to run kstest2 between each
% session with a Bonferroni correction for 7(8)
% (square/circle(circ2square)) between correlations and shuffled
% correlations
G30_square_global_remap = [0 0 0 0 0 1 0 0];
G30_circle_global_remap = [0 0 0 0 1 0 0 0];

%% G31
G31_square(1).Date = '12_15_2014'; G31_square(1).Session = 1;
G31_square(2).Date = '12_15_2014'; G31_square(2).Session = 2;
G31_square(3).Date = '12_18_2014'; G31_square(3).Session = 1;
G31_square(4).Date = '12_18_2014'; G31_square(4).Session = 2;
G31_square(5).Date = '12_19_2014'; G31_square(5).Session = 1;
G31_square(6).Date = '12_20_2014'; G31_square(6).Session = 2;
G31_square(7).Date = '12_21_2014'; G31_square(7).Session = 1;
G31_square(8).Date = '12_21_2014'; G31_square(8).Session = 2;
[G31_square(:).Animal] = deal('GCamp6f_31');

G31_oct(1).Date = '12_16_2014'; G31_oct(1).Session = 1;
G31_oct(2).Date = '12_16_2014'; G31_oct(2).Session = 2;
G31_oct(3).Date = '12_17_2014'; G31_oct(3).Session = 1;
G31_oct(4).Date = '12_17_2014'; G31_oct(4).Session = 2;
G31_oct(5).Date = '12_19_2014'; G31_oct(5).Session = 2;
G31_oct(6).Date = '12_20_2014'; G31_oct(6).Session = 1;
G31_oct(7).Date = '12_22_2014'; G31_oct(7).Session = 1;
G31_oct(8).Date = '12_22_2014'; G31_oct(8).Session = 2;
[G31_oct(:).Animal] = deal('GCamp6f_31');

G31_manual_limits = [0 0 0 0 1 1 0 0];
G31_botharenas = cat(2,G31_square, G31_oct);
G31_botharenas = G31_botharenas([1 2 9 10 11 12 3 4 5 13 14 6 7 8 15 16]);
G31_both_manual_limits = [0 0 0 1 0 0 0 0 1 1 1 1 0 0 0 0]; 

G31_square_best_angle = [0 0 0 0 0 180 0 0]; % Session 8 (and maybe 7) might be remappers, though it may just be the low number of cells...
G31_circle_best_angle = [0 0 0 0 0 195 0 15]; % Session 6 appears to be a global remapping 
G31_circ2square_best_angle = [15 15 15 30 30 210 15 210]; % Note that only sessions 3 and 4 appear to have circ2square mapping - very low numbers of cells active between the two environments...
G31_both_best_angle = [0 0 15 15 15 30 0 0 0 30 210 180 0 0 15 210];
%% G45
G45_square(1).Date = '08_28_2015'; G45_square(1).Session = 1;
G45_square(2).Date = '08_28_2015'; G45_square(2).Session = 2;
G45_square(3).Date = '08_31_2015'; G45_square(3).Session = 1;
G45_square(4).Date = '08_31_2015'; G45_square(4).Session = 2;
G45_square(5).Date = '09_01_2015'; G45_square(5).Session = 2;
G45_square(6).Date = '09_02_2015'; G45_square(6).Session = 3;
G45_square(7).Date = '09_03_2015'; G45_square(7).Session = 1;
G45_square(8).Date = '09_03_2015'; G45_square(8).Session = 2;
[G45_square(:).Animal] = deal('GCamp6f_45');

G45_oct(1).Date = '08_29_2015'; G45_oct(1).Session = 1;
G45_oct(2).Date = '08_29_2015'; G45_oct(2).Session = 2;
G45_oct(3).Date = '08_30_2015'; G45_oct(3).Session = 1;
G45_oct(4).Date = '08_30_2015'; G45_oct(4).Session = 2;
G45_oct(5).Date = '09_01_2015'; G45_oct(5).Session = 3;
G45_oct(6).Date = '09_02_2015'; G45_oct(6).Session = 2;
G45_oct(7).Date = '09_04_2015'; G45_oct(7).Session = 1;
G45_oct(8).Date = '09_04_2015'; G45_oct(8).Session = 2;
[G45_oct(:).Animal] = deal('GCamp6f_45');

G45_manual_limits = [0 0 0 0 1 1 0 0];
G45_botharenas = cat(2,G45_square, G45_oct);
G45_botharenas = G45_botharenas([1 2 9 10 11 12 3 4 5 13 14 6 7 8 15 16]);
G45_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0];

G45_square_best_angle = [0 180 0 0 0 0 270 0];
G45_circle_best_angle = [0 15 0 0 15 15 345 330];
G45_circ2square_best_angle = [0 15 0 345 0 0 345 330]; % All sessions have mapping between arenas
G45_both_best_angle = [0 180 0 15 0 345 0 0 0 0 0 0 270 0 345 330];

%% G48
G48_square(1).Date = '08_29_2015'; G48_square(1).Session = 1;
G48_square(2).Date = '08_29_2015'; G48_square(2).Session = 2;
G48_square(3).Date = '09_01_2015'; G48_square(3).Session = 1;
G48_square(4).Date = '09_01_2015'; G48_square(4).Session = 2;
G48_square(5).Date = '09_02_2015'; G48_square(5).Session = 1;
G48_square(6).Date = '09_03_2015'; G48_square(6).Session = 2;
G48_square(7).Date = '09_04_2015'; G48_square(7).Session = 1;
G48_square(8).Date = '09_04_2015'; G48_square(8).Session = 2;
[G48_square(:).Animal] = deal('GCamp6f_48');

G48_oct(1).Date = '08_30_2015'; G48_oct(1).Session = 1;
G48_oct(2).Date = '08_30_2015'; G48_oct(2).Session = 2;
G48_oct(3).Date = '08_31_2015'; G48_oct(3).Session = 1;
G48_oct(4).Date = '08_31_2015'; G48_oct(4).Session = 2;
G48_oct(5).Date = '09_02_2015'; G48_oct(5).Session = 2;
G48_oct(6).Date = '09_03_2015'; G48_oct(6).Session = 1;
G48_oct(7).Date = '09_05_2015'; G48_oct(7).Session = 1;
G48_oct(8).Date = '09_05_2015'; G48_oct(8).Session = 2;
[G48_oct(:).Animal] = deal('GCamp6f_48');

G48_manual_limits = [0 0 0 0 1 1 0 0];
G48_botharenas = cat(2,G48_square, G48_oct);
G48_botharenas = G48_botharenas([1 2 9 10 11 12 3 4 5 13 14 6 7 8 15 16]);
G48_both_manual_limits = [0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0]; %%% Is this correct?  Manual limits on 1st square session?

G48_square_best_angle = [0 180 0 0 90 90 180 90]; % All look good
G48_circle_best_angle = [0 120 0 330 0 330 0 45]; % Session 3 and 4 appear to be global remappers
G48_circ2square_best_angle = [105 240 105 75 90 75 90 150]; % Note that sessions 3,4, and 7 appear sketchy (no mapping between arenas)
G48_both_best_angle = [0 180 105 240 105 75 0 0 90 90 75 90 180 90 90 150];
%% All sessions
all_sessions = cat(2,G30_botharenas, G31_botharenas, G45_botharenas, G48_botharenas);
all_square = cat(2,G30_square,G31_square,G45_square,G48_square);
all_oct = cat(2,G30_oct,G31_oct,G45_oct,G48_oct);
square_days = [ 1 1 4 4 5 6 7 7];
circle_days = [2 2 3 3 5 6 8 8];
all_days = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8];
bw_sesh.before = [1 1 1 1 2 2 2 2 7 7 7 7 8 8 8 8; ...
                  3 4 5 6 3 4 5 6 3 4 5 6 3 4 5 6]'; % Session indices for comparisons between square/circle before connection
bw_sesh.during = [ 9  9  12 12;...
                   10 11 10 11]';
bw_sesh.after = [ 13 13 14 14; ...
                  15 16 15 16]';
         
bw_sesh2.before = [1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4; ...
                   1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4]';
bw_sesh2.during = [5 5 6 6 ; ... 
                   5 6 5 6]';
bw_sesh2.after = [7 7 8 8 ; ...
                  7 8 7 8]';

time_comp = {'before','during','after'};
for j = 1:length(time_comp)
    bw_sesh.(time_comp{j}) = sort(bw_sesh.(time_comp{j}),2);
end

%% Check script
sesh_check = G48_square;
fo_exist = false(1,length(sesh_check));
min_exist = false(1,length(sesh_check));
pf_exist = false(1,length(sesh_check));
for j = 1:length(sesh_check) 
    dirstr = ChangeDirectory(sesh_check(j).Animal, sesh_check(j).Date, ...
        sesh_check(j).Session,0); 
    disp(dirstr);
    fo_exist(j) = exist(fullfile(dirstr,'FinalOutput.mat'),'file');
    min_exist(j) = exist(fullfile(dirstr,'ICmovie_min_proj.tif'),'file');
    pf_exist(j) = exist(fullfile(dirstr,'Placefields.mat'),'file');
    
end
