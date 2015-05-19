function [ seq_use, seq_pos_use ] = get_replays( start_array, lin_pos_active, frame_threshold, dist_threshold, type)
%UNTITLED2 Summary of this function goes here

%   INPUTS
%       start_array = logical with each column being a frame, each row being a
%       cell, and a 1 if the cell starts a transient on that frame and 0 if it
%       doesn't
% 
%       lin_pos_active = linear position of all the active cells in start_array
%
%       frame_threshold = exclude any neurons who are active more than this
%       number of frames after the active cell in a sequence
%   
%       type = 'forward' or 'backward' - types of replays to consider
%
%   OUTPUTS
%       seq_use = a 1 x m cell, where m is the number of sequences
%       and the contents of each array are the indices of the cell numbers
%       in start_array and lin_pos_active that are included in the sequence
%%
maze_length = 144; % Used for thesholding if points are close enough
min_length_replay = 3; % minimum number of cells that must be involved in a replay to count

tt = 1; %debugging counter
% n_frame = 1; % not relevant anymore because assigned within while loop
% below?
m = 1; % Sequence number
n_use = 1; % neuron number you are looking at to start a sequence - will cycle through all
frame_filter = ones(1,size(start_array,2));
n_active = 1; % start with 1st neuron in lin_pos_active
seq_temp = 1; % start first sequence with neuron number 1
seq_temp_pos = lin_pos_active(1); % linear position of cell
neuron_used = zeros(1,size(start_array,1));
neuron_used(1) = 1; % Tracks if a neuron had been used or not, so start out
% with neuron 1 as used
% n_neuron_used = 0;

%% Keyboard statement for debugging
% keyboard

%% Meat of the function 
while n_use < length(lin_pos_active)+1 % n_neuron_used < length(lin_pos_active)
    n_frame = find(start_array(n_active,:) & frame_filter, 1 ); % Find frame in which neuron is active
    active_in_frame = find(start_array(:,n_frame)); % Get all cells that are active in a given frame
    active_after_frame = find(sum(start_array(:,n_frame:end),2) ~= 0 ...
    & [1:length(lin_pos_active)]' ~= n_active); % Get all cells that are active after a given frame, NOT including the active cell
%     active_after_frame = find(sum(start_array(:,n_frame:end),2) ~= 0); % Get all cells that are active after a given frame
    % If more than one cell is active in a frame, cycle through each
    % Get centroid of active cell you are interested in
    pos_active_in_frame = lin_pos_active(1, n_active);
    pos_active_after_frame = lin_pos_active(1, active_after_frame);
    % Get distances to all cells that are active in or after the current
    % frame
    dist_array = pos_active_after_frame - pos_active_in_frame;
    % Update cells distances to range from -maze_length/2 to +
    % maze_length/2
    dist_array(dist_array >= maze_length/2) = ...
        dist_array(dist_array >= maze_length/2) - maze_length;
    dist_array(dist_array <= -maze_length/2) = ...
        dist_array(dist_array <= -maze_length/2) + maze_length;
%     dist_array(dist_array ~= 0 & dist_array >= maze_length/2) = ...
%         dist_array(dist_array ~= 0 & dist_array >= maze_length/2) - maze_length;
%     dist_array(dist_array ~= 0 & dist_array <= -maze_length/2) = ...
%         dist_array(dist_array ~= 0 & dist_array <= -maze_length/2) + maze_length;

%     %%% OLD METHOD %%%
%     %%% Get index of closest cell %%%
%     min_dist = min(abs(dist_array)); % distance to closest cell
%     ind_closest = find(min_dist == abs(dist_array)); % index of closest cell
%     ind_closest_all = active_after_frame(ind_closest);
%     
%     %%% Here's where all the inclusion critera sit %%%
%     % If you aren't on the last frame, the replay is forward, and the
%     % closest neuron has not already been used in a sequence, then add onto
%     % the sequence
%     if n_frame ~= size(start_array,2) && ~isnan(min_dist) && dist_array(ind_closest) > 0 % && neuron_used(ind_closest_all) ~= 1
%         seq_dist_temp = [seq_dist_temp ind_closest_all]; % append closest cell if it is in front of the current cell
%         n_active = ind_closest_all; % Make the closest neuron the next one to use
%     else
%         n_use = n_use + 1; % start next iteration with a new neuron
%         n_active = n_use;  % jump to next unused neuron
%         
%         seq{m} = seq_dist_temp; % save sequence
%         m = m+1; % update sequence number
%         seq_dist_temp = n_active; % restart sequence temporary variable
%     end
    
    %%% NEW METHOD %%%
    % Get indices of all cells active that are in front of current cell
    if strcmpi(type,'forward')
        ind_pos_after = find(dist_array > 0 & abs(dist_array) < dist_threshold)';
    elseif strcmpi(type,'backward')
        ind_pos_after = find(dist_array < 0 & abs(dist_array) < dist_threshold)';
    end
    temp_pos_after = dist_array(ind_pos_after)'; % distance to all active cells in front of active cell
    % Get number of frames to all the cells after the active cell
    temp_frame_after = []; % Reset variable
    for j = 1:length(ind_pos_after)
        temp_frame_after(j,1) = find(start_array(ind_pos_after(j),:),1,'first') - n_frame; 
    end
    within_frame_thresh = temp_frame_after <= frame_threshold & temp_frame_after >= 0;
    min_dist_within_thresh = min(temp_pos_after(within_frame_thresh));
    if ~isempty(min_dist_within_thresh)
        ind_closest = ind_pos_after(min_dist_within_thresh == temp_pos_after);
        ind_closest_all = active_after_frame(ind_closest);
        % Hack to include only one neuron if multiple have the same
        % position
        if length(ind_closest_all) > 1
            ind_closest = ind_closest(1);
            ind_closest_all = ind_closest_all(1);
        end
                
    else
        ind_closest_all = [];
    end
    
    if ~isempty(ind_closest_all)
        seq_temp = [seq_temp ind_closest_all]; % append closest cell if it is in front of the current cell
        seq_temp_pos = [seq_temp_pos lin_pos_active(ind_closest_all)];
        n_active = ind_closest_all; % Make the closest neuron the next one to use
        % Track previous frame to prevent an endless while loop from happening
        % when the same cell is active twice in an epoch
        frame_filter = zeros(1,size(start_array,2));
        frame_filter(n_frame:end) = ones(1,length(n_frame:length(frame_filter)));
    else
        n_use = n_use + 1; % start next iteration with a new neuron
        n_active = n_use;  % jump to next unused neuron
        
        seq{m} = seq_temp; % save sequence
        seq_pos{m} = seq_temp_pos; % Save linear position of all the cells in a sequence
        if n_use < length(lin_pos_active)+1
            seq_temp_pos = lin_pos_active(n_active); % restart sequence position temporary variable
        end
        m = m+1; % update sequence number
        seq_temp = n_active; % restart sequence temporary variable
        frame_filter = ones(1,size(start_array,2));
        
    end
    
    neuron_used(n_active) = 1;
    m;
    tt = tt + 1; % Debugging variables to count iteration numbers
%        keyboard;

end

%% Next - need to eliminate any redundant sequences - that is, smaller sequences
% that occur within a larger sequence

[seq_use, seq_pos_use] = elim_redundant_seq(seq, seq_pos, min_length_replay);

end

