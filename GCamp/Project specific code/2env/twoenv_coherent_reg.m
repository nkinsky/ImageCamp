function [ reg_stats_coh, reg_stats_remap ] = twoenv_coherent_reg(...
    base_sesh, sesh1, sesh2, sesh_type)
% [ reg_stats_coh, reg_stats_remap ] = twoenv_coherent_reg(...
%     base_sesh, sesh1, sesh2, sesh_type)
%
%   Get registration stats for coherent vs remapping cells, sesh1 must come
%   before sesh2 chronolgocially if sesh_type = 'square' or 'circle', and
%   sesh1 must be square and sesh2 circle if sesh_type = 'circ2square';
base_dir = ChangeDirectory_NK(base_sesh,0);

load(fullfile(base_dir,...
    ['full_rotation_analysis_' sesh_type '_TMap_gauss_shuffle1000.mat']))
if strcmpi(sesh_type,'circ2square')
    load(fullfile(base_dir,'batch_session_map_trans.mat'));
    sesh_ind_full = [1 2 1 2 3 4 3 4 5 5 6 6 7 8 7 8];
else
    load(fullfile(base_dir,'batch_session_map.mat'));
    
end
batch_session_map = fix_batch_session_map(batch_session_map);
sesh1_ind = get_session_index(sesh1, batch_session_map.session);
sesh2_ind = get_session_index(sesh2, batch_session_map.session);
if strcmpi(sesh_type,'circ2square')
    sesh1_ind = sesh_ind_full(sesh1_ind);
    sesh2_ind = sesh_ind_full(sesh2_ind);
end
good_map = neuron_map_simple(sesh1, sesh2, 'suppress_output', true);
coherent_bool = get_coherent_neurons(best_angle(sesh1_ind,sesh2_ind),...
    best_angle_all{sesh1_ind,sesh2_ind}, 30);
coh_bool2 = coherent_bool(good_map ~= 0 & ~isnan(good_map));

reg_stats = neuron_reg_qc(sesh1,sesh2);
reg_stats_coh.orient_diff = reg_stats.orient_diff(coh_bool2);
reg_stats_coh.avg_corr = reg_stats.avg_corr(coh_bool2);
reg_stats_remap.orient_diff = reg_stats.orient_diff(~coh_bool2);
reg_stats_remap.avg_corr = reg_stats.avg_corr(~coh_bool2);

end

