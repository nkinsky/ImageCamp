function [ reg_NeuronImage ] = get_regNeuronImage( base_mds, reg_mds )
%[ reg_NeuronImage ] = get_regNeuronImage( base_mds, reg_mds )
%   Spits out neuron masks that have all been registered to the base
%   session and can be overlaid with base image neurons. NOTE that
%   image_reg_simple must have already been ran between the two sessions
%   and ProcOut.mat must reside in the registration directory.
%
%   INPUTS
%   base_mds and reg_mds: structures with the fields .Animal, .Date, and
%   .Session (if not specified will default to 1), matching the format of MakeMouseSessionList.  
%
%   OUTPUTS
%   reg_NeuronImage: NeuronImage (from ProcOut.mat) for the reg session
%   that has been registered (and is thus the same size) back to the base
%   session

if ~isfield(base_mds,'Session')
    base_mds.Session = 1;
end

if ~isfield(reg_mds,'Session')
    reg_mds.Session = 1;
end


currdir = cd;
% Load Registration Session Neuron masks
ChangeDirectory(base_mds.Animal, reg_mds.Date, reg_mds.Session);
load('ProcOut.mat','NeuronImage');
% Load Registration Info between base and register sessions
ChangeDirectory(base_mds.Animal, base_mds.Date, base_mds.Session);
load(['RegistrationInfo-' base_mds.Animal '-' reg_mds.Date ...
    '-session' num2str(reg_mds.Session)]);

% Pre-allocate
reg_NeuronImage = cell(size(NeuronImage));
for k = 1:length(NeuronImage)
    reg_NeuronImage{k} = imwarp(NeuronImage{k},RegistrationInfoX.tform,'OutputView',...
        RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
end

cd(currdir);

end

