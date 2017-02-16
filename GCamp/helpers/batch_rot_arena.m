function [ rot_final ] = batch_rot_arena( base_struct, reg_struct, rot_array, varargin )
% rot_final = batch_rot_arena( base_struct, reg_struct, rot_array, manual_limits, varargin )
% Applies batch_align_pos to each session but rotates the data all of the
% degrees in rot_array

p = inputParser;
p.addRequired('base_struct', @(a) isstruct(a) && length(a) == 1);
p.addRequired('reg_struct', @(a) isstruct(a));
p.addRequired('rot_array', @isnumeric)
p.addOptional('manual_limits', false(size(rot_array)), @islogical);
p.addParameter('circ2square', false, @(a) islogical(a) && length(a) == 1); 
p.parse(base_struct, reg_struct, rot_array, varargin{:});

manual_limits = p.Results.manual_limits;
circ2square = p.Results.circ2square;

rot_array = flip_array(rot_array);
manual_limits = flip_array(manual_limits);

num_rots = length(rot_array);
full_struct = cat(2, base_struct, reg_struct);
%% Step 1 - get rotations for all sessions
num_sessions = length(full_struct);
if ~circ2square % Rotates every session as indicated in rot_array
    
    rot_start = [];
    for j = 1:num_sessions
        rot_to_std = get_rot_from_db(full_struct(j));
        rot_start = [rot_start, repmat(rot_to_std, 1, num_rots)];
        
    end
    
    % Replicate things for inputs to step 2
    rot_final = rot_start + repmat(rot_array, 1, num_sessions);
    rot_final(rot_final < 0) = rot_final(rot_final < 0) + 360;
    rot_final(rot_final >= 360) = rot_final(rot_final >= 360) - 360;
    rot_text = repmat(arrayfun(@(a) ['_rot' num2str(a)], round(rot_array),'UniformOutput',false),1,num_sessions);
    % rot_text = arrayfun(@(a) ['_rot' num2str(a)], round(rot_final),'UniformOutput', false);
    
    final_struct = repmat(base_struct, 1, num_rots);
    limits_full = repmat(manual_limits(1),1, num_rots);
    for j = 1: length(reg_struct)
        final_struct = cat(2,final_struct, repmat(reg_struct(j),1,num_rots));
        limits_full = [limits_full, repmat(manual_limits(j+1), 1, num_rots)];
    end
elseif circ2square % Set up arrays so that you rotate just the circle, NOT the square sessions
    rot_start = [];
    rot_add = [];
    
    for j = 1:num_sessions
        [~, full_sesh] = ChangeDirectory(full_struct(j).Animal, full_struct(j).Date, full_struct(j).Session, 0);
        is_circ = ~isempty(regexpi(full_sesh.Env,'octagon'));
        rot_to_std = get_rot_from_db(full_struct(j));
        if is_circ % perform all rotations if circle
            rot_start = [rot_start, repmat(rot_to_std, 1, num_rots)];
            rot_add = [rot_add, rot_array];
        elseif ~is_circ % don't perform any rotations if square
            rot_start = [rot_start, rot_to_std];
            rot_add = [rot_add, 0];
        end
        
    end
    
    rot_final = rot_start + rot_add;
    rot_final(rot_final < 0) = rot_final(rot_final < 0) + 360;
    rot_final(rot_final >= 360) = rot_final(rot_final >= 360) - 360;
    rot_text = arrayfun(@(a) ['_trans_rot' num2str(a)], round(rot_add),'UniformOutput',false);
    
    [~, full_sesh] = ChangeDirectory(full_struct(1).Animal, full_struct(1).Date, full_struct(1).Session, 0);
    if ~isempty(regexpi(full_sesh.Env,'square'))
        final_struct = base_struct;
        limits_full = manual_limits(1);
    elseif ~isempty(regexpi(full_sesh.Env,'octagon'))
        final_struct = repmat(base_struct, 1, num_rots);
        limits_full = repmat(manual_limits(1),1, num_rots);
    end
    
    for j = 1: length(reg_struct)
         [~, full_sesh] = ChangeDirectory(reg_struct(j).Animal, reg_struct(j).Date, reg_struct(j).Session, 0);
        is_circ = ~isempty(regexpi(full_sesh.Env,'octagon'));
        if is_circ
        final_struct = cat(2,final_struct, repmat(reg_struct(j),1,num_rots));
        limits_full = [limits_full, repmat(manual_limits(j+1), 1, num_rots)];
        elseif ~is_circ
            final_struct = cat(2,final_struct,reg_struct(j));
            limits_full = [limits_full, manual_limits(j+1)];
        end
    end
    
end

%% Step 2 - do batch align

batch_align_pos(final_struct(1), final_struct(2:end), 'skip_skew_fix', true, ...
    'rotate_data', rot_final, 'manual_limits', limits_full, ...
    'name_append', rot_text, 'suppress_output', true, 'skip_trace_align', true,...
    'circ2square_use', circ2square);


end

%% Yes I know there is some fancy MATLAB code to do this
function [array_out] = flip_array(array_in)

if size(array_in,1) >= 2 && size(array_in,2) >= 2
    error('array_in must be 1 x n')
elseif size(array_in,1) == 1 && size(array_in,2) >= 1
    array_out = array_in;
elseif size(array_in,1) >= 1 && size(array_in,2) == 1
    array_out = array_in';
end

end

