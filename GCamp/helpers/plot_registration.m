function [ ha ] = plot_registration( MD1, MD2, name_append )
% ha = plot_registration( MD1, MD2, name_append )
% Plots ROIs from each session overlaid on one another after registering
% MD2 to MD1. Later goal is to have one plot be the registration and the
% other be registration metrics... name_append is appended to the end of
% the neuron map and image registration files.

if nargin < 3
    name_append = '';
end

sesh = complete_MD(MD1);
sesh(2) = complete_MD(MD2);

neuron_map = neuron_map_simple(MD1, MD2, 'name_append', name_append,...
    'suppress_output',true);
reginfo = image_registerX(MD1.Animal, MD1.Date, MD1.Session, MD2.Date,...
    MD2.Session, 'name_append', name_append,'suppress_output',true);

for j = 1:2
   load(fullfile(sesh(j).Location,'FinalOutput.mat'),'NeuronImage');
   sesh(j).ROIs = NeuronImage;
end

ha = plot_reg_neurons(neuron_map, reginfo, sesh(1).ROIs, sesh(2).ROIs);
xlabel([mouse_name_title(sesh(1).Animal) ' ' mouse_name_title(sesh(1).Date) ...
    ' session ' num2str(sesh(1).Session) ...
    ' to ' mouse_name_title(sesh(2).Date) ' session ' num2str(sesh(2).Session)]);

end

