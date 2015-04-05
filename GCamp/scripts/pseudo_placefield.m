% Run through plotting calcium transients using grids...

%% Variables

transient_thresh = 30; % exclude FTs whose sum of calcium transient is below this value...only use active cells!
cmperbin = 1.5;

%% Load RVP and get Occmap to use, get Xedges and Yedges

disp('Loading Files')
% load('occupancy_grid_info.mat');
load('pos_corr_to_std.mat');
% load('FinalTraces.mat'); % Old neurons
load('ProcOut.mat');

%% Get occupancy counts

% Assign occupancy grid

grid_info = assign_occupancy_grid(pos_align.x, pos_align.y, cmperbin, 1);

% shorten pos_align.x appropriately to match FT - this is a HACK and should
% be checked if fields look funky...
pos_start = size(caltrain{1},2) - length(pos_align.x) + 1;
% FT = FT(:,pos_start:end);
for j = 1:size(caltrain,2)
    caltrain{j} = caltrain{j}(pos_start:end);
    temp(j) = (sum(caltrain{j}) > transient_thresh);
end
cal_use_index = find(temp > 0);

[countsx,Xbin] = histc(pos_align.x,grid_info.Xedges);
[countsy,Ybin] = histc(pos_align.y,grid_info.Yedges);

Xbin((Xbin == (grid_info.NumXBins+1))) = grid_info.NumXBins; % send anything below the minimum grid edge value to the first grid
Ybin((Ybin == (grid_info.NumYBins+1))) = grid_info.NumYBins;

Xbin((Xbin == 0)) = 1; % send anything beyond the max grid edge value to the last grid
Ybin((Ybin == 0)) = 1;


%% Sum up calcium transients in each bin, divide by occupancy, scroll through

% put NaNs anywhere where the Occmap doesn't meet the pass threshold
vel_filter = ones(size(Xbin)); % hack for now

base_grid = zeros(grid_info.NumYBins,grid_info.NumXBins);

for j = 1:grid_info.NumYBins
    for i = 1:grid_info.NumXBins
        % Define Active Frames
        ActiveFrames = find(Xbin == i & Ybin == j & vel_filter);
        if sum(ActiveFrames(:)) == 0 % Set bins with zero occupancy to NaN (will plot white)
            base_grid(j,i) = NaN;
        end
    end
end


figure
cal_use_index = [33 82 141];
for j = 1:length(cal_use_index)
    caltrain_grid = base_grid;
    transient_index = find(caltrain{cal_use_index(j)} ~= 0);
    
    for k = 1:length(transient_index)
        caltrain_grid(Ybin(transient_index(k)),Xbin(transient_index(k))) = ...
            caltrain_grid(Ybin(transient_index(k)),Xbin(transient_index(k))) + ...
            caltrain{cal_use_index(j)}(transient_index(k));
        
    end
    
    % Smooth it
    caltrain_smooth = smooth2a_NRK(caltrain_grid,2,2);
%     caltrain_smooth = SmoothDave(caltrain_grid);
    
    imagesc_nan(caltrain_smooth); title([' Cell ' num2str(cal_use_index(j)) ' Firing Map']);
    
    waitforbuttonpress
    
end

%% Plot for Howard
cell_num = 82;
files_to_plot{1} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\place cell grid size checks\cell33_map_0_5cm_smoothNRK2.fig';
files_to_plot{2} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\place cell grid size checks\cell33_map_1cm_smoothNRK2.fig';
files_to_plot{3} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working\place cell grid size checks\cell33_map_1_5cm_smooth1.fig';

sub_title = {'0.5 cm grid with smoothing' '1 cm grid with smoothing' '1.5cm grid with smoothing'};

sub_index = {2 3 4};

for j = 1:size(files_to_plot,2)
    temp2 = regexp(files_to_plot{j},'cell33','split');
   files_to_plot{j} = [temp2{1} 'cell' num2str(cell_num) temp2{2}]; 
end

for j = 1:length(files_to_plot)
    h(j) = openfig(files_to_plot{j});
    title(sub_title{j});
    xlabel('Grid number'); ylabel('Grid number')
%     fig_to_subplot(h1, sub_index(j), files_to_plot{j});
end
figs2subplots(h,[2 2],sub_index)
subplot(2,2,1)
plot(pos_align.x,pos_align.y,'b',pos_align.x(logical(caltrain{cell_num})),pos_align.y(logical(caltrain{cell_num})),'r*')
set(gca,'YDir','reverse')
xlim([2 28]); ylim([-2 26]); xlabel('cm'); ylabel('cm'); 
title(['Animal Trajectory and firing for cell ' num2str(cell_num)]);

close(h)

%% To do
% 1) Pull out traces using 1st derivative movie looking only at positive
% values! Might need to threshold also...
% 2) Compare to placefields from PlaceMaps.mat as a QC measure - maybe look at
% all cells? Also, play with size and smoothing (gaussian maybe?)
% 3) Side by side smoothing comparison using flat smoother and gaussian?