% AddPoTransients QC Comparison

%% Load variables

disp('Load variables')
load('ExpTransients.mat','PosTr');
es = load('expPosTr_slow.mat');
e2 = load('expPosTr_take2_wbufix.mat');
e3 = load('expPosTr_take3_wbugfix.mat');
e3bug = load('expPosTr_take3_Nobugfix.mat','expPosTrsubs','expPosTrIdx');
e4 = load('expPosTr_take4_wbufix.mat');
load('NormTraces.mat','trace');

NumNeurons = size(PosTr,1);

%% Run through comparison
figure(500); 
time_plot = (1:size(trace,2))/20; 
for j = 1:NumNeurons
    
    % Plot traces
    subplot(4,4,1:3);
    hold off
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(es.expPosTr(j,:))),trace(j,logical(es.expPosTr(j,:))),'y.'); 
    hold on
        plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.'); 
    title(['Trace + original added transient (with bug) for neuron ' num2str(j)])
    
    subplot(4,4,5:7);
    hold off
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(e2.expPosTr(j,:))),trace(j,logical(e2.expPosTr(j,:))),'g.'); 
    hold on
    plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.');
    title(['Trace + take 2 added transients for neuron ' num2str(j)])
    
    subplot(4,4,9:11);
    hold off
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(e3.expPosTr(j,:))),trace(j,logical(e3.expPosTr(j,:))),'c.'); 
    hold on
    plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.');
    title(['Trace + take 3 added transients for neuron ' num2str(j)])
    
    subplot(4,4,13:15);
    hold off
    plot(time_plot,trace(j,:),'k',...
        time_plot(logical(e4.expPosTr(j,:))),trace(j,logical(e4.expPosTr(j,:))),'b.'); 
    hold on
    plot(time_plot(logical(PosTr(j,:))),trace(j,logical(PosTr(j,:))),'r.');
    title(['Trace + take 4 added transients for neuron ' num2str(j)])
    
    % Plot locations of Neuron, pPeak, mRank, and added transient locations
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}) = 1;
    bw2 = bwperim(temp);
    centr = regionprops(temp,'Centroid');
    
    [yperim, xperim] = find(bw2);
    
    hax(1) = subplot(4,4,4);
    temp(NeuronPixels{j}) = mRank{j};
    imagesc(temp);
    title('mRank')
    
    hax(2) = subplot(4,4,8);
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}(e2.expPosTrIdx{j}(e2.expPosTrIdx{j} ~= 0))) = 1;
    imagesc(temp);
    hold on
    plot(xperim,yperim,'r.')
    title('take2 added');
    hold off
    
    hax(3) = subplot(4,4,12);
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}(e3.expPosTrIdx{j}(e3.expPosTrIdx{j} ~= 0))) = 1;
%     temp(NeuronPixels{j}(e3bug.expPosTrIdx{j}(e3bug.expPosTrIdx{j} ~= 0))) = 2;
    imagesc(temp)
    hold on
    plot(xperim,yperim,'r.')
    title('take3 added');
    hold off
    
    hax(4) = subplot(4,4,16);
    temp = zeros(Xdim,Ydim);
    temp(NeuronPixels{j}(e3bug.expPosTrIdx{j}(e3bug.expPosTrIdx{j} ~= 0))) = 1;
    imagesc(temp)
    hold on
    plot(xperim,yperim,'r.')
    title('take3 added w/bug');
    hold off

    zwindow = 30;
    linkaxes(hax);
    xlim([centr.Centroid(1)-zwindow/2, centr.Centroid(1)+zwindow/2])
    ylim([centr.Centroid(2)-zwindow/2, centr.Centroid(2)+zwindow/2])
    
    waitforbuttonpress; 
end

%% Look at pPeak and mRank values



