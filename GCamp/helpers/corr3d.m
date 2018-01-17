function [ corr2d_out ] = corr3d( array1, array2 )
% corr2d_out  = corr3d( array1, array2 )
%   Performs correlations between two 3d arrays (n1 x n2 x n3) along the
%   3rd dimension and ouputs an n1 x n2 correlation matrix. Can also input
%   a single (2 x n1 x n2 x n3) array.

if nargin < 2
    temp = array1;
    array1 = squeeze(temp(1,:,:,:));
    array2 = squeeze(temp(2,:,:,:));
end

[nBinsx, nBinsy, ~] = size(array1);
if ~all(size(array1) == size(array2))
    error('array1 and array2 are not the same size')
end

corr2d_out = nan(nBinsx,nBinsy);
for j = 1:nBinsx
    for k = 1:nBinsy
        PVa = squeeze(array1(j,k,:));
        PVb = squeeze(array2(j,k,:));
        corr2d_out(j,k) = corr(PVa,PVb,'type','Spearman','rows','complete');
    end
end


end

