function [ROI_reg] = ROIwarp( base_sesh, reg_sesh )
% ROI_reg = ROIwarp( base_sesh, reg_sesh )
%   Registers neuron ROIs from reg_sesh to match base_sesh.

% base_dir = ChangeDirectory(base_sesh.Animal, base_sesh.Date, base_sesh.Session);
reg_dir = ChangeDirectory(reg_sesh.Animal, reg_sesh.Date, reg_sesh.Session);

% Register sessions
reginfo = image_registerX(base_sesh.Animal, base_sesh.Date, base_sesh.Session,...
    reg_sesh.Date, reg_sesh.Session);

load(fullfile(reg_dir,'FinalOutput.mat'),'NeuronImage');
ROI_reg = cellfun(@(a) imwarp_quick(a, reginfo), NeuronImage, ...
    'UniformOutput', false);

end

