% Get t-test values for Eraser Behavioral Pilot Data

%% Control guys
control_file = 'E:\Eraser\Behavioral Pilot Data\1 shock CONTROL FREEZING\Marblesnu.csv';
cnum = xlsread(control_file);

% Grab last 4 guys - 1 shock pilots. Will track down where data for top 5
% guys came from - python Marbles perhaps?
good_controls = cnum(6:9,:);

[~, pday1c] = ttest(good_controls(:,2),good_controls(:,4), 'tail', 'left'); % Day -1 to Day 1
[~, pday2c] = ttest(good_controls(:,2),good_controls(:,5), 'tail', 'left'); % Day -1 to Day 2
[~, p4c] = ttest(good_controls(:,2),good_controls(:,3), 'tail', 'left'); % Day -1 to 4 hrs
[~, pbefc] = ttest(good_controls(:,2),good_controls(:,1), 'tail', 'both'); % Day -1 to Day -2

%% ANI GUYS

ani_file = 'E:\Eraser\Behavioral Pilot Data\ANI_PILOT_FREEZING\freezing\ANI_1.csv';
good_ani = xlsread(ani_file);

% Grab last 4 guys - 1 shock pilots. Will track down where data for top 5
% guys came from - python Marbles perhaps?

[~, pday1a] = ttest(good_ani(:,2),good_ani(:,4), 'tail', 'left'); % Day -1 to Day 1
[~, pday2a] = ttest(good_ani(:,2),good_ani(:,5), 'tail', 'left'); % Day -1 to Day 2
[~, p4a] = ttest(good_ani(:,2),good_ani(:,3), 'tail', 'left'); % Day -1 to 4 hrs
[~, pbefa] = ttest(good_ani(:,2),good_ani(:,1), 'tail', 'both'); % Day -1 to Day -2