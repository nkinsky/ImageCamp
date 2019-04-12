function [sesh_cell_matchmin, sesh_cell_matchmax] = match_sesh_num(sesh_cell, free_only)
% sesh_cell_match = match_sesh_num(sesh_cell, free_only)
%   Randomly down/upsamples all the session structures in sesh_cell to match
%   the minimum/maximum number of sessions. each cell index corresponds to
%   a different mouse.

% Only include free sessions by default...
if nargin < 2
    free_only = true;
end

% Pre-allocate session variables
nmice = length(sesh_cell);
sesh_cell_matchmin = cell(1,nmice);
sesh_cell_matchmax = cell(1,nmice);

% Grab only free sessions if specified
if free_only
    [~,~,free_bool] = cellfun(@alt_id_sesh_type, sesh_cell, ...
        'UniformOutput', false);
    sesh_use = cellfun(@(a,b) a(b), sesh_cell, free_bool, ...
        'UniformOutput', false);
elseif ~free_only
    sesh_use = sesh_cell;
end

% Get # sessions for each mouse
nsesh = cellfun(@length, sesh_use); 
nmax = max(nsesh); nmin = min(nsesh);

%% Down/upsample
for j = 1:nmice
    
    % Down-sample each session to match the smallest session
    min_inds = sort(randperm(nsesh(j), nmin));
    sesh_cell_matchmin{j} = sesh_use{j}(min_inds);
    
    % Up-sample each session to match the largest session
    nreps = floor(nmax/nsesh(j)); % Number of times to repeat all sessions
    npartial = mod(nmax,nsesh(j)); % Randomly pick this many sessions to match max size
    max_inds = sort([repmat(1:nsesh(j), 1, nreps), ...
        randperm(nsesh(j), npartial)]);
    sesh_cell_matchmax{j} = sesh_use{j}(max_inds);
   
end

end

