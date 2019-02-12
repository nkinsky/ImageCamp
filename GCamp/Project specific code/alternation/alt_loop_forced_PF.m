function [suc_bool] = alt_loop_forced_PF(sesh)
% suc_bool = alt_forced_free_PF(sesh)
%   Runs Placefields on G30 sessions with loop/forced divide.
%   suc_bool tells you which sessions ran properly and which had an error.

num_sesh = length(sesh);
suc_bool = false(1, num_sesh);
for j = 1:num_sesh
    
    dir_use = ChangeDirectory_NK(sesh(j),0);
    exc_frames_file = fullfile(dir_use,'exclude_frames_loop_forced.mat');
    if exist(exc_frames_file,'file')
        load(exc_frames_file, 'exc_frames_loop', 'exc_frames_forced')
        Placefields(sesh(j),'minspeed',1,'cmperbin',1,...
            'exclude_frames',exc_frames_loop,'name_append','_loop_cm1')
        Placefields(sesh(j),'minspeed',1,'cmperbin',1,...
            'exclude_frames',exc_frames_forced,'name_append','_forced_cm1')
        suc_bool(j) = true;
    else
        disp(['No ''exclude_frames_loop_forced.mat'' file for session ' num2str(j) '.'])
        disp('Run alt_get_loop_forced')
    end

end
    
end

