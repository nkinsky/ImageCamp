function [best_angle] = twoenv_rot_plot_full(sessions, rot_type, varargin)
% best_angle = twoenv_rot_analysis(base_session, rot_sessions, rot_type)
%
%   Plots rotation "tuning curves" for all sessions versus one another, the
%   histogram of TMap correlations at the best rotation, and a histogram of
%   best angles for TMaps between each session.  Only cells that have are
%   validly mapped between sessions are plotted.
%   Also spits out the best angle of rotation when compared
%   to the base_session (i.e. the one that gives the highest correlation)
%
%   Should probably just combine with twoenv_batch_rot_analysis and call it
%   twoenv_plot_rot_full or something similar

%% Parse inputs
ip = inputParser;
ip.addRequired('sessions', @(a) isstruct(a));
ip.addRequired('rot_type', @(a) ischar(a) && (strcmpi(a,'square') || ...
    strcmpi(a,'circle') || strcmpi(a,'circ2square'))); % type of analysis to perform
ip.addParameter('map_session', sessions(1), @(a) isstruct(a) && length(a) == 1); % location of batch map if NOT in 1st entry in sessions
ip.addParameter('alt_map_file', '', @ischar); % alternate batch_map filename if it isn't batch_session_map or batch_session_map_trans
ip.addParameter('num_shuffles', 10, @(a) a >= 0 && round(a) == a)
ip.parse(sessions, rot_type, varargin{:});

map_session = ip.Results.map_session;
alt_map_file = ip.Results.alt_map_file;
num_shuffles = ip.Results.num_shuffles;

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
% Plot all sessions vs each other
best_angle = nan(num_sessions, num_sessions);
if ~trans
    
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
            subplot_ind = num_sessions*(j-1)+k;
            best_angle(j,k) = plot_func(corr_mat, shuffle_mat2, rot_array, ...
                distal_rot, edges, edges2, hh, num_sessions, subplot_ind);
            
            p.progress;
        end
    end
    p.stop;

elseif trans
    disp('circ2square functionality not finished yet')
    % We want only to plot each square session versus each circle session,
    % not including square v square and circle v circle.
    % Would need to get circle and square sessions out of the session_list,
    % list them, then do a for loop with j = square sessions and k = circle
    % sessions
    
end


end

%% plotting sub-function
function [best_angle] = plot_func(corr_mat, shuffle_mat2, rot_array, distal_rot, ...
    edges, edges2, fig_h, num_sessions, subplot_ind)
figure(fig_h(1))
h = subplot(num_sessions, num_sessions, subplot_ind);
corr_means = nanmean(corr_mat,1);
plot(rot_array, corr_means) % plot data

hold on
plot(rot_array, nanmean(shuffle_mat2),'g-.') % Plot shuffled - need to show CI somehow

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
%         xlabel('Local Cue Mismatch (deg)')
%         ylabel('Mean Spearman Correlation')
%         title([mouse_name_title(sessions(k).Date) ' - Session ' num2str(sessions(k).Session) ...
%             ' (' twoenv_get_shape(sessions(k).Animal, sessions(k).Date, sessions(k).Session) ')'])
%         legend('Actual', 'Shuffled', 'Distal aligned')

% Get best angle for all neurons together
[~, best_ind] = max(corr_means);
best_angle = rot_array(best_ind);

% Get best angle for each individual cell
[~, best_ind2] = max(corr_mat(~isnan(nanmean(corr_mat,2)),:),[],2);
[~, best_ind2_shuf] = max(shuffle_mat2(~isnan(nanmean(shuffle_mat2,2)),:),[],2);
best_angle_all = rot_array(best_ind2);
best_angle_all_shuf = rot_array(best_ind2_shuf);

% plot histogram breakdown of correlation values at best rotation
% vs. shuffle
figure(fig_h(2))
subplot(num_sessions, num_sessions, subplot_ind);
histogram(corr_mat(:, best_ind), edges, 'Normalization', 'probability'); hold on;
histogram(shuffle_mat2(:,1), edges, 'Normalization', 'probability');
%         title([mouse_name_title(sessions(k).Date) ' - Session ' num2str(sessions(k).Session) ...
%             ' (' twoenv_get_shape(sessions(k).Animal, sessions(k).Date, sessions(k).Session) ')'])
%         xlabel('Spearman Correlation')
%         ylabel('Probability')
%         legend('Best Rotation', 'Shuffled')

figure(fig_h(3));
subplot(num_sessions, num_sessions, subplot_ind);
histogram(best_angle_all, edges2); hold on;
pshuf = histcounts(best_angle_all_shuf, edges2, 'Normalization', 'probability');
plot(rot_array, pshuf*length(best_angle_all),'k--')
%         title([mouse_name_title(sessions(k).Date) ' - Session ' num2str(sessions(k).Session) ...
%             ' (' twoenv_get_shape(sessions(k).Animal, sessions(k).Date, sessions(k).Session) ')'])
        xlim([rot_array(1)-mean(diff(rot_array))/2 rot_array(end)+mean(diff(rot_array))/2])
        set(gca,'XTick',0:90:270);
%         xlabel('Angle of best correlation (degrees)')
%         ylabel('Probability (#neurons/total')
%         legend('Actual','Shuffled')

end