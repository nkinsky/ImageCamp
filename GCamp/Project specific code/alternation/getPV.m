function [ PV, PVz, unique_bins ] = getPV( PSAbool, occbin )
% [ PV, PVz ] = getPV( PSAbool, occbin )
%   Spits out a num_neurons x num_bins PV of mean and z-scored activity
%   levels for each neuron in each unique occupancy bin indicated in
%   occbin.  length(occbin) must match the 2nd dimension of PSAbool. Need
%   to create a way to get shuffled values.

% Get population mean and std for later z-scoring
PVmean = mean(PSAbool,2);
PVstd = std(PSAbool,1,2);

% Identify all non-NaN bins
unique_bins = unique(occbin);
unique_bins = unique_bins(~isnan(unique_bins));

% Calculate PV
PV = nan(size(PSAbool,1),length(unique_bins));
PVz = nan(size(PSAbool,1),length(unique_bins));
for j = 1:length(unique_bins)
   bin_use = unique_bins(j);
   PV(:,j) = mean(PSAbool(:, occbin == bin_use),2);
   PVz(:,j) = (PV(:,j) - PVmean)./PVstd;
end


end

