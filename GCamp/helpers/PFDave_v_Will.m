%% Will v Dave placefields function vetting
DaveMap = load('PlaceMaps.mat');
WillMap = load('Placefields.mat');

%%
num_neurons = length(DaveMap.TMap_gauss);
figure(100)
for j = 1:num_neurons
    subplot(2,3,1)
    imagesc(rot90(WillMap.TMap_unsmoothed{j})); 
    title(['Will ' num2str(j) ' unsmoothed']);
    
    subplot(2,3,2)
    imagesc(rot90(WillMap.TMap_gauss{j})); 
    title(['Will ' num2str(j) ' Gauss']); 
    
    subplot(2,3,3)
    plot_occupancy_grid(WillMap.x,WillMap.y,WillMap.xEdges,WillMap.yEdges);
    hold on;
    plot(x(WillMap.PSAbool(j,:)), y(WillMap.PSAbool(j,:)), 'r*')
    hold off
    
    subplot(2,3,4); 
    imagesc(rot90(DaveMap.TMap_unsmoothed{j})); 
    title('Dave unsmoothed'); 
    
    subplot(2,3,5); 
    imagesc(rot90(DaveMap.TMap_gauss{j})); 
    title('Dave Gauss');
    
    subplot(2,3,6)
    plot_occupancy_grid(DaveMap.x(DaveMap.isrunning), DaveMap.y(DaveMap.isrunning), ...
        DaveMap.Xedges, DaveMap.Yedges);
    hold on;
    trans_use = DaveMap.FT(j,:) & DaveMap.isrunning;
    plot(DaveMap.x(trans_use), DaveMap.y(trans_use), 'r*')
    hold off
    
    waitforbuttonpress; 
end