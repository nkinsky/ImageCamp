function [ reg_stats ] = neuron_reg_qc( base_struct, reg_struct, varargin )
% reg_stats = neuron_reg_qc( base_struct, reg_struct, ... )
%   Calculate statistics for neuron registration.
%
%   INPUTS:
%
%   base_struct: session structure to base session
%
%   reg_struct: session strcture to registered session. 
%
%   'name_append' (optional): if you have performed a non-standard registration (e.g.
%   by using a user-specified image registration) then specify the name
%   appended to the 'neuron_map' file here.
%
%   'shuffle' (optional): calculate all the metrics in reg_stats with a 
%   shuffled map(s) between session(s).  Must be followed by desired number
%   of shuffles.
%
%   'plot' (optional): set to 1/true to plot the desired qc metrics.
%   default = 0/false.  Also can set as a handle to an existing figure to
%   plot onto that.  If used in conjunction with 'shuffle', shuffled
%   distributions will be plotted also
%
%   OUTPUTS:
%
%   reg_stats: a data structure containing centroid_dist, ratio_diff,
%   orientation_diff, and avg_corr from dist_bw_reg_sessions

%% NK to-do
% Make if shift 5 and 10 pixels in all 8 cardinal directions and plot those
% two as a reference (as an option?).  Orient_diff only!

%% Parse Inputs
p = inputParser;
p.addRequired('base_struct', @(a) isstruct(a) && length(a) == 1);
p.addRequired('reg_struct', @(a) isstruct(a) && length(a) == 1);
p.addParameter('name_append', '', @ischar); % default = ''
p.addParameter('shuffle', 0, @(a) isnumeric(a));
p.addParameter('shift', false, @isnumeric);
p.addParameter('plot', false, @(a) islogical(a) || (isnumeric(a) && ...
    a == 0 || a == 1) || ishandle(a));
p.parse(base_struct, reg_struct, varargin{:});

name_append = p.Results.name_append;
num_shuffles = p.Results.shuffle;
num_shifts = p.Results.shift;

% Parse out where to plot if specified
if ~ishandle(p.Results.plot)
    plot_flag = p.Results.plot;
    if plot_flag % Make new figure if no handle specified
        h = figure;
    end
elseif ishandle(p.Results.plot) % Grab specified handle for latter plotting
    plot_flag = true;
    h = p.Results.plot;
end

%% Do the calculations
reg_path = ChangeDirectory_NK(reg_struct,0);
base_path = ChangeDirectory_NK(base_struct,0);

% Load neuron ROI info
load(fullfile(base_path,'FinalOutput.mat'),'NeuronImage','NeuronAvg');
ROI_base = NeuronImage;
ROIavg_base = MakeAvgROI(NeuronImage,NeuronAvg);
load(fullfile(reg_path,'FinalOutput.mat'),'NeuronImage','NeuronAvg');

% Get registration between sessions
neuron_map = neuron_register(base_struct.Animal, base_struct.Date, ...
    base_struct.Session, reg_struct.Date, reg_struct.Session, ...
    'name_append', name_append, 'suppress_output', true);
  
% Register neuron ROIs and AvgROIs to base_session
[reginfo, ~] = image_registerX(base_struct.Animal, ...
    base_struct.Date, base_struct.Session, reg_struct.Date, ...
    reg_struct.Session, 'suppress_output', true); % Get transform between sessions
ROI_reg = cellfun(@(a) imwarp_quick(a,reginfo),NeuronImage,'UniformOutput',0);
ROIavg = MakeAvgROI(NeuronImage,NeuronAvg);
ROIavg_reg = cellfun(@(a) imwarp_quick(a,reginfo),ROIavg,'UniformOutput',0);

% Calculate metrics in dist_bw_reg_sessions
[ mapped_ROIs, valid_neurons ] = map_ROIs( neuron_map.neuron_id, ROI_reg );
[ mapped_ROIavg, ~] = map_ROIs( neuron_map.neuron_id, ROIavg_reg );
disp(['Calculating Neuron Registration Metrics for ' base_struct.Animal ' ' ...
    base_struct.Date ' session ' num2str(base_struct.Session) ' to ' ...
    reg_struct.Date ' session ' num2str(reg_struct.Session)])
