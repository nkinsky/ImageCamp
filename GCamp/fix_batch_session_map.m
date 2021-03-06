function [ batch_session_map_new] = fix_batch_session_map( batch_session_map_old )
% batch_session_map_new = fix_batch_session_map( batch_session_map_old )
%
%   Fixes session information in older versions of batch_session_map (i.e.
%   using .mouse, .date, and .sesssion) and updates it the proper names
%   (i.e. .Animal, .Date, .Session).  Does nothing to the field if it
%   already exists.

for j = 1:length(batch_session_map_old.session)
    if ~isfield(batch_session_map_old.session,'Animal') || ...
            isempty(batch_session_map_old.session(j).Animal) && ...
            isfield(batch_session_map_old.session,'mouse') && ...
            ~isempty(batch_session_map_old.session(j).mouse)
        session_new(j).Animal = batch_session_map_old.session(j).mouse;
    elseif isfield(batch_session_map_old.session,'Animal')
        session_new(j).Animal = batch_session_map_old.session(j).Animal;
    else
        disp('.mouse field doesn''t exist in batch_session_map.session or something else is wrong')
    end
    if ~isfield(batch_session_map_old.session,'Date') || ...
            isempty(batch_session_map_old.session(j).Date) && ...
            isfield(batch_session_map_old.session,'date') && ...
            ~isempty(batch_session_map_old.session(j).date)
        session_new(j).Date = batch_session_map_old.session(j).date;
    elseif isfield(batch_session_map_old.session,'Date')
        session_new(j).Date = batch_session_map_old.session(j).Date;
    else
        disp('.date field doesn''t exist in batch_session_map.session or something else is wrong')
    end
    if ~isfield(batch_session_map_old.session,'Session') ||...
            isempty(batch_session_map_old.session(j).Session) && ...
            isfield(batch_session_map_old.session,'session') && ...
            ~isempty(batch_session_map_old.session(j).session)
        session_new(j).Session = batch_session_map_old.session(j).session;
    elseif isfield(batch_session_map_old.session,'Session')
        session_new(j).Session = batch_session_map_old.session(j).Session;
    else
        disp('.session field doesn''t exist in batch_session_map.session or something else is wrong')
    end
end

batch_session_map_new = batch_session_map_old; % copy old batch_session_map
batch_session_map_new.session = session_new; % Add in updated session info

end

