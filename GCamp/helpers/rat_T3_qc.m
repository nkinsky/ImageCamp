% Rat Tenaspis debugging scripts

%% Scroll through each neuron, look at average triggered frame, ROI location,
% and trace
sesh_use = MD(293);
ChangeDirectory_NK(sesh_use)

load('T2output.mat','NeuronImage','FT');
load('NormTraces.mat','trace')
allmask = create_AllICmask(NeuronImage); 
FT_use{1} = FT;
FTTrigAvgs = MakeTrigAvg(FT_use);

figure(1) 
for j = 1:length(FTTrigAvgs{1}); 
    b = bwboundaries(NeuronImage{j},'noholes'); 
    subplot(2,2,1) 
    hold off 
    imagesc(FTTrigAvgs{1}{j}); 
    hold on 
    plot(b{1}(:,2),b{1}(:,1),'r')
    title(['Neuron ' num2str(j)]); 
    
    subplot(2,2,2)
    hold off
    imagesc(allmask)
    hold on
    plot(b{1}(:,2),b{1}(:,1),'r')
    
    subplot(2,2,[3 4]) 
    plot(trace(j,:))
    hold on
    plot(find(logical(FT(j,:))),trace(j,logical(FT(j,:))),'r.')
    title(['Neuron ' num2str(j)])
    hold off
    waitforbuttonpress
end