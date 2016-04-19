function DNMP_parse_trials(xls_path, xls_sheet_num, pos_file_fullpath)
% DNMP_parse_trials(xls_path, pos_file_fullpath)
%   Saves exclude_frames_raw for running CalculatePlaceFields for different
%   trial type breakdowns.

[frames, txt] = xlsread(xls_path, xls_sheet_num);

num_blocks = size(frames,1);

load(pos_file_fullpath,'time_interp','AVItime_interp')
% pos_data = importdata(DVT_fullpath);

num_brain_frames = length(AVItime_interp);
%% Parse inputs
blocks = frames(:,1);
forced_start = frames(:,2);
free_start = frames(:,3);
leave_maze = frames(:,4);
cage_start = frames(:,5);
cage_leave = frames(2:end,6);

right_trials_forced = strcmpi(txt(2:end,7),'R');
right_trials_free = strcmpi(txt(2:end,8),'R');
left_trials_forced = strcmpi(txt(2:end,7),'L');
left_trials_free = strcmpi(txt(2:end,8),'L');
correct_trials = (strcmpi(txt(2:end,7),'R') & strcmpi(txt(2:end,8),'L')) | ...
    (strcmpi(txt(2:end,7),'L') & strcmpi(txt(2:end,8),'R'));

% Interp AVIframes to brainframes

forced_start = AVI_to_brain_frame(forced_start, AVItime_interp);
free_start = AVI_to_brain_frame(free_start, AVItime_interp);
leave_maze = AVI_to_brain_frame(leave_maze, AVItime_interp);

keyboard
%% Get all frames to include for each trial type (free, forced, L, R, correct)
inc_free = [];
inc_free_l = [];
inc_free_r = [];
inc_forced = [];
inc_forced_l = [];
inc_forced_r = [];
on_maze = [];
inc_correct = [];

for j = 1:num_blocks
    
    inc_forced = [inc_forced, forced_start(j):free_start(j)];
    inc_free = [inc_free, free_start(j):leave_maze(j)];
    on_maze = [on_maze, forced_start(j):leave_maze(j)];
    
    if left_trials_forced(j) == 1
        inc_forced_l = [inc_forced_l, forced_start(j):free_start(j)];
    elseif right_trials_forced(j) == 1
        inc_forced_r = [inc_forced_r, forced_start(j):free_start(j)];
    end
        
    if left_trials_free(j) == 1
        inc_free_l = [inc_free_l, free_start(j):leave_maze(j)];
    elseif right_trials_free(j) == 1
        inc_free_r = [inc_free_r, free_start(j):leave_maze(j)];
    end
    
    if correct_trials(j) == 1
        inc_correct = [inc_correct, forced_start(j):leave_maze(j)];
    elseif correct_trials(j) == 0
        inc_correct = [inc_correct, forced_start(j):free_start(j)];
    end
    
end

%% Convert to logicals
forced_log = false(1,num_brain_frames); forced_log(inc_forced) = true;
forced_l_log = false(1,num_brain_frames); forced_l_log(inc_forced_l) = true;
forced_r_log = false(1,num_brain_frames); forced_r_log(inc_forced_r) = true;
free_log = false(1,num_brain_frames); free_log(inc_free) = true;
free_l_log = false(1,num_brain_frames); free_l_log(inc_free_l) = true;
free_r_log = false(1,num_brain_frames); free_r_log(inc_free_r) = true;
correct_log = false(1,num_brain_frames); correct_log(inc_correct) = true;
on_log = false(1,num_brain_frames); on_log(on_maze) = true;

forced_exclude = find(~forced_log);
forced_l_exclude = find(~forced_l_log);
forced_r_exclude = find(~forced_r_log);
free_exclude = find(~free_log);
free_l_exclude = find(~free_l_log);
free_r_exclude = find(~free_r_log);
correct_exclude = find(~correct_log);
on_maze_exclude = find(~on_log);

%% Save
save exclude_frames forced_exclude forced_l_exclude forced_r_exclude ...
    free_exclude free_l_exclude free_r_exclude correct_exclude on_maze_exclude
end

