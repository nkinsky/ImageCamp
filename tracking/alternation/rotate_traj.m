function [rotx, roty] = rotate_traj(x,y,rotang)
%[rotx, roty] = rotate_traj(x,y)
%
%   This function takes the mouse's trajectory and rotates it along the x
%   axis. This is to correct for if the maze is slightly tilted (base
%   doesn't align with choice point). 
%
%   INPUTS: 
%       X & Y: X and Y position vectors from PFA.m.
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
        rotang = -atan(h/w); 
    
        %Save the rotation angle. 
        save rotationangle rotang;
    end
    
    %Rotation array. 
    rotarray = [cos(rotang), -sin(rotang);...
                sin(rotang), cos(rotang)]; 

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
    rotang_deg = radtodeg(rotang); 
    disp(['Rotated animal trajectory by ', num2str(rotang_deg), ' degrees.']); 

end