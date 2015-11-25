function [ output_args ] = dist_bw_reg_sessions( BinBlobs_reg )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_sessions = length(BinBlobs);
num_neurons = length(BinBlobs{1});

% Get cms for each neuron
for j = 1:num_sessions
   for k = 1: num_neurons
      stats_temp = regionprops(BinBlobs_reg{j}{k},'Centroid','PixelIdxList');
      neuron_cm{j}{k} = stats_temp.Centroid;
   end
   
end

% Calculating difference in centers-of-mass for these neurons
cm_dist = nan(num_sessions-1, num_sessions, num_neurons);
for k = 1:num_sessions-1
    for ll = k+1:num_sessions
        for j = 1:num_neurons
            cm_dist(k,ll,j) = pdist([neuron_cm{k}{j}; neuron_cm{ll}{j}]);
        end
    end
end


end

