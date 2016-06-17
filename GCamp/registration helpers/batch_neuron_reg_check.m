function [ ] = batch_neuron_reg_check( batch_session_map, MD, varargin )
% batch_neuron_reg_check( batch_session_map, MD )
%
%   Checks how good your image/neuron registration is for all sessions
%   created by running neuron_reg_batch by spitting ecdfs of axis ratio
%   (shape) differences and axis orientation differences between sessions.
%
% To-do: 1) Make this more general to be used for any group of sessions,
% with a wrapper function for batch_session_map inputs specifically

%% Process varargins
plot_PF_dist = false; % default
ax_use = []; % default
num_shuffles = 0; % default
shuffle_session = 2; % default
for j = 1:length(varargin)
    if strcmpi('plot_PF_dist',varargin{j});
        plot_PF_dist = true;
        PF_file_use = varargin{j+1};
    end
    if strcmpi('ax_handle',varargin{j})
        ax_use = varargin{j+1};
    end
    if strcmpi('num_shuffles',varargin{j})
        num_shuffles = varargin{j+1};
    end
end

%% PF analysis variables
PF_filterspec = 4; % 3 = use only neurons with a valid PF in BOTH session, 4 = either session
PF_pval_thresh = 0.05; % pval threshold on spatial information for filtering out neurons

%% Load preliminary data

% Fix older batch_session_map if input
batch_session_map = fix_batch_session_map(batch_session_map);

% Designate base v registered sessions & shorten batch_map name
session = batch_session_map.session;
batch_map = batch_session_map.map;

base_dir = ChangeDirectory_NK(session(1),0);

%% Load and calc initial session PF info if desired
if plot_PF_dist
    disp('Calculating Placefield distances')
    load(fullfile(base_dir, PF_file_use),'TMap_gauss','pval','cmperbin');
    session(1).pval = pval;
    [ ~, session(1).max_FR_location ] = get_PF_centroid(TMap_gauss, 0.9, 0);
    num_neurons = size(batch_map,1);

    % Get neurons that are validly mapped across all sessions
    min_dist = cell(1,length(session));
    min_dist_filter = cell(1,length(session));
    for j = 2:length(session)
        session(j).dir = ChangeDirectory_NK(session(j),0);
        
        load(fullfile(session(j).dir, PF_file_use),'pval','TMap_gauss','cmperbin');
        session(j).pval = pval;
        
        load(fullfile(base_dir,['neuron_map-' session(j).Animal '-' session(j).Date '-session' num2str(session(j).Session) '.mat']))
        [ ~, session(j).max_FR_location ] = get_PF_centroid(TMap_gauss, 0.9, 0);
%         [ ~, valid_neurons ] = map_ROIs(neuron_map.neuron_id, [], 0 );
        
        neuron_map_use = get_neuronmap_from_batchmap(batch_map,1,j);
        min_dist{j} = get_PF_centroid_diff(session(1).max_FR_location, ...
            session(j).max_FR_location, neuron_map_use,1); % get min dist for each pair
        good_neurons = pval_filter_bw_sesh( session(1).pval, session(j).pval,...
            neuron_map_use, 'filter_spec',PF_filterspec,'thresh',PF_pval_thresh);
        
        min_dist_filter{j} = min_dist{j}(good_neurons); % Get min distance for neurons that carry significant spatial information
        
    end
    
    % Get shuffled distribution if specified
    neuron_map_use = get_neuronmap_from_batchmap(batch_map,1,shuffle_session);
    min_dist_shuffle = nan(length(neuron_map_use),num_shuffles);
    valid_neurons = find(neuron_map_use ~= 0); % Use specifiedd session to get shuffled values
    disp('Calculating Shuffled Place Field distances')
    resol = 1; % Percent resolution for progress bar, in this case 10%
    resol = max([resol, num_shuffles]);
    p = ProgressBar(100/resol);
    update_inc = max([round(length(num_shuffles)/(100/resol)), 1]); % Get increments for updating ProgressBar
    for j = 1:num_shuffles
        neuron_map_shuffle = neuron_map_use;
        neuron_map_shuffle(valid_neurons) = neuron_map_use(valid_neurons(randperm(length(valid_neurons))));
        min_dist_shuffle(:,j) = get_PF_centroid_diff(session(1).max_FR_location, ...
            session(shuffle_session).max_FR_location, neuron_map_shuffle,1);
        if round(j/update_inc) == (j/update_inc)
            p.progress;
        end
    end
    p.stop;
end

%% Calculate Neuron Shape, Orientation, and Overlap metrics

% AllActiveMap{1} = create_AllICmask(ROI_base(neuron_map_all_log));

disp('Calculating neuron ROI metrics')
if exist(fullfile(base_dir,'T2output.mat'),'file')
    load(fullfile(base_dir,'T2output.mat'),'NeuronImage')
    ROI_base = NeuronImage;
else
    disp('Base session: Using T1 output!!!! Update for final plots!')
    load(fullfile(base_dir,'MeanBlobs.mat'),'BinBlobs')
    ROI_base = BinBlobs;
end


