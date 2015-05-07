function [ bounds_use ] = get_bounds( bounds,index,l_r)
% [ bounds_use ] = get_bounds( bounds,index )
% Maps appropriate bounds into bounds_use, using the index specified below
% e.g. if index = 1, you will get bounds.base. 
%       1. Base
%       2. Center
%       3. Choice
%       4. Left approach
%       5. Left
%       6. Left return
%       7. Right approach
%       8. Right
%       9. Right return
%       10. Goals - if l_r = 1 then left goal, if l_r = 2 then right goal

if index == 1
    bounds_use = bounds.base;
elseif index == 2
    bounds_use = bounds.center;
elseif index == 3
    bounds_use = bounds.choice;
elseif index == 4
    bounds_use = bounds.approach_l;
elseif index == 5
    bounds_use = bounds.left;
elseif index == 6
    bounds_use = bounds.return_l;
elseif index == 7
    bounds_use = bounds.approach_r;
elseif index == 8
    bounds_use = bounds.right;
elseif index == 9
    bounds_use = bounds.return_r;
elseif index == 10
    if l_r == 1
        bounds_use = bounds.goal_l;
    elseif l_r == 2
        bounds_use = bounds.goal_r;
    end
end

end

