function [rho, pval] = corr2d(array1, array2, varargin)
% [rho, pval] = corr2d(array1, array2, ...)
%   Wrapper function for 'corr' that lets you do 2d correlations with all
%   the same arguments you would pass to corr.
[rho, pval] = corr(array1(:), array2(:), varargin{:});

end

