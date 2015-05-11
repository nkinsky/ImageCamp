function [ bounds_use ] = get_section_bounds( section_to_get, bounds )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if strcmpi(section_to_get,'base') || section_to_get == 1
    bounds_use = bounds.base;
elseif strcmpi(section_to_get,'center') || section_to_get == 2
    bounds_use = bounds.center;
elseif strcmpi(section_to_get,'choice') || section_to_get == 3
    bounds_use = bounds.choice;
elseif strcmpi(section_to_get,'approach_l') || section_to_get == 4
    bounds_use = bounds.approach_l;
elseif strcmpi(section_to_get,'left') || section_to_get == 5
    bounds_use = bounds.left;
elseif strcmpi(section_to_get,'return_l') || section_to_get == 6
    bounds_use = bounds.return_l;
elseif strcmpi(section_to_get,'approach_r') || section_to_get == 7
    bounds_use = bounds.approach_r;
elseif strcmpi(section_to_get,'right') || section_to_get == 8
    bounds_use = bounds.right;
elseif strcmpi(section_to_get,'return_r') || section_to_get == 9
    bounds_use = bounds.right;
elseif strcmpi(section_to_get,'goal_l') || section_to_get == 10
    bounds_use = bounds.goal_l;
elseif strcmpi(section_to_get,'goal_r') || section_to_get == 11
    bounds_use = bounds.goal_r;
end

end

