function [corr_mat, shuffle_mat] = twoenv_best_rot_analysis(sesh_use, best_angle, circ2square_flag, num_shuffles)
% [corr_mat, shuffle_mat] = twoenv_batch_rot_analysis(sesh_use, best_angle, circ2square)
%
% Get correlations between all TMaps at the best angle of rotation between
% every session in sesh_use.  circ2square_flag = true if you want to
% compare square to transformed circle sessions


if nargin < 3
    circ2square_flag = false;
    num_shuffles = 10;
elseif nargin < 4
    num_shuffles = 10;
end
base_dir = ChangeDirectory(sesh_use(1).Animal, sesh_use(1).Date, sesh_use(1).Session, 0);

if ~circ2square_flag
    load(fullfile(base_dir,'batch_session_map'));
elseif circ2square_flag
    load(fullfile(base_dir,'batch_session_map_trans'));
end

num_sessions = length(sesh_use);
corr_mat = cell(num_sessions, num_sessions);
shuffle_mat = cell(num_sessions, num_sessions);
if circ2square_flag
    p = ProgressBar(num_sessions^2/2);
else
    p = ProgressBar((num_sessions)*(num_sessions-1)/2);
end
% Don't redo comparions for square-square or circle-circle, but compare all
% square to all circle sessions
% if circ2square_flag; end_ind = num_sessions; else; end_ind = num_sessions-1; end 
for j = 1:num_sessions-1 %1:end_ind
    [~, struct1] = ChangeDirectory_NK(sesh_use(j));
%     if circ2square_flag; start_ind = 1; else; start_ind = j+1; end
    for k = j+1:num_sessions %start_ind:num_sessions
        [~, struct2] = ChangeDirectory_NK(sesh_use(k));
        
        % Only perform comparison between two different structures if
        % circ2square analysis is indicated.
        if circ2square_flag && (~isempty(regexpi(struct1.Env,'square')) && ~isempty(regexpi(struct2.Env,'square')) || ...
                ~isempty(regexpi(struct1.Env,'octagon')) && ~isempty(regexpi(struct2.Env,'octagon')))
            continue  % Skip to next session if between two same shape sessions
            
        end
        
        % Get angle between the two sessions and
        rot_use = best_angle(k) - best_angle(j);
        if rot_use < 0; rot_use = rot_use + 360; end
        
        [corr_mat{j,k}, ~, shuffle_mat{j,k}] = corr_rot_analysis( sesh_use(j), sesh_use(k), ...
            batch_session_map, rot_use, 'num_shuffles', num_shuffles, ...
            'trans', circ2square_flag );
        
        p.progress;
       
   end
end
p.stop;