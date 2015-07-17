% Han first step
% Goal is to take an individual session, import its Pos.mat file, pull out
% its position data, get velocity data, filter it if necessary, and then
% plot out an trajectory, occupancy map, and velocity plot and histogram,
% all on the same figure

%% Step 1: Get your file(s)

%% Step 2: Assign position variables and get velocity

%% Step 2a: Filter Velocity - we may get crazy jumps in the velocity due to sampling,
% and need to smooth those out...

[tk, xk, yk, vxk, vyk, axk, ayk] = KalmanVel_sam(Xcm, Ycm, time, 2);
speed_k = sqrt(vxk.^2 + vyk.^2);

%% Step 3: Plot trajectory in red

%% Step 4: Plot occupancy map
% We want to be able to quickly eyeball this to see how much time the mouse
% spent in each part of the arena - I will walk you through this

%% Step 5: Plot velocity vs time