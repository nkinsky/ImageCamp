function [] = imagereg_byactive( batch_session_map, sessions_to_map, varargin)
% imagereg_byactive( batch_session_map)
%   Performs image registration on all the session in batch_session_map by
%   their AllActiveMask

%% Fix bad batch session map 
batch_session_map = fix_batch_session_map(batch_session_map);

%% Only run certain sessions if specified
if nargin >= 2
    batch_session_map.session = batch_session_map.session(sessions_to_map);
end

%% Run it
basedir = ChangeDirectory_NK(batch_session_map.session(1),0);
base_mask = importdata(fullfile(basedir,'AllActiveMask.mat'));
for j = 2:length(batch_session_map.session)
    dirstr = ChangeDirectory_NK(batch_session_map.session(j),0);
    reg_mask = importdata(fullfile(dirstr,'AllActiveMask.mat'));
    
    disp(['Running Registration for session ' num2str(j) ' to base session'])
    image_registerX(batch_session_map.session(1).Animal, batch_session_map.session(1).Date,...
        batch_session_map.session(1).Session, batch_session_map.session(j).Date, ...
        batch_session_map.session(j).Session,0,'use_allmask', base_mask, reg_mask, varargin{:});
end


end

