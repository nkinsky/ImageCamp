function [rotx, roty, rot_ang] = rotate_traj(x,y,rot_ang)
%[rotx, roty] = rotate_traj(x,y)
%
%   This function takes the mouse's trajectory and rotates it along the x
%   axis. This is to correct for if the maze is slightly tilted (base
%   doesn't align with choice point). 
%
%   INPUTS: 
%       X and Y: Position vectors from PFA.m.
%
%       rot_ang (optional): The angle at which you want to rotate the
%       animal's trajectory (in radians). If not specified, function will
%       prompt you to label to points on the maze to calculate an angle. 
%
%   OUTPUTS: 
%       rotx & roty: Rotated X and Y position vectors. 
%
    %Concatenate the x and y vectors. 
    to_rotate = [x;y]; 

    %If rotation angle is not specified. 
    if nargin < 3

        %Plot the trajectory. 
        figure;
        plot(x,y);
            title('Animal Trajectory', 'fontsize', 12);

        %Specify angle using a line down the center arm. 
        disp('Select the middle of the choice region and then the middle of the start base.'); 
        [angx,angy] = ginput(2); 

        %Calculate the angle. 
        w = angx(2)-angx(1);
        h = angy(2)-angy(1); 
        rot_ang = -atan(h/w); 
    
    end
    
    %Rotation array. 
    rotarray = [cos(rot_ang), -sin(rot_ang);...
                sin(rot_ang), cos(rot_ang)]; 

    %Initiliaze. 
    new_coords = nan(2,length(x));

    %Multiply the coordinates by the rotation array. 
    for i=1:length(x)
        new_coords(:,i) = rotarray*to_rotate(:,i); 
    end

    %Extract new coordinates. 
    rotx = new_coords(1,:);
    roty = new_coords(2,:);
  
    %Display degree of rotation. 
    rotang_deg = radtodeg(rot_ang); 
    disp(['Rotated animal trajectory by ', num2str(rotang_deg), ' degrees.']); 

end