function [ cov_mat ] = PVcov( PVin )
% cov_mat = PVcov( PVin )
%  Takes a spatial PV matrix (nXbins x nYbins x nNeurons) and spits out a
%  covariance matrix for all cells, using each spatial bin as an
%  observation.

[nbins1, nbins2, ~] = size(PVin);

%% Stack all the PVs together - each row is a spatial bin, each column is a
% neuron
PVcat = [];
for j = 1:nbins1
    for k = 1:nbins2
        PVbin = squeeze(PVin(j,k,:));
        PVcat = cat(1,PVcat,PVbin');
    end
end

%% Get the covariance
cov_mat = cov(PVcat,'omitrows');

end

