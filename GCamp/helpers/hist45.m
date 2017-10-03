function [ n, edges, x45, y45 ] = hist45(xdata, ydata, num_bins )
% [ n, edges, x2, y2 ] = hist45(xdata, ydata, num_bins )
%   Plots 45 degree histograms per Roux et al., 2017

if nargin < 3
    num_bins = 10;
end

%% Transform Data 
[ x45, y45 ] = proj45( xdata, ydata);

%% Get histogram

h = histogram(x45,num_bins);
n = h.Values;
edges = h.BinEdges;

end

