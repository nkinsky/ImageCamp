function [ dist_matrix ] = neuron_dist( NeuronImage )
% dist_matrix = neuron_dist( NeuronImage )
%
%   Gets the distance from the centroid of each neuron mask in the cell
%   NeuronImage to every other neuron mask

num_neurons = length(NeuronImage);

centroid = zeros(length(NeuronImage),2);
for j = 1:num_neurons
    stats = regionprops(NeuronImage{j} > 0,'Centroid');
    centroid(j,:) = stats.Centroid;
end

dist_matrix = nan(num_neurons, num_neurons);
for j = 1:num_neurons
    for k = 1:num_neurons
        if j ~= k
            centroid_delta = centroid(j,:) - centroid(k,:);
            dist_matrix(j,k) =  sqrt(centroid_delta(1)^2 + centroid_delta(2)^2);
        end
    end
end

