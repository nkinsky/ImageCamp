function [ success_bool ] = Placefields_batch(MD, varargin )
% Placefields_batch(MD, varargin )
%   Run Placefields function on multiple sessions at once with the same
%   parameters. Outputs boolean indicating if run of each session was
%   successful or not

success_bool = false(1,length(MD));
for j= 1:length(MD)
    try
        Placefields(MD(j),varargin{:});
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

