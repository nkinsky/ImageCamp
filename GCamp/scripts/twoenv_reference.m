%% References for running 2env task

G31_start = 26; % start index in MD for G31
G31_square_sesh = [0 1 6 7 8 11 12 13] + G31_start;
G31_oct_sesh = [2 3 4 5 9 10 14 15] + G31_start;
G31_manual_limits = [0 0 0 0 1 1 0 0];
G31_rot = [0 1 0 1 0 1 0 1 0 0 1 1 0 1 0 1]; % Indices for all the sessions that were rotated

G30_start = 56;
G30_square_sesh = [0 1 6 7 8 11 12 13] + G30_start;
G30_oct_sesh = [2 3 4 5 9 10 14 15] + G30_start;
G30_manual_limits = [0 0 0 0 1 1 0 0];
G30_rot = [0 0 0 1 0 1 0 1 0 0 1 1 0 1 0 0]; % Indices for all the sessions that were rotated

G45_start = ref.G45.twoenv(1);
G45_square_sesh = [0 1 6 7 9 13 14 15] + G45_start;
G45_oct_sesh = [2 3 4 5 10 12 16 17] + G45_start;
G45_manual_limits = [0 0 0 0 1 1 0 0];

G48_start = ref.G48.twoenv(1);
G48_square_sesh = [0 1 6 7 8 11 12 13] + G48_start;
G48_oct_sesh = [2 3 4 5 9 10 14 15] + G48_start;
G48_manual_limits = [0 0 0 0 1 1 0 0];