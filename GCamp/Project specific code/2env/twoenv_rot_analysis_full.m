function [best_angle, best_angle_all, corr_at_best, sig_test] = twoenv_rot_analysis_full(sessions, rot_type, varargin)
% best_angle = twoenv_rot_analysis(sessions, rot_type, ...)
%
%   Plots rotation "tuning curves" for all sessions versus one another, the
%   histogram of TMap correlations at the best rotation, and a histogram of
%   best angles for TMaps between each session.  Only cells that have are
%   validly mapped between sessions are plotted.
%   Also spits out the best angle of rotation when compared
%   to the base_session (i.e. the one that gives the highest correlation)
%

%% Parse inputs
ip = inputParser;
ip.addRequired('sessions', @(a) isstruct(a));
ip.addRequired('rot_type', @(a) ischar(a) && (strcmpi(a,'square') || ...
    strcmpi(a,'circle') || strcmpi(a,'circ2square'))); % type of analysis to perform
ip.addParameter('map_session', sessions(1), @(a) isstruct(a) && length(a) == 1); % location of batch map if NOT in 1st entry in sessions
ip.addParameter('alt_map_file', '', @ischar); % alternate batch_map filename if it isn't batch_session_map or batch_session_map_trans
ip.addParameter('num_shuffles', 10, @(a) a >= 0 && round(a) == a);
ip.addParameter('save_fig', false, @islogical);
ip.parse(sessions, rot_type, varargin{:});

map_session = ip.Results.map_session;
alt_map_file = ip.Results.alt_map_file;
num_shuffles = ip.Results.num_shuffles;
save_fig = ip.Results.save_fig;

alpha = 0.05; % Significance level before Bonferroni correction

%% Set up variables

batch_dir = ChangeDirectory(map_session.Animal, map_session.Date, ...
    map_session.Session, 0);

switch rot_type
    case 'square'
        rot_array = 0:90:270;
        batch_map_file = fullfile(batch_dir,'batch_session_map.mat');
        trans = false;
    case 'circle'
        rot_array = 0:15:345;
        batch_map_file = fullfile(batch_dir,'batch_session_map.mat');
        trans = false;
    case 'circ2square'
        rot_array = 0:15:345;
        batch_map_file = fullfile(batch_dir,'batch_session_map_trans.mat');
        trans = true;
    otherwise
        error('something wrong')
end

if ~isempty(alt_map_file)
    batch_map_file = fullfile(batch_dir,alt_map_file);
end

num_sessions = length(sessions);
%% Check to make sure batch_session_map is legit
load(batch_map_file);
batch_session_map = fix_batch_session_map(batch_session_map);
session_index = zeros(1,num_sessions);
for j = 1:num_sessions
    session_index(j) = match_session(batch_session_map.session, sessions(j));
end

if any(isnan(session_index))
    error('some input sessions not found in batch_session_map')
end

%% Do the analysis and plot everything

edges = -1:0.05:1; % bin edges for neuron correlation plots
angle_incr = mean(diff(rot_array));
edges2 = (rot_array(1)-angle_incr/2):angle_incr:(rot_array(end)+angle_incr/2);

hh(1) = figure;
hh(2) = figure;
hh(3) = figure;
ylims = [0 0];
% Plot all sessions vs each other
if ~trans
    num_comp = num_sessions*(num_sessions-1)/2;
    alpha_corr = alpha/num_comp; % Bonferroni corrected significance level
    best_angle = nan(num_sessions, num_sessions);
    best_angle_all = cell(num_sessions, num_sessions);
    corr_at_best = nan(num_sessions, num_sessions);
    sig_test = nan(num_sessions, num_sessions);
    p = ProgressBar((num_sessions-1)*num_sessions/2);
    for j = 1:num_sessions-1
        [~, base_rot] = get_rot_from_db(sessions(j));
        for k = j+1:num_sessions
            % Do analysis
            [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sessions(j), ...
                sessions(k), batch_session_map, rot_array, num_shuffles, 'trans', trans); % do rotation analysis
            
            % Plot everything            
            [~, sesh2_rot] = get_rot_from_db(sessions(k));
            distal_rot = sesh2_rot - base_rot;
            subplot_ind = (j-1)*num_sessions + k;
            [best_angle(j,k), best_angle_all{j,k}, corr_lims, corr_at_best(j,k), sig_test(j,k)] = ...
                plot_func(corr_mat, shuffle_mat2, rot_array, ...
                distal_rot, edges, edges2, hh, num_sessions, subplot_ind, ...
                j, k, j, k, sessions, rot_type, alpha_corr);
            
            ylims(1) = min([ylims(1) corr_lims(1)]);
            ylims(2) = max([ylims(2) corr_lims(2)]);
            
            p.progress;
            
        end
    end
    p.stop;
    
    % Scale figure 1 appropriately
    figure(hh(1))
    ylims = ceil(abs(10*ylims))/10.*[-1 1];
    for j = 1:num_sessions-1
        for k = j+1:num_sessions
            subplot(num_sessions, num_sessions,num_sessions*(j-1)+k);
            ylim(ylims)
        end
    end

