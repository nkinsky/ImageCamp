function [ coh_bool, remap_bool, silent_bool, valid_bool, map_use] = twoenv_filter_cells2( ...
    base_sesh, sesh1, sesh2, comp_type )
% [ coh_bool, remap_bool, silent_bool, valid_bool, map_use] = twoenv_filter_cells2( ...
%     base_sesh, sesh1, sesh2, comp_type)
%   Wrapper function for twoenv_filter_cells. Breaks out cells into coherent, ...
%   remapping, and silent between sesh1 and sesh2. 
%   comp_type = 'circ2square' or
%   'square', 'circle'. Assumes 4cm bins

base_dir = ChangeDirectory_NK(base_sesh,0);
sesh(1).dir = ChangeDirectory_NK(sesh1,0);
sesh(2).dir = ChangeDirectory_NK(sesh2,0);

if strcmpi(comp_type,'circ2square')
    ind_map = [1 2 1 2 3 4 3 4 5 5 6 6 7 8 7 8];
    type_map = [1 1 2 2 2 2 1 1 1 2 2 1 1 1 2 2]; % 1 = sq, 2 = circ
    load(fullfile(base_dir,'batch_session_map_trans.mat'));
    load(fullfile(base_dir,'full_rotation_analysis_circ2square_TMap_gauss_shuffle1000.mat'),...
        'best_angle','best_angle_all');
    pf_file = 'Placefields_cm4_trans_rot0.mat';
else 
    ind_map = 1:8;
    load(fullfile(base_dir,'batch_session_map.mat'));
    pf_file = 'Placefields_cm4_rot0.mat';
    if strcmpi(comp_type,'circle')
        load(fullfile(base_dir,'full_rotation_analysis_circle_TMap_gauss_shuffle1000.mat'),...
            'best_angle','best_angle_all');
    elseif strcmpi(comp_type,'square')
        load(fullfile(base_dir,'full_rotation_analysis_square_TMap_gauss_shuffle1000.mat'),...
            'best_angle','best_angle_all');
    end
end
batch_session_map = fix_batch_session_map(batch_session_map);

load(fullfile(sesh(1).dir,pf_file),'PSAbool','xBin','yBin');
PSAbool1 = PSAbool(:,(xBin ~= 0 & yBin ~= 0));

load(fullfile(sesh(2).dir,pf_file),'PSAbool','xBin','yBin');
PSAbool2 = PSAbool(:,(xBin ~= 0 & yBin ~= 0));

sesh1_ind = get_session_index(sesh1,batch_session_map.session);
sesh2_ind = get_session_index(sesh2,batch_session_map.session);
if sesh1_ind == sesh2_ind
    best_angle_pop = 0;
    best_angle_dist = zeros(size(PSAbool,1),1);
elseif sesh1_ind ~= sesh2_ind
    best_angle_pop = best_angle(ind_map(sesh1_ind), ind_map(sesh2_ind));
    best_angle_dist = best_angle_all{ind_map(sesh1_ind), ind_map(sesh2_ind)};
    if isnan(best_angle_pop)
        best_angle_pop = best_angle(ind_map(sesh2_ind), ind_map(sesh1_ind));
        best_angle_dist = best_angle_all{ind_map(sesh2_ind), ind_map(sesh1_ind)};
    end
        
end

map_use = get_neuronmap_from_batchmap(batch_session_map, sesh1_ind, sesh2_ind);

% Need to adjust this - only valid for circ2square stuff
[ coh_bool, remap_bool, silent_bool, valid_bool ] = twoenv_filter_cells( ...
    best_angle_pop, best_angle_dist, PSAbool1, PSAbool2, map_use);
end

