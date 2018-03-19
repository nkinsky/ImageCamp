function [best_angle, best_angle_all, corr_at_best, sig_test, corr_means, CI, hh,...
    best_angle_shuf_all] = twoenv_rot_analysis_full(sessions, rot_type, varargin)
%  [best_angle, best_angle_all, corr_at_best, sig_test, corr_means, CI, hh, ...
%   best_angle_shuf_all] = twoenv_rot_analysis_full(sessions, rot_type, varargin)
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
ip.addParameter('map_session', sessions(1), @(a) isstruct(a) && ...
    length(a) == 1); % location of batch map if NOT in 1st entry in sessions
ip.addParameter('alt_map_file', '', @ischar); % alternate batch_map filename if it isn't batch_session_map or batch_session_map_trans
ip.addParameter('num_shuffles', 10, @(a) a >= 0 && round(a) == a);
ip.addParameter('sig_star', false(length(sessions)), @islogical); % Puts a star and p-value by each non-nan value
ip.addParameter('sig_value', nan(length(sessions)), @isnumeric); % Puts the value of anything in sig_stars on the graph
ip.addParameter('save_fig', true, @islogical);
ip.addParameter('local_ref', true, @islogical); % true = use local cues as 
% reference and plot in terms of local cue mismatch, false = use distal
% cues as reference and plot rotation of curves in reference to the room
% and plot red triangle at the rotation of local cues from session 1 to
% session 2
ip.addParameter('name_append','',@ischar); % Name to append to end of .mat and .pdf files
ip.addParameter('cm_append','',@ischar);
ip.addParameter('TMap_type', 'TMap_gauss', @(a) strcmpi(a,'TMap_gauss') || ...
    strcmpi(a,'TMap_unsmoothed'));
ip.addParameter('plot_flag', true, @islogical);
ip.parse(sessions, rot_type, varargin{:});

map_session = ip.Results.map_session;
alt_map_file = ip.Results.alt_map_file;
num_shuffles = ip.Results.num_shuffles;
save_fig = ip.Results.save_fig;
sig_star = ip.Results.sig_star;
sig_value = ip.Results.sig_value;
name_append = ip.Results.name_append;
cm_append = ip.Results.cm_append;
TMap_type = ip.Results.TMap_type;
local_ref = ip.Results.local_ref;
plot_flag = ip.Results.plot_flag;

alpha = 0.05; % Significance level before Bonferroni correction

sessions = complete_MD(sessions);
square_bool = arrayfun(@(a) ~isempty(regexpi(a.Env,'square')), sessions);
circ_bool = arrayfun(@(a) ~isempty(regexpi(a.Env,'octagon')), sessions);
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

% Check if already run
file_save_name = fullfile(batch_dir,['full_rotation_analysis_' rot_type ...
    cm_append '_' TMap_type '_shuffle' num2str(num_shuffles) name_append]);
try
    load(file_save_name)
    disp('Loading previously saved file with these parameters and plotting from it')
    disp('Delete or re-name to re-run')
    already_ran = true;
    
    % pull out only the relevant sessions
    if ~trans
        sessions_rows = session_index;
        sessions_cols = session_index;
    elseif trans
        square_ind = get_shape_ind(sessions, 'square');
        circle_ind = get_shape_ind(sessions, 'octagon');
        for j = 1:length(square_ind)
            sessions_rows(j) = find(session_index(square_ind(j)) == ...
                get_shape_ind(batch_session_map.session,'square'));
        end
        for j = 1:length(circle_ind)
            sessions_cols(j) = find(session_index(circle_ind(j)) == ...
                get_shape_ind(batch_session_map.session,'octagon'));
        end
    end
    best_angle = best_angle(sessions_rows, sessions_cols);
    best_angle_all = best_angle_all(sessions_rows, sessions_cols);
    best_angle_shuf_all = best_angle_shuf_all(sessions_rows, sessions_cols);
    corr_at_best = corr_at_best(sessions_rows, sessions_cols);
    sig_test = sig_test(sessions_rows, sessions_cols);
    corr_means = corr_means(sessions_rows, sessions_cols,:);
    CI = CI(sessions_rows, sessions_cols,:,:);
    
