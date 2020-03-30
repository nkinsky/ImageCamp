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
%   orientation_diff, avg_corr, and centroid_angle from dist_bw_reg_sessions

%% NK to-do
% Make if shift 5 and 10 pixels in all 8 cardinal directions and plot those
% two as a reference (as an option?).  Orient_diff only!

%% Parse Inputs
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('base_struct', @(a) isstruct(a) && length(a) == 1);
p.addRequired('reg_struct', @(a) isstruct(a) && length(a) == 1);
p.addParameter('name_append', '', @ischar); % default = ''
p.addParameter('shuffle', 0, @(a) isnumeric(a) && round(a) == a && a >= 0);
p.addParameter('shift', false, @(a) isnumeric(a) || islogical(a));
p.addParameter('plot', false, @(a) islogical(a) || (isnumeric(a) && ...
    a == 0 || a == 1) || ishandle(a));
p.addParameter('shift_dist', 4, @(a) isnumeric(a) && a > 0 );
p.addParameter('batch_mode', 0, @(a) a == 0 || a == 1 || a == 2);
p.addParameter('orient_only', false, @islogical); % only calculate orient_diff if true
p.addParameter('save_stats', false, @islogical);
p.parse(base_struct, reg_struct, varargin{:});

name_append = p.Results.name_append;
num_shuffles = p.Results.shuffle;
num_shifts = p.Results.shift;
shift_dist = p.Results.shift_dist;
batch_mode = p.Results.batch_mode;
orient_only = p.Results.orient_only;
save_stats = p.Results.save_stats;

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

save_file = fullfile(base_struct.Location, ['reg_stats_' reg_struct.Date ...
        '-s', num2str(reg_struct.Session)]);

if ~exist(save_file, 'file')
%% Do the calculations
reg_path = ChangeDirectory_NK(reg_struct,0);
base_path = ChangeDirectory_NK(base_struct,0);

reg_stats.base = base_struct;
reg_stats.reg = reg_struct;

% Load neuron ROI info, get registration info between sessions
if batch_mode == 0 || batch_mode == 1
    load(fullfile(base_path,'FinalOutput.mat'),'NeuronImage','NeuronAvg');
    ROI_base = NeuronImage;
    ROIavg_base = MakeAvgROI(NeuronImage,NeuronAvg);
    
    if batch_mode == 0 % Use direct registration between sessions (good unless you are mapping multiple sessions)
        neuron_map = neuron_register(base_struct.Animal, base_struct.Date, ...
            base_struct.Session, reg_struct.Date, reg_struct.Session, ...
            'name_append', name_append, 'suppress_output', true);
        map_use = neuron_map.neuron_id;
    elseif batch_mode == 1 % Use final vetted map from neuron_reg_batch (better, conservative)
        load(fullfile(base_path,['batch_session_map' name_append '.mat'])); % Load batch map
        batch_session_map = fix_batch_session_map(batch_session_map);  % Fix it if pre-bugfix
        reg_index_use = get_index(batch_session_map.session, reg_struct);
        map_use = get_neuronmap_from_batchmap(batch_session_map.map, 1, reg_index_use);
    end

elseif batch_mode == 2 % Check registration to ALL ROIs (including those appended from each session, less conservative).
    load(fullfile(base_path,['Reg_NeuronIDs_updatemasks0' name_append '.mat']));
    ROI_base = Reg_NeuronIDs(1).AllMasks;
    ROIavg_base = Reg_NeuronIDs(1).AllMasksMean;
    
    load(fullfile(base_path,'batch_session_map'));
    batch_session_map = fix_batch_session_map( batch_session_map); % Fix it if pre-bugfix
    reg_index_use = get_index(batch_session_map.session, reg_struct);
    last_row = find(batch_session_map.map(:,reg_index_use+1) ...
        == min(Reg_NeuronIDs(reg_index_use-1).new_neurons)) - 1; % All neuron masks after this are from the registration itself
    map_use = batch_session_map.map(1:last_row, reg_index_use + 1);
    
end

load(fullfile(reg_path,'FinalOutput.mat'),'NeuronImage','NeuronAvg');

% Register neuron ROIs and AvgROIs to base_session
[reginfo, ~] = image_registerX(base_struct.Animal, ...
    base_struct.Date, base_struct.Session, reg_struct.Date, ...
    reg_struct.Session, 'suppress_output', true, 'name_append', name_append); % Get transform between sessions
