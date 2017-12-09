function [ ha ] = plot_reg_neurons( neuron_map, tform, base_ref, ROIs1, ROIs2 )
% ha = plot_reg_neurons( neuron_map, tform, base_ref, ROIs1, ROIs2 )
%   Plots neurons overlaid on top of one another. neuron_map maps neurons
%   in session 2 to session 1. tform registers ROIs2 to ROIs1.

sesh.ROIs = ROIs1;
ROIs_reg = register_ROIs(ROIs2, tform, base_ref);
sesh(2).ROIs = ROIs_reg;

for k = 1:2
    sesh(k).AllNeuronMask = create_AllICmask(sesh(k).ROIs);
end

% This is sort-of a hack
figure;
imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); colorbar
title('1 = session 1, 2 = session 2, red outline = both')
hold on
for j = 1:length(neuron_map)
    neuron_use = neuron_id(j);
    if neuron_use ~= 0 && ~isnan(neuron_use)
        b1 = bwboundaries(sesh(1).ROIs{j},'noholes');
        b2 = bwboundaries(sesh(2).ROIs{neuron_use},'noholes');
        plot(b1{1}(:,2),b1{1}(:,1),'r',b2{1}(:,2),b2{1}(:,1),'r');
    end
end
hold off
% xlabel([mouse_name_title(mouse_name) ' ' mouse_name_title(base_date) ' session ' num2str(base_session) ...
%     ' to ' mouse_name_title(reg_date) ' session ' num2str(reg_session)]);
ha = gca;

end

