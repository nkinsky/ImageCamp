%% Plot ALL placefields in different colors on a map

NumNeurons = length(TMap);
colors = rand(NumNeurons,3);

figure(25)
n = 0;
for j = 1:length(TMap)
        % get PF outline (if avail)
        WhichField = MaxPF(j);
        temp = zeros(size(TMap{1}));
        tp = PFpixels{j,WhichField};
        try
            temp(tp) = 1;
        catch
            keyboard;
        end
        nt = size(NP_FindSupraThresholdEpochs(FT(j,:),eps),1);
        % plot PF outline (using correct color)
        b = bwboundaries(temp,4);
        if (~isempty(b) && (pval(j) > 0.5) && (nt >= 3))
%             n = n + 1
%             j
            yt = b{1}(:,2);
            xt = b{1}(:,1);
%             xt= xt+(rand(size(xt))-0.5)/2;
%             yt= yt+(rand(size(yt))-0.5)/2;
            %colors(j,:)
            plot(xt,yt,'Color',colors(j,:),'LineWidth',2);
            xlim([0,size(TMap{1},2)])
            ylim([0,size(TMap{1},2)])
            hold on
            
            
        end
end