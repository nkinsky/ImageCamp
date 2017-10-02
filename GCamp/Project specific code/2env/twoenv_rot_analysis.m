function [best_angle, corr_at_best] = twoenv_rot_analysis(base_session, rot_sessions, rot_type, varargin)
% best_angle = twoenv_rot_analysis(base_session, rot_sessions, rot_type)
%
%   NOT REALLY USED ANYMORE AND MIGHT NOT WORK WELL DUE TO CHANGES TO LOWER
%   LEVEL FUNCTIONS
%
%   Plots rotation "tuning curves" for all the rot_sessions vs. the
%   base_session.  Also spits out the best angle of rotation when compared
%   to the base_session (i.e. the one that gives the highest correlation).
%
%   Use this if you want a less dense version of comparisons since it will
%   show you plots versus only 1 session (the base session).  Might be
%   better for plotting individual sessions versus one another.

%% Parse inputs
ip = inputParser;
ip.addRequired('base_session', @(a) isstruct(a) && length(a) == 1);
ip.addRequired('rot_sessions', @(a) isstruct(a));
ip.addRequired('rot_type', @(a) ischar(a) && (strcmpi(a,'square') || ...
    strcmpi(a,'circle') || strcmpi(a,'circ2square'))); % type of analysis to perform
ip.addParameter('map_session', base_session, @(a) isstruct(a) && length(a) == 1); % location of batch map if NOT in base_session
ip.addParameter('alt_map_file', '', @ischar); % alternate batch_map filename if it isn't batch_session_map or batch_session_map_trans
ip.addParameter('num_shuffles', 10, @(a) a >= 0 && round(a) == a)
ip.parse(base_session, rot_sessions, rot_type, varargin{:});

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

sesh_use = cat(2, base_session, rot_sessions);
num_sessions = length(sesh_use);
%% Check to make sure batch_session_map is legit
load(batch_map_file);
batch_session_map = fix_batch_session_map(batch_session_map);
session_index = zeros(1,num_sessions);
for j = 1:num_sessions
    session_index(j) = match_session(batch_session_map.session, sesh_use(j));
end

if any(isnan(session_index))
    error('some input sessions not found in batch_session_map')
end

%% Do the analysis and plot everything

[~, base_rot] = get_rot_from_db(base_session);

edges = -1:0.05:1; % bin edges for neuron correlation plots
angle_incr = mean(diff(rot_array));
edges2 = (rot_array(1)-angle_incr/2):angle_incr:(rot_array(end)+angle_incr/2);

h1 = figure;
h2 = figure;
h3 = figure;
% Plot session 1 vs all others
best_angle = nan(1, num_sessions);
corr_at_best = nan(1,num_sessions);
p = ProgressBar(length(sesh_use));
for k = 2:length(sesh_use)
    figure(h1)
    h = subplot_auto(num_sessions,k);
    [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sesh_use(1), ...
        sesh_use(k), batch_session_map, rot_array, num_shuffles, 'trans', trans); % do rotation analysis
    corr_means = nanmean(corr_mat,1);
    plot(rot_array, corr_means) % plot data
    
    hold on
    plot(rot_array, nanmean(shuffle_mat2),'g-.') % Plot shuffled - need to show CI somehow
    
    % Get and plot global rotation - needs sanity check!!!
    [~, sesh2_rot] = get_rot_from_db(sesh_use(k));
    distal_rot = sesh2_rot - base_rot;
    if distal_rot < 0
        distal_rot = distal_rot + 360;
    elseif distal_rot >= 360
        distal_rot = distal_rot < 360;
    end
    rot_log = rot_array == distal_rot;
    plot( rot_array(rot_log), corr_means(rot_log), 'r^')
   
    xlim([0 360])
    set(h,'XTick',0:90:360);
    hold off
    xlabel('Local Cue Mismatch (deg)')
    ylabel('Mean Spearman Correlation')
    title([mouse_name_title(sesh_use(k).Date) ' - Session ' num2str(sesh_use(k).Session) ...
        ' (' twoenv_get_shape(sesh_use(k).Animal, sesh_use(k).Date, sesh_use(k).Session) ')'])
    legend('Actual', 'Shuffled', 'Distal aligned')
    
    % Get best angle for all neurons together
    [corr_at_best(k), best_ind] = max(corr_means);
    best_angle(k) = rot_array(best_ind);
    
    % Get best angle for each individual cell
    [~, best_ind2] = max(corr_mat(~isnan(nanmean(corr_mat,2)),:),[],2);
    [~, best_ind2_shuf] = max(shuffle_mat2(~isnan(nanmean(shuffle_mat2,2)),:),[],2);
    best_angle_all = rot_array(best_ind2);
    best_angle_all_shuf = rot_array(best_ind2_shuf);
    
    % plot each ecdf vs shuffle
    figure(h2)
    subplot_auto(num_sessions,k);
%     ecdf(corr_mat(:,best_ind)); hold on;
%     ecdf(shuffle_mat2(:,1));
    histogram(corr_mat(:, best_ind), edges, 'Normalization', 'probability'); hold on;
    histogram(shuffle_mat2(:,1), edges, 'Normalization', 'probability');
    title([mouse_name_title(sesh_use(k).Date) ' - Session ' num2str(sesh_use(k).Session) ...
        ' (' twoenv_get_shape(sesh_use(k).Animal, sesh_use(k).Date, sesh_use(k).Session) ')'])
    xlabel('Spearman Correlation')
    ylabel('Probability')
    legend('Best Rotation', 'Shuffled')
    
    figure(h3);
    subplot_auto(num_sessions,k);
    histogram(best_angle_all, edges2); hold on;
    pshuf = histcounts(best_angle_all_shuf, edges2, 'Normalization', 'probability');
    plot(rot_array, pshuf*length(best_angle_all),'k--')
    title([mouse_name_title(sesh_use(k).Date) ' - Session ' num2str(sesh_use(k).Session) ...
        ' (' twoenv_get_shape(sesh_use(k).Animal, sesh_use(k).Date, sesh_use(k).Session) ')'])
    xlim([rot_array(1)-angle_incr 360])
    set(gca,'XTick',0:90:360);
    xlabel('Angle of best correlation (degrees)')
    ylabel('Probability (#neurons/total')
    legend('Actual','Shuffled')
    
    p.progress;
end
p.stop;

% Plot session 1 vs itself for non circ2square analyses
main_title = [mouse_name_title(base_session.Animal) ': ' ...
    mouse_name_title(base_session.Date) ' - Session ' num2str(base_session.Session) ' (' ...'
    twoenv_get_shape(base_session.Animal, base_session.Date, base_session.Session) ') vs: '];
if ~trans
    figure(h1)
    subplot_auto(num_sessions,1);
    [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sesh_use(1), ...
        sesh_use(1), batch_session_map, rot_array, num_shuffles, 'trans', trans);
    
    plot(rot_array, nanmean(corr_mat,1))
    hold on
    plot(rot_array, nanmean(shuffle_mat2),'g-.')
    hold off
    xlabel('Local Cue Mismatch (deg)')
    ylabel('Mean Spearman Correlation')
    title(main_title)
    
elseif trans
    figure(h1)
    subplot_auto(num_sessions,1);
    title(main_title)
    
end
    
figure(h2)
subplot_auto(num_sessions,1);
title(main_title)

figure(h3)
subplot_auto(num_sessions,1);
title(main_title)

end