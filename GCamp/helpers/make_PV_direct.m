function [ PV ] = make_PV_direct( PSAbool, x, y, xlims, ylims, NumXBins, ...
    NumYBins, SR )
% PV = make_PV_direct( PSAbool, x, y, xlims, ylims, NumXBins, NumYBins, SR )
%   Makes a 2d spatial population vector.
%   PSAbool - putative spiking activity array - #neurons x #time bins
%   x,y - x and y position with same # time bins as PSAbool
%   xlims = [xmin xmax] of data. Ditto for ylims.
%   SR = frames/sec in PSAbool

% Calculate occupancy bin edges
xmin = xlims(1); xmax = xlims(2);
ymin = ylims(1); ymax = ylims(2);
Xedges = xmin:(xmax-xmin)/NumXBins:xmax;
Yedges = ymin:(ymax-ymin)/NumYBins:ymax;

% Get bin for each position of the animal
[~,Xbin] = histc(x,Xedges);
[~,Ybin] = histc(y,Yedges);

% Calculate PV
PV = nan(NumYBins, NumXBins, size(PSAbool,1)); % pre-allocate
for j = 1:NumXBins
    for k = 1:NumYBins
        PV(k,j,:) = sum(PSAbool(:,Xbin == j & Ybin == k),2)/...
            (length(x)/SR); % Firing rate in Hz for each neuron
    end
end

end