ROI_reg = cellfun(@(a) imwarp_quick(a,reginfo),NeuronImage,'UniformOutput',0);
if ~orient_only
    ROIavg = MakeAvgROI(NeuronImage,NeuronAvg);
    ROIavg_reg = cellfun(@(a) imwarp_quick(a,reginfo),ROIavg,'UniformOutput',0);
end

% Calculate metrics in dist_bw_reg_sessions
[ mapped_ROIs, valid_neurons ] = map_ROIs( map_use, ROI_reg );
ROI_reg = {ROI_base(valid_neurons), mapped_ROIs(valid_neurons)};
disp(['Calculating Neuron Registration Metrics for ' base_struct.Animal ' ' ...
    base_struct.Date ' session ' num2str(base_struct.Session) ' to ' ...
    reg_struct.Date ' session ' num2str(reg_struct.Session)])
if ~orient_only
    [ mapped_ROIavg, ~] = map_ROIs( map_use, ROIavg_reg );
    [~, reg_stats.cent_d, ~, ~, ~, reg_stats.orient_diff, reg_stats.avg_corr, reg_stats.cent_angle] = ...
        dist_bw_reg_sessions(ROI_reg, 'avg_corr', ...
        {ROIavg_base(valid_neurons), mapped_ROIavg(valid_neurons)},...
        'orient_only', orient_only);
elseif orient_only
    [~, reg_stats.cent_d, ~, ~, ~, reg_stats.orient_diff, reg_stats.avg_corr, ...
        reg_stats.cent_angle] = ...
        dist_bw_reg_sessions(ROI_reg,'orient_only', orient_only);
end
    


%% Do shuffling if specified
% cent_d_shuf = []; orient_diff_shuf = []; avg_corr_shuf = [];
num_neurons = length(valid_neurons);
cent_d_shuf = nan(num_neurons, num_shuffles);
orient_diff_shuf = nan(num_neurons, num_shuffles);
avg_corr_shuf = nan(num_neurons, num_shuffles);
if num_shuffles > 0
    disp(['Shuffling ' num2str(num_shuffles) ' time(s)...'])
    pp = ProgressBar(num_shuffles);
    ROI_reg = {ROI_base(valid_neurons), mapped_ROIs(valid_neurons)};
    parfor j = 1:num_shuffles
        [~, cent_d_temp, ~, ~, ~, orient_diff_temp, ~] = ...
            dist_bw_reg_sessions (ROI_reg,...
            'shuffle', true, 'suppress_bar', true, 'orient_only', orient_only);
%         cent_d_shuf = [cent_d_shuf; cent_d_temp];
%         orient_diff_shuf = [orient_diff_shuf; orient_diff_temp];
        cent_d_shuf(:,j) = cent_d_temp;
        orient_diff_shuf(:,j) = orient_diff_temp;
        
        pp.progress; %#ok<*PFBNS>
        
    end
    pp.stop;
end

reg_stats.shuffle.cent_d = cent_d_shuf;
reg_stats.shuffle.orient_diff = orient_diff_shuf;
reg_stats.shuffle.avg_corr = avg_corr_shuf;
%% Do shift if specified

rot_angle_range = 0; % Rotation angle - suggest keeping at zero