catch
    already_ran = false;
end

% Grab the appropriate sessions from sig_star and sig_value if only a few
% sessions are entered
if size(sig_star,1) ~= num_sessions
    sig_star = sig_star(session_index, session_index);
end

if size(sig_value,1) ~= num_sessions
    sig_value = sig_value(session_index, session_index);
end
 
% Set up variables for plots
edges = -1:0.05:1; % bin edges for neuron correlation plots
angle_incr = mean(diff(rot_array));
edges2 = (rot_array(1)-angle_incr/2):angle_incr:(rot_array(end)+angle_incr/2);

hh(1) = figure; set(gcf,'Visible', 'off'); 
hh(2) = figure; set(gcf,'Visible', 'off'); 
ylims = [0 0];

% Plot all sessions vs each other
if plot_flag
if ~trans
    if ~already_ran % pre-allocate if analysis part not already ran
        num_comp = num_sessions*(num_sessions-1)/2;
        alpha_corr = alpha/num_comp; % Bonferroni corrected significance level
        best_angle = nan(num_sessions, num_sessions);
        best_angle_all = cell(num_sessions, num_sessions);
        best_angle_shuf_all = cell(num_sessions, num_sessions);
        corr_at_best = nan(num_sessions, num_sessions);
        sig_test = nan(num_sessions, num_sessions);
        corr_means = nan(num_sessions, num_sessions, length(rot_array));
        CI = nan(num_sessions, num_sessions, 2, length(rot_array));
    end
    p = ProgressBar((num_sessions-1)*num_sessions/2);
    for j = 1:num_sessions-1
        [~, base_rot] = get_rot_from_db(sessions(j));
        sesh1 = session_index(j);
        for k = j+1:num_sessions
            sesh2 = session_index(k);
            % Do analysis if not already done
            if ~already_ran
                [corr_mat, ~, shuffle_mat2, shift_back] = corr_rot_analysis(sessions(j), ...
                    sessions(k), batch_session_map, rot_array, num_shuffles, ...
                    'trans', trans,'cm_append', cm_append,'TMap_type',TMap_type); % do rotation analysis
            end
                   
            % Calculate required metrics for plotting
            [~, sesh2_rot] = get_rot_from_db(sessions(k));
            cue_rot = sesh2_rot - base_rot; % ID how much local cues have rotated from session 1 to session 2
            if ~already_ran
                [best_angle(j,k), best_angle_all{j,k}, ~, corr_at_best(j,k), ...
                    sig_test(j,k), corr_means(j,k,:), CI(j,k,:,:), ...
                    best_angle_shuf_all{j,k}] = calc_metrics(corr_mat, ...
                    shuffle_mat2, rot_array, shift_back, alpha_corr);
            end
            
            % NRK - adjust here to shift corr_mat - NEEDS checking...
            if ~local_ref
                % Identify how much to shift curves back
                % 90 degree increments for square
                if square_bool(j) && square_bool(k) 
                    local_shift_back = cue_rot/90;
                else % 15 degree increments otherwise
                    local_shift_back = cue_rot/15; 
                end
                cue_rot_add = cue_rot;
            elseif local_ref
                local_shift_back = 0;
                cue_rot_add = 0;
            end
            
            % Plot each session-pair
            subplot_ind = (j-1)*num_sessions + k;
            corr_mean_use = circshift(squeeze(corr_means(j,k,:)), local_shift_back);
            CI_use = circshift(squeeze(CI(j,k,:,:)), local_shift_back);
            plot_tuning_curve(rot_array, corr_mean_use, CI_use, cue_rot, ...
                hh(1), num_sessions, subplot_ind, j, k, sesh1, sesh2, sessions, ...
                rot_type, sig_star(j,k), sig_value(j,k), local_ref);
            best_ang_use = wrapTo360(best_angle_all{j,k} + cue_rot_add);
            best_ang_use(best_ang_use == 360) = 0;
            best_ang_shuf_use = wrapTo360(best_angle_shuf_all{j,k} + ...
                cue_rot_add);
            best_ang_shuf_use(best_ang_shuf_use == 360) = 0;
            plot_bestang_hist(rot_array, best_ang_use, best_ang_shuf_use, ...
                edges2, hh(2), num_sessions, subplot_ind, j, k, sesh1, sesh2,  ...
                sessions, rot_type, local_ref);
            
            % Aggregate data limits to set y-axis the same for tuning curve
            % plots
            ylims(1) = min([ylims(1) min(corr_mean_use)]);
            ylims(2) = max([ylims(2) max(corr_mean_use)]);
            
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
%             make_plot_pretty(gca);
        end
    end

