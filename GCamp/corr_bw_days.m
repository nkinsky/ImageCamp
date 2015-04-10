function [ corr_1st_2nd] = corr_bw_days(rate_map1, rate_map2, tform, exclude)
%[corr_1st_2nd] = corr_bw_sessions(rate_map1, rate_map2) 
%   Get correlation between rate maps between two sessions.  
%
%   rate_map1 and
%   rate_map2 are the rate maps (could be place field heat maps, reverse
%   place fields, a population vector of firing rates at a given place like
%   a reward location, etc.).  They are currently set as cells, and must
%   have the same x/y dimensions. 
%
%   tform is an affine transfrom that takes the image data from the 2nd
%   session (rate_map2) and registers it onto the 1st session (rate_map1)
%   so that you can make comparisons...
%
%   exclude is a binary vector of indices you want to exclude from using in
%   your calculation of correlations.  Could be where there is blood, or
%   where there are zeroed out pixels as a result of image registration

%%% NRK - should test this with same session data, but with an adjusted
%%% rate_map2 with some data from the edges deleted to mimic a
%%% registration.  Also, should figure out how to exclude any data that
%%% becomes an NaN due to the registration!

NumXBins = size(rate_map1,2);
NumYBins = size(rate_map1,1);

if nargin < 3
    include = ones(length(rate_map(:)),1); % Include everything
else
    include = find(~exclude);
end

corr_1st_2nd = zeros(size(rate_map1));
for j=1:NumYBins
    for i = 1:NumXBins
        rate_map2{j,i} = imwarp(rate_map2{j,i},tform,'OutputView',...
    imref2d(size(rate_map1{j,i})),'InterpolationMethod','nearest');
        temp = corrcoef(rate_map1{j,i}(include),rate_map2{j,i}(include));
        corr_1st_2nd(j,i) = temp(1,2);
    end
end



end