[~, reg_stats.cent_d, ~, ~, ~, reg_stats.orient_diff, reg_stats.avg_corr] = ...
    dist_bw_reg_sessions ({ROI_base(valid_neurons), mapped_ROIs(valid_neurons)},...
    'avg_corr', {ROIavg_base(valid_neurons), mapped_ROIavg(valid_neurons)});


%% Do shuffling if specified
cent_d_shuf = []; orient_diff_shuf = []; avg_corr_shuf = [];
if num_shuffles > 0
    disp('Shuffling...')
    pp = ProgressBar(num_shuffles);
    for j = 1:num_shuffles
        [~, cent_d_temp, ~, ~, ~, orient_diff_temp, ~] = ...
            dist_bw_reg_sessions ({ROI_base(valid_neurons), mapped_ROIs(valid_neurons)},...
            'shuffle', true, 'suppress_bar', true);
        cent_d_shuf = [cent_d_shuf; cent_d_temp];
        orient_diff_shuf = [orient_diff_shuf; orient_diff_temp];
        
        pp.progress;
        
    end
    pp.stop;
end


reg_stats.shuffle.cent_d = cent_d_shuf;
reg_stats.shuffle.orient_diff = orient_diff_shuf;
reg_stats.shuffle.avg_corr = avg_corr_shuf;
%% Do shift if specified

angle_range = 0;
dist_range = 30;

reg_stats.shift.cent_d = [];
reg_stats.shift.orient_diff = [];
reg_stats.shift.avg_corr = [];
if num_shifts > 0
    disp('Calculating intentionally shifted registration metrics (4-pixel offset)')
    pp = ProgressBar(num_shifts);
    for j = 1:num_shifts
    
        jitter_mat = make_jitter_mat(dist_range, angle_range);
        
        % Get registration between sessions
        neuron_map = neuron_register(base_struct.Animal, base_struct.Date, ...
            base_struct.Session, base_struct.Date, base_struct.Session, ...
            'add_jitter', jitter_mat, 'min_thresh', 3 , ...
            'save_on', false, 'suppress_output', true);
%         neuron_map = neuron_register(base_struct.Animal, base_struct.Date, ...
%             base_struct.Session, base_struct.Date, base_struct.Session, ...
%             'add_jitter', jitter_mat, 'min_thresh', max(dist_range)+1 , ...
%             'save_on', false, 'suppress_output', true);
%         neuron_map = neuron_register(base_struct.Animal, base_struct.Date, ...
%             base_struct.Session, reg_struct.Date, reg_struct.Session, ...
%             'add_jitter', jitter_mat, 'min_thresh', max(dist_range)+1 , ...
%             'save_on', false, 'suppress_output', true);
%         
        % Register neuron ROIs and AvgROIs to base_session
        [reginfo, ~] = image_registerX(base_struct.Animal, ...
            base_struct.Date, base_struct.Session, base_struct.Date, ...
            base_struct.Session, 'suppress_output', true); % Get transform between sessions
%         [reginfo, ~] = image_registerX(base_struct.Animal, ...
%             base_struct.Date, reg_struct.Session, reg_struct.Date, ...
%             base_struct.Session, 'suppress_output', true); % Get transform between sessions
        
        reginfo.tform.T = reginfo.tform.T*jitter_mat;
        ROI_reg = cellfun(@(a) imwarp_quick(a,reginfo), ROI_base,'UniformOutput',0);
        ROIavg_reg = cellfun(@(a) imwarp_quick(a,reginfo), ROIavg_base,'UniformOutput',0);
