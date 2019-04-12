function [ corr_out ] = corr3d( array1, array2, dim )
% corr_out  = corr3d( array1, array2, dim )
%   Default: Performs correlations between two 3d arrays (n1 x n2 x n3) along the
%   3rd dimension and ouputs an n1 x n2 correlation matrix. Can also input
%   a single (2 x n1 x n2 x n3) array. Output = n1 x n2 array.
%
%   Optional: set dim to 12 to perform 2d correlations for each point in
%   dimension 3. Output = n3 x 1 array.

if nargin < 3
    dim = 3;
    if nargin < 2
        temp = array1;
        array1 = squeeze(temp(1,:,:,:));
        array2 = squeeze(temp(2,:,:,:));
    end
end

[nBinsx, nBinsy, n3] = size(array1);
if ~all(size(array1) == size(array2))
    error('array1 and array2 are not the same size')
end

if dim == 3
    corr_out = nan(nBinsx,nBinsy);
    for j = 1:nBinsx
        for k = 1:nBinsy
            PVa = squeeze(array1(j,k,:));
            PVb = squeeze(array2(j,k,:));
            corr_out(j,k) = corr(PVa,PVb,'type','Spearman','rows','complete');
        end
    end
elseif dim == 12
    corr_out = nan(n3,1);
    for j = 1:n3
       corr_out(j) = corr2d(array1(:,:,j), array2(:,:,j), 'type', 'Spearman', ...
           'rows', 'complete');
    end
end

end