elseif trans
    
    alpha_corr = alpha/(length(square_ind)*length(circle_ind));
    
    if ~already_ran % pre-allocate if analysis part not already ran
        best_angle = nan(num_sessions/2, num_sessions/2);
        best_angle_all = cell(num_sessions/2, num_sessions/2);
        best_angle_shuf_all = cell(num_sessions/2, num_sessions/2);
        corr_at_best = nan(num_sessions/2, num_sessions/2);
        sig_test = nan(num_sessions/2, num_sessions/2);
        corr_means = nan(num_sessions/2, num_sessions/2, length(rot_array));
        CI = nan(num_sessions/2, num_sessions/2, 2, length(rot_array));
    end
    p = ProgressBar((num_sessions/2)^2);
    for j = 1:length(square_ind)
        [~, base_rot] = get_rot_from_db(sessions(square_ind(j)));
        for k = 1:length(circle_ind)
            
            % Do analysis if not already done
            if ~already_ran
                [corr_mat, ~, shuffle_mat2, shift_back] = corr_rot_analysis(sessions(square_ind(j)), ...
                    sessions(circle_ind(k)), batch_session_map, rot_array, ...
                    num_shuffles, 'trans', trans,'cm_append', cm_append,...
                    'TMap_type',TMap_type); % do rotation analysis
            end
            
            % Calculate required metrics for plotting
            [~, sesh2_rot] = get_rot_from_db(sessions(circle_ind(k)));
            cue_rot = sesh2_rot - base_rot; % ID how much local cues have rotated from session 1 to session 2
            if ~already_ran
                [best_angle(j,k), best_angle_all{j,k}, ~, corr_at_best(j,k), ...
                    sig_test(j,k), corr_means(j,k,:), CI(j,k,:,:), ...
                    best_angle_shuf_all{j,k}] = calc_metrics(corr_mat, ...
                    shuffle_mat2, rot_array, shift_back, alpha_corr);
            end
            
            if ~local_ref
                % Identify how much to shift curves back
                local_shift_back = -cue_rot/15;
                cue_rot_add = cue_rot;
            elseif local_ref
                local_shift_back = 0;
                cue_rot_add = 0;
            end
            
            % Plot each session-pair
            subplot_ind = (j-1)*num_sessions/2 + k;
            corr_mean_use = circshift(squeeze(corr_means(j,k,:)), local_shift_back);
            CI_use = circshift(squeeze(CI(j,k,:,:)), local_shift_back);
            plot_tuning_curve(rot_array, corr_mean_use, CI_use, cue_rot, ...
                hh(1), num_sessions/2, subplot_ind, square_ind(j), circle_ind(k),...
                j, k, sessions, rot_type, sig_star(j,k), sig_value(j,k),...
                local_ref);
            best_ang_use = wrapTo360(best_angle_all{j,k} + cue_rot_add);
            best_ang_use(best_ang_use == 360) = 0;
            best_ang_shuf_use = wrapTo360(best_angle_shuf_all{j,k} + ...
                cue_rot_add);
            plot_bestang_hist(rot_array, best_ang_use, best_ang_shuf_use, ...
                edges2, hh(2), num_sessions/2, subplot_ind, square_ind(j), ...
                circle_ind(k), j, k, sessions, rot_type, local_ref);
            
            % Aggregate data limits to set y-axis the same for tuning curve
            % plots
            ylims(1) = min([ylims(1) min(corr_mean_use)]);
            ylims(2) = max([ylims(2) max(corr_mean_use)]);

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
end

%% Save Figures 1-3
ref_type = {'distalref','localref'};
ref_text = ref_type{local_ref + 1};

