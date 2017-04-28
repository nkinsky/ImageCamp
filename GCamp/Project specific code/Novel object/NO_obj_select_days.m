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
num_comps = size(sesh_comp,1);
num_weeks = 2;
delta_TP = cell(num_animals,num_weeks, num_comps, num_objects);
for j = 1:num_animals
    for week = 1:2
        basedir = ChangeDirectory_NK(Mouse{j}.sesh(1+(week-1)*4),0);
        load(fullfile(basedir,'batch_session_map.mat'));
        TP_both = [];
        for k = 1:num_comps
            sesh1_index = sesh_comp(k,1);
            sesh2_index = sesh_comp(k,2);
            map_use = get_neuronmap_from_batchmap(batch_session_map.map, sesh1_index, sesh2_index);
            
            sesh1 = Mouse{j}.sesh(sesh1_index +(week-1)*4);
            sesh2 = Mouse{j}.sesh(sesh2_index +(week-1)*4);
            
            for ll = 1:num_objects
                sig_cells1 = find(Mouse{j}.sig_curve{sesh1_index + (week-1)*4}(:,ll));
                sig_cells1_2 = map_use(sig_cells1); % Significant cells in session 1 that are in session 2 also
                sig_cells1_2log = false(1,size(TP_max{j,sesh2_index},1));
                good_map = sig_cells1_2 ~= 0 & ~isnan(sig_cells1_2);
                sig_cells1_2log(sig_cells1_2(good_map)) = sig_cells1_2(good_map);
                TP_across = zeros(length(sig_cells1),2);
                TP_across(:,1) = TP_max{j,sesh1_index + (week-1)*4}(sig_cells1,ll);
                TP_across(good_map,2) = TP_max{j,sesh2_index + (week-1)*4}(sig_cells1_2log,ll); % Working - now just dump this into a higher dimensional matrix and pull all the info out!
%                 keyboard
% if j == 2 && week == 2 && k == 1 && ll == 1
%     disp(['Mouse' num2str(j) ' obj ' num2str(ll)])
%     keyboard
%     TP_across
% end
                delta_TP{j,week,k,ll} = abs(diff(TP_across,1,2));
            end
        end
    end
    
end

%% Assemble everything - this is terrible but I can't keep it straight
% otherwise
w1_d1_o1 = cat(1,delta_TP{:,1,1,1}); % Saline week, day 1-2, object 1
w1_d1_o2 = cat(1,delta_TP{:,1,1,2}); % Saline week, day 2-3, object 1
w1_d2_o1 = cat(1,delta_TP{:,1,2,1});
w1_d2_o2 = cat(1,delta_TP{:,1,2,2});
w2_d1_o1 = cat(1,delta_TP{:,2,1,1}); % CPP week, day 1-2, object 1
w2_d1_o2 = cat(1,delta_TP{:,2,1,2}); % CPP week, day 2-3, object 1
w2_d2_o1 = cat(1,delta_TP{:,2,2,1});
w2_d2_o2 = cat(1,delta_TP{:,2,2,2});

figure(50)
subplot(2,2,1)
h1 = bar([1 2], [mean(w1_d1_o1) mean(w1_d1_o2); mean(w1_d2_o1) mean(w1_d2_o2)]);
std_mat = [std(w1_d1_o1) std(w1_d1_o2); std(w1_d2_o1) std(w1_d2_o2)];
hold on
for j = 1:2
    errorbar(h1(j).XData + h1(j).XOffset, h1(j).YData, std_mat(j,:),'k.')
end
hold off
title('Saline Week')
set(gca,'XTick', [1 2], 'XTickLabel',{'1 - 2', '2 - 3'})
ylabel('Change in Transient Probability')
xlabel('Days Compared')
legend('Obj 1 (Familiar)', 'Obj 2/3 (Novel)')
ylim([0 0.6])

subplot(2,2,2)
h1 = bar([1 2], [mean(w2_d1_o1) mean(w2_d1_o2); mean(w2_d2_o1) mean(w2_d2_o2)]);
std_mat = [std(w2_d1_o1) std(w2_d1_o2); std(w2_d2_o1) std(w2_d2_o2)];
hold on
for j = 1:2
    errorbar(h1(j).XData + h1(j).XOffset, h1(j).YData, std_mat(:,j),'k.')
end
hold off
title('CPP Week')
set(gca,'XTick', [1 2], 'XTickLabel',{'1 - 2', '2 - 3'})
ylabel('Change in Transient Probability')
xlabel('Days Compared')
legend('Obj 1 (Familiar)', 'Obj 2/3 (Novel)')
ylim([0 0.6])





