function [ PV, PV_corrs ] = twoenv_connPVcorrs( circ2square_sesh, best_angle, ...
    comp_type, filter_type, custom_filter )
% [ PV, PV_corrs ] = twoenv_connPVcorrs( circ2square_sesh, best_angle, ...
%   comp_type, filter_type, custom_filter )
%  Get PV and PV correlations for all sessions on the connected day(s) in
%  circ2square_sesh.
%  best_angle comes from twoenv_reference (e.g. G30_both_best_angle)
%  comp_type = 'day5', 'day6', 'both' and filter_type = anything in
%  get_PV_and_corr
%  custom_filter = 'no_coherent_cells','no_remap_cells', or 'no_silent_cells'
%% Load up variables
conn_sesh = circ2square_sesh(9:12);
base_dir = ChangeDirectory_NK(Mouse.sesh.circ2square(1),0);
load(fullfile(base_dir,'batch_session_map'))

% Get frames to exclude
[~, full_sesh_cell] = arrayfun(@(a) ChangeDirectory_NK(a,0), ...
    conn_sesh,'UniformOutput',false);
[exclude_frames_cell, FToffset_array, end_array] = ...
    align_exclude_frames(conn_sesh);

%% Re-organize - day 5 1st 4 cols, day 6 2nd 4 cols
exclude_frames_cell = exclude_frames_cell([1 2 1 2 3 4 3 4]);
conn_sesh = Mouse.sesh.circ2square([9 10 9 10 11 12 11 12]);
best_angle_use = best_angle([9 10 9 10 11 12 11 12]);
if strcmpi(comp_type,'day5')
    exclude_frames_cell = exclude_frames_cell(1:4);
    conn_sesh = conn_sesh(1:4);
    best_angle_use = best_angle_use(1:4);
elseif strcmpi(comp_type,'day6')
    exclude_frames_cell = exclude_frames_cell(5:8);
    conn_sesh = conn_sesh(5:8);
    best_angle_use = best_angle_use(5:8);
end

%% Adjust exclude_frames_cell
half_array = cellfun(@(a) a.half, full_sesh_cell) - ...
    FToffset_array'; % Get halfpoint of each to start
for ll = 1:2
    % Construct exclude array to include exclude frames AND
    % halfpoint
    if ll == 1 % 1st half
        temp = arrayfun(@(a,b) (a+1):b, half_array, end_array',...
            'UniformOutput',false);
        half_exclude_cell([1 2 5 6]) = temp(1:4);
    elseif ll == 2 % 2nd half
        temp = arrayfun(@(a) 1:a, half_array,...
            'UniformOutput',false);
        half_exclude_cell([3 4 7 8]) = temp(1:4);
    end
    
end
exclude_frames_comb = cellfun(@(a,b) unique([a,b]),half_exclude_cell, ...
    exclude_frames_cell,'UniformOutput',false); % Combine them!

%% Calculate custom filters

%% Run Analysis
[PV, PV_corrs] = get_PV_and_corr( conn_sesh, ...
    batch_session_map, 'alt_pos_file', arrayfun(@(a) ['Pos_align_rot' num2str(a) '.mat'], ...
    best_angle_use, 'UniformOutput', false),...
    'output_flag',false, 'num_shuffles', num_shuffles,...
    'exclude_frames', exclude_frames_comb, 'filter_type', filter_type,'custom_filter',...
    custom_filter);


end

