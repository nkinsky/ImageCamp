function [corr_mat, shuffle_mat] = twoenv_batch_rot_analysis(sesh_use, best_angle, circ2square_flag)
% [corr_mat, shuffle_mat] = twoenv_batch_rot_analysis(sesh_use, best_angle, circ2square)
%
% Get corrleations between all TMaps at the best angle of rotation between
% every session in sesh_use.  circ2square_flag = true if you want to
% compare square to transformed circle sessions


if nargin < 3
    circ2square_flag = false;
end
base_dir = ChangeDirectory(sesh_use(1).Animal, sesh_use(1).Date, sesh_use(1).Session, 0);
num_shuffles = 10;

if ~circ2square_flag
    load(fullfile(base_dir,'batch_session_map'));
elseif circ2square_flag
    load(fullfile(base_dir,'batch_session_map_trans'));
end

num_sessions = length(sesh_use);
corr_mat = cell(num_sessions, num_sessions);
shuffle_mat = cell(num_sessions, num_sessions);
for j = 1:num_sessions-1
    [~, struct1] = ChangeDirectory_NK(sesh_use(j));
   for k = j+1:num_sessions
       [~, struct2] = ChangeDirectory_NK(sesh_use(k));
       
       % Only perform comparison between two different structures
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
       
       % Don't perform comparison if square-to-square or circ-to-circ
       
       
   end
end
