function [first_trans_frames] = get_first_transient(PSAbool)
% first_trans_frames = get_first_transient(PSAbool)
%   Gets the frame when the first transient starts for each neuron in
%   PSAbool

nneurons = size(PSAbool,1);

first_trans_frames = nan(nneurons,1);
for j = 1:size(PSAbool,1)
    try
        first_trans_frames(j) = find(PSAbool(j,:),1,'first');
    end
end
end