elseif trans
    square_ind = get_shape_ind(sessions, 'square');
    circle_ind = get_shape_ind(sessions, 'octagon');
    
    alpha_corr = alpha/(length(square_ind)*length(circle_ind));
    
    best_angle = nan(num_sessions/2, num_sessions/2);
    best_angle_all = cell(num_sessions/2, num_session/2);
    corr_at_best = nan(num_sessions/2, num_sessions/2);
    sig_test = nan(num_sessions/2, num_sessions/2);
    p = ProgressBar((num_sessions/2)^2);
    for j = 1:length(square_ind)
        [~, base_rot] = get_rot_from_db(sessions(square_ind(j)));
        for k = 1:length(circle_ind)
            
            [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sessions(square_ind(j)), ...
                sessions(circle_ind(k)), batch_session_map, rot_array, num_shuffles, 'trans', trans); % do rotation analysis
            
            % Plot everything            
            [~, sesh2_rot] = get_rot_from_db(sessions(circle_ind(k)));
            distal_rot = sesh2_rot - base_rot;
            subplot_ind = (j-1)*num_sessions/2 + k;
            [best_angle(j,k), best_angle_all{j,k}, corr_lims, corr_at_best(j,k), sig_test(j,k)] = ...
                plot_func(corr_mat, shuffle_mat2, rot_array, ...
                distal_rot, edges, edges2, hh, num_sessions/2, subplot_ind, ...
                square_ind(j), circle_ind(k), j, k, sessions, rot_type, alpha_corr);
            
            ylims(1) = min([ylims(1) corr_lims(1)]);
            ylims(2) = max([ylims(2) corr_lims(2)]);
            p.progress;
        end
    
    end
    p.stop;
    
    % Scale figure 1 appropriately
    figure(hh(1))
    ylims = ceil(abs(10*ylims))/10.*[-1 1];
    for j = 1:length(square_ind)
        for k = 1:length(circle_ind)
            subplot(num_sessions/2, num_sessions/2,num_sessions/2*(j-1)+k);
            ylim(ylims)
        end
    end
    
end

if ~isempty(save_fig)
%     ext_type = '.png';
    file_name = {[sessions(1).Animal ' - ' rot_type ' - Population Rotation Analysis'],...
        [sessions(1).Animal ' - ' rot_type ' - Population Best Angle Histogram'],...
        [sessions(1).Animal ' - ' rot_type ' - Neuron Best Angle Histogram']};
    for j = 1:3
       figure(hh(j));
       set(gcf,'Position',[1921 31 1680 974])
%        export_fig(fullfile(save_dir),file_name{j})
       printNK(file_name{j},'2env_rot')
    end
end

end

%% plotting sub-function
function [best_angle, best_angle_all2, corr_lims, corr_at_best, sig_test] = plot_func(corr_mat, shuffle_mat2, rot_array, distal_rot, ...
    edges, edges2, fig_h, num_sessions, subplot_ind, sesh1_ind, sesh2_ind, row, col, sesh_use, rot_type, alpha_corr)

%%% How do I do stats here? %%% K-S test on distributions? Or compare to
%%% shuffled means and look for means greater than shuffled (1-alpha)*100%
%%% of the time?  I'm doing the latter here...
figure(fig_h(1))
try
h = subplot(num_sessions, num_sessions, subplot_ind);
catch
    keyboard
end
corr_means = nanmean(corr_mat,1);
corr_lims = [min(corr_means), max(corr_means)];
plot(rot_array, corr_means) % plot data

hold on


% Get and plot global rotation - needs sanity check!!!
if distal_rot < 0
    distal_rot = distal_rot + 360;
elseif distal_rot >= 360
    distal_rot = distal_rot < 360;
