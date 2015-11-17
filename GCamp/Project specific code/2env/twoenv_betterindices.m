% Better categorization of each mouse's session indices
%1st column = 1/2 (square/octagon), 2nd column = 1st sesh, 3rd column = 2nd
%sesh
% _conflict = conflict between local and distal cues (sessions are rotated
% relative to one another)
% _aligned = no conflict between local and distal cues (sessions are NOT
% rotated relative to one another)

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
after_5_aligned{1} = [1 5 7; 1 5 8; 2 5 8];

after_6_conflict{1} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_conflict{1} = [];

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
after_5_aligned{2} = [1 5 7; 1 5 8];

after_6_conflict{2} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_conflict{2} = [];

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
after_5_aligned{3} = [1 5 7; 1 5 8];

after_6_conflict{3} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_conflict{3} = [];

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
after_5_aligned{4} = [1 5 7; 1 5 8];

after_6_conflict{4} = [ 1 6 7; 1 6 8; 2 6 7; 2 6 8];
after_6_conflict{4} = [];




