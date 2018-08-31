function [ ha ] = plot_registration( MD1, MD2, name_append, ha )
% ha = plot_registration( MD1, MD2, name_append, ha )
% Plots ROIs from each session overlaid on one another after registering
% MD2 to MD1. Later goal is to have one plot be the registration and the
% other be registration metrics... name_append (optional) is appended to the end of
% the neuron map and image registration files. ha (optional) is handle to
% plotting axes (otherwise a new figure is created.

if nargin < 4
    ha = '';
    if nargin < 3
        name_append = '';
    end
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

ha = plot_reg_neurons(neuron_map, reginfo, sesh(1).ROIs, sesh(2).ROIs, ...
    true, ha);

% Add in mouse name and sessions to title
title_use = get(gca,'Title');
title_use.String = {title_use.String, [mouse_name_title(MD1.Animal) mouse_name_title(name_append)], ...
    [mouse_name_title(MD1.Date) '-s' num2str(MD1.Session) ' to ' ...
    mouse_name_title(MD2.Date) '-s' num2str(MD2.Session)]};

end

