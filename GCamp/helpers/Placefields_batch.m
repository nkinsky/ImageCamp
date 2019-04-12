function [ success_bool ] = Placefields_batch(MD, stats_bool, varargin )
% success_bool = Placefields_batch(MD, stats_bool, varargin )
%   Run Placefields function on multiple sessions at once with the same
%   parameters. Outputs boolean indicating if run of each session was
%   successful or not. stats_bool = 2 (default) indicates to run
%   placefieldstats and placefields, 1 = run only stats, 0 = run only
%   placefields

if nargin < 2
    stats_bool = 2;
end
name_append = '';
for j=1:length(varargin)
    if strcmpi(varargin{j},'name_append')
        name_append = varargin{j+1};
    end
end

success_bool = false(1,length(MD));
for j = 1:length(MD)
    try
        if stats_bool == 2 || stats_bool == 0
            Placefields(MD(j),varargin{:});
        end
        if stats_bool == 2 || stats_bool == 1
            PlacefieldStats(MD(j),'name_append',name_append);
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

