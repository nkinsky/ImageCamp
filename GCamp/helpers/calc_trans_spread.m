function [ dd_mean, dd_std ] = calc_trans_spread( PSAbool, x, y )
% [dd_mean, dd_std ] = calc_trans_spread( PSAbool, x, y )
%   Calculates the mean distance between the mouse's position for all
%   firing epochs above the speed thresh.  Inputs are from Placefields.mat
num_neurons = size(PSAbool,1);

dd_mean = nan(num_neurons,1);
dd_std = nan(num_neurons,1);
for j = 1:num_neurons
    PSA = PSAbool(j,:);
    num_pts = sum(PSA);
    x_use = x(PSA); y_use = y(PSA);
    dd = nan(num_pts,num_pts);
    for k = 1:num_pts-1
        for ll = 2:num_pts
            dd(j,k) = ((x_use(k)-x_use(ll))^2 + (y_use(k)-y_use(ll))^2)^0.5;
        end
    end
    dd_mean(j) = nanmean(dd(:));
    dd_std(j) = nanstd(dd(:));
end

end

