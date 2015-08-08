function [ ] = combine_tracking( varargin )
% combine_tracking( FTframes1, t1,x1,y1, FTframes2, t2,x2, y2, ... )
% Takes tracking sessions that have been split into 2 session (due to
% camera fritzing out, cord needing untangling, etc.) and combines them
% into one session that matches up with the fluorescence trace...NOTE: you
% should probably check and make sure this has been combined
% properly...e.g. does the first valid point in the second session
% correspond to the appropriate frame in the FT trace?)
%
%   INPUTS
%   FTframes: the number of frames in each fluorescence movie
%   t1,x1,y1,tx2,y2,...: time_interp, xpos_interp, and ypos_interp from the
%   appropriate sessions.  Should be 1 x n arrays.
%   OUTPUTS
%   Saves Pos_comb.mat in current directory with combined xpos_interp,
%   ypos_interp, and time_interp, as well as x1,y1,t1,... (these get dumped
%   into cell arrays x_use, y_use, t_use)

fill_pos = [0 0]; % Sends all filled in values to this...should be something you can easily exclude or ignore later on.

num_sessions = nargin/4;

if round(num_sessions) ~= num_sessions
    error('You have not entered the correct number of arguments')
end

% Dump varargins into a useful structure
for j = 1:length(varargin)
    if mod(j,4) == 1 % time values
        n_image_frames{ceil(j/4)} = varargin{j};
    elseif mod(j,4) == 2 % time values
        t_use{ceil(j/4)} = varargin{j};
    elseif mod(j,4) == 3 % x values
        x_use{ceil(j/4)} = varargin{j}; 
    elseif mod(j,4) == 0 % y values
        y_use{ceil(j/4)} = varargin{j}; 
    end
        
end

% Get sample rate in sec from mean difference between timestamps
SR = mean(diff(t_use{1})); 

% Initialized variables
xpos_interp = [];
ypos_interp = [];
time_interp = [];

% keyboard

%% Run it
for j = 1:num_sessions
    
    % Get end time stamp (kind of meaningless since we know that there is a bit
    % of drift in frame rates between Inscopix and Plexon, really the frame
    % number is the meaningful variable here)
    end_time = max(time_interp);
    
    % Get gap between sessions and output the fill time
    if j == 1
        gap = 0;
        fill_time = [];
        end_time = 0;
    else
        gap = min(t_use{j});
        fill_time = SR:SR:gap-SR;
    end
    
    % Align the end of the imaging and tracking data
    n_frames_tracking = t_use{j}(end)/SR; % Number of frames there would be if the frames started at 0+SR.
    if n_image_frames{j} > n_frames_tracking
        fill_frames = n_image_frames{j} - n_frames_tracking;
        t_chop{j} = [t_use{j} t_use{j}(end) + SR:SR:SR*fill_frames];
        x_chop{j} = [x_use{j} fill_pos(1)*ones(1,fill_frames)];
        y_chop{j} = [y_use{j} fill_pos(2)*ones(1,fill_frames)];
        
    elseif n_image_frames{j} <= n_frames_tracking
        chop_ind = findclosest(t_use{j},n_image_frames{j}*SR);
        t_chop{j} = t_use{j}(1:chop_ind);
        x_chop{j} = x_use{j}(1:chop_ind);
        y_chop{j} = y_use{j}(1:chop_ind);
    end
    
    % Fill in the gaps
    time_interp = [time_interp end_time+fill_time end_time+t_chop{j}];
    xpos_interp = [xpos_interp ones(size(fill_time)) x_chop{j}];
    ypos_interp = [ypos_interp ones(size(fill_time)) y_chop{j}];
end

% keyboard

%% Save stuff

save Pos_comb.mat time_interp xpos_interp ypos_interp n_image_frames t_use x_use y_use

end

