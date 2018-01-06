function [ cm_dist, cm_dist_min ] = get_ROIdist_simple( MD1, MD2, name_append )
% [ cm_dist, cm_dist_min ] = get_ROIdist_simple( MD1, MD2 )
%   Gets distances between all neurons in MD1 and MD2 and spits them out in
%   cm_dist with min dist to closest neighbor in cm_dist_min.

if nargin < 3
    name_append = '';
end

% Register neuron ROIs to each other
[ ROIs1, ROIs2 ] = register_ROIs_simple( MD1, MD2, name_append );

% Get COMs
[cm1(:,1), cm1(:,2)] = cellfun(@get_ROIcm, ROIs1);
[cm2(:,1), cm2(:,2)] = cellfun(@get_ROIcm, ROIs2);

% Get distances
cm_dist = get_cm_dist(cm1, cm2, true);
cm_dist_min = min(cm_dist,[],2);

end

