function [ filter_cells ] = twoenv_PVcorr_filt(sessions, batch_session_map, ...
    filt_type, DI)
% filter_cells = twoenv_PVcorr_filt(sessions, batch_session_map ,filt_type )
%   Gets cells to filter out for each comparison type. circ2square sessions
%   only.
%   ('coherent_cells','remap_cells','silent_cells')
%
%   e.g. 'coherent_cells' will return a boolean with coherent cells removed
%   and all other cells present

base_dir = ChangeDirectory_NK(batch_session_map.session(1),0);
sesh_ind = arrayfun(@(a) get_session_index(a,batch_session_map.session), ...
    sessions);
load(fullfile(base_dir,'full_rotation_analysis_circ2square_shuffle1000.mat'),...
    'best_angle','best_angle_all');
coherent_bool = get_coherent_neurons(best_angle(sesh_ind(1),sesh_ind(2)),...
    best_angle_all{sesh_ind(1),sesh_ind(2)});
if strcmpi(filt_type,'coherent_cells')
    
elseif strcmpi(filt_type,'remap_cells')
    
elseif strcmpi(filt_type,'silent_cells')
    filter_cells = abs(DI) ~= 1;
end

end