% Better categorization of each mouse's session indices
%1st column = 1/2 (square/octagon), 2nd column = 1st sesh, 3rd column = 2nd
%sesh
% G30
before_win_rot{1} = [1 1 4; 1 2 4; 1 3 4; 2 1 2; 2 1 4; 2 2 3; 2 2 4; 2 3 4];
before_win_both{1} = [1 1 2; 1 1 3; 1 2 3; 2 1 3];

after_win_rot{1} = [1 7 8];
after_win_both{1} = [2 7 8];

before_after_rot{1} = [1 1 8; 1 2 8; 1 3 8; 1 4 7; 1 4 8; 2 2 7; 2 2 8; 2 4 7; 2 4 8];
before_after_both{1} = [1 1 7; 1 2 7; 1 3 7; 2 1 7; 2 1 8; 2 3 7; 2 3 8];

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