reg_stats.shift.cent_d = cell(1,num_shifts);
reg_stats.shift.cent_d_cat = [];
reg_stats.shift.orient_diff = cell(1,num_shifts);
reg_stats.shift.orient_diff_cat = [];
reg_stats.shift.avg_corr = [];
reg_stats.shift.cent_angle = [];
reg_stats.shift.shift_dist = shift_dist;
reg_stats.shift.num_shifts = num_shifts;
if num_shifts > 0
    disp('Calculating intentionally shifted registration metrics (4-pixel offset)')
    pp = ProgressBar(num_shifts);
    n = 1; % Set shift counter
    for j = 1:num_shifts
    
        jitter_mat = make_jitter_mat(shift_dist, rot_angle_range, num_shifts, n);
        n = n +1;
        
        % Get registration between sessions
        neuron_map = neuron_register(base_struct.Animal, base_struct.Date, ...
            base_struct.Session, base_struct.Date, base_struct.Session, ...
            'add_jitter', jitter_mat, 'min_thresh', 3 , ...
            'save_on', false, 'suppress_output', true);
        map_use = neuron_map.neuron_id;

        % Register neuron ROIs and AvgROIs to base_session
        [reginfo, ~] = image_registerX(base_struct.Animal, ...
            base_struct.Date, base_struct.Session, base_struct.Date, ...
            base_struct.Session, 'suppress_output', true); % Get transform between sessions
        
        reginfo.tform.T = reginfo.tform.T*jitter_mat;
        ROI_reg = cellfun(@(a) imwarp_quick(a,reginfo), ROI_base,'UniformOutput',0);
        ROIavg_reg = cellfun(@(a) imwarp_quick(a,reginfo), ROIavg_base,'UniformOutput',0);

        % Calculate metrics in dist_bw_reg_sessions
        [ mapped_ROIs, valid_neurons ] = map_ROIs( map_use, ROI_reg );
        [ mapped_ROIavg, ~] = map_ROIs( map_use, ROIavg_reg );
        [~, temp3, ~, ~, ~, temp2, temp, temp4] = dist_bw_reg_sessions (...
            {ROI_base(valid_neurons), mapped_ROIs(valid_neurons)},...
            'avg_corr', {ROIavg_base(valid_neurons), mapped_ROIavg(valid_neurons)},...
            'suppress_bar', true);
        reg_stats.shift.avg_corr = [reg_stats.shift.avg_corr; temp];
        reg_stats.shift.orient_diff_cat = [reg_stats.shift.orient_diff_cat; temp2];
        reg_stats.shift.orient_diff{j} = temp2;
        reg_stats.shift.cent_d{j} = temp3;
        reg_stats.shift.cent_d_cat = [reg_stats.shift.cent_d_cat; temp3];
        reg_stats.shift.cent_angle = [reg_stats.shift.cent_angle; temp4];
        pp.progress;
        
        % de-bugging code here - un-comment to see how neurons map for each
        % shifted session
%         figure; 
%         plot_mapped_neurons2(ROI_base, ROI_reg, neuron_map.neuron_id);
    end
    pp.stop;
end

if save_stats
    save(save_file, 'reg_stats')
end
else
    load(save_file, 'reg_stats')
end

%% Make plot if specified (probably should just make this mandatory, or lump in with shuffling
if plot_flag
    figure(h)
    plot_metrics(reg_stats.cent_d, reg_stats.orient_diff, reg_stats.avg_corr, false);
    
    if num_shuffles > 0
%         plot_metrics(cent_d_shuf, reg_stats.shift.orient_diff, avg_corr_shuf, 1);
        plot_metrics(cent_d_shuf, orient_diff_shuf, avg_corr_shuf, 1);
%         plot_metrics(reg_stats.shift.cent_d, reg_stats.shift.orient_diff, ...
%             reg_stats.shift.avg_corr, 2);
        subplot(2,2,2);
        legend('Actual','Shuffled')
%         subplot(2,2,3);
%         legend('Actual','Shifted 4 pixels')
        
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
function [jitter_mat] = make_jitter_mat(offset_dist, angle_range, num_shifts, counter)
    % Creates a matrix to offset the image by offset_dist at angle
    % alpha_use (see below) and rotate it by angle_range.
   alpha = 0:360/num_shifts:360-360/num_shifts; % direction of shift can be at 5 degree increments
   num_angles = length(angle_range);
   angle_use = angle_range(randperm(num_angles,1)); % Shoose rotation angle 
   alpha_use = alpha(counter); % Pick next shift angle
   
   jitter_mat = [cosd(angle_use) -sind(angle_use) 0; ...
                sind(angle_use) cosd(angle_use) 0; ...
                offset_dist*cosd(alpha_use) offset_dist*sind(alpha_use) 1];
        
end

%% Get session index in batch_map
function [reg_index] = get_index(session_list, session_to_match)
animal_list = {session_list(:).Animal};
date_list = {session_list(:).Date};
sesh_list = {session_list(:).Session};

animal_log = strcmpi(animal_list, session_to_match.Animal);
date_log = strcmpi(date_list, session_to_match.Date);
sesh_log = cellfun(@(a) a == session_to_match.Session, sesh_list);

reg_index = find(animal_log & date_log & sesh_log);
    
end

