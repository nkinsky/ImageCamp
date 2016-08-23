function [ ] = make_allactive_mask( batch_session_map, plot_flag)
% make_allactive_map( batch_session_map)
%   Makes and saves a mask of all active neurons for each session in batch_session map 
%   that is saved in each session's directory. Use with
%   image_registerX(...,'use_neuron_masks',2).

%% Designate if you want to plot or not

if nargin < 2
    plot_flag = 0;
end

%% Get preliminary information

batch_session_map = fix_batch_session_map(batch_session_map); % Fix old maps

num_sessions = length(batch_session_map.session); % Number of sessions mapped
active_log = batch_session_map.map(:,2:end) ~= 0 & ~isnan(batch_session_map.map(:,2:end)); % ID validly mapped neurons
all_active_log = sum(active_log,2) == num_sessions; % ID neurons active across ALL sessions

%% Run it

% Set up plots if desired
if plot_flag == 1
    figure;
end

for j = 1:num_sessions
    dirstr = ChangeDirectory_NK(batch_session_map.session(j),0);
    
    % Load relevant files
    try
        load(fullfile(dirstr,'T3output.mat'));
        ROIs = NeuronImage;
        version_str = 'version 3';
    catch
        try
           load(fullfile(dirstr,'T2output.mat'));
           ROIs = NeuronImage;
           version_str = 'version 2';
        catch
            load(fullfile(dirstr,'MeanBlobs.mat'));
            ROIs = BinBlobs;
            version_str = 'version 1';
        end
    end
    disp(['Using Tenaspis ' version_str ' outputs to create mask of all active neurons for session ' num2str(j)])
    all_active_mask = create_AllICmask(ROIs(batch_session_map.map(all_active_log,j+1)));
    save(fullfile(dirstr,'AllActiveMask.mat'),'all_active_mask');
    
    if plot_flag == 1
        subplot_auto(num_sessions,j);
        imagesc(all_active_mask)
        title(['Session ' num2str(j) ' All Active Mask'])
    end
    
end

end

