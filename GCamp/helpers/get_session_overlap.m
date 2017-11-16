function [ overlap_num, overlap_ratio ] = get_session_overlap(session, batch_session_map)
% [ overlap_num, overlap_ratio ] = get_session_overlap(sessions, batch_session_map)
%   Gets total number of cells overlapping and overlap ratio (cells active
%   in both sessions / (cells active session i + cells active session j  - 
%   cells active both sessions)
%   for all the sessions in 'sessions' variable. If batch_session_map is
%   ommitted, direct registration between sessions is performed.

direct_reg = false;
if nargin < 2
    direct_reg = true;
end

batch_session_map = fix_batch_session_map(batch_session_map);

num_sessions = length(session);

overlap_num = nan(num_sessions);
overlap_ratio = nan(num_sessions);
if ~direct_reg
    for j = 1:num_sessions
        session1_ind = get_session_index(session(j),...
            batch_session_map.session);
        num_neurons(1) = sum(batch_session_map.map(:,session1_ind+1) ~= 0 & ...
            ~isnan(batch_session_map.map(:,session1_ind+1)));
        for k = 1:num_sessions
            session2_ind = get_session_index(session(k),batch_session_map.session);
            map_use = get_neuronmap_from_batchmap(batch_session_map,session1_ind,...
                session2_ind);
            num_neurons(2) = sum(batch_session_map.map(:,session2_ind+1) ~= 0 & ...
                ~isnan(batch_session_map.map(:,session2_ind+1)));
            overlap_num(j,k) = sum(~isnan(map_use) & map_use ~= 0);
            overlap_ratio(j,k) = overlap_num(j,k)/(sum(num_neurons) - ...
                overlap_num(j,k));
            
        end
    end
elseif direct_reg
    for j = 1:num_sessions-1
        load(fullfile(ChangeDirectory_NK(session(j),0),...
            'FinalOutput.mat'),'NumNeurons');
        num_neurons(1) = NumNeurons;
        for k = j+1:num_sessions
            temp = neuron_register(session(j).Animal, session(j).Date, ...
                session(j).Session, session(k).Date, session(k).Session);
            map_use = temp.neuron_id;
            overlap_num(j,k) = sum(cellfun(@(a) ~isempty(a) && ~isnan(a) && ...
                a ~= 0, map_use));
            load(fullfile(ChangeDirectory_NK(session(k),0),...
                'FinalOutput.mat'),'NumNeurons');
            num_neurons(2) = NumNeurons;
            overlap_ratio(j,k) = overlap_num(j,k)/( sum(num_neurons) - ...
                overlap_num(j,k));;
            
        end
    end
end


end

