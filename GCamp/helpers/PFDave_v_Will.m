%% Will v Dave placefields function vetting
DaveMap = load('PlaceMaps.mat');
WillMap = load('Placefields.mat');

%% Compare Will's Placefield output versus Dave's PlaceMaps output
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

%% Compare Two different Placefields outputs from the same session
map1 = 'Placefields_oddeven.mat';
map2 = []; % leave empty to plot 1st v 2nd half

if ~isempty(map2)
    sesh1 = load(map1); sesh2 = load(map2);
elseif isempty(map2)
    load(map1);
    sesh1 = Placefields_half{1};
    sesh2 = Placefields_half{2};
end


num_neurons = length(sesh1.TMap_gauss);
figure(100)
for j = 1:num_neurons
    subplot(2,3,1)
    imagesc(rot90(sesh1.TMap_unsmoothed{j})); 
    title(['Will ' num2str(j) ' unsmoothed']);
    
    subplot(2,3,2)
    imagesc(rot90(sesh1.TMap_gauss{j})); 
    title(['Will ' num2str(j) ' Gauss']); 
    
    subplot(2,3,3)
    plot_occupancy_grid(sesh1.x,sesh1.y,sesh1.xEdges,sesh1.yEdges);
    hold on;
    plot(sesh1.x(sesh1.PSAbool(j,:)), sesh1.y(sesh1.PSAbool(j,:)), 'r*')
    hold off
    
    subplot(2,3,4); 
    imagesc(rot90(sesh2.TMap_unsmoothed{j})); 
    title('Dave unsmoothed'); 
    
    subplot(2,3,5); 
    imagesc(rot90(sesh2.TMap_gauss{j})); 
    title('Dave Gauss');
    
    subplot(2,3,6)
    plot_occupancy_grid(sesh2.x, sesh2.y, sesh2.xEdges, sesh2.yEdges);
    hold on;
    plot(sesh2.x(sesh2.PSAbool(j,:)), sesh2.y(sesh2.PSAbool(j,:)), 'r*')
    hold off
    
    waitforbuttonpress; 
end