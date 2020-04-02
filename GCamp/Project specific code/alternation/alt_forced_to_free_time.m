function [success_bool] = alt_forced_to_free_time(MD)
% alt_forced_to_free_time(MD)
%   Saves time stamp for when forced trials end and free trials begin for
%   G58.

success_bool = false;
try
    dir_use = MD.Location;
    
    load(fullfile(dir_use,'exclude_frames_forced_free.mat'), ...
        'exc_frames_forced');
    load(fullfile(dir_use, 'Pos_align.mat'), 'time_interp');
    t_start_free = time_interp(min(exc_frames_forced)+1); % free start = frame after last forced frame to exclude.
    
    save(fullfile(dir_use,'t_start_free.mat'), 't_start_free');
    success_bool = true;
catch
    disp(['Error calculating free start time for ' MD.Animal ':' ...
        MD.Date ' session ' num2str(MD.Session)])
    success_bool = false;
end

end

