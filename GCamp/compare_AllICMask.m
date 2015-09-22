function [ output_args ] = compare_AllICMask(base_struct, reg_struct)
% compare_AllNeuronMask( base_struct, reg_struct )
%   Compare the neuron masks from base session to reg session
%
%   INPUTS
%   base_struct: data structure (see MakeMouseSessionList) with all session
%   information about the base session
%   reg_struct: same as above, but with info about the registration
%   structure

currdir = cd;

% Get base structure neuron masks, create Allmask
ChangeDirectory(base_struct.Animal, base_struct.Date, base_struct.Session);
load('ProcOut.mat', 'NeuronImage')
base_neurons = NeuronImage;
base_AllMask = create_AllICmask(base_neurons);
base_min_proj = imread('ICmovie_min_proj.tif');

reg_filename = ['RegistrationInfo-' reg_struct.Animal '-' reg_struct.Date '-session' ...
    num2str(reg_struct.Session) '.mat'];
load(reg_filename)

% Get reg structure neuron masks
ChangeDirectory(reg_struct.Animal, reg_struct.Date, reg_struct.Session);
load('ProcOut.mat', 'NeuronImage')
reg_neurons = NeuronImage;
reg_AllMask = create_AllICmask(reg_neurons);
reg_min_proj = imread('ICmovie_min_proj.tif');

% register reg_AllMask to base and min_proj to base
reg_AllMask_reg = imwarp(reg_AllMask, RegistrationInfoX.tform, 'OutputView',...
    RegistrationInfoX.base_ref, 'InterpolationMethod','nearest');
reg_min_proj_reg = imwarp(reg_min_proj, RegistrationInfoX.tform, 'OutputView',...
    RegistrationInfoX.base_ref, 'InterpolationMethod','nearest');

% Plot them both on top of one another
figure
imagesc(base_AllMask + 2*reg_AllMask_reg);
title([base_struct.Animal ': ' base_struct.Date ' Session ' num2str(base_struct.Session) ...
    ' vs. ' reg_struct.Date ' Session ' num2str(reg_struct.Session)]);
colorbar;
colormap;

figure
subplot(2,2,1); imagesc_gray(base_min_proj); title('Base min projection')
subplot(2,2,2); imagesc_gray(reg_min_proj); title('Reg min projection - unregistered');
subplot(2,2,3); imagesc_gray(reg_min_proj_reg); title('Reg min projection - registered');
subplot(2,2,4); imagesc_gray(base_min_proj - reg_min_proj_reg); title('Base - reg');

keyboard

cd(currdir)
end

