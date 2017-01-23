function [ centroid, centroid_dist, axisratio, ratio_diff, ...
    orientation, orientation_diff, avg_corr, centroid_angle ] = dist_bw_reg_sessions( ROI_reg, varargin)
%[ centroid, centroid_dist, axisratio, ratio_diff, orientation, ...
% orientation_diff, ROI_corr ] = dist_bw_reg_sessions( ROI_reg, ... )
%   Calculate neuron centroid and distance to between sessions
% 
%   Use in conjunction with map_ROIs function, e.g.:
%
%   [ mapped_ROIs, valid_neurons ] = map_ROIs( neuron_map.neuron_id, NeuronROI_reg );
%   [cent, cent_d, aratio, aratio_diff, orient, orient_diff] = ...
%   dist_bw_reg_sessions ({NeuronROI_base(valid_neurons), mapped_ROIs(valid_neurons)},0);
%
% INPUTS
%   ROI_reg: of the form BinBlobs{session_number}{neuron_number},
%   where each entry is the neuron mask that HAS BEEN REGISTERED back to
%   the base session
%
%   'avg_corr' (optional): calculate avg_corr (see below).  Must be
%   followed by AvgROI (see MakeAvgROI function).
%
%   'shuffle' (optional): 1 = shuffle BinBlobs_reg randomly for each session
%   when calculating centroid_dist, ratio_diff, and orientation_diff
%   to get shuffled distributions of distances/differences.  0 = no shuffle (default)
%
%   'suppress_bar' (optional): suppress progress bar output to screen  
%
% OUTPUTS
%   centroid: same form as ROI_reg, with x and y coordinates of
%   the neuron ROI centroids
%
%   centroid_dist: a num_sessions - 1 x num_sessions x num_neurons array
%   with the distances between neuron centroids
%
%   orientation: the orientation, in degrees of the each neuron
%   ROI's major axis. Same form as ROI_reg
%   
%   orientation_diff: difference between neuron orientations. Same format as 
%   centroid_dist.
%
%   axisratio: ratio of major axis length to minor axis length for neuron
%   ROI.  Sam form as ROI_reg.
%
%   avg_corr (optional): correlation between average ROI pixel activations.  Same
%   format as centroid_dist.

%% Parse inputs
p = inputParser;
p.addRequired('ROI_reg', @iscell);
p.addParameter('avg_corr',[],@iscell);
p.addParameter('shuffle',0, @(a) isnumeric(a) && (a == 0 || a == 1) || ...
    islogical(a));
p.addParameter('suppress_bar', false, @(a) islogical(a) || (a == 0 || a == 1));
p.parse(ROI_reg,varargin{:});

AvgROI = p.Results.avg_corr;
shuffle = p.Results.shuffle;
suppress_bar = p.Results.suppress_bar;

corr_flag = iscell(AvgROI); % Set flag to calculate average correlations if entered
%% Define things
num_sessions = length(ROI_reg);
num_neurons = length(ROI_reg{1});

%% Get centroids, axis ratios, and orientations for each neuron

centroid = cell(num_sessions,1);
axisratio = cell(num_sessions,1);
orientation = cell(num_sessions,1);
for j = 1:num_sessions
    for k = 1: num_neurons
        stats_temp = regionprops(ROI_reg{j}{k},'Centroid','MajorAxisLength','MinorAxisLength','Orientation');
        if length(stats_temp) ~= 1
            
            if ~suppress_bar
                disp(['Multiple or Zero Neuron ROIs detected for Session ' num2str(j) ' Neuron ' num2str(k) '. Skipping'])
            end
            centroid{j}{k} = [nan nan];
            axisratio{j}(k) = nan;
            orientation{j}(k) = nan;
            
            continue
            
        end
        centroid{j}{k} = stats_temp.Centroid;
        axisratio{j}(k) = stats_temp.MinorAxisLength/stats_temp.MajorAxisLength;
        orientation{j}(k) = stats_temp.Orientation;
    end
    
end


%% Calculate difference in centers-of-mass, axis ratio, and orientation
centroid_dist = nan(num_neurons, 1);
centroid_angle = nan(num_neurons, 1);
ratio_diff = nan(num_neurons, 1);
orientation_diff = nan(num_neurons, 1);
avg_corr = nan(num_neurons, 1);
if shuffle
    neuron_index_use = randperm(num_neurons);
elseif ~shuffle
    neuron_index_use = 1:num_neurons;
end

% Set-up screen output
if ~suppress_bar
    pp = ProgressBar(num_neurons);
end

for j = 1:num_neurons
    centroid_dist(j) = sqrt((centroid{1}{j}(1) - centroid{2}{neuron_index_use(j)}(1))^2 ...
        + (centroid{1}{j}(2) - centroid{2}{neuron_index_use(j)}(2))^2);
    centroid_angle(j) = atan2(centroid{2}{neuron_index_use(j)}(2) - centroid{1}{j}(2), ...
        centroid{2}{neuron_index_use(j)}(1) - centroid{1}{j}(1));
        
    if corr_flag
        avg_corr(j) = corr(AvgROI{1}{j}(:), AvgROI{2}{neuron_index_use(j)}(:), ...
            'type','Spearman');
    end
    
    if ~suppress_bar; pp.progress; end
    
end

if ~suppress_bar; pp.stop; end

if num_neurons > 0
    ratio_diff(:) = axisratio{2}(neuron_index_use) - axisratio{1};
    orientation_diff(:) = orientation{2}(neuron_index_use) - orientation{1};
end

end