arrayfun(@(a) set(a,'Visible','on'),hh)
if save_fig && plot_flag
        file_name = {[sessions(1).Animal ' - ' rot_type ...
            ' - Population Rotation Analysis - ' num2str(num_shuffles) ...
            ' shuffles' name_append '_' ref_text],...
        [sessions(1).Animal ' - ' rot_type ' - Neuron Best Angle Histogram - '...
        num2str(num_shuffles) ' shuffles' name_append '_' ref_text]};
    % %         [sessions(1).Animal ' - ' rot_type ' - Population Best Angle Histogram - ' ...
    %         num2str(num_shuffles) ' shuffles' name_append '_' ref_text ],...

    for j = 1:2
       set(gcf,'Position',[1921 1 1920 1004])
       printNK(file_name{j},'2env_rot')
    end
end

% Save relevant variables
if ~already_ran
    file_save_name = fullfile(batch_dir,['full_rotation_analysis_' rot_type ...
        cm_append '_' TMap_type '_shuffle' num2str(num_shuffles) name_append]);
    save(file_save_name, 'best_angle', 'best_angle_all', 'corr_at_best', ...
        'sig_test', 'corr_means', 'CI', 'num_shuffles', 'best_angle_shuf_all',...
        'TMap_type','cm_append')
end

end

%%
function [best_angle, best_angle_all2, corr_lims, corr_at_best, sig_test, ...
    corr_means, CI, best_angle_shuf_all] = ...
    calc_metrics(corr_mat, shuffle_mat2, rot_array, shift_back, alpha_corr)

corr_means = nanmean(corr_mat,1);
corr_lims = [min(corr_means), max(corr_means)];

% Get best angle for all neurons together and correlation at this value
[corr_at_best, idx] = max(corr_means);
best_angle = rot_array(idx);

% Calculate Significance & get 95% CIs for population tuning curve
num_shuffles = size(shuffle_mat2,1)/size(corr_mat,1);
shuffle_chunk = size(corr_mat,1);
shuf_mean_corr = nan(num_shuffles,1);
shuf_mean_temp = nan(num_shuffles, size(shuffle_mat2,2));
for k = 1:num_shuffles
    ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk); % Get indices for each shuffled session
    shuf_mean_temp(k,:) = nanmean(shuffle_mat2(ind_use,:),1); % Get mean of shuffled sessions
    shuf_mean_corr(k,1) = max(shuf_mean_temp(k,:)); % Get mean at best rotation/highest corr
    shuf_mean_corr(k,2) = min(shuf_mean_temp(k,:)); % Get mean at worst rotation/lowest corr
end
% Calculate pval as how many times the mean tuning curve is less than the
% shuffled tuning curve and compare to alpha (Bonferroni-corrected
% signficance level)
sig_test = (1 - sum(corr_at_best > shuf_mean_corr(:,1))/num_shuffles) < alpha_corr;
shuf_mean_sort = sort(shuf_mean_temp,1);
CI(1,:) = shuf_mean_sort(round(0.975*num_shuffles),:);
CI(2,:) = shuf_mean_sort(max([round(0.025*num_shuffles),1]),:);

% Get best angle for each individual cell
[~, best_ind2] = max(corr_mat(~isnan(nanmean(corr_mat,2)),:),[],2);
best_angle_all = rot_array(best_ind2);
best_angle_all2 = nan(size(corr_mat,1),1);
best_angle_all2(~isnan(nanmean(corr_mat,2))) = best_angle_all; % Keep these in the same neuron location as session1

% Reassemble each shuffled best angle array so that the peaks align
best_angle_shuf_all = nan(round(length(best_ind2)*1.2), num_shuffles); % pre-allocate
for k = 1:num_shuffles
    ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk);
    shuf_mat_use = shuffle_mat2(ind_use,:); % Grab each shuffled chunk
    shuf_mat_use = circshift(shuf_mat_use, shift_back(k),2); % Shift it back to its original alignment (corr_rot_analysis rotates stacks all the best shuffles in the first column, so just looking at that one is unfair)
    [~, best_ind_shuf_temp] = max(shuf_mat_use(~isnan(nanmean(shuf_mat_use,2)),:),[],2); % ID best index for each cell
    best_ang_shuf = rot_array(best_ind_shuf_temp); % Convert index to angle
    best_angle_shuf_all(1:length(best_ang_shuf),k) = best_ang_shuf'; % Dump into matrix!!
