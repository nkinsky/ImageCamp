function [] = twoenv_rot_analysis(base_session, rot_sessions, rot_type)
% twoenv_rot_analysis(base_session, rot_sessions, rot_type)
%
%   Plots rotation "tuning curves" for all the rot_sessions vs. the
%   base_session

%% Parse inputs
ip = inputParser;
ip.addRequired('base_session', @(a) isstruct(a) && length(a) == 1);
ip.addRequired('rot_sessions', @(a) isstruct(a));
ip.addRequired('rot_type', @(a) ischar(a) && (strcmpi(a,'square') || ...
    strcmpi(a,'circle') || strcmpi(a,'circ2square')));
ip.parse(base_session, rot_sessions, rot_type);

base_dir = ChangeDirectory(base_session.Animal, base_session.Date, ...
    base_session.Session, 0);

%% Set up variables
switch rot_type
    case 'square'
        rot_array = 0:90:270;
        batch_map_file = fullfile(base_dir,'batch_session_map.mat');
        trans = false;
    case 'circle'
        rot_array = 0:15:345;
        batch_map_file = fullfile(base_dir,'batch_session_map.mat');
        trans = false;
    case 'circ2square'
        rot_array = 0:15:345;
%         rot_array_circle = 0:15:345;
%         rot_array_square = 0:90:270;
        batch_map_file = fullfile(base_dir,'batch_session_map_trans.mat');
        trans = true;
    otherwise
        error('something wrong')
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

figure
% Plot session 1 vs all others
for k = 2:length(sesh_use)
    subplot_auto(num_sessions,k);
%     if ~trans
        [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sesh_use(1), ...
            sesh_use(k), batch_session_map, rot_array, 10, 'trans', trans);
%     elseif trans
%         [~, temp] = ChangeDirectory(sesh_use(k).Animal, sesh_use(k).Date,...
%             sesh_use(k).Session,0);
%        if ~isempty(regexpi(temp.Env,'square')) 
%            rot_array = rot_array_square;
%        elseif ~isempty(regexpi(temp.Env,'octagon')) 
%            rot_array = rot_array_circle;
%        end
%        [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sesh_use(1), ...
%             sesh_use(k), batch_session_map, rot_array, 10, 'trans', true);
%     end
%     
    plot(rot_array, nanmean(corr_mat,1))
    
    hold on
    plot(rot_array, nanmean(shuffle_mat2),'g-.')
    xlim([0 360])
    hold off
    xlabel('Rotation from Standard (deg)')
    ylabel('Mean Spearman Correlation')
    title(['Session ' num2str(session_index(1)) ' vs ' num2str(session_index(k))])
end

% Plot session 1 vs itself for non circ2square analyses
if ~trans
    subplot_auto(num_sessions,1);
    [corr_mat, ~, shuffle_mat2] = corr_rot_analysis(sesh_use(1), ...
        sesh_use(1), batch_session_map, rot_array, 10, 'trans', trans);
    
    plot(rot_array, nanmean(corr_mat,1))
    hold on
    plot(rot_array, nanmean(shuffle_mat2),'g-.')
    hold off
    xlabel('Rotation from Standard (deg)')
    ylabel('Mean Spearman Correlation')
    title([mouse_name_title(base_session.Animal) ' ' rot_type ' analysis: Session ' ...
        num2str(session_index(1)) ' vs ' num2str(session_index(1))])
elseif trans
    subplot_auto(num_sessions,1);
    title([mouse_name_title(base_session.Animal) ' ' rot_type ' analysis'])
end

end

%% load batch_session_map
function batch_session_map = load_batch_map(base_session, rot_sessions, batch_name)

sesh_all = cat(2 ,base_session, rot_sessions);

for j = 1:length(sesh_all)
    dirstr = ChangeDirectory(sesh_all(j).Animal, sesh_all(j).Date, sesh_all(j).Session, 0);
    try
        load(fullfile(dirstr,batch_name))
        disp(['Loading file ' fullfile(dirstr,batch_name)])
    catch
        continue
    end
end

end