function [ filt_bool ] = twoenv_pairwise_filt(base_sesh, sesh1, sesh2,...
    comp_type, filt_type, half_use)
% filt_bool = twoenv_pairwise_filt(base_sesh, sesh1, sesh2,...
%     comp_type, filt_type, half_use)
%   Filters cells in pairwise fashion, with pval < 0.05 and ntrans >= 5,
%   according to type (pval only, silent cells included, random remapping
%   cells, etc.)

pval_thresh = 0.05;
ntrans_thresh = 5;

half_flag = false;
if exist('half_use','var')
    half_flag = true;
end

%% Load in data and get pval and ntrans for each session
sesh = sesh1; sesh(2) = sesh2;
sesh = complete_MD(sesh);
for j = 1:2
    dirstr = ChangeDirectory_NK(sesh(j),0);
    if ~half_flag
        load(fullfile(dirstr,['Placefields_rot0.mat']),...
            'pval','PSAbool');
    elseif half_flag
        load(fullfile(dirstr,['Placefields_half_trans.mat']))
        pval = Placefields_halves{half_use(j)}.pval;
        PSAbool = Placefields_halves{half_use(j)}.PSAbool;
    end
    
    sesh(j).pval_filt = pval < pval_thresh;
    sesh(j).ntrans_filt = get_num_trans(PSAbool)' >= ntrans_thresh;
end

%% Get map between sessions
if strcmpi(comp_type,'circ2square')
    map_name = 'batch_session_map.mat';
elseif strcmpi(comp_type,'square') || strcmpi(comp_type,'circle')
    map_name = 'batch_session_map.mat';
end
load(fullfile(ChangeDirectory_NK(base_sesh,0),map_name));

%% Filter cells to get valid, silent, and coherent

[ coh_bool, remap_bool, silent_bool, valid_bool, map_use] = ...
    twoenv_filter_cells2( batch_session_map.session(1), sesh(1), ...
    sesh(2), comp_type );

ppass1 = sesh(1).pval_filt & sesh(1).ntrans_filt;
ppass2 = assignPV(sesh(2).pval_filt & sesh(2).ntrans_filt, map_use)';
ppass2(isnan(ppass2)) = false;
ppass_either = (ppass1 | ppass2) & valid_bool'; % Include cells that pass inclusion criteria in EITHER session and that are active in both

%% Perform filtering
switch filt_type
    case 'pval'
        filt_bool = ppass_either';
    case 'remap_only'
        filt_bool = ppass_either' & remap_bool;
    case 'silent_only'
        filt_bool = ppass_either' & silent_bool;
    case 'coherent_only'
        filt_bool = ppass_either' & coh_bool;
    case 'no_coherent'
        filt_bool = ppass_either' & ~coh_bool;
    case 'no_remap'
        filt_bool = ppass_either' & ~remap_bool;
    case 'no_silent'
        filt_bool = ppass_either' & ~silent_bool;
    otherwise
        error('incorrect ''filt_type'' entered')
end

end

