function [speedL, speedR] = alt_get_trial_speed(session)
% [speedL, speedR] = alt_get_trial_speed(session)
%   Gets speed on all L and R correct trials for all points

isrunning = []; time_interp = []; Alt = []; 
load(fullfile(session.Location, 'Placefields_cm1.mat'), 'isrunning')
load(fullfile(session.Location, 'Pos.mat'), 'time_interp')
load(fullfile(session.Location, 'Alternation.mat'), 'Alt')

% Calculate speed and smooth
time = time_interp(isrunning);
tdiff = diff(time);
SRuse = round(1/median(tdiff)); % Get ~sample rate of imaging camera
tdiff(end + 1) = median(tdiff);
xdiff = diff(Alt.x);
xdiff(end + 1) = xdiff(end);
% Calculate speed in x-direction only. This will give wonky velocity values
% for all cross-arm occupancy. However, since we are ONLY worried about the
% stem for each trial, this shouldn't matter.
speed = abs(xdiff)./tdiff; 
speed_sm = convtrim(speed,ones(1,2*SRuse))./(2*SRuse);

% Identify correct L and R trials
corrLtrials = unique(Alt.trial(Alt.alt == 1 & Alt.choice == 1));
corrRtrials = unique(Alt.trial(Alt.alt == 1 & Alt.choice == 2));

%%
% Pre-allocate!
speedL = nan(length(corrLtrials),1);
speedR = nan(length(corrRtrials),1);

for j = 1:length(corrLtrials)
    speedL(j) = mean(speed_sm(Alt.trial == corrLtrials(j) & ...
        Alt.section == 2));
end

for j = 1:length(corrRtrials)
    speedR(j) = mean(speed_sm(Alt.trial == corrRtrials(j) & ...
        Alt.section == 2));
end


end

