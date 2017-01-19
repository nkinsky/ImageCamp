function [NumTransients] = get_num_trans(PSAbool)
% NumTransients = get_num_trans(PSAbool)
%
% Gets the number of transients fired by each neuron in PSAbool
num_neurons = size(PSAbool,1);

NumTransients = nan(num_neurons,1);
for j = 1:num_neurons
    temp = NP_FindSupraThresholdEpochs(PSAbool(j,:),eps);
    NumTransients(j,1) = size(temp,1);
end

end