axratio_diff = cell(1,length(session));
orient_diff = cell(1,length(session));
overlap_ratio = cell(1,length(session));
for j = 2:length(session)
    
    load(fullfile(base_dir,['neuron_map-' session(j).Animal '-' session(j).Date '-session' num2str(session(j).Session) '.mat']))
    ChangeDirectory_NK(session(j));
    if exist(fullfile(pwd,'T2output.mat'),'file')
        load(fullfile(pwd,'T2output.mat'),'NeuronImage')
        ROI_reg = NeuronImage;
    else
        disp(['Session ' num2str(j) ': Using T1 output!!!! Update for final plots!'])
        load(fullfile(pwd,'MeanBlobs.mat'),'BinBlobs');
        ROI_reg = BinBlobs;
    end
    
    
    % Register all shifted neuron ROIs to base session
    load(fullfile(base_dir,['RegistrationInfo-' session(j).Animal '-' session(j).Date '-session' num2str(session(j).Session) '.mat']))
    disp('Warping reg session ROIs to base session')
    resol = 1; % Percent resolution for progress bar, in this case 10%
    p = ProgressBar(100/resol);
    update_inc = round(length(ROI_reg)/(100/resol)); % Get increments for updating ProgressBar
    for ll = 1:length(ROI_reg)
        tform_use = RegistrationInfoX.tform;
        ROI_reg{ll} = imwarp(ROI_reg{ll}, tform_use,...
            'OutputView', RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
        if round(ll/update_inc) == (ll/update_inc)
            p.progress;
        end
        
    end
    p.stop;
    
    
    % Map ROIs between sessions
    map_use = get_neuronmap_from_batchmap(batch_map,1,j);
    [ mapped_ROIs, valid_neurons ] = map_ROIs(map_use, ROI_reg );
    
     % Save one sessions ROIs for later shuffling
    if j == shuffle_session
        mapped_ROIs_shuf = mapped_ROIs;
        valid_neurons_shuf = valid_neurons;
    end
    
%     AllActiveMap{j} = create_AllICmask(mapped_ROIs(valid_neurons));
    
    % Get differences between centroids, axis ratio, major axis angle
    [ ~, ~, ~, axratio_diff_temp, ~, orient_diff_temp ] = ...
        dist_bw_reg_sessions( {ROI_base(valid_neurons), ...
        mapped_ROIs(valid_neurons)} );
    
    axratio_diff{j} = squeeze(axratio_diff_temp(1,2,:));
    orient_diff{j} = squeeze(orient_diff_temp(1,2,:));
    
    % Get overlap info for each shift
    [overlap_ratio_temp, ~, ~, ~, ~ ] = ...
        reg_calc_overlap( ROI_base(valid_neurons), mapped_ROIs(valid_neurons));
    
    overlap_ratio{j} = overlap_ratio_temp;
    
end 

%% Get shuffled distribution if specified
axratio_diff_shuffle = nan(length(valid_neurons_shuf),num_shuffles);
orient_diff_shuffle = nan(length(valid_neurons_shuf),num_shuffles);
disp('Calculating shuffled neuron ROI metrics')
resol = 1; % Percent resolution for progress bar
resol = max([resol, num_shuffles]);
p = ProgressBar(100/resol);
update_inc = round(length(num_shuffles)/(100/resol)); % Get increments for updating ProgressBar
for j = 1:num_shuffles
    valid_neurons_shuf2 = valid_neurons_shuf(randperm(length(valid_neurons_shuf)));
    
    [ ~, ~, ~, axratio_diff_temp, ~, orient_diff_temp ] = ...
        dist_bw_reg_sessions( {ROI_base(valid_neurons_shuf), ...
        mapped_ROIs_shuf(valid_neurons_shuf2)} );
    
    axratio_diff_shuffle(:,j) = squeeze(axratio_diff_temp(1,2,:));
    orient_diff_shuffle(:,j) = squeeze(orient_diff_temp(1,2,:));
    
    if round(j/update_inc) == (j/update_inc)
        p.progress;
    end
    
end
p.stop;

%% Make QC plots

% Create new figure if axis handle is not specified in the varargins
if isempty(ax_use)
    figure;
    ax_use = gca;
end

axes(ax_use)
for j = 2:length(session)
    subplot(2,2,1)
    hold on
    ecdf(axratio_diff{j});
    hold off
    
    subplot(2,2,2)
    hold on
    ecdf(overlap_ratio{j});
    hold off
    
    subplot(2,2,3)
    hold on
    ecdf(orient_diff{j});
    hold off
    
    if PF_plot_dist
        subplot(2,2,4)
        hold on
        ecdf(min_dist_filter{j});
        hold off
    end
    
   
end

% Create plot legend
plot_legend = arrayfun(@(a) [mouse_name_title(a.Date) ' - ' num2str(a.Session)], ...
    session(2:end),'UniformOutput',0);

% Add in shuffled values, axis titles, and legends
subplot(2,2,1)
hold on
[f, x] = ecdf(axratio_diff_shuffle(:));
h1s = stairs(x,f);
hold off
set(h1s,'LineStyle','--')
xlabel('Axis ratio difference')
legend({plot_legend{:} 'Shuffled'})

subplot(2,2,2)
xlabel('Overlap ratio')
legend(plot_legend)

subplot(2,2,3)
hold on
[f, x] =  ecdf(orient_diff_shuffle(:));
h3s = stairs(x,f);
set(h3s,'LineStyle','--')
hold off
xlabel('Orientation difference (degrees)')
legend({plot_legend{:} 'Shuffled'})

if plot_PF_dist
    subplot(2,2,4)
    [f, x] =  ecdf(min_dist_shuffle(:));
    h4s = stairs(x,f);
    set(h4s,'LineStyle','--')
    hold off
    xlabel('PF centroid difference (cm)')
    legend({plot_legend{:} 'Shuffled'})
end


end