%         load(fullfile(reg_path,'FinalOutput.mat'),'NeuronImage','NeuronAvg');
%         ROI_reg = cellfun(@(a) imwarp_quick(a,reginfo), NeuronImage,'UniformOutput',0);
%         ROIavg_reg = cellfun(@(a) imwarp_quick(a,reginfo), ...
%             MakeAvgROI(NeuronImage,NeuronAvg),'UniformOutput',0);
        
        % Calculate metrics in dist_bw_reg_sessions
        [ mapped_ROIs, valid_neurons ] = map_ROIs( neuron_map.neuron_id, ROI_reg );
        [ mapped_ROIavg, ~] = map_ROIs( neuron_map.neuron_id, ROIavg_reg );
        [~, temp3, ~, ~, ~, temp2, temp] = dist_bw_reg_sessions (...
            {ROI_base(valid_neurons), mapped_ROIs(valid_neurons)},...
            'avg_corr', {ROIavg_base(valid_neurons), mapped_ROIavg(valid_neurons)},...
            'suppress_bar', true);
        reg_stats.shift.avg_corr = [reg_stats.shift.avg_corr; temp];
        reg_stats.shift.orient_diff = [reg_stats.shift.orient_diff; temp2];
        reg_stats.shift.cent_d = [reg_stats.shift.cent_d; temp3];
        pp.progress;
        
        % de-bugging code here - un-comment to see how neurons map for each
        % shifted session
%         figure; 
%         plot_mapped_neurons2(ROI_base, ROI_reg, neuron_map.neuron_id);
    end
    pp.stop;
end

%% Make plot if specified (probably should just make this mandatory, or lump in with shuffling
if plot_flag
    figure(h)
    plot_metrics(reg_stats.cent_d, reg_stats.orient_diff, reg_stats.avg_corr, false);
    
    if num_shuffles > 0
%         plot_metrics(cent_d_shuf, reg_stats.shift.orient_diff, avg_corr_shuf, 1);
        plot_metrics(cent_d_shuf, orient_diff_shuf, avg_corr_shuf, 1);
        plot_metrics(reg_stats.shift.cent_d, reg_stats.shift.orient_diff, ...
            reg_stats.shift.avg_corr, 2);
        subplot(2,2,2);
        legend('Actual','Shuffled')
        subplot(2,2,3);
        legend('Actual','Shifted 4 pixels')
        
    end
        
    subplot(2,2,1)
    title([mouse_name_title(base_struct.Date) ' Session ' num2str(base_struct.Session) ' to ' ...
        mouse_name_title(reg_struct.Date) ' Session ' num2str(reg_struct.Session)]);
end

end

%% Plotting sub-function
function [] = plot_metrics(cd, od, ac, shuf_flag)
if shuf_flag == 0
    subplot(2,2,1)
    hold on
    histogram(cd,0:0.25:10);
    xlabel('Centroid Distance')
    ylabel('Count')
    hold off
    
    subplot(2,2,2)
    hold on
    ecdf(abs(od))
    xlabel('Absolute Orientation Difference (\theta, degrees)')
    ylabel('F(\theta)');
    hold off
    
    subplot(2,2,3)
    hold on
    ecdf(ac)
    xlabel('Average ROI Activation Correlation (x)')
    ylabel('F(x)')
    hold off

elseif shuf_flag == 1
    subplot(2,2,2)
    hold on
    [f, x] =  ecdf(abs(od));
    hs1 = stairs(x,f);
    set(hs1,'LineStyle','--')
    hold off
    
elseif shuf_flag == 2
    subplot(2,2,3)
    hold on
    [f, x] = ecdf(ac);
    hs2 = stairs(x,f);
    set(hs2,'LineStyle','--')
    hold off
    
end

end

%% Shift/shuffle sub-function
function [jitter_mat] = make_jitter_mat(dist_range, angle_range)
    % Offsets transform by a random rotation and random offset within the
    % angle range and distance range specified
   alpha = 0:5:355; % offset can be at 15 degree increments
   num_dist = length(dist_range);
   num_angles = length(angle_range);
   dist_use = dist_range(randperm(num_dist,1));
   angle_use = angle_range(randperm(num_angles,1));
   alpha_use = alpha(randperm(length(alpha),1));
   
   jitter_mat = [cosd(angle_use) -sind(angle_use) 0; ...
                sind(angle_use) cosd(angle_use) 0; ...
                dist_use*cosd(alpha_use) dist_use*sind(alpha_use) 1];
        
end


