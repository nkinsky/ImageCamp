% Run through plotting calcium transients using grids...

%% Variables

transient_thresh = 50; % exclude FTs whose sum of calcium transient is below this value...only use active cells!

%% Load RVP and get Occmap to use, get Xedges and Yedges

load('occupancy_grid_info.mat');
load('pos_corr_to_std.mat');


%% Get occupancy counts
[countsx,Xbin] = histc(pos_align.x,grid_info.Xedges);
[countsy,Ybin] = histc(pos_align.y,grid_info.Yedges);

Xbin((Xbin == (grid_info.NumXBins+1))) = grid_info.NumXBins; % send anything below the minimum grid edge value to the first grid
Ybin((Ybin == (grid_info.NumYBins+1))) = grid_info.NumYBins;

Xbin((Xbin == 0)) = 1; % send anything beyond the max grid edge value to the last grid
Ybin((Ybin == 0)) = 1;


%% Sum up calcium transients in each bin, divide by occupancy

FTuse_index = find(sum(FT,2) > transient_thresh);

figure
for j = 1:length(FTuse_index)
    caltrain_grid = zeros(grid_info.NumYBins,grid_info.NumXBins);
    transient_index = find(FT(FTuse_index(j),:) ~= 0);
    
    % Sum up transients in each bin - could go through each bin and do this
    % also, but this seems faster
    
    for k = 1:length(transient_index)
        caltrain_grid(Ybin(transient_index(k)),Xbin(transient_index(k))) = ...
            caltrain_grid(Ybin(transient_index(k)),Xbin(transient_index(k))) + ...
            FT(j,transient_index(k));
        
    end
    imagesc(caltrain_grid); title([' Cell ' num2str(FTuse_index(j)) ' Firing map']);
    
    waitforbuttonpress
    
end

%% put NaNs anywhere where the Occmap doesn't meet the pass threshold

%% smooth?

%% plot out "place-field" and scroll through