% Better categorization of each mouse's session indices
%1st column = 1/2 (square/octagon), 2nd column = 1st sesh, 3rd column = 2nd
%sesh
% _conflict = conflict between local and distal cues (sessions are rotated
% relative to one another)
% _aligned = no conflict between local and distal cues (sessions are NOT
% rotated relative to one another)

sameday_ind = [1 2; 3 4; 5 nan; 6 nan; 7 8]; % session indices that occur on the same day

% G30
before_win_conflict{1} = [ 1 1 4; 1 2 4; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_aligned{1} = [ 1 1 2; 1 1 3; 1 2 3; 2 1 3];

after_win_conflict{1} = [1 7 8];
after_win_aligned{1} = [2 7 8];

before_after_conflict{1} = [1 1 8; 1 2 8; 1 3 8; 1 4 7; 1 4 8; 2 2 7; 2 2 8; 2 4 7; 2 4 8];
before_after_aligned{1} = [1 1 7; 1 2 7; 1 3 7; 2 1 7; 2 1 8; 2 3 7; 2 3 8];

before_5_conflict{1} = [ 1 4 5; 2 2 5; 2 4 5];
before_5_aligned{1} = [ 1 1 5; 1 2 5; 1 3 5; 2 1 5; 2 3 5];

before_6_conflict{1} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_aligned{1} = [];

after_5_conflict{1} = [1 5 8];
after_5_aligned{1} = [1 5 7; 2 5 7; 2 5 8];

after_6_conflict{1} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_aligned{1} = [];

conn1_conn2_conflict{1} = [1 5 6; 2 5 6];
conn1_conn2_aligned{1} = [];

% G31
before_win_conflict{2} = [1 1 2; 1 1 4; 1 2 3; 1 2 4; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_aligned{2} = [ 1 1 3; 2 1 3];

after_win_conflict{2} = [1 7 8; 2 7 8];
after_win_aligned{2} = [];

before_after_conflict{2} = [1 1 8; 1 2 7; 1 2 8; 1 3 8; 1 4 7; 2 1 8; 2 2 7; 2 2 8; 2 3 8; 2 4 7];
before_after_aligned{2} = [1 1 7; 1 3 7; 1 4 8; 2 1 7; 2 3 7; 2 4 8];

before_5_conflict{2} = [1 2 5; 1 4 5; 2 2 5; 2 4 5];
before_5_aligned{2} = [ 1 1 5; 1 3 5; 2 1 5; 2 3 5];

before_6_conflict{2} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_aligned{2} = [];

after_5_conflict{2} = [1 5 8; 2 5 8];
after_5_aligned{2} = [1 5 7; 2 5 7];

after_6_conflict{2} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_aligned{2} = [];

conn1_conn2_conflict{2} = [1 5 6; 2 5 6];
conn1_conn2_aligned{2} = [];

% G45
before_win_conflict{3} = [1 1 2; 1 1 4; 1 2 3; 1 2 4; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_aligned{3} = [ 1 1 3; 2 1 3];

after_win_conflict{3} = [1 7 8; 2 7 8];
after_win_aligned{3} = [];

before_after_conflict{3} = [1 1 8; 1 2 7; 1 3 8; 1 4 7; 2 1 8; 2 2 7; 2 2 8; 2 3 8; 2 4 7];
before_after_aligned{3} = [1 1 7; 1 2 8; 1 3 7; 1 4 8; 2 1 7; 2 3 7; 2 4 8];

before_5_conflict{3} = [1 2 5; 1 4 5; 2 2 5; 2 4 5];
before_5_aligned{3} = [ 1 1 5; 1 3 5; 2 1 5; 2 3 5];

before_6_conflict{3} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_aligned{3} = [];

after_5_conflict{3} = [1 5 8; 2 5 8];
after_5_aligned{3} = [1 5 7; 2 5 7];

after_6_conflict{3} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_aligned{3} = [];

conn1_conn2_conflict{3} = [1 5 6; 2 5 6];
conn1_conn2_aligned{3} = [];

% G48

before_win_conflict{4} = [1 1 2; 1 1 4; 1 2 3; 1 2 4; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_aligned{4} = [ 1 1 3; 2 1 3];

after_win_conflict{4} = [1 7 8; 2 7 8];
after_win_aligned{4} = [];

before_after_conflict{4} = [1 1 8; 1 2 7; 1 2 8; 1 3 8; 1 4 7; 2 1 8; 2 2 7; 2 3 8; 2 4 7];
before_after_aligned{4} = [1 1 7; 1 3 7; 1 4 8; 2 1 7; 2 2 8; 2 3 7; 2 4 8];

before_5_conflict{4} = [1 2 5; 1 4 5; 2 2 5; 2 4 5];
before_5_aligned{4} = [ 1 1 5; 1 3 5; 2 1 5; 2 3 5];

before_6_conflict{4} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_aligned{4} = [];

after_5_conflict{4} = [1 5 8; 2 5 8];
after_5_aligned{4} = [1 5 7; 2 5 7];

after_6_conflict{4} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_aligned{4} = [];

conn1_conn2_conflict{4} = [1 5 6; 2 5 6];
conn1_conn2_aligned{4} = [];
%% Combine all

for j = 1:length(before_win_conflict)
   conflict_indices_all{j} = [before_win_conflict{j}; ...
       after_win_conflict{j}; before_after_conflict{j}; before_5_conflict{j}; ...
       before_6_conflict{j}; after_5_conflict{j}; after_6_conflict{j}; ...
       conn1_conn2_conflict{j}];
   aligned_indices_all{j} = [before_win_aligned{j}; ...
       after_win_aligned{j}; before_after_aligned{j}; before_5_aligned{j}; ...
       before_6_aligned{j}; after_5_aligned{j}; after_6_aligned{j}; 
       conn1_conn2_aligned{j}];
   % Combine all indices where the two environments are separate and both
   % the local and distal cues are aligned
   aligned_indices_separate_all{j} = [before_win_aligned{j}; ...
       after_win_aligned{j}; before_after_aligned{j}];
end

%% Time indices

time_index = [1 1 2 0; 1 1 3 3; 1 1 4 3; 1 1 5 4; 1 1 6 5; 1 1 7 6; 1 1 8 6;...
    1 2 3 3; 1 2 4 3; 1 2 5 4; 1 2 6 5; 1 2 7 6; 1 2 8 6; ...
    1 3 4 0; 1 3 5 1; 1 3 6 2; 1 3 7 3; 1 3 8 3; ...
    1 4 5 1; 1 4 6 2; 1 4 7 3; 1 4 8 3; 1 5 6 1; 1 5 7 2; 1 5 8 2; ...
    1 6 7 1; 1 6 8 1; 1 7 8 0; ...
    2 1 2 0 ; 2 1 3 1 ; 2 1 4 1 ; 2 1 5 3 ; 2 1 6 4 ; 2 1 7 6 ; 2 1 8 6 ; ...
    2 2 3 1 ; 2 2 4 1 ; 2 2 5 3 ; 2 2 6 4 ; 2 2 7 6 ; 2 2 8 6 ; ...
    2 3 4 0 ; 2 3 5 2 ; 2 3 6 3 ; 2 3 7 5 ; 2 3 8 5 ; ...
    2 4 5 2 ; 2 4 6 3 ; 2 4 7 5 ; 2 4 8 5 ; 2 5 6 1 ; 2 5 7 3 ; 2 5 8 3 ; ...
    2 6 7 2 ; 2 6 8 2 ; 2 7 8 0];



before_5_rot{1} = [1 4 5; 2 2 5; 2 4 5];
before_5_both{1} = [1 1 5; 1 2 5; 1 3 5; 2 1 5; 2 3 5];

after_5_rot{1} = [1 5 8];
after_5_both{1} = [1 5 7; 2 5 7; 2 5 8];

before_6_rot{1} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_both{1} = [];

after_6_rot{1} = [1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_both{1} = [];

% G31 - Note that some of this is wrong....One G31 session is incorrectly
% rotated, I think (1st square session?)

before_win_rot{2} = [1 1 2; 1 1 4; 1 2 3; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_both{2} = [1 1 3; 1 2 4; 2 1 3];

after_win_rot{2} = [1 7 8; 2 7 8];
after_win_both{2} = [];

before_after_rot{2} = [1 1 8; 1 2 7; 1 3 8; 1 4 7; 2 1 8; 2 2 7; 2 2 8; 2 3 8; 2 4 7];
before_after_both{2} = [1 1 7; 1 2 8; 1 3 7; 1 4 8; 2 1 7; 2 3 7; 2 4 8];

before_5_rot{2} = [1 2 5; 1 4 5; 2 2 5; 2 4 5];
before_5_both{2} = [1 1 5; 1 3 5; 2 1 5; 2 3 5];

after_5_rot{2} = [1 5 8; 2 5 8];
after_5_both{2} = [1 5 7; 2 5 7];

before_6_rot{2} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_both{2} = [];

after_6_rot{2} = [1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_both{2} = [];

% G45

before_win_rot{1} = [1 1 2; 1 1 4; 1 2 3; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_both{1} = [1 1 3; 1 2 4; 2 1 3];

after_win_rot{1} = [1 7 8; 2 7 8];
after_win_both{1} = [];

before_after_rot{1} = [1 1 8; 1 2 7; 1 3 8; 1 4 7; 2 1 8; 2 2 7; 2 2 8; 2 3 8; 2 4 7];
before_after_both{1} = [1 1 7; 1 2 8; 1 3 7; 1 4 8; 2 1 7; 2 3 7; 2 4 8];

before_5_rot{1} = [1 2 5; 1 4 5; 2 2 5; 2 4 5];
before_5_both{1} = [1 1 5; 1 3 5; 2 1 5; 2 3 5];

after_5_rot{1} = [1 5 8; 2 5 8];
after_5_both{2} = [1 5 7; 2 5 7];

before_6_rot{1} = [1 1 6; 1 2 6; 1 3 6; 1 4 6; 2 1 6; 2 2 6; 2 3 6; 2 4 6];
before_6_both{1} = [];

after_6_rot{1} = [1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_both{1} = [];
