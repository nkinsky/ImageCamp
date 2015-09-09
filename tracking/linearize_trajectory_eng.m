function [lin_pos] = linearize_trajectory_eng(x, y, varargin)
%[lin_pos] = linearize_trajectory(x, y, ...)
%   Goal is to linearize trajectories, such that each trial begins at zero
%   and finishes at the end, with the length of each trajectory being equal
%   to 2*l_arms + 2*l_return, specified below.  This is the "engineering"
%   version by NK and differs from the more elegant JR/WM version
%   "linearize_trajectory".
%
%   INPUTS
%   x,y: mouse position
%   'ArmLength','ReturnLength': available if you want to specify something
%   different that the default
%   'x_add','y_add': additional points you want to get trajectories for..if
%   specified, outputs will corresponde to x_add and y_add, NOT x and y
%   'skip_rot_check': 0 (default) means you will manually rotate the
%   position data in x and y and/or check it with a plot if it needs it,
%   1 means skip this step (if done already!)
%   'suppress_output' = 1 means suppress any warnings in postrials,
%   0(default) = display warningsa about epochs with multiple trials and
%   total trial number
%
%   OUTPUTS
%       lin_pos: first row is the linear position along the maze, second
%       row is negative if a left trial and positive if a right trial

%% Specify length of center arm and other areas
l_arm_default = 60;     % length of center, left arm, and right arm, in centimeters
l_return_default = 12;  % length of approaches and returns in centimeters
% Override above if specified in function inputs
for j = 1:2:length(varargin) - 1
    if strcmpi(varargin{j},'ArmLength')
        l_arm = varargin{j+1};
    elseif strcmpi(varargin{j},'ReturnLength')
        l_return = varargin{j+1};
    elseif strcmpi(varargin{j},'x_add')
        x_add = varargin{j+1};
    elseif strcmpi(varargin{j},'y_add')
        y_add = varargin{j+1};
    elseif strcmpi(varargin{j},'skip_rot_check')
        skip_rot_check = varargin{j+1};
    elseif strcmpi(varargin{j},'suppress_output')
        suppress_output = varargin{j+1};
    end
end

% Set defaults if not specified
if ~exist('l_arm','var')
    l_arm = l_arm_default;
end

if ~exist('l_return','var')
    l_return = l_return_default;
end

if ~exist('skip_rot_check','var')
    skip_rot_check = 0;
end

if ~exist('suppress_output','var')
    suppress_output = 0;
end
%% Get section for trial and bounds of each part of arena
    pos_data = postrials(x,y,0,'skip_rot_check',skip_rot_check,...
        'suppress_output',suppress_output);
    [bounds, rot_x, rot_y] = sections(x, y, 1);
if ~exist('x_add','var')
    [sect, goal] = getsection(x, y,'skip_rot_check',1);
elseif exist('x_add','var')
    [sect, goal] = getsection(x, y,'skip_rot_check',1,'x_add',x_add,...
        'y_add',y_add);
    rot_x = x_add; rot_y = y_add;
end

% keyboard
%% Meat of function - here you designate where the mouse was, in linear 
% space, for each trial
%       1. Base
%       2. Center
%       3. Choice
%       4. Left approach
%       5. Left
%       6. Left return
%       7. Right approach
%       8. Right
%       9. Right return

%Preallocate.
lin_pos = nan(1,length(x)); 
% overwrite if x_add and y_add are specified
if exist('x_add','var')
   lin_pos = nan(3,length(x_add)); 
end

for j = 1: size(lin_pos,2)
   if sect(j,2) == 1
       lin_pos(1,j) = 0;
   elseif sect(j,2) == 2
       lin_pos(1,j) = lin_interp(bounds.center.x([2 1]),[0 l_arm], rot_x(j));
   elseif sect(j,2) == 3
       lin_pos(1,j) = l_arm;
   elseif sect(j,2) == 4
       lin_pos(1,j) = l_arm + lin_interp(bounds.approach_l.y([4 1]),[0 l_return], rot_y(j));
   elseif sect(j,2) == 5
       lin_pos(1,j) = l_arm + l_return + lin_interp(bounds.left.x([1 2]),[0 l_arm], rot_x(j));
   elseif sect(j,2) == 6
       lin_pos(1,j) = 2*l_arm + l_return + lin_interp(bounds.return_l.y([1 4]),[0 l_return], rot_y(j));
   elseif sect(j,2) == 7
       lin_pos(1,j) = l_arm + lin_interp(bounds.approach_r.y([1 4]),[0 l_return], rot_y(j));
   elseif sect(j,2) == 8
       lin_pos(1,j) = l_arm + l_return + lin_interp(bounds.right.x([1 2]),[0 l_arm], rot_x(j));
   elseif sect(j,2) == 9
       lin_pos(1,j) = 2*l_arm + l_return + lin_interp(bounds.return_r.y([4 1]),[0 l_return], rot_y(j));
   end
       
end

%% Divy up lin_pos into left and right trials
% -5 = left, +5 = right

for j = 1:size(lin_pos,2)
    % Set left trials as row two and right trials as row three
    if pos_data.choice(j) == 1 || sect(j,2) == 4 || sect(j,2) == 5 || sect(j,2) == 6
        lin_pos(2,j) = lin_pos(1,j); % left trials
        lin_pos(3,j) = nan; % right trials
%         lin_pos(4,j) = -100;
    elseif pos_data.choice(j) == 2 || sect(j,2) == 7 || sect(j,2) == 8 || sect(j,2) == 9
        lin_pos(2,j) = nan; % left
        lin_pos(3,j) = lin_pos(1,j) ; % right
%         lin_pos(4,j) = 100;
    elseif sect(j,2) == 1 || sect(j,2) == 2 || sect(j,2) == 3
        lin_pos(2,j) = lin_pos(1,j); % left
        lin_pos(3,j) = lin_pos(1,j); % right
    else
%         lin_pos(4,j) = 0;
    end
end

end

