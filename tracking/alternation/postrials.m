function data = postrials(x,y,plot_each_trial,varargin)
%function data = postrials(x,y,plot_each_trial,...)
%   
%   This function takes mouse position data and sorts them into trial
%   numbers, left/right, and correct/incorrect.
%
%   INPUTS: 
%       X & Y: Position vectors after passing through
%       PreProcessMousePosition.
%       
%       plot_each_trial: Logical to determine whether or not you want the
%       function to plot the XY position of the mouse for each trial. 
%
%       'skip_rot_check': 0(default if left blank) = perform check of
%       rotation of position data, 1 = skip it.  Enter as
%       postrials(....,'skip_rot_check',0).
%
%       'suppress_output': 1 - suppresses any warning outputs, 0 (default)
%       - provide outputs for number of trials and any warnings about
%       epochs with multiple trials
%       
%
%   OUTPUTS:
%       DATA: a struct with these fields:
%           frame = Frame number.
%           trial = Trial number. 
%           choice = Left (1) vs. right (2).
%           alt = Correct (1) vs. incorrect (0). 
%           x = X position.
%           y = Y position.
%           section = section number. Refer to getsection.m. 
%           summary = Summary of trials. The first column is trial number
%           followed by left/right and correct/incorrect in the same format
%           as above. 
%
%   TIP: To find frames for a particular trial of interest, you can do:
%       data.frames(data.trial == TRIAL_OF_INTEREST).
%
%% Assign varargin
for j = 1:2:length(varargin)-1
    if strcmpi(varargin{j},'skip_rot_check')
        skip_rot_check = varargin{j+1};
    elseif strcmpi(varargin{j},'suppress_output')
        suppress_output = varargin{j+1};  
    end
end

if ~exist('skip_rot_check','var')
    skip_rot_check = 0;
end

%% Label position data with section numbers. 
    [sect,goal,rot_x,rot_y] = getsection(x,y,'skip_rot_check',skip_rot_check);
    
%% Define important section numbers. 
    %Define sequences of section numbers that correspond to left or right
    %trials. **CURRENTLY OBSOLETE**
    %left = 1:6; 
    %right = [1,2,3,7,8,9]; 
    
    %Define opposite arms. Important for catching miscategorization of 
    %trials by this script. 
    left = 5; right = 8; 
    
    %Define return arms. **CURRENTLY OBSOLETE**
    %return_arm = [6,9]; 
    
    %Define when the mouse is at the start position. 
    base = find(sect(:,2)==1);
    
%% Label trials. 
    %Define first trial. When does the mouse first enter the starting
    %location? 
    start = min(find(sect(:,2)==1)); 

    %Preallocate.
    epochs = start; 
    mouse_running = 1;
    
    %For each lap. 
    for this_trial = 1:200
        
        try     %Try sorting a trial. 
        
        %Index for next trial. 
        next = this_trial+1;    
        epochs(next) = epochs(this_trial)+1;    %First glance: trials are at least 1 frame long. 

        %As long as the criteria are not satisfied (see below)...
        while mouse_running
            
            epochs(next) = epochs(next) + 1;    %...keep adding frames.

            %To break the while loop, must satisfy the criteria that the
            %mouse entered the left/right arm from the left/right approach
            %area. 
            if (sect(epochs(next),2) == left && sect(epochs(next)-1,2) == left-1) || ...    
                    (sect(epochs(next),2) == right && sect(epochs(next)-1,2) == right-1)
                
                %Label this trial as left/right.
                if sect(epochs(next),2) == left
                    trialtype(this_trial) = 1; 
                elseif sect(epochs(next),2) == right
                    trialtype(this_trial) = 2; 
                end
                
                %Once mouse enters left/right arm, reach for next instance
                %where he is in the base. The duration since the while loop
                %started up until this timepoint is now one lap. 
                epochs(next) = min(base(base > epochs(next))); 

                break;
            end
        end
        
        %Plot laps. 
        if plot_each_trial == 1
            figure(this_trial);
            plot(x(epochs(this_trial):epochs(next)), y(epochs(this_trial):epochs(next))); 
            xlim([min(x) max(x)]); ylim([min(y) max(y)]); 
            title(['Trial ', num2str(this_trial)], 'fontsize', 12); 
        end
        
        %Notify user of possible errors in the trial sorting script. This
        %catches when the mouse appears on both maze arms in what the
        %script believed to be a single trial. 
        if ~exist('suppress_output','var') || suppress_output ~= 1
            if (ismember(left, sect(epochs(this_trial):epochs(next),2)) && trialtype(this_trial) == 2) || ...
                    (ismember(right, sect(epochs(this_trial):epochs(next),2)) && trialtype(this_trial) == 1)
                disp(['Warning: This epoch may contain more than one trial: Trial ', num2str(this_trial)]);
            end
        end
        
        %When postrials can no longer successfully sort a trial, stop the
        %loop. 
        catch
            numtrials = this_trial-1;           %this_trial produced an error, so roll back a trial
            if length(trialtype) > numtrials    %Sometimes, the mouse leaves the maze on a left/right arm so trialtype gets an extra entry.
                trialtype(this_trial) = [];     %In that case, remove it. 
            end
            break; 
        end
        
    end
    
    %Display number of trials sorted. 
    if ~exist('suppress_output','var') || suppress_output ~= 1
        disp(['Successfully sorted ', num2str(numtrials), ' trials.']); 
    end
    
%% Build up the struct. 
    data.frames = 1:length(x);          %Frames.
    
    %Vector containing correct vs. error using a trick: take the difference
    %between consecutive trial types (left (1) vs. right (2)) such that
    %errors corresponding to consecutive double visits will be zero (one
    %minus one or two minus two). Take the absolute value and all other
    %correct visits will be 1. The first choice (reward on both arms) is
    %always correct. 
    alt = [1 abs(diff(trialtype))]; 
    
    %Trial numbers, trial type (left vs. right), and correct vs. incorrect. 
    for this_trial = 1:numtrials
        next = this_trial+1; 

        data.trial(epochs(this_trial):epochs(next)) = this_trial; 
        data.choice(epochs(this_trial):epochs(next)) = trialtype(this_trial); 
        data.alt(epochs(this_trial):epochs(next)) = alt(this_trial); 
    end
    
    %This script may not cover the entire session. If that's the case, pad
    %the rest of it with 0s or NaNs.
    if length(data.trial) < length(x)
        data.trial(end:length(x)) = 0; 
        data.choice(end:length(x)) = 0;
        data.alt(end:length(x)) = NaN;      %NaNs so that the last uncaptured trials don't register as errors. 
    end
    
    %Mouse position. 
    data.x = rot_x;                 %X position.
    data.y = rot_y;                 %Y position. 
    data.section = sect(:,2)';      %Section number. Refer to getsection.m.
    
    %Summary. 
    data.summary = [(1:numtrials)', trialtype', alt']; 
    
    %Save. 
    save Alternation data;
end