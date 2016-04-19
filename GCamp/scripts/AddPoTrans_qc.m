% AddPoTransients QC Comparison

%% Directories
new_dir = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working';
old_dir = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working old version';
%% Load variables

disp('Load variables')
load('ExpTransients.mat','PosTr');
es = load(fullfile(old_dir,'expPosTr.mat'));
e2 = load(fullfile(new_dir,'expPosTr_calcahead1.mat'));% load('expPosTr_take2_wbufix.mat');
esFT = load(fullfile(old_dir,'T2output.mat'),'FT');
e2FT = load(fullfile(new_dir,'T2output.mat'),'FT');
espeak = load(fullfile(old_dir,'pPeak.mat'));
e2peak = load(fullfile(new_dir,'pPeak.mat'));
% e3 = load(fullfile(new_dir,'expPosTr_calcahead0.mat')); % load('expPosTr_take3_wbugfix.mat');
% e3bug = load('expPosTr_take3_Nobugfix.mat','expPosTrsubs','expPosTrIdx');
% e4 = load('expPosTr_calcahead1.mat');%load('expPosTr_take4_wbufix.mat');
load(fullfile(new_dir,'expPosTr_calcahead1.mat'),'buddies');
load('NormTraces.mat','trace');
load('ProcOut.mat','Xdim','Ydim','NeuronPixels')
load('pPeak');

NumNeurons = size(PosTr,1);

%% Run through comparison
figure(500); 
time_plot = (1:size(trace,2))/20; 
for j=1:NumNeurons
    ha = []; hax = [];
    
    % Plot traces
    ha(1) = subplot(4,4,1:3);
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(es.expPosTr(j,:))),trace(j,logical(es.expPosTr(j,:))),'y.'); 
    hold on
        plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.'); 
    title(['Trace + master added transient (with bug) for neuron ' num2str(j)])
    hold off
    
    ha(2) = subplot(4,4,5:7);
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(es.expPosTr(j,:) & esFT.FT(j,:))),trace(j,logical(es.expPosTr(j,:) & esFT.FT(j,:))),'y.'); 
    hold on
        plot(time_plot(logical(PosTr(j,:) & esFT.FT(j,:))),trace(j,logical(PosTr(j,:) & esFT.FT(j,:))),'r.'); 
    title(['Trace + master added rising events (with bug) for neuron ' num2str(j)])
    hold off
    
    ha(3) = subplot(4,4,9:11);
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(e2.expPosTr(j,:))),trace(j,logical(e2.expPosTr(j,:))),'g.'); 
    hold on
    plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.');
    title(['Trace + NatT2\_edits calc\_ahead1 added transients for neuron ' num2str(j)])
    hold off
    
    ha(4) = subplot(4,4,13:15);
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(e2.expPosTr(j,:) & e2FT.FT(j,:))),trace(j,logical(e2.expPosTr(j,:) & e2FT.FT(j,:))),'g.'); 
    hold on
    plot(time_plot(logical(PosTr(j,:) & e2FT.FT(j,:))),trace(j,logical(PosTr(j,:) & e2FT.FT(j,:))),'r.');
    title(['Trace + NatT2\_edits calc\_ahead1 added rising events for neuron ' num2str(j)])
    hold off
    
%     ha(3) = subplot(4,4,9:11);
%     plot(time_plot,trace(j,:),'k',...
%         time_plot(logical(e3.expPosTr(j,:))),trace(j,logical(e3.expPosTr(j,:))),'c.'); 
%     hold on
%     plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.');
%     title(['Trace + NatT2\_edits calc\_ahead0 added transients for neuron ' num2str(j)])
%     hold off
    
