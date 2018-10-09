%% Alternation reference
% File listing alternation sessions by mouse.
[MD, ref] = MakeMouseSessionListNK('Nat');
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
G30_alt(j).Date = '10_31_2014'; G30_alt(j).Session = 1; j = j+1; 
G30_alt(j).Date = '10_31_2014'; G30_alt(j).Session = 2; j = j+1; % Forced part
G30_alt(j).Date = '11_04_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_06_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_07_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_10_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_11_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_12_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_13_2014'; G30_alt(j).Session = 1; j = j+1;
[G30_alt(:).Animal] = deal('GCamp6f_30');
G30_alt = complete_MD(G30_alt);
[G30_loop_bool, G30_forced_bool] = alt_id_sesh_type(G30_alt);
G30_free_bool = ~G30_forced_bool & ~G30_loop_bool;

j = 1; 
G31_start = '11_25_2014';
% G31_alt(j).Date = '11_24_2014'; G31_alt(j).Session = 1; j = j+1; % Acclimation (free roaming) no good lap data
G31_alt(j).Date = '11_25_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '11_26_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_02_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_03_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_04_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_05_2014'; G31_alt(j).Session = 1; j = j+1;
% G31_alt(j).Date = '12_08_2014'; G31_alt(j).Session = 1; j = j+1; % Bad imaging plane
G31_alt(j).Date = '12_11_2014'; G31_alt(j).Session = 1; j = j+1;
[G31_alt(:).Animal] = deal('GCamp6f_31');
G31_alt = complete_MD(G31_alt);
[G31_loop_bool, G31_forced_bool] = alt_id_sesh_type(G31_alt);
G31_free_bool = ~G31_forced_bool & ~G31_loop_bool;

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
% G45_alt(j).Date = '09_29_2015'; G45_alt(j).Session = 1; j = j+1; % exclude - bad registration
G45_alt(j).Date = '09_30_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_30_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '10_01_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '10_01_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '10_02_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '10_03_2015'; G45_alt(j).Session = 1; j = j+1;
% G45_alt(j).Date = '10_06_2015'; G45_alt(j).Session = 1; j = j+1; % don't include: imaging/tracking drift
G45_alt(j).Date = '10_07_2015'; G45_alt(j).Session = 1; j = j+1;
[G45_alt(:).Animal] = deal('GCamp6f_45');
G45_alt = complete_MD(G45_alt);
[G45_loop_bool, G45_forced_bool] = alt_id_sesh_type(G45_alt);
G45_free_bool = ~G45_forced_bool & ~G45_loop_bool;
 
j = 1; 
G48_start = '09_10_2015';
G48_alt(j).Date = '09_10_2015'; G48_alt(j).Session = 1; j = j+1; % Loop left->right
G48_alt(j).Date = '09_11_2015'; G48_alt(j).Session = 1; j = j+1; % Loop right->left
G48_alt(j).Date = '09_15_2015'; G48_alt(j).Session = 1; j = j+1; % Loop right->left
G48_alt(j).Date = '09_15_2015'; G48_alt(j).Session = 2; j = j+1; % Loop left->right
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
% G48_alt(j).Date = '10_02_2015'; G48_alt(j).Session = 2; j = j+1; % Too weird to include: free with correction
G48_alt(j).Date = '10_03_2015'; G48_alt(j).Session = 1; j = j+1; % All Forced
G48_alt(j).Date = '10_06_2015'; G48_alt(j).Session = 1; j = j+1; % All Forced
G48_alt(j).Date = '10_06_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_06_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_07_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_07_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
% G48_alt(j).Date = '10_07_2015'; G48_alt(j).Session = 2; j = j+1; % too weird: forced->free->forced
G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_08_2015'; G48_alt(j).Session = 4; j = j+1; % Forced part
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
% G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 1; j = j+1;
% G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 2; j = j+1; 
G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 4; j = j+1; % Forced part
% G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 1; j = j+1; % Session 1 super distracted
G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 1; j = j+1; % Low cell #, bad sesh?
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 3; j = j+1; % Forced part - low cell #, bad sesh?

G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 4; j = j+1; % Forced part
[G48_alt(:).Animal] = deal('GCamp6f_48'); 
G48_alt = complete_MD(G48_alt);
[G48_loop_bool, G48_forced_bool] = alt_id_sesh_type(G48_alt);
G48_free_bool = ~G48_forced_bool & ~G48_loop_bool;

alt_all_cell{1} = G30_alt; alt_all_cell{2} = G31_alt; %Parsed out by mouse
alt_all_cell{3} = G45_alt; alt_all_cell{4} = G48_alt;
alt_all = cat(2,alt_all_cell{:}); % All together
alt_all = complete_MD(alt_all);

%% G48 is complicated since the field of view moves a few times over the 1.5
% months. Below lists the registrations for the 4 good chunks of data. Very
% conservative.
G48_alt_nf = G48_alt(~G48_forced_bool); %  get non-forced sessions
G48_alt2 = G48_alt_nf(2:9);
G48_alt3 = G48_alt_nf(3:13);
G48_alt4 = G48_alt_nf(12:16);
G48_alt5 = G48_alt_nf(18:30);