end

end

%% plotting sub-function: plot population tuning curve
function plot_tuning_curve(rot_array, corr_means, CI, cue_rot, fig_h, ...
    num_sessions, subplot_ind, sesh1_ind, sesh2_ind, sesh1_num, sesh2_num, ...
    sesh_use, rot_type, sig_star, sig_value, local_ref)

% Plot tuning curves
set(groot, 'CurrentFigure', fig_h);
h = subplot(num_sessions, num_sessions, subplot_ind);
plot([rot_array 360], [corr_means' corr_means(1)]) % plot data
hold on

% Get best angle for all neurons together and correlation at this value
[corr_at_best, idx] = max(corr_means);
best_angle = rot_array(idx);

% Get and plot cue rotation
if cue_rot < 0
    cue_rot = cue_rot + 360;
elseif cue_rot >= 360
    cue_rot = cue_rot < 360;
end
rot_log = rot_array == cue_rot;
plot( rot_array(rot_log), corr_means(rot_log), 'r^')

% Put significance star on plot
if sig_star
   plot(best_angle, corr_at_best + 0.04, 'r*'); 
end

if ~isnan(sig_value)
      text(30, -0.3, ['p = ' num2str(sig_value,'%0.2g')]); 
end

xlim([0 360])
ylim([-1 1])
set(h,'XTick',0:90:360);
hold on

% Plot 95% CI %
plot([rot_array 360], [CI CI(:,1)],'k:') 
hold off
title_label(subplot_ind, sesh1_ind, sesh2_ind, sesh1_num, sesh2_num, ...
    rot_type, sesh_use)

if local_ref
    xlabel('Local Cue Mismatch (\theta)')
elseif ~local_ref
    xlabel('Rotation (\theta)')
end

ylabel('Mean Corr')

end

%% LEGACY CODE (NOT CURRENTLY USED): plotting sub-function: plot histogram of correlations at optimum rotation
% function plot_opt_corrs(corr_mat, edges, fig_h, num_sessions, subplot_ind, ...
%     sesh1_ind, sesh2_ind, row, col, sesh_use, rot_type)
% 
% % Get best angle for all neurons together and correlation at this value
% [~, idx] = max(corr_means);
% 
% % Plot histogram breakdown of correlation values at best rotation
% % vs. shuffle
% set(groot, 'CurrentFigure', fig_h); % figure(fig_h(2))
% subplot(num_sessions, num_sessions, subplot_ind);
% histogram(corr_mat(:, idx), edges, 'Normalization', 'probability'); hold on;
% % histogram(shuffle_mat2(:,1), edges, 'Normalization', 'probability');
% title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)
% 
% end

%% plotting sub-function: plot histogram of best/optimal rotation counts
function plot_bestang_hist(rot_array, best_angle_all, best_ang_shuf_all,  ...
    edges2, fig_h, num_sessions, subplot_ind, sesh1_ind, sesh2_ind, ...
    sesh1_num, sesh2_num, sesh_use, rot_type, local_ref)

num_shuffles = size(best_ang_shuf_all,2);
% Plot histogram of best angle counts for all neurons
set(groot, 'CurrentFigure', fig_h); % figure(fig_h(3));
subplot(num_sessions, num_sessions, subplot_ind);
histogram(best_angle_all, edges2); hold on;

% Calculate histogram 95% CIs from shuffled data
shuf_count = nan(num_shuffles, length(rot_array)); % pre-allocate
for k = 1:num_shuffles
    shuf_count(k,:) = histcounts(best_ang_shuf_all(:,k), edges2); % Get counts
end
shuf_count_sort = sort(shuf_count,1);
CI_count(1,:) = shuf_count_sort(round(0.975*num_shuffles),:);
CI_count(2,:) = shuf_count_sort(max([round(0.025*num_shuffles),1]),:);
plot(rot_array, nanmean(shuf_count,1),'k-', rot_array, CI_count, 'k:');
xlim([rot_array(1)-mean(diff(rot_array))/2 rot_array(end)+mean(diff(rot_array))/2])
set(gca,'XTick',0:90:270);
title_label(subplot_ind, sesh1_ind, sesh2_ind, sesh1_num, sesh2_num, rot_type, sesh_use)

if local_ref
    xlabel('\theta_{optimal} (Local Cue Mismatch)')
elseif ~local_ref
    xlabel('\theta_{optimal}')
end

ylabel('# Neurons')

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
function [] = title_label(subplot_ind, sesh1_index, sesh2_index, sesh1_num, ...
    sesh2_num, rot_type, sesh_use)

if (strcmpi(rot_type,'circ2square') && subplot_ind == 1) || ...
        (~strcmpi(rot_type,'circ2square') && sesh1_index == 1 && sesh2_index == 2)
    [~, sesh_use] = ChangeDirectory_NK(sesh_use(1),0);
    title(mouse_name_title(sesh_use(1).Animal))
else
    title([num2str(sesh1_num) ' ' twoenv_get_shape(sesh_use(sesh1_index).Animal, ...
        sesh_use(sesh1_index).Date, sesh_use(sesh1_index).Session)...
        ' - ' num2str(sesh2_num) ' ' twoenv_get_shape(sesh_use(sesh2_index).Animal, ...
        sesh_use(sesh2_index).Date, sesh_use(sesh2_index).Session)]);
end

end


%% old plotting sub-function: archived here just in case
% function [best_angle, best_angle_all2, corr_lims, corr_at_best, sig_test, ...
%     corr_means, CI, best_angle_shuf_all] = ...
%     plot_func(corr_mat, shuffle_mat2, rot_array, shift_back, cue_rot, ...
%     edges, edges2, fig_h, num_sessions, subplot_ind, sesh1_ind, sesh2_ind, ...
%     row, col, sesh_use, rot_type, alpha_corr, sig_star, sig_value)
% 
% %%% NRK Note: look through this function for all calls to "plot" and
% %%% "histogram" and then rewrite it into two separate functions - one that
% %%% calculates all the necessary inputs to the plot functions, and the plot
% %%% functions themselves.  Then you can load the saved full rotation
% %%% analyses and plot these all shifted.
% 
% set(groot, 'CurrentFigure', fig_h(1)); % figure(fig_h(1))
% 
% try
% h = subplot(num_sessions, num_sessions, subplot_ind);
% catch
%     keyboard
% end
% corr_means = nanmean(corr_mat,1);
% corr_lims = [min(corr_means), max(corr_means)];
% plot(rot_array, corr_means) % plot data
% 
% % Get best angle for all neurons together and correlation at this value
% [corr_at_best, idx] = max(corr_means);
% best_angle = rot_array(idx);
% 
% hold on
% 
% % Get and plot cue rotation
% if cue_rot < 0
%     cue_rot = cue_rot + 360;
% elseif cue_rot >= 360
%     cue_rot = cue_rot < 360;
% end
% rot_log = rot_array == cue_rot;
% plot( rot_array(rot_log), corr_means(rot_log), 'r^')
% 
% % Put significance star on plot
% if sig_star
%    plot(rot_array(idx), corr_at_best + 0.1, 'r*'); 
% end
% 
% if ~isnan(sig_value)
%       text(30, -0.3, ['p = ' num2str(sig_value,'%0.2g')]); 
% end
% 
% xlim([0 360])
% ylim([-1 1]) % Need to revise this to go to the max of all the data in the end
% set(h,'XTick',0:90:360);
% hold off
% title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)
% 
% % Calculate Significance
% num_shuffles = size(shuffle_mat2,1)/size(corr_mat,1);
% shuffle_chunk = size(corr_mat,1);
% shuf_mean_corr = nan(num_shuffles,1);
% shuf_mean_temp = nan(num_shuffles, size(shuffle_mat2,2));
% for k = 1:num_shuffles
%     ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk); % Get indices for each shuffled session
%     shuf_mean_temp(k,:) = nanmean(shuffle_mat2(ind_use,:),1); % Get mean of shuffled sessions
%     shuf_mean_corr(k,1) = max(shuf_mean_temp(k,:)); % Get mean at best rotation/highest corr
%     shuf_mean_corr(k,2) = min(shuf_mean_temp(k,:)); % Get mean at worst rotation/lowest corr
% end
% sig_test = (1 - sum(corr_at_best > shuf_mean_corr(:,1))/num_shuffles) < alpha_corr;
% 
% % Plot shuffled 95% CI
% hold on
% % plot(rot_array, nanmean(shuffle_mat2),'g--') % Plot shuffled mean
% shuf_mean_sort = sort(shuf_mean_temp,1);
% CI(1,:) = shuf_mean_sort(round(0.975*num_shuffles),:);
% CI(2,:) = shuf_mean_sort(max([round(0.025*num_shuffles),1]),:); % ceil(0.025*num_shuffles),1);
% plot(rot_array, CI,'k:') % Plot 95% CI % plot(rot_array,circshift(CI,idx-1,2),'k:') % Plot 95% CI
% hold off
% 
% % Get best angle for each individual cell
% [~, best_ind2] = max(corr_mat(~isnan(nanmean(corr_mat,2)),:),[],2);
% % [~, best_ind2_shuf] = max(shuffle_mat2(~isnan(nanmean(shuffle_mat2,2)),:),[],2);
% best_angle_all = rot_array(best_ind2);
% best_angle_all2 = nan(size(corr_mat,1),1);
% best_angle_all2(~isnan(nanmean(corr_mat,2))) = best_angle_all; % Keep these in the same neuron location as session1
% % best_angle_all_shuf = rot_array(best_ind2_shuf);
% 
% % plot histogram breakdown of correlation values at best rotation
% % vs. shuffle
% set(groot, 'CurrentFigure', fig_h(2)); % figure(fig_h(2))
% subplot(num_sessions, num_sessions, subplot_ind);
% histogram(corr_mat(:, idx), edges, 'Normalization', 'probability'); hold on;
% histogram(shuffle_mat2(:,1), edges, 'Normalization', 'probability');
% title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)
% 
% % Plot histogram of best angle counts for all neurons
% set(groot, 'CurrentFigure', fig_h(3)); % figure(fig_h(3));
% subplot(num_sessions, num_sessions, subplot_ind);
% histogram(best_angle_all, edges2); hold on;
% % pshuf = histcounts(best_angle_all_shuf, edges2, 'Normalization', 'probability');
% % Get 95% CIs
% shuf_count = nan(num_shuffles, length(rot_array)); % pre-allocate
% best_angle_shuf_all = nan(round(length(best_ind2)*1.2), num_shuffles); % pre-allocate
% for k = 1:num_shuffles
%     ind_use = ((k-1)*shuffle_chunk+1):(k*shuffle_chunk);
%     shuf_mat_use = shuffle_mat2(ind_use,:); % Grab each shuffled chunk
%     shuf_mat_use = circshift(shuf_mat_use, shift_back(k),2); % Shift it back to its original alignment (corr_rot_analysis rotates stacks all the best shuffles in the first column, so just looking at that one is unfair)
%     [~, best_ind_shuf_temp] = max(shuf_mat_use(~isnan(nanmean(shuf_mat_use,2)),:),[],2); % ID best index for each cell
%     best_ang_shuf = rot_array(best_ind_shuf_temp); % Convert index to angle
%     shuf_count(k,:) = histcounts(best_ang_shuf, edges2); % Get counts
%     best_angle_shuf_all(1:length(best_ang_shuf),k) = best_ang_shuf'; % Dump into matrix!!
% end
% shuf_count_sort = sort(shuf_count,1);
% CI_count(1,:) = shuf_count_sort(round(0.975*num_shuffles),:);
% CI_count(2,:) = shuf_count_sort(max([round(0.025*num_shuffles),1]),:);
% plot(rot_array, nanmean(shuf_count,1),'k-', rot_array, CI_count, 'k:');
% 
% % plot(rot_array, pshuf*length(best_angle_all),'k--')
% xlim([rot_array(1)-mean(diff(rot_array))/2 rot_array(end)+mean(diff(rot_array))/2])
% set(gca,'XTick',0:90:270);
% title_label(subplot_ind, sesh1_ind, sesh2_ind, row, col, rot_type, sesh_use)
% 
% end
