function [ thetas ] = twoenv_get_entry_angles( sesh )
% thetas = twoenv_get_entry_angles( sesh )
%   Note that his direction at entry is pretty hard to tell. However, entry
%   location, and landing direction are legit. Square angles are restricted
%   to 90 degree angles.
%
%   thetas = [theta_enter, theta_enterdir, theta_landdir];

sesh = complete_MD(sesh);
dir = sesh.Location;
issquare = regexpi(dir, 'square');

load(fullfile(dir,'entry_tracking.mat'))
load(fullfile(dir,'Pos.mat'),'xpos_interp','ypos_interp')

% Get center of maze
[fx, xx] = ecdf(xpos_interp*0.6246);
[fy, yy] = ecdf(ypos_interp*0.6246);
if ~isempty(regexpi(sesh.Env, 'combined')) || ~isempty(regexpi(sesh.Env, 'standard'))
    cx = xx(findclosest(fx,0.25));
elseif isempty(regexpi(sesh.Env, 'combined')) && isempty(regexpi(sesh.Env, 'standard'))
    cx = xx(findclosest(fx,0.5)); % hack for connected days
end
cy = yy(findclosest(fy,0.5));

% Get angles
theta_enter = atan2d(entry_tracking.yEnter/0.6246 - cy, ...
    entry_tracking.xEnter/0.6246 - cx);
theta_enterdir = atan2d(entry_tracking.yEnterDir, entry_tracking.xEnterDir);
theta_landdir = atan2d(entry_tracking.yLandDir, entry_tracking.xLandDir);
thetas = [theta_enter, theta_enterdir, theta_landdir];
thetas(thetas < 0) = thetas(thetas < 0) + 360;

square_angles = 0:90:360;
if issquare
   thetas(~isnan(thetas)) = square_angles(arrayfun(@(a) ...
       findclosest(a,square_angles), thetas(~isnan(thetas))));
   thetas(thetas == 360) = 0;
end

end

