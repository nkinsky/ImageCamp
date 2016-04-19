% For Annalyse: Steps to import Pos.mat files

%% FOR INDIVIDUAL SESSIONS %%
%% Step 0: note file locations
mouse1_file{1} = 'C:\mouse1\session1\Pos.mat'; % Mouse 1, session 1

%% Step 1: import files
load(mouse1_file{1},'xpos_interp','ypos_interp')

%% Step 2: plot trajectory using plot command
% use figure command to create a figure
% use title command to label each plot

%% Step 3: Save to usable format

%% FOR ALL SESSIONS (ADVANCED)
% create for loop to run through all of the above, e.g.
for j = 1:3
    % Follow steps above but use j instead of 1 to loop through each
    % session, e.g.:
   load(mouse1_file{j},'xpos_interp','ypos_interp')
   
end
