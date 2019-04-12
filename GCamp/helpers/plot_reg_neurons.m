function [ ha ] = plot_reg_neurons( neuron_map, reginfo, ROIs1, ROIs2, do_reg, ha )
% ha = plot_reg_neurons( neuron_map, tform, base_ref, ROIs1, ROIs2, do_reg, ha )
%   Parent function (easier to use) is plot_registration.
%   Plots neurons overlaid on top of one another. neuron_map maps neurons
%   in session 2 to session 1. reginfo comes from image_registerX. do_reg =
%   false does NOT register ROIs2 to ROIs1 (default = true). 

if nargin < 6 || isempty(ha) || ~ishandle(ha)
    figure; set(gcf,'Position',[700 220 980 720]);
    ha = gca;
end

if nargin < 5
    do_reg = true;
    
end

sesh.ROIs = ROIs1;
if do_reg
    ROIs_reg = register_ROIs(ROIs2, reginfo);
    sesh(2).ROIs = ROIs_reg;
elseif ~do_reg
    sesh(2).ROIs = ROIs2;
end

for k = 1:2
    sesh(k).AllNeuronMask = create_AllICmask(sesh(k).ROIs);
end

% This is sort-of a hack
axes(ha);
comb_mask = sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask;
comb_mask(comb_mask == 0) = nan;
cm = [0 0 1; 0 1 0; 1 1 0];
imagesc_nan(comb_mask, cm);
title('blue = session 1, green = session 2, yellow = overlapping ROIs, red outline = both')
hold on
for j = 1:length(neuron_map)
    neuron_use = neuron_map(j);
    if neuron_use ~= 0 && ~isnan(neuron_use)
        b1 = bwboundaries(sesh(1).ROIs{j},'noholes');
        b2 = bwboundaries(sesh(2).ROIs{neuron_use},'noholes');
        plot(b1{1}(:,2),b1{1}(:,1),'r',b2{1}(:,2),b2{1}(:,1),'r');
    end
end
hold off
ha = gca;
axis off;

end

