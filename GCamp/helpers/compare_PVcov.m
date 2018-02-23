function [ covmat1, covmat2, PV1good, PV2good, good_bool_both ] = compare_PVcov( PVpair )
% [ covmat1, covmat2, PV1good, PV2good, good_bool_both ] = compare_PVcov( PVpair )
%   Calculates covariance matrix for neurons in the PVpair.  PVpair is a 4D
%   array consisting of a pair of spatial population vectors, 
%   size = 2 x nbinsX x nbinsY x nneurons matrix. Spits out covariance
%   matrix for each session as well as "good" PVs that have removed any
%   neurons that have NaN values for all spatial bins in either session.
%   Also spits out boolean identifying good (non-NaN) neurons in PVpair.

% Extract PVs for each session
PV1 = squeeze(PVpair(1,:,:,:));
PV2 = squeeze(PVpair(2,:,:,:));
[n1, n2, nneurons] = size(PV1); % Get size of PV

% Identify good and bad neurons in each session
% eliminate any neurons with NaNs in ALL spatial bins
good_bool1 = ~all(isnan(reshape(PV1,n1*n2,nneurons)),1); 
good_bool2 = ~all(isnan(reshape(PV2,n1*n2,nneurons)),1);
good_bool_both = good_bool1 & good_bool2;
PV1good = PV1(:,:,good_bool_both);
PV2good = PV2(:,:,good_bool_both);

% Get covariance matrix for each PV
covmat1 = PVcov(PV1good);
covmat2 = PVcov(PV2good);

end

