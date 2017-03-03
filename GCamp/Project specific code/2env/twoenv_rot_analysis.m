function [best_angle] = twoenv_rot_analysis(base_session, rot_sessions, rot_type, varargin)
% best_angle = twoenv_rot_analysis(base_session, rot_sessions, rot_type)
%
%   Plots rotation "tuning curves" for all the rot_sessions vs. the
%   base_session.  Also spits out the best angle of rotation when compared
%   to the base_session (i.e. the one that gives the highest correlation)

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

h1 = figure;
h2 = figure;
% Plot session 1 vs all others
best_angle = nan(1, num_sessions);
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
    
    % Get best angle
    [~, best_ind] = max(corr_means);
    best_angle(k) = rot_array(best_ind);
    
    % plot each ecdf vs shuffle
    figure(h2)
    edges = -1:0.05:1;
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
    
    figure(h2)
    subplot_auto(num_sessions,1);
    title(main_title)
    
elseif trans
    figure(h1)
    subplot_auto(num_sessions,1);
    title(main_title)
    
    figure(h2)
    subplot_auto(num_sessions,1);
    title(main_title)
    
end

end

% %% load batch_session_map
% function batch_session_map = load_batch_map(base_session, rot_sessions, batch_name)
% 
% sesh_all = cat(2, base_session, rot_sessions);
% 
% for j = 1:length(sesh_all)
%     dirstr = ChangeDirectory(sesh_all(j).Animal, sesh_all(j).Date, sesh_all(j).Session, 0);
%     try
%         load(fullfile(dirstr,batch_name))
%         disp(['Loading file ' fullfile(dirstr,batch_name)])
%     catch
%         continue
%     end
% end
% end