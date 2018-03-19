% Topo plots - are coherent cells and/or high vs. low DI cells concentrated
% together?

%% Are coherent cells clustered? Plot topo of coh vs remapping
Animal_use = 3;
sesh1_ind = 6; % 1ST SESSION OR SQUARE SESSION
sesh2_ind = 6; % 2ND SESSION OR CIRCLE SESSION
sesh_type_use = 'circ2square';
base_dir = ChangeDirectory_NK(Mouse(Animal_use).sesh.(sesh_type_use)(1),0);
sq_ind = [1 2 7 8 9 12 13 14];
cir_ind = [ 3 4 5 6 10 11 15 16];
if strcmpi(sesh_type_use,'circ2square')
    load(fullfile(base_dir,'batch_session_map_trans.mat'));
    sesh1_ind2 = sq_ind(sesh1_ind);
    sesh2_ind2 = cir_ind(sesh2_ind);
else
    load(fullfile(base_dir,'batch_session_map.mat'));
    sesh1_ind2 = sesh1_ind;
    sesh2_ind2 = sesh2_ind;
end
load(fullfile(base_dir,['full_rotation_analysis_' sesh_type_use ...
    '_TMap_gauss_shuffle1000.mat']),'best_angle_all','best_angle');
twoenv_coherent_topo(best_angle_all{sesh1_ind,sesh2_ind} - best_angle(sesh1_ind,...
    sesh2_ind), batch_session_map, sesh1_ind2, sesh2_ind2, 'angle', false);
title([mouse_name_title(Mouse(Animal_use).sesh.square(1).Animal) ' - ' ...
    sesh_type_use ' - sesh ' num2str(sesh1_ind) ' to sesh ' num2str(sesh2_ind)]);
printNK([Mouse(Animal_use).sesh.square(1).Animal ' - ' sesh_type_use ...
    ' Coh Topo - s' num2str(sesh1_ind) ' to s' num2str(sesh2_ind)],'2env')

%DI topo if circ2square is used above
if strcmpi(sesh_type_use,'circ2square')
    twoenv_DI_topo(Mouse(Animal_use).DI(sesh1_ind, sesh2_ind,:),...
        batch_session_map, [sesh1_ind2 sesh2_ind2]);
    title([mouse_name_title(Mouse(Animal_use).sesh.square(1).Animal) ' - ' ...
        sesh_type_use ' - sesh ' num2str(sesh1_ind) ' to sesh ' num2str(sesh2_ind)]);
    printNK([Mouse(Animal_use).sesh.square(1).Animal ' - ' sesh_type_use ...
        ' DI Topo - s' num2str(sesh1_ind) ' to s' num2str(sesh2_ind)],'2env')
end