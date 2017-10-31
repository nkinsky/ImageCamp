function [ FR_vector_master] = assign_FR( FR_vector_session, map_use, silent_include )
% FR_vector_master = assign_FR( FR_vector_session, map_use, zero_FR )
%
% Takes a vector of firing rates from a given session (FR_vector_session) and the neuron
% mapping to the master session and outputs the same vector but with each
% row corresponding to the master neuron number (FR_vector_master).  Puts nans where map_use
% indicates a bad mapping. FR_vectors are n x 1 vectors.
%
%   silent_include: true = set silent cell rates (batch_map value = 0) to 0
%   (default).  false = set to NaN.

if nargin < 3
    silent_include = true;
end

% map_use = batch_map(:,j+1);
%%
nan_neurons = isnan(map_use);

temp = unique(map_use); % Get numbers of all neurons properly mapped in this session
map_unique = temp(~isnan(temp) & temp ~= 0); 

if silent_include
    temp_FR = zeros(size(map_use,1),1);
elseif ~silent_include
    temp_FR = nan(size(map_use,1),1);
end
%%
for k = 1:length(map_unique) % 1:max(map_use)
    neuron_id = map_use == map_unique(k);
    temp_FR(neuron_id) = FR_vector_session(map_unique(k)); % Assign FR for that session to appropriate master neuron number
end

% Put nans wherever the neuron is not properly mapped
temp_FR(nan_neurons) = nan;

FR_vector_master = temp_FR;

end

