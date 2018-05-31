function [ success_bool ] = Placefields_half_batch(MD, stats_bool, calc_mode, ...
    varargin )
% Placefields_batch(MD, stats_bool, varargin )
%   Run Placefields function on multiple sessions at once with the same
%   parameters. Outputs boolean indicating if run of each session was
%   successful or not. stats_bool = 2 (default) indicates to run
%   placefieldstats and placefields, 1 = run only stats, 0 = run only
%   placefields

name_append = '_half';
varg_bool = true(size(varargin));
for j=1:length(varargin)
    if strcmpi(varargin{j},'name_append')
        name_append = varargin{j+1};
        varg_bool(j:(j+1)) = false;
    end
end
varg_use = varargin(varg_bool);

MD = complete_MD(MD);
success_bool = false(1,length(MD));
for j= 1:length(MD)
    try
        exclude_frames = MD(j).exclude_frames;
        if stats_bool == 2 || stats_bool == 0
            Placefields_half(MD(j), calc_mode, exclude_frames, name_append, ...
                varg_use{:});
        end
        if stats_bool == 2 || stats_bool == 1
            PlacefieldStats(MD(j), 'name_append', [name_append '_' calc_mode], ...
                'halfPF', true);
        end
        success_bool(j) = true;
    catch
        success_bool(j) = false;
    end
end

% Output which failed to run
success_ind = find(~success_bool);
for j = 1:length(success_ind)
    fail_sesh = MD(success_ind(j));
    disp([fail_sesh.Animal ' - ' fail_sesh.Date ' session ' num2str(...
        fail_sesh.Session) ' failed to run'])
    
end

end