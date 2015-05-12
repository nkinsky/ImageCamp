function lin_pos = linearize_trajectory(x, y, varargin)
%UNTITLED2 Summary of this function goes here
%   Goal is to linearize trajectories, such that each trial begins at zero
%   and finishes at the end, with the length of each trajectory being equal
%   to 2*l_arms + 2*l_return, specified below

%% Specify length of center arm and other areas
l_arm_default = 60;     % length of center, left arm, and right arm, in centimeters
l_return_default = 12;  % length of approaches and returns in centimeters
% Override above if specified in function inputs
for j = 1:2:length(varargin)/2
    if strcmpi(varargin{j/2},'ArmLength')
        l_arm = varargin{j+1};
    elseif strcmpi(varargin{j/2},'ReturnLength')
        l_return = varargin{j+1};
    end
end

% Set defaults if not specified
if ~exist('l_arm','var')
    l_arm = l_arm_default;
end

if ~exist('l_return','var')
    l_return = l_return_default;
end

%% Get section for trial and bounds of each part of arena
[sect, goal] = getsection(x, y);
[bounds, rot_x, rot_y] = sections(x, y);
pos_data = postrials(x,y,0);

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
lin_pos = nan(1,length(pos_data.frames)); 

for j = 1: length(pos_data.frames)
   if sect(j,2) == 1
       lin_pos(j) = 0;
   elseif sect(j,2) == 2
       lin_pos(j) = lin_interp(bounds.center.x([2 1]),[0 l_arm], rot_x(j));
   elseif sect(j,2) == 3
       lin_pos(j) = l_arm;
   elseif sect(j,2) == 4
       lin_pos(j) = l_arm + lin_interp(bounds.approach_l.y([4 1]),[0 l_return], rot_y(j));
   elseif sect(j,2) == 5
       lin_pos(j) = l_arm + l_return + lin_interp(bounds.left.x([1 2]),[0 l_arm], rot_x(j));
   elseif sect(j,2) == 6
       lin_pos(j) = 2*l_arm + l_return + lin_interp(bounds.return_l.y([1 4]),[0 l_return], rot_y(j));
   elseif sect(j,2) == 7
       lin_pos(j) = l_arm + lin_interp(bounds.approach_r.y([1 4]),[0 l_return], rot_y(j));
   elseif sect(j,2) == 8
       lin_pos(j) = l_arm + l_return + lin_interp(bounds.right.x([1 2]),[0 l_arm], rot_x(j));
   elseif sect(j,2) == 9
       lin_pos(j) = 2*l_arm + l_return + lin_interp(bounds.return_r.y([4 1]),[0 l_return], rot_y(j));
   end
       
end


end