end
rot_log = rot_array == distal_rot;
plot( rot_array(rot_log), corr_means(rot_log), 'r^')

xlim([0 360])
ylim([-1 1]) % Need to revise this to go to the max of all the data in the end
set(h,'XTick',0:90:360);
hold off
title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)

% Get best angle for all neurons together and correlation at this value
[corr_at_best, idx] = max(corr_means);
best_angle = rot_array(idx);

% Calculate Significance
num_shuffles = size(shuffle_mat2,1)/size(corr_mat,1);
shuffle_chunk = size(corr_mat,1);
shuf_mean_corr = nan(num_shuffles,1);
for k = 1:num_shuffles
    ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk); % Get indices for each shuffled session
    shuf_mean_temp(k,:) = nanmean(shuffle_mat2(ind_use,:),1); % Get mean of shuffled sessions
    shuf_mean_corr(k,1) = max(shuf_mean_temp(k,:)); % Get mean at best rotation/highest corr
    shuf_mean_corr(k,2) = min(shuf_mean_temp(k,:)); % Get mean at worst rotation/lowest corr
end
sig_test = (1 - sum(corr_at_best > shuf_mean_corr(:,1))/num_shuffles) < alpha_corr;

% Plot shuffled 95% CI
hold on
% plot(rot_array, nanmean(shuffle_mat2),'g--') % Plot shuffled mean
shuf_mean_sort = sort(shuf_mean_temp,1);
CI(1,:) = shuf_mean_sort(round(0.975*num_shuffles),:);
CI(2,:) = shuf_mean_sort(max([round(0.025*num_shuffles),1]),:); % ceil(0.025*num_shuffles),1);
plot(rot_array,circshift(CI,idx-1,2),'g:') % Plot 95% CI
hold off

% Get best angle for each individual cell
[~, best_ind2] = max(corr_mat(~isnan(nanmean(corr_mat,2)),:),[],2);
[~, best_ind2_shuf] = max(shuffle_mat2(~isnan(nanmean(shuffle_mat2,2)),:),[],2);
best_angle_all = rot_array(best_ind2);
best_angle_all2 = nan(size(corr_mat,1),1);
best_angle_all2(~isnan(nanmean(corr_mat,2))) = best_angle_all; % Keep these in the same neuron location as session1
best_angle_all_shuf = rot_array(best_ind2_shuf);

% plot histogram breakdown of correlation values at best rotation
% vs. shuffle
figure(fig_h(2))
subplot(num_sessions, num_sessions, subplot_ind);
histogram(corr_mat(:, idx), edges, 'Normalization', 'probability'); hold on;
histogram(shuffle_mat2(:,1), edges, 'Normalization', 'probability');
title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)

figure(fig_h(3));
subplot(num_sessions, num_sessions, subplot_ind);
histogram(best_angle_all, edges2); hold on;
pshuf = histcounts(best_angle_all_shuf, edges2, 'Normalization', 'probability');
plot(rot_array, pshuf*length(best_angle_all),'k--')
xlim([rot_array(1)-mean(diff(rot_array))/2 rot_array(end)+mean(diff(rot_array))/2])
set(gca,'XTick',0:90:270);
title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)

end

%% Get indices for each shape
function [shape_ind] = get_shape_ind(struct_in,shape)
    
    shape_log = nan(1,length(struct_in));
    for ll=1:length(struct_in)
        [~, struct_full] = ChangeDirectory_NK(struct_in(ll),0);
        shape_log(ll) = ~isempty(regexpi(struct_full.Env,shape)); 
    end
    shape_ind = find(logical(shape_log));
end

%% title label sub-function
function [] = title_label(subplot_ind, sesh1_index, sesh2_index, row, col, rot_type, sesh_use)

if (strcmpi(rot_type,'circ2square') && subplot_ind == 1) || ...
        (~strcmpi(rot_type,'circ2square') && sesh1_index == 1 && sesh2_index == 2)
    [~, sesh_use] = ChangeDirectory_NK(sesh_use(1),0);
    title(mouse_name_title(sesh_use(1).Animal))
else
    title([num2str(row) ' ' twoenv_get_shape(sesh_use(sesh1_index).Animal, sesh_use(sesh1_index).Date, sesh_use(sesh1_index).Session)...
        ' - ' num2str(col) ' ' twoenv_get_shape(sesh_use(sesh2_index).Animal, sesh_use(sesh2_index).Date, sesh_use(sesh2_index).Session)]);
end


end
