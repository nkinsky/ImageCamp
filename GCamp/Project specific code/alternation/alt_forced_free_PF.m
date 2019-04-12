function [suc_bool] = alt_forced_free_PF(sesh)
% suc_bool = alt_forced_free_PF(sesh)
%   Runs Placefields on sessions with forced/free divide and save
%   appropriately. For alternation sessions only, mainly G48 but also a
%   couple G30 sessions and might be able to hack this a bit to do the same
%   for G30 looping sessions. suc_bool tells you which sessions ran
%   properly and which had an error.

num_sesh = length(sesh);
suc_bool = false(1, num_sesh);
for j = 1:num_sesh
    
    dir_use = ChangeDirectory_NK(sesh(j),0);
    exc_frames_file = fullfile(dir_use,'exclude_frames_forced_free.mat');
    if exist(exc_frames_file,'file')
        load(exc_frames_file, 'exc_frames_free', 'exc_frames_forced')
        Placefields(sesh(j),'minspeed',1,'cmperbin',1,...
            'exclude_frames',exc_frames_free,'name_append','_free_cm1')
        Placefields(sesh(j),'minspeed',1,'cmperbin',1,...
            'exclude_frames',exc_frames_forced,'name_append','_forced_cm1')
        suc_bool(j) = true;
    else
        disp(['No ''exclude_frames_forced_free.mat'' file for session ' num2str(j) '.'])
        disp('Run alt_get_forced_free')
    end

end
    
end

