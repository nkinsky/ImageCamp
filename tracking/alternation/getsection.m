function [sect, goal] = getsection(x,y)
%function [sect, goal] = getsection(x,y)
%   This function takes position data and transforms it into section
%   number. 
%
%   X and Y are vectors indicating the mouse position.
%
%   SECT is X x 2 vector where col1 is the frame # and col2 is section #: 
%       1. Base
%       2. Center
%       3. Choice
%       4. Left approach
%       5. Left
%       6. Left return
%       7. Right approach
%       8. Right
%       9. Right return
%
%   GOAL is an X x 2 vector where col1 is the fram # and col2 is the
%   following:
%       0. Not in a goal location
%       1. In left goal zone
%       2. In right goal zone
    
%% Get relevant section coordinates. 
    [bounds, rot_x, rot_y] = sections(x,y);
    
    xmin = [bounds.base.x(1);               
            bounds.center.x(1);
            bounds.choice.x(1);
            bounds.approach_l.x(1);
            bounds.left.x(1); 
            bounds.return_l.x(1); 
            bounds.approach_r.x(1);
            bounds.right.x(1); 
            bounds.return_r.x(1)]; 
        
    xmax = [bounds.base.x(3);
            bounds.center.x(3);
            bounds.choice.x(3);
            bounds.approach_l.x(3);
            bounds.left.x(3); 
            bounds.return_l.x(3); 
            bounds.approach_r.x(3);
            bounds.right.x(3); 
            bounds.return_r.x(3)]; 
        
    ymin = [bounds.base.y(1);               
            bounds.center.y(1);
            bounds.choice.y(1);
            bounds.approach_l.y(1);
            bounds.left.y(1); 
            bounds.return_l.y(1); 
            bounds.approach_r.y(1);
            bounds.right.y(1); 
            bounds.return_r.y(1)]; 
        
    ymax = [bounds.base.y(3);               
            bounds.center.y(3);
            bounds.choice.y(3);
            bounds.approach_l.y(3);
            bounds.left.y(3); 
            bounds.return_l.y(3); 
            bounds.approach_r.y(3);
            bounds.right.y(3); 
            bounds.return_r.y(3)]; 
    
    % Same for goal sections
    xmin_goal = [bounds.goal_l.x(1); bounds.goal_r.x(1)];
    xmax_goal = [bounds.goal_l.x(2); bounds.goal_r.x(2)];
    ymin_goal = [bounds.goal_l.y(1); bounds.goal_r.y(1)];
    ymax_goal = [bounds.goal_l.y(3); bounds.goal_r.y(3)];
        
%% Find mouse's current section. 
    %Preallocate section column. 
    sect = nan(length(rot_x),2); 
    sect(:,1) = 1:length(rot_x); % frame number
    
    for this_section = 1:9
        ind = rot_x > xmin(this_section) & rot_x < xmax(this_section) & ...
            rot_y > ymin(this_section) & rot_y < ymax(this_section);
        sect(ind,2) = this_section; 
    end
    
    %Preallocate goal column. 
    goal = zeros(length(rot_x),2); 
    goal(:,1) = 1:length(rot_x); % frame number
    
    for this_section = 1:2
        ind = rot_x > xmin_goal(this_section) & rot_x < xmax_goal(this_section) & ...
            rot_y > ymin_goal(this_section) & rot_y < ymax_goal(this_section);
        goal(ind,2) = this_section; 
    end
    
end