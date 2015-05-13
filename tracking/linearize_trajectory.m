function [lin_pos] = linearize_trajectory(x, y, varargin)
%UNTITLED2 Summary of this function goes here
%   Goal is to linearize trajectories, such that each trial begins at zero
%   and finishes at the end, with the length of each trajectory being equal
%   to 2*l_arms + 2*l_return, specified below
%   INPUTS
%   x,y: mouse position
%   'ArmLength','ReturnLength': available if you want to specify something
%   different that the default
%
%   OUTPUTS
%       lin_pos: first row is the linear position along the maze, second
%       row is negative if a left trial and positive if a right trial

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

%% Load necessary information. 
try 
    load(fullfile(pwd,'Bounds.mat'));
catch 
    bounds = sections(x,y);
end

try 
    load(fullfile(pwd,'Alternation.mat'))
catch 
    data = postrials(x,y);
end

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

%For the choice and start, find distance the mouse is from the middle of
%the exit boundary. 
base.ind.l = data.section == 1 && data.trial == 1; 
base.ind.r = data.section == 1 && data.trial == 2; 
choice.ind.l = data.section == 3 && data.trial == 1;
choice.ind.r = data.section == 3 && data.trial == 2; 

%Extract the referenc points. 
refs.base.l = [mean(bounds.base.x(1:2)), bounds.base.y(1)];
refs.base.r = [mean(bounds.base.x(1:2)), bounds.base.y(3)];
refs.choice.l = [mean(bounds.choice.x(1:2)), bounds.base.y(1)]; 
refs.choice.r = [mean(bounds.choice.x(1:2)), bounds.base.y(3)]; 

%Get distances. 
d.base.l = linearize_dist(refs.base.l(base.ind.l),x,y);
d.base.r = linearize_dist(refs.base.r(base.ind.r),x,y); 
d.choice.l = linearize_dist(refs.choice.l(choice.ind.l),x,y);
d.choice.r = linearize_dist(refs.choice.r(choice.ind.r),x,y); 

%Interpolate. 
for j = 1: length(pos_data.frames)
   if data.section(j) == 1
       if data.trial == 1
           
           
           lin_pos(j) = lin_interp(%INSERT STUFF TO INTERPOLATE HERE%);
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

%% Divvy up lin_pos into left and right trials
% -5 = left, +5 = right

for j = 1:length(lin_pos)
    if pos_data.choice(j) == 1
        lin_pos(2,j) = -100;
    elseif pos_data.choice(j) == 2
        lin_pos(2,j) = 100;
    else
        lin_pos(2,j) = 0;
    end
end

end

