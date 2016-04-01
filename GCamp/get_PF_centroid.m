function [ PF_centroid, max_FR_location ] = get_PF_centroid( PlaceMap, thresh, qcplot )
% [ PF_centroid, max_FR_location ] = get_PF_centroid( PlaceMap, thresh )
%   Gets the centroid(s) of neuron PlaceMaps.  PlaceMap is a cell with a
%   TMap for each neuron, and thresh is the cutoff from the ecdf that you
%   wish to use to define each field (e.g. thresh = 0.9 will define fields
%   where the smoothed firing rate is greater than 90% of the values in the
%   TMap). NOTE: max_FR_location probably gives more accurate location of
%   the place-field, since the centroids of non-circular fields will be
%   well skewed from the peak FR location.  NOTE also that PF_centroid and
%   max_FR_location are ordered by firing rate, with the highest FR field
%   occupying the first column and so forth.
%
%   qcplot = 1 outputs a plot for quality control purposes

%%
num_PFs = length(PlaceMap);

if nargin < 3
    qcplot = 0; % default value
end
% nan_map = nan(size(PlaceMap{1}));

%% if only one value is entered and it is not a cell, make it a cell
if ~iscell(PlaceMap)
   temp = PlaceMap;
   clear PlaceMap;
   PlaceMap{1} = temp;
end
%% Make PlaceMaps binary 
PF_centroid = cell(num_PFs,1);
max_FR_location = cell(num_PFs,1);
PF_solidity = cell(num_PFs,1);
for j = 1:num_PFs
    if sum(~isnan(PlaceMap{j}(:))) > 0
%         [f, x] = ecdf(PlaceMap{j}(:));
%         thresh_binary = x(find(f > thresh,1,'first'));
        map_binary = make_binary_TMap(PlaceMap{j},thresh);
        cc = bwconncomp(map_binary);
        stats = regionprops(cc,'Centroid','PixelIdxList');
        max_FR = nan(1,length(stats));
        
        for k = 1:length(stats)
            max_FR(k) = max(PlaceMap{j}(stats(k).PixelIdxList)); % Get max FR for each region
            [ymax, xmax] = find(max_FR(k) == PlaceMap{j}); % Get location of max FR for each region
            max_FR_location{j,k} = [mean(xmax), mean(ymax)]; % Take mean if FR_max spans multiple pixels
        end
        % Put everything in order from highest FR to lowest FR
        try
        [~, sort_ind] = sort(max_FR,2,'descend');
        [PF_centroid{j,1:length(stats)}] = deal(stats(sort_ind).Centroid);
        max_FR_location(j,1:length(stats)) = max_FR_location(j,sort_ind);
        catch
            disp('get_PF_centroid debugging')
            keyboard
        end
    else
%         PF_centroid{j,1} = [];
    end
    
end

%% Quality control plot if necessary
if qcplot == 1
    hqc = figure;
    escape_flag = 'out';
    n_out = 1;
    while ~strcmpi(n_out,escape_flag)
        try
        map_binary = make_binary_TMap(PlaceMap{n_out},thresh);
        cc = bwconncomp(map_binary);
        stats = regionprops(cc,'Centroid');
        figure(hqc)
        subplot(1,2,1)
        imagesc(PlaceMap{n_out});
        title(num2str(n_out));
        set(gca,'YDir','Normal');
        hold on
        subplot(1,2,2)
        imagesc(map_binary);
        set(gca,'YDir','Normal');
        hold on
        linespec = {'w*','r*','r*','r*','r*'};
        for k = 1:length(stats)
            for ll = 1:2
                subplot(1,2,ll)
                plot(max_FR_location{n_out,k}(1),max_FR_location{n_out,k}(2),...
                    linespec{k});
                hold off
            end
        end
        n_out = LR_cycle(n_out,[1 num_PFs],escape_flag);
        catch
            keyboard
        end
    end
    
    close(hqc)

end

end