%     ha(4) = subplot(4,4,13:15);
%     plot(time_plot,trace(j,:),'k',...
%         time_plot(logical(e4.expPosTr(j,:))),trace(j,logical(e4.expPosTr(j,:))),'b.'); 
%     hold on
%     plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.');
%     title(['Trace + calc\_ahead1 added transients for neuron ' num2str(j)])
%     hold off
    
    linkaxes(ha)
    
    % Plot locations of Neuron, pPeak, mRank, and added transient locations
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}) = 1;
    bw2 = bwperim(temp);
    centr = regionprops(temp,'Centroid');
    
    [yperim, xperim] = find(bw2);
    
%     hax(1) = subplot(4,4,4);
% %     temp(NeuronPixels{j}) = mRank{j};
%     temp = zeros(Xdim,Ydim);
%     temp(NeuronPixels{j}(es.expPosTrIdx{j}(es.expPosTrIdx{j} ~= 0))) = 1;
%     imagesc(temp);
%     hold on
%     plot(xperim,yperim,'r.')
%     title('calcmiddle added')
%     hold off
    
    hax(1) = subplot(4,4,4);
%     temp = zeros(Xdim,Ydim);
%     temp(NeuronPixels{j}(e2.expPosTrIdx{j}(e2.expPosTrIdx{j} ~= 0))) = 1;
%     imagesc(temp);
    hold on
    plot(xperim,yperim,'r.')
    title('added peak');
    hold off
    
    hax(2) = subplot(4,4,8);
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}) = espeak.mRank{j};
    imagesc(temp)
    hold on
    plot(xperim,yperim,'r.')
    title('mRank');
    hold off
    
    hax(3) = subplot(4,4,12);
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}(e2.expPosTrIdx{j}(e2.expPosTrIdx{j} ~= 0))) = 1;
%     temp(NeuronPixels{j}(e3bug.expPosTrIdx{j}(e3bug.expPosTrIdx{j} ~= 0))) = 2;
    imagesc(temp)
    hold on
    plot(xperim,yperim,'r.')
    title('added peak');
    hold off
    
    hax(4) = subplot(4,4,16);
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}) = e2peak.mRank{j};
    imagesc(temp)
    hold on
    plot(xperim,yperim,'r.')
    title('mRank');
    hold off
    
%     hax(4) = subplot(4,4,16);
%     temp = zeros(Xdim,Ydim);
%     temp(NeuronPixels{j}(e4.expPosTrIdx{j}(e4.expPosTrIdx{j} ~= 0))) = 1;
%     imagesc(temp)
%     hold on
%     plot(xperim,yperim,'r.')
%     title('calc\_ahead1 added w/bug');
%     hold off

    zwindow = 30;
    linkaxes(hax);
    xlim([centr.Centroid(1)-zwindow/2, centr.Centroid(1)+zwindow/2])
    ylim([centr.Centroid(2)-zwindow/2, centr.Centroid(2)+zwindow/2])
    
    waitforbuttonpress; 
end

%% Plot buddies

figure(501); 
time_plot = (1:size(trace,2))/20; 

escape_flage = 'exit';
j = 1;
stay_in = true;
while stay_in
    
    ha = []; hax = [];
    
    num_buddies = length(buddies{j});
    buddy_spike_times = sum(e2FT.FT(buddies{j},:),1) > 0;
    % Plot traces for neuron j
    ha(1) = subplot(num_buddies + 1,1,1);
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(e2FT.FT(j,:))),trace(j,logical(e2FT.FT(j,:))),'r.'); 
    hold on
        plot(time_plot(logical(buddy_spike_times)),trace(j,logical(buddy_spike_times)),'b.'); 
    title(['Trace for neuron 2 ' num2str(j)])
    legend('trace','Neuron event','Buddy event times')
    hold off
    
    for k = 1:num_buddies
        ha(k+1) = subplot(num_buddies + 1,1,k+1);
        plot(time_plot,trace(buddies{j}(k),:),'k',...
        time_plot(logical(e2FT.FT(buddies{j}(k),:))),trace(buddies{j}(k),logical(e2FT.FT(buddies{j}(k),:))),'b.');
    end
    
    linkaxes(ha)

    [j, stay_in] = LR_cycle(j,[1 NumNeurons]);
end




