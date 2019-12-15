%% Alternation reference
% File listing alternation sessions by mouse.

% Load database - assume BU desktop or Nat's laptop only
if strcmpi('natlaptop', getenv('COMPUTERNAME'))
    [MD, ref, ref2] = MakeMouseSessionListEraser('natlaptop');
else
    [MD, ref] = MakeMouseSessionListEraser('Nat');
end
alt_test_session(1) = G30_alt(end);
alt_test_session(2) = G31_alt(4);
alt_test_session(3) = G45_alt(20);
alt_test_session(4) = G48_alt(11);
clear G30_alt G30loop_alt G31_alt G45_alt G48_alt alt_all alt_all_cell

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

% G30 looping and forced sessions broken out separately since this was done at the
% final stages of analysis and I didn't want to break any code written much
% earlier. Note that G48 was broken out earlier in analysis and is handled
% differently
G30loop_alt(1).Date = '10_17_2014'; G30loop_alt(1).Session = 2; % Loop only
G30loop_alt(2).Date = '10_21_2014'; G30loop_alt(2).Session = 2; % Loop only
G30loop_alt(3).Date = '10_23_2014'; G30loop_alt(3).Session = 2; % Loop only
[G30loop_alt(:).Animal] = deal('GCamp6f_30');
G30loop_alt = complete_MD(G30loop_alt);

G30forced_alt(1).Date = '10_17_2014'; G30forced_alt(1).Session = 3; % forced only
G30forced_alt(2).Date = '10_21_2014'; G30forced_alt(2).Session = 3; % forced only
G30forced_alt(3).Date = '10_23_2014'; G30forced_alt(3).Session = 3; % forced only
[G30forced_alt(:).Animal] = deal('GCamp6f_30');
G30forced_alt = complete_MD(G30forced_alt);

j = 1; 
G31_start = '11_25_2014';
% G31_alt(j).Date = '11_24_2014'; G31_alt(j).Session = 1; j = j+1; % Acclimation (free roaming) no good lap data
G31_alt(j).Date = '11_25_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '11_26_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_02_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_03_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_04_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_05_2014'; G31_alt(j).Session = 1; j = j+1;

%%% Could use the below for behavioral tracking only!!!
% G31_alt(j).Date = '12_08_2014'; G31_alt(j).Session = 1; j = j+1; % Bad imaging plane
% G31_alt(j).Date = '12_09_2014'; G31_alt(j).Session = 1; j = j+1;
% G31_alt(j).Date = '12_10_2014'; G31_alt(j).Session = 1; j = j+1;

G31_alt(j).Date = '12_11_2014'; G31_alt(j).Session = 1; j = j+1;
[G31_alt(:).Animal] = deal('GCamp6f_31');
G31_alt = complete_MD(G31_alt);
[G31_loop_bool, G31_forced_bool] = alt_id_sesh_type(G31_alt);
G31_free_bool = ~G31_forced_bool & ~G31_loop_bool;

%%% G31 behavior only!
j = 1; 
G31behavior_start = '11_25_2014';
% G31_alt(j).Date = '11_24_2014'; G31_alt(j).Session = 1; j = j+1; % Acclimation (free roaming) no good lap data
G31behavior_alt(j).Date = '11_25_2014'; G31behavior_alt(j).Session = 1; j = j+1;
G31behavior_alt(j).Date = '11_26_2014'; G31behavior_alt(j).Session = 1; j = j+1;
G31behavior_alt(j).Date = '12_02_2014'; G31behavior_alt(j).Session = 1; j = j+1;
G31behavior_alt(j).Date = '12_03_2014'; G31behavior_alt(j).Session = 1; j = j+1;
G31behavior_alt(j).Date = '12_04_2014'; G31behavior_alt(j).Session = 1; j = j+1;
G31behavior_alt(j).Date = '12_05_2014'; G31behavior_alt(j).Session = 1; j = j+1;

%%% For behavioral tracking only - bad imaging data!!!
G31behavior_alt(j).Date = '12_08_2014'; G31behavior_alt(j).Session = 1; j = j+1; % Bad imaging plane
G31behavior_alt(j).Date = '12_09_2014'; G31behavior_alt(j).Session = 1; j = j+1;

%%% Need tracking correction! %%%
G31behavior_alt(j).Date = '12_10_2014'; G31behavior_alt(j).Session = 1; j = j+1;

G31behavior_alt(j).Date = '12_11_2014'; G31behavior_alt(j).Session = 1; j = j+1;

%%% Need tracking correction! %%%
G31behavior_alt(j).Date = '12_12_2014'; G31behavior_alt(j).Session = 1; j = j+1;

[G31behavior_alt(:).Animal] = deal('GCamp6f_31');
G31behavior_alt = complete_MD(G31behavior_alt);
[G31behavior_loop_bool, G31behavior_forced_bool] = alt_id_sesh_type(G31behavior_alt);
G31behavior_free_bool = ~G31behavior_forced_bool & ~G31behavior_loop_bool;

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

% G45 has two good chunks of sessions that register well together, listed
% here
G45_alt1 = G45_alt(1:16);
G45_alt2 = G45_alt(17:end);
 
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

