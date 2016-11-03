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
NumNeurons = length(FTTrigAvgs{1});

figure(1) 
n_out = 1;
stay_in = true;
while stay_in
    
    b = bwboundaries(NeuronImage{n_out},'noholes');
    subplot(2,2,1)
    hold off
    imagesc(FTTrigAvgs{1}{n_out});
    hold on
    plot(b{1}(:,2),b{1}(:,1),'r')
    title(['Neuron ' num2str(n_out)]);
    
    subplot(2,2,2)
    hold off
    imagesc(allmask)
    hold on
    plot(b{1}(:,2),b{1}(:,1),'r')
    
    subplot(2,2,[3 4])
    plot(trace(n_out,:))
    hold on
    plot(find(logical(FT(n_out,:))),trace(n_out,logical(FT(n_out,:))),'r.')
    title(['Neuron ' num2str(n_out)])
    hold off
    
    [n_out, stay_in] = LR_cycle(n_out, [1 NumNeurons]);
end