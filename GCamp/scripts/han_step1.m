% Han first step
% Goal is to take an individual session, import its Pos.mat file, pull out
% its position data, get velocity data, filter it if necessary, and then
% plot out an trajectory, occupancy map, and velocity plot and histogram,
% all on the same figure

%% Step 1: Get your file(s) - can load with "load filename" or you can use a
% user interface with "uigetfile".  Grab the Pos.mat files and save them in
% a variable that makes sense to you.

%% Step 2: Assign position variables and get velocity
% vel = sqrt(dx^2 + dy^2)/dt. you can use the "diff" function to get dx,
% dy, and dt from Xcm and Ycm
% Need to convert to centimeters also - for room 201a use a factor of 0.07
% to start (e.g. Xcm = 0.07*xpos_interp)

%% Step 2a: Filter Velocity - we may get crazy jumps in the velocity due to sampling,
% and need to smooth those out...Here's some sample code:
% 
% [tk, xk, yk, vxk, vyk, axk, ayk] = KalmanVel_sam(Xcm, Ycm, time, 2);
% speed_k = sqrt(vxk.^2 + vyk.^2);

%% Step 3: Plot trajectory in red

%% Step 4: Plot occupancy map
% We want to be able to quickly eyeball this to see how much time the mouse
% spent in each part of the arena - I will walk you through this

%% Step 5: Plot velocity vs time