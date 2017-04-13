function [n1, n2, nboth ] = plot_mapped_neurons( Animal, Base_Date, Base_Session, Reg_Date, Reg_Session)
% [n1, n2, nboth] = plot_mapped_neurons( Animal, Base_Date, Base_Session, Reg_Date, Reg_Session)
%   Plots each session's neuron ROIs overlaid on the other.  Good for
%   identifying good/bad registrations.  Same as plot_mapped_neurons2 but
%   with different inputs.
%
%   n1, n2, nboth: # cells active in session 1 only, session 2 only, and
%   both

base_dir = ChangeDirectory(Animal, Base_Date, Base_Session, 0);
load(fullfile(base_dir,'FinalOutput.mat'),'NeuronImage');
sesh(1).NeuronImage_reg = NeuronImage;
image_reg_file = fullfile(base_dir, ['RegistrationInfo-' Animal '-' ...
    Reg_Date '-session' num2str(Reg_Session) '.mat']);
reg_dir = ChangeDirectory(Animal, Reg_Date, Reg_Session, 0);
load(fullfile(reg_dir,'FinalOutput.mat'),'NeuronImage');
reginfo = importdata(image_reg_file);
sesh(2).NeuronImage_reg = cellfun(@(a) imwarp_quick(a, reginfo), ...
    NeuronImage, 'UniformOutput', 0);

neuron_map = neuron_register(Animal, Base_Date, Base_Session, ...
    Reg_Date, Reg_Session);
neuron_id = neuron_map.neuron_id;

for k = 1:2
    sesh(k).AllNeuronMask = create_AllICmask(sesh(k).NeuronImage_reg);
end

% This is sort-of a hack
figure;
imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); 
hc = colorbar;
title('Red outline = same neuron across sessions')
hold on
nboth = 0;
for j = 1:length(neuron_id)
    nid = neuron_id{j};
    if ~isempty(nid) && ~isnan(nid)
        b1 = bwboundaries( sesh(1).NeuronImage_reg{j},'noholes');
        b2 = bwboundaries(sesh(2).NeuronImage_reg{nid},'noholes');
        plot(b1{1}(:,2),b1{1}(:,1),'r',b2{1}(:,2),b2{1}(:,1),'r');
        nboth = nboth + 1;
    end
end
hold off

n1 = length(sesh(1).NeuronImage_reg) - nboth;
n2 = length(sesh(2).NeuronImage_reg) - nboth;

hc.Ticks = [1 2 3]; 
hc.TickLabels = {'Session 1 only' 'Session 2 only' 'Overlap'};

end

