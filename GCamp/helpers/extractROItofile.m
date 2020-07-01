function [] = extractROItofile(MD)
% extractROItofile(MD)
%   Takes the ROIs from FinalOutput.mat and saves them to NeuronROIs.mat
%   for archiving of processed data.

load(fullfile(MD.Location, 'FinalOutput.mat'),'NeuronImage');
save(fullfile(MD.Location, 'NeuronROIs.mat'), 'NeuronImage');

end

