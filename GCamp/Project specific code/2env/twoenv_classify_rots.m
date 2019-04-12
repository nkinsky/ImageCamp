function [ mismatch_bool, local_bool, distal_bool, breakdown ] = ...
    twoenv_classify_rots(delta_angle_mean, arena_rot, mismatch_cutoff, gr_bool)
%[ mismatch_bool, local_bool, distal_bool ] = ...
%     twoenv_classify_rots(delta_angle_med, arena_rot, mismatch_cutoff)
%
%   Takes the median place field rotation angle and compares it to the
%   arena rotation, spitting out booleans identifying which session-pairs
%   rotate with local cues and session-pairs where the arena rotation and
%   place field rotations do not match (excludes rotation = 0, see distal_bool). 
%   Also spits out distal_bool, session pairs where the place fields do no
%   rotate at all. Also spits out a breakdown of total number of sessions
%   in the mismatch, local, and distal conditions for pairs with a rotation
%   and pairs with no rotation, with the last column being global remapping
%   numbers.
%  
%   Need to get global remapping sessions and exclude them. I bet I won't
%   see ANY sessions with rot ~= 0:90:270 for the square...

%   NOTE that the input delta_angle_mean must contain values  between 0 and 360.

if nargin < 3
    mismatch_cutoff = 22.5;
end

if nargin < 4
    gr_bool = false(size(arena_rot));
end

% % Mis-match session-pairs are all those whose rotation do not match
% % that of the arena
% mismatch_bool = (abs(delta_angle_mean - arena_rot) > mismatch_cutoff | ...
%     abs(delta_angle_mean - arena_rot) > (360 - mismatch_cutoff)) & ~gr_bool;
% 
% % Distal session-pairs are those whose rotation is zero when the arena is
% % rotated - a special case of mismatch cells
% distal_bool = (abs(delta_angle_mean) <= mismatch_cutoff ...
%     | abs(delta_angle_mean-360) <= mismatch_cutoff) & mismatch_bool;
% 
% % Local session-pairs are those whose rotation matches that of the
% % arena
% local_bool = abs(delta_angle_mean - arena_rot) <= mismatch_cutoff & ~gr_bool;

local_bool = (abs(delta_angle_mean - arena_rot) <= mismatch_cutoff | ...
    abs(delta_angle_mean - arena_rot) >= (360 - mismatch_cutoff)) & ~gr_bool;

mismatch_bool = ~local_bool & ~gr_bool & ~isnan(delta_angle_mean);

distal_bool = (abs(delta_angle_mean) <= mismatch_cutoff ...
    | abs(delta_angle_mean) >= (360 - mismatch_cutoff)) & mismatch_bool;

% Make breakdown matrix
nmis_rot = sum(mismatch_bool(:) & arena_rot(:) ~= 0);
nloc_rot = sum(local_bool(:) & arena_rot(:) ~= 0);
ndist_rot = sum(distal_bool(:) & arena_rot(:) ~=0);
ngr_rot = sum(gr_bool(:) & arena_rot(:) ~= 0);

nmis_no_rot = sum(mismatch_bool(:) & arena_rot(:) == 0);
nloc_no_rot = sum(local_bool(:) & arena_rot(:) == 0);
ndist_no_rot = sum(distal_bool(:) & arena_rot(:) == 0);
ngr_no_rot = sum(gr_bool(:) & arena_rot(:) == 0);

breakdown = [nmis_rot-ndist_rot, nloc_rot, ndist_rot, ngr_rot; ...
             nmis_no_rot-ndist_no_rot, nloc_no_rot, ndist_no_rot, ngr_no_rot];

end

