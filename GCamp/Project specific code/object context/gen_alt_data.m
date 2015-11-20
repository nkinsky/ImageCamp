% Make Alt matrix for representational similarity analysis

%
%           column1 = Frame number (multiply by 0.05 to get timestamp in seconds).
%           column2 = Trial number. 
%           column3 = Left (1) vs. right (2).
%           column4 = Correct (1) vs. incorrect (0). 
%           column5 = section number. See below.
%               1. Base
%               2. Center
%               3. Choice
%               4. Left approach
%               5. Left
%               6. Left return
%               7. Right approach
%               8. Right
%               9. Right return
%           column6 = goal location. 1 = left. 2 = right. 0 = not goal
%           location. 
%           columns 7 to n: individual neuron calcium activity (each column
%           is a neuron, 1 = calcium event, 0 = not).
%

%%
clear alt_matrix

SR = 0.05;
alt_matrix(:,1) = Alt.frames';
alt_matrix(:,2) = Alt.trial';
alt_matrix(:,3) = Alt.choice';
alt_matrix(:,4) = Alt.alt';
alt_matrix(:,5) = Alt.goal';
alt_matrix(:,6) = Alt.section';
alt_matrix(:,7:6+size(FT,1)) = FT';

num_trials = max(alt_matrix(:,2));
good_trials = find(Alt.summary(:,3) == 1);
prev_start_frame = 1;
for j = 1:num_trials
    event_start_frame = find(Alt.goal == Alt.summary(j,2) & ...
        Alt.trial == Alt.summary(j,1),1);
    choice_start(j,1) = find(Alt.section == 3 & Alt.frames > prev_start_frame & Alt.frames <= event_start_frame,1,'first');
    center_start = find(Alt.section == 2 & Alt.frames > prev_start_frame & Alt.frames <= event_start_frame,1,'first');
    center_end = find(Alt.section == 2 & Alt.frames > prev_start_frame & Alt.frames <= event_start_frame,1,'last');
    design_mat(j,1) = event_start_frame; % 1st col = frame number of event start
    design_mat(j,2) = event_start_frame*SR; % 2nd col = time-stamp of event start
    design_mat(j,3) = Alt.summary(j,2); % goal location (left or right)
    design_mat(j,4) = Alt.summary(j,3); % Correct = 1, Incorrect = 0
    design_mat(j,5) = center_start; % Center stem start frame
    design_mat(j,6) = center_end; % Center stem end frame
    design_mat(j,7) = design_mat(j,6) - design_mat(j,5) < 100; %
    prev_start_frame = event_start_frame;
   
end