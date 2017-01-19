function [ ] = plot_mapped_neurons( Animal, Base_Date, Base_Session, Reg_Date, Reg_Session)
% plot_mapped_neurons( Animal, Base_Date, Base_Session, Reg_Date, Reg_Session)
%   Plots each session's neuron ROIs overlaid on the other.  Good for
%   identifying good/bad registrations

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
imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); colorbar
title('1 = session 1, 2 = session 2, red outline = both')
hold on
for j = 1:length(neuron_id)
    nid = neuron_id{j};
    if ~isempty(nid) && ~isnan(nid)
        b1 = bwboundaries( sesh(1).NeuronImage_reg{j},'noholes');
        b2 = bwboundaries(sesh(2).NeuronImage_reg{nid},'noholes');
        plot(b1{1}(:,2),b1{1}(:,1),'r',b2{1}(:,2),b2{1}(:,1),'r');
    end
end
hold off



end

