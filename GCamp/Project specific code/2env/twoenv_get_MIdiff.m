function [ MIdiff ] = twoenv_get_MIdiff( square_sesh, circ_sesh, base_session )
% MIdiff = twoenv_get_MIdiff( square_sesh, circ_sesh, base_session )
% Gets difference in mutual information between a given square and circle
% session.

sesh_use = cat(2,square_sesh,circ_sesh);
load(fullfile(ChangeDirectory_NK(base_session,0),...
    'batch_session_map_trans.mat'));
neuron_map = neuron_map_simple(square_sesh, circ_sesh, 'batch_map', ...
    batch_session_map);
good_ind = ~isnan(neuron_map) & neuron_map ~= 0;
good_map = neuron_map(good_ind);

for j = 1:2
   dirstr = ChangeDirectory_NK(sesh_use(j),0);
   load(fullfile(dirstr,'SpatialInfo_cm4_rot0.mat'),'MI');
   sesh_use(j).MI = MI;
end
MIsq = sesh_use(1).MI(good_ind);
MIci = sesh_use(2).MI(good_map);
MIdiff = MIsq - MIci;

end