% Create another cell with G30loop and G30forced split out
alt_all_cell_G30split = alt_all_cell;
alt_all_cell_G30split{5} = G30loop_alt; alt_all_cell_G30split{6} = G30forced_alt;
alt_all = cat(2,alt_all_cell{:}); % All together
alt_all = complete_MD(alt_all);
[alt_all_loop_bool, alt_all_forced_bool] = alt_id_sesh_type(alt_all);
alt_all_free_bool = ~alt_all_forced_bool & ~alt_all_loop_bool;

% Create alt_all for behavior including behavior but bad imaging sessions
% from G31
alt_all_behavior_cell{1} = G30_alt; alt_all_behavior_cell{2} = G31behavior_alt;
alt_all_behavior_cell{3} = G45_alt; alt_all_behavior_cell{4} = G48_alt;

alt_all_behavior = cat(2, alt_all_behavior_cell{:});
alt_all_behavior = complete_MD(alt_all_behavior);

alt_all_free_boolc{1} = G30_free_bool;
alt_all_free_boolc{2} = G31_free_bool;
alt_all_free_boolc{3} = G45_free_bool;
alt_all_free_boolc{4} = G48_free_bool;

% sp cell splits out G45 and G48 sessions into halves corresponding to when
% I get good registration between sessions
alt_all_cell_sp{1} = G30_alt; alt_all_cell_sp{2} = G31_alt; %Parsed out by mouse
alt_all_cell_sp{3} = G45_alt(1:14); 
% Exclude session 15 - tons of new cells seem to pop up for there...
% alt_all_cell_sp{3} = G45_alt(1:15); 
alt_all_cell_sp{4} = G45_alt(16:end); 
% Exclude session 16 - tons of new cells seem to pop up for there...
alt_all_cell_sp{5} = G48_alt(1:15); 
% alt_all_cell_sp{5} = G48_alt(1:16); 
alt_all_cell_sp{6} = G48_alt(17:end);

alt_all_free_boolc_sp{1} = G30_free_bool;
alt_all_free_boolc_sp{2} = G31_free_bool;
alt_all_free_boolc_sp{3} = G45_free_bool(1:14);
alt_all_free_boolc_sp{4} = G45_free_bool(16:end);
alt_all_free_boolc_sp{5} = G48_free_bool(1:15);
alt_all_free_boolc_sp{6} = G48_free_bool(17:end);

%% Set up learning stage data - sessions are when each stage ends! Based on
% normalizing each mouse's smoothed learning curve (4 session window) and
% looking for sections in bottom 3rd(early), middle 3rd(middle), and top
% 3rd (late). Below is last session in each group!
learning_stage_ends(1,1) = G30_alt(6); learning_stage_ends(1,2) = G30_alt(9);
learning_stage_ends(1,3) = G30_alt(end);
learning_stage_ends(2,1) = G31_alt(4); learning_stage_ends(2,2) = G31_alt(4);
learning_stage_ends(2,3) = G31_alt(end);
learning_stage_ends(3,1) = G45_alt(6); learning_stage_ends(3,2) = G45_alt(15);
learning_stage_ends(3,3) = G45_alt(end);
learning_stage_ends(4,1) = G48_alt(9); learning_stage_ends(4,2) = G48_alt(31);
learning_stage_ends(4,3) = G48_alt(end-1);

%% Set up learning data but with G45 and G48 split into two groups to match
% alt_all_cell_sp above!

learning_stage_ends_sp(1,1) = G30_alt(6); learning_stage_ends_sp(1,2) = G30_alt(9);
learning_stage_ends_sp(1,3) = G30_alt(end);
learning_stage_ends_sp(2,1) = G31_alt(4); learning_stage_ends_sp(2,2) = G31_alt(4);
learning_stage_ends_sp(2,3) = G31_alt(end);
learning_stage_ends_sp(3,1) = G45_alt(6); learning_stage_ends_sp(3,2) = G45_alt(15);
learning_stage_ends_sp(3,3) = G45_alt(end);
learning_stage_ends_sp(4,1) = G45_alt(6); learning_stage_ends_sp(4,2) = G45_alt(15);
learning_stage_ends_sp(4,3) = G45_alt(end);
learning_stage_ends_sp(5,1) = G48_alt(9); learning_stage_ends_sp(5,2) = G48_alt(31);
learning_stage_ends_sp(5,3) = G48_alt(end-1);
learning_stage_ends_sp(6,1) = G48_alt(9); learning_stage_ends_sp(6,2) = G48_alt(31);
learning_stage_ends_sp(6,3) = G48_alt(end-1);

%% G48 is complicated since the field of view moves a few times over the 1.5
% months. Below lists the registrations for the 4 good chunks of data. Very
% conservative.
% G48_alt_nf = G48_alt(~G48_forced_bool); %  get non-forced sessions
% % G48_alt2 = G48_alt_nf(2:9);
% % G48_alt3 = G48_alt_nf(3:13);
% % G48_alt4 = G48_alt_nf(12:16);
% % G48_alt5 = G48_alt_nf(18:30);

% Above is super-conservative. Below is better - two good chunks that
% register pretty well together.
G48_alt1 = G48_alt(1:15);
G48_alt2 = G48_alt(16:end);
