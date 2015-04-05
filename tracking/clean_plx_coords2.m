function [path, LEDs, rawLEDs, hd]= clean_plx_coords2(rawLEDs,smoothstamps)
%CLEAN_PLX_COORDS    Clean-up the coordinates produced by Plexon CinePlex
%   CLEAN_PLX_COORDS takes as input the raw coordinates from CinePlex video
%   tracking data (see PLX_VT_INTERPRET and PLX_EVENT_TS) and sanitizes
%   the coordinates.
%
% [c] = clean_plx_coords(c_raw)
%
% INPUT:
%   rawLEDs  - Raw LED coordinates read directly from the data file. Data
%              format depends upon the nVTMode (see PLX_VT_INTERPRET)
%   smoothstamps - scalar. Number of timestamps that are smoothed
%
% OUTPUT:
%   path     - The animals position (average of LED positions)
%   LEDs     - Cleaned LED coordinates:
%              - Timestamps with all zero coordinates have been removed.
%              - Zero coordinates have been replaced with NaNs.
%              - Coordinates where the LEDs were too far apart to be valid
%                were removed.
%              - Coordinates were smoothed.
%
%   rawLEDs  - Original LED coordinates except for the following:
%              - Zero coordinates have been replaced with NaNs.
%
%   See also PLX_VT_INTERPRET, PLX_EVENT_TS.

% Written by Benjamin Kraus (bkraus@bu.edu) 2008
% Edited by Jon Rueckemann 2014
%% Initialize variables
maxgap = 45; %Max valid distance between LEDs in pixels (appx. 8-9 cm for most situations)


% Just in case we are using this script to clean up data that has
% previously been fed through this function.
rawLEDs(isnan(rawLEDs)) = 0;

LEDs = rawLEDs;

n = size(LEDs, 1);
nDim = size(LEDs, 2);
nCoordSets = floor((nDim - 1)/2);

%% Check that the input is valid.
if(nCoordSets<1 || nCoordSets>3); error('Invalid coordinate input.'); end
if(nCoordSets ~=2); warning('BK:Ephys:nCoords','Many aspects of this function assume 2 coordinate sets.'); end

%% Record points where at least one data point is missing.
miss = false(n, nCoordSets);
for i = 1:nCoordSets
    xi = 2*i;
    yi = xi+1;
    miss(:,i) = (LEDs(:,xi) == 0 & LEDs(:,yi) == 0);
end

%% NaN out points where the gap (between LEDs) is too large.

% FIX - assumes exactly two coordinates
if(nCoordSets == 2)
    gap = sqrt((LEDs(:,2)-LEDs(:,4)).^2+(LEDs(:,3)-LEDs(:,5)).^2);
    gap(any(miss(:,1:2),2)) = 0;
    toobig = (gap>maxgap);
    miss(toobig,1:2) = true;
    LEDs(toobig,2:5) = nan;
end

%% Remove points where there is no data provided.
nullpoint = all(miss,2);
LEDs = LEDs(~nullpoint, :);
miss = miss(~nullpoint, :);

%% Fill in missing data points

% Before calculating the path of the animal, fill in missing data points
% based on existing data points. This is so that when one (or two) LED(s)
% disappear, the path of the animal doesn't suddently jump to the remaining
% LED position.

tmpLEDs = LEDs;

% FIX - assumes exactly two coordinates
if(nCoordSets == 2)
    allgood = ~any(miss(:,1:2),2);
    gap12 = [LEDs(:,2) - LEDs(:,4), LEDs(:,3) - LEDs(:,5)];
    newgap12 = interp1(LEDs(allgood,1), gap12(allgood,:), LEDs(miss(:,1),1), 'linear');
    newgap21 = interp1(LEDs(allgood,1), gap12(allgood,:), LEDs(miss(:,2),1), 'linear');

    tmpLEDs(miss(:,1),2) = LEDs(miss(:,1),4) + newgap12(:,1);
    tmpLEDs(miss(:,1),3) = LEDs(miss(:,1),5) + newgap12(:,2);

    tmpLEDs(miss(:,2),4) = LEDs(miss(:,2),2) - newgap21(:,1);
    tmpLEDs(miss(:,2),5) = LEDs(miss(:,2),3) - newgap21(:,2);

    % The process above could produce NaNs if the first few or last few data
    % points are missing one or more LEDs. In that case, remove those points.
    toremove = isnan(sum(tmpLEDs(:,2:5),2));
    tmpLEDs = tmpLEDs(~toremove,:);
    LEDs = LEDs(~toremove,:);
    miss = miss(~toremove,:);
end

%% Smooth the data
for i = 1:nCoordSets
    xi = 2*i;
    yi = xi+1;
    tmpLEDs(:,xi) = smooth(tmpLEDs(:,1),tmpLEDs(:,xi),smoothstamps,'moving');
    tmpLEDs(:,yi) = smooth(tmpLEDs(:,1),tmpLEDs(:,yi),smoothstamps,'moving');
    LEDs(~miss(:,i),xi:yi) = tmpLEDs(~miss(:,i),xi:yi);
end

%% Calculate the path of the animal.

% The path of the animal is now just the average position of the LEDs.
x = mean(tmpLEDs(:,2:2:nDim), 2);
y = mean(tmpLEDs(:,3:2:nDim), 2);

path = [LEDs(:,1) x y];

if(nCoordSets >= 2)
    hd = atan2(tmpLEDs(:,3)-tmpLEDs(:,5),tmpLEDs(:,4)-tmpLEDs(:,2));
    path = [path hd];
end

%% Replace any zeros with NaNs.

LEDs(LEDs == 0) = nan;
rawLEDs(rawLEDs == 0) = nan;

%% Fill in missing timestamps in the path
ts = path(1,1):1/30:path(end,1);
ts = round(ts'.*1000)./1000;
path = interp1(path(:,1),path(:,2:end),ts,'pchip');

if(nCoordSets >= 2)
    hd = path(:,3);
    path = [ts round(path(:,1:2))];    
else
    path = [ts round(path)];
    hd = nan(size(path,1),1);
end

end
