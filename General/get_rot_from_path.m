function [rot] = get_rot_from_path( pathname, rot_overwrite )
% rot = get_rot_from_path( pathname )
%   Pulls out the arena rotation from the pathname to the location of the
%   AVI file.

if rot_overwrite == 1 % Don't rotate if flagged not to
    rot = 0;
elseif rot_overwrite == 0
    if ~isempty(regexpi(pathname,'90CW'))
        rot = 90;
    elseif ~isempty(regexpi(pathname,'90CCW'))
        rot = -90;
    elseif ~isempty(regexpi(pathname,'180'))
        rot = 180;
    else
        rot = 0;
    end
end

end

