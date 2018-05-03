% Two-env covariance matrix vetting

MPV1 = importdata('2env_PVsilent_cm4_local0-1000shuffles-2018-01-06.mat');
%% Create a plot of cov mats for a pair of coherent sessions and a pair of
% global remapping sessions
try close(257); catch; end
try close(258); catch; end
silent_thresh_ind = 1; % 1 = no silent cells, 2 = unambiguous silent cells, 3 
Animal = 1;
coh_sesh_type = 'circ2square';
coh_sesh1 = 4;
coh_sesh2 = 4;
remap_sesh_typ = 'circ2square';
remap_sesh1 = 4;
remap_sesh2 = 5;
clust_size = 20; % Approximate # of neurons per cluster

PVcoh = MPV1(Animal).PVcorrs.(coh_sesh_type)(silent_thresh_ind)...
    .PV{coh_sesh1,coh_sesh2};% population vectors for two sessions
[PVcoh1, PVcoh2] = compare_PVcov(PVcoh); %calculate covariance matrices for each session

PVremap = MPV1(Animal).PVcorrs.(coh_sesh_type)(silent_thresh_ind)...
    .PV{remap_sesh1,remap_sesh2};
[PVremap1, PVremap2] = compare_PVcov(PVremap);

figure(257)
subplot(2,3,1)
imagesc_nan(PVcoh1);
title('COV - Coherent session 1')
colorbar
subplot(2,3,2)
imagesc_nan(PVcoh2);
title('COV - Coherent session 2')
colorbar
subplot(2,3,3)
imagesc_nan(abs(PVcoh1 - PVcoh2));
colorbar
title('\Delta_{COV} : Coherent')
subplot(2,3,4)
imagesc_nan(PVremap1);
colorbar
title('COV - Global Remap session 1')
subplot(2,3,5)
imagesc_nan(PVremap2);
colorbar
title('COV - Global Remap session 2')
subplot(2,3,6)
imagesc_nan(abs(PVremap1 - PVremap2));
colorbar
title('\Delta_{COV} : Global Remap')

% Try sorting for blockiness
k_coh = round(size(PVcoh1,1)/clust_size); % Try to find clusters of around 10 neurons min
idx_coh = kmeans(PVcoh1,k_coh); % Get clusters
[~, ind_sort_coh] = sort(idx_coh); % Now get vector for rearranging indices
k_remap = round(size(PVremap1,1)/clust_size);
idx_remap = kmeans(PVremap1,k_remap); % Get clusters
[~, ind_sort_remap] = sort(idx_remap); % Now get vector for rearranging indices
figure(258)
subplot(2,3,1)
imagesc_nan(PVcoh1(ind_sort_coh,ind_sort_coh));
title('COV - Coherent session 1 - Clustered')
colorbar
subplot(2,3,2)
imagesc_nan(PVcoh2(ind_sort_coh,ind_sort_coh));
title('COV - Coherent session 2 - Clustered')
colorbar
subplot(2,3,3)
imagesc_nan(abs(PVcoh1(ind_sort_coh,ind_sort_coh)) - ...
    PVcoh2(ind_sort_coh,ind_sort_coh));
colorbar
title('\Delta_{COV} : Coherent')
subplot(2,3,4)
imagesc_nan(PVremap1(ind_sort_remap,ind_sort_remap));
colorbar
title('COV - Global Remap session 1 - Clustered')
subplot(2,3,5)
imagesc_nan(PVremap2(ind_sort_remap,ind_sort_remap));
colorbar
title('COV - Global Remap session 2 - Clustered')
subplot(2,3,6)
imagesc_nan(abs(PVremap1(ind_sort_remap,ind_sort_remap) - ...
    PVremap2(ind_sort_remap,ind_sort_remap)));
colorbar
title('\Delta_{COV} : Global Remap')

