function [ start_array, all_active_cells, TMap_order ] = get_activation_order(frames_use, FT, TMap )
% [ start_array, all_active_cells, cell_activation_order ] = get_activation_order(frames_use,FT )
%   Gets the temporal order of cell activations from full traces in FT
%   during and epoch of frames who are listed in frames_use

% Get active cells during the epoch
all_active_cells = find(sum(FT(:,frames_use),2) ~= 0);

%% Get boolean for if a cell is active in each frame
temp = [];
for j = 1:length(frames_use)
   temp = [temp (FT(all_active_cells,frames_use(j)) ~= 0)];
end

%% Pull out only the frames where something changes
temp2 = temp(:,1);
for j = 2:length(frames_use)
    if sum(temp(:,j-1) ~= temp(:,j))
        temp2 = [temp2 temp(:,j)];
    end
end

%% Pull out only the frames where a cell starts firing!
temp3 = temp2(:,1); 
for j = 2:size(temp2,2)
    if sum((temp2(:,j)-temp2(:,j-1)) == 1) >= 1
        temp3 = [temp3 temp2(:,j)-temp2(:,j-1)];
    end
end

start_array = temp3 == 1; % Pull out only ones (events where cell starts firing)

%% Make a TMap of firing fields in the order that they fire
% Note that this currently will not separate different trajectories, and
% does not preserve relative timing, but only looks at order of activation

% Get binary TMaps for active cells
for j = 1:length(all_active_cells)
    active(j).TMap_bin = make_binary_TMap(TMap{all_active_cells(j)});
end

% Initialize TMap_order
TMap_order = zeros(size(TMap{1}));
for k = 1:size(start_array,2)
    start_cells = find(start_array(:,k)); % Get indices of cells that are start firing
    for m = 1:length(start_cells)
        % Put value k in for the kth field(s) active
        TMap_order(active(start_cells(m)).TMap_bin(:)) = k*ones(sum(active(start_cells(m)).TMap_bin(:)),1);
    end
end

%%   
% keyboard
end

