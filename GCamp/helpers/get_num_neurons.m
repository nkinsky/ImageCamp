function [num_neurons] = get_num_neurons(MD)
% num_neurons = get_num_neurons(MD)
%  Gets # neurons for all sessions listed in MD.
nsesh = length(MD);

num_neurons = nan(1, nsesh);
for j = 1:nsesh
    NumNeurons = nan;
    load(fullfile(MD(j).Location, 'FinalOutput.mat'), 'NumNeurons');
    num_neurons(j) = NumNeurons;
end

end

