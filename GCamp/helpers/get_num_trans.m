function [NumTransients, trans_frames, LenTransients] = get_num_trans(PSAbool)
% [NumTransients, trans_frames, LenTransients] = get_num_trans(PSAbool)
%
% Gets the number of transients fired by each neuron in PSAbool, the frames
% when each neuron was active, and the lenth of transients =

num_neurons = size(PSAbool, 1);

NumTransients = nan(num_neurons, 1);
trans_frames = cell(num_neurons, 1);
LenTransients = cell(num_neurons, 1);
for j = 1:num_neurons
    temp = NP_FindSupraThresholdEpochs(PSAbool(j,:),eps);
    NumTransients(j,1) = size(temp, 1); % # of transients produces
    LenTransients{j,1} = diff(temp, 1, 2); % Get transient length
    trans_frames{j} = temp;
end

end

