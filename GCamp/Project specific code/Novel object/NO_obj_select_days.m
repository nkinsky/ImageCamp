% NO track object cells across days

clear all

% Load up sessions
[MD, ref] = MakeMouseSessionList('natlaptop');
Mouse{1}.sesh = MD(ref.Bellatrix(1):ref.Bellatrix(2));
Mouse{2}.sesh = MD(ref.Polaris(1):ref.Polaris(2));

num_animals = length(Mouse);
num_objects = 2;
num_sessions = length(Mouse{1}.sesh);

num_shuffles = 100;

sesh_calc = [2 3 4 6 7 8];
%% Run NO_PETH

for j = 1:num_animals
    for k = 1:length(sesh_calc)
        [Mouse{j}.PETH_out{sesh_calc(k)},~,~,~, Mouse{j}.tuning_curve{sesh_calc(k)}, Mouse{j}.sig_curve{sesh_calc(k)}, Mouse{j}.PSA_mean_shuffle{sesh_calc(k)}] = ...
            NO_PETH(Mouse{j}.sesh(sesh_calc(k)),'scroll_flag',false);
    end
end

%% Identify significant object cells on each day and get max FR

num_obj_cells = zeros(num_animals, num_objects, num_sessions);
num_both_obj_cells = zeros(num_animals, num_sessions);
TP_max = cell(num_animals, num_sessions); % Maximum transient probability for each significant cell
for j = 1:num_animals
    for k = 1:length(sesh_calc)
        sesh_use = sesh_calc(k);
        sig_use = Mouse{j}.sig_curve{sesh_use};
        num_neurons = size(sig_use,1);
        num_obj_cells(j,:,sesh_use) = sum(sig_use,1);
        num_both_obj_cells(j,sesh_use) = sum(any(sig_use,2));
        
        TP_max{j,sesh_use} = max(Mouse{j}.tuning_curve{sesh_use},[],3);
    end
end

%% track each sig cell from day 1 to day 2 and see how it changes
sesh_comp = [2 3; 3 4];
for j = 1:num_animals
    for week = 1:2
        basedir = ChangeDirectory_NK(Mouse{j}.sesh(1+(week-1)*4),0);
        load(fullfile(basedir,'batch_session_map.mat'));
        TP_both = [];
        for k = 1:2
            sesh1_index = sesh_comp(k,1);
            sesh2_index = sesh_comp(k,2);
            map_use = get_neuronmap_from_batchmap(batch_session_map.map, sesh1_index, sesh2_index);
            
            sesh1 = Mouse{j}.sesh(sesh1_index +(week-1)*4);
            sesh2 = Mouse{j}.sesh(sesh2_index +(week-1)*4);
            
            for ll = 1:2
                sig_cells1 = find(Mouse{j}.sig_curve{sesh1_index + (week-1)*4}(:,ll));
                sig_cells1_2 = map_use(sig_cells1); % Significant cells in session 1 that are in session 2 also
                sig_cells1_2log = false(1,size(TP_max{j,sesh2_index},1));
                good_map = sig_cells1_2 ~= 0 & ~isnan(sig_cells1_2);
                sig_cells1_2log(sig_cells1_2(good_map)) = sig_cells1_2(good_map);
                keyboard
                TP_across = zeros(length(sig_cells1),2);
                TP_across(:,1) = TP_max{j,sesh1_index}(sig_cells1,ll);
                TP_across(good_map,2) = TP_max{j,sesh2_index}(sig_cells1_2log,ll); % Working - now just dump this into a higher dimensional matrix and pull all the info out!
            end
            
            
        end
    end
    
end


