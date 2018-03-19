%% Supplemental Figure 1 - simultaneous pattern completion and pattern 
% separation mechanisms
twoenv_reference;
load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_batch_analysis4_workspace_1000shuffles_2018JAN11.mat'));

%% S1a Simple - traces for positive, neutral, and negative DI neurons
sesh_use = G30_square(5); %G45_square(5); %G45_square(5);
sesh_use2 = G30_oct(5);
DI_cutoff = 0.67;
dirstr = ChangeDirectory_NK(sesh_use,0);
load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool','NeuronTraces','NeuronImage');
base_image = imread(fullfile(dirstr,'ICmovie_min_proj.tif'));
num_neurons = size(PSAbool,1);
num_frames = size(PSAbool,2);

% For G30_square(5)
env_t = [320 750 1075];
cells1 = 1:690;
cells2 = 691:num_neurons;
redDI = [95 114 31 98 193]; % 1st arena/square
blueDI = [763 578 73 761 770]; %2nd arena/circle
greenDI = [376 153 249 164 327]; %[130 376 39 120 64]; % same in both

[PSAbool_sort, sort_ind] = sortPSA(PSAbool);
PSAbool_sort2 = double(PSAbool_sort);
PSAbool_sort2(cells2,:) = PSAbool_sort2(cells2,:)*2;
LPtrace_sort = NeuronTraces.LPtrace(sort_ind,:);
time_plot = (1:num_frames)/20;

% Get DI between arenas
PV1 = get_PV_from_TMap(sesh_use, 'PFname_append', '_cm4_rot0',...
    'TMap_use', 'unsmoothed');
PV2 = get_PV_from_TMap(sesh_use2, 'PFname_append', '_cm4_rot0',...
    'TMap_use', 'unsmoothed');
[~,~, DI] = get_discr_ratio(nanmean(nanmean(PV1,1),2), ...
    nanmean(nanmean(PV2,1),2));
DI = squeeze(DI);
DIsort = DI(sort_ind);
DIclass = nan(size(DI));
DIclass(DIsort >= DI_cutoff) = 1; % 1st arena cells
DIclass(DIsort > -DI_cutoff & DIsort < DI_cutoff) = 2; % Neither cells?
DIclass(DIsort <= -DI_cutoff) = 3; % 2nd arena cells
PSAbool_sort3 = double(PSAbool_sort);
PSAbool_sort3(DIclass == 2,:) = PSAbool_sort3(DIclass == 2,:)*2;
PSAbool_sort3(DIclass == 3,:) = PSAbool_sort3(DIclass == 3,:)*3;

%%
try close(250); end; try close(251); end
neurons_to_plot = cat(1,redDI,greenDI,blueDI)';
% order = [1:5; 6:10; 11:15];
% colors = cat(1, repmat([1 0 0],length(redDI),1), ...
%     repmat([0 1 0],length(greenDI),1), repmat([0 0 1],length(blueDI),1))';
colors = cat(1, repmat('r',1,length(redDI)), repmat('g',1,length(greenDI)), ...
    repmat('b',1,length(blueDI)))';
figure(250)
set(gcf,'Position',[1930 220 1840 720])
ha = subplot(1,2,1);
plot_neuron_outlines(base_image,NeuronImage(neurons_to_plot(:)),ha,...
    'colors',colors(:));
hold on

hb = subplot(1,2,2);
traces_to_plot = LPtrace_sort(flipud(neurons_to_plot(:)),:);
PSA_plot = PSAbool_sort(flipud(neurons_to_plot(:)),:);
colors_plot = flipud(colors(:));
plot_neuron_traces(traces_to_plot,colors_plot,hb) % ,'PSAbool',PSA_plot);
hold on;
ylims = get(gca,'YLim');
for j = 1:3
    plot([env_t(j) env_t(j)], ylims,'k--')
end
make_figure_pretty(gcf);
printNK('Connected Day example traces and ROIS by DI type','2env')

figure(251)
hc = gca;
set(gcf,'Position',[1930 220 1500 720])
plot_neuron_traces(traces_to_plot,colors_plot,hc) % ,'PSAbool',PSA_plot);
hold on;
ylims = get(gca,'YLim');
for j = 1:3
    plot([env_t(j) env_t(j)], ylims,'k--')
end
make_plot_pretty(hc,'linewidth',1.5);
printNK('Connected Day example traces by DI type','2env')

%% S1b - What proportion of neurons maintain the coherent map?
rot_file_use = 'full_rotation_analysis_circ2square_cm4_TMap_unsmoothed_shuffle1000.mat';
coh_cutoff = 30; % degrees

coh_prop = nan(4,8,8);
for j = 1:4
    dirstr = ChangeDirectory_NK(Mouse(j).sesh.circ2square(1),0);
    load(fullfile(dirstr ,rot_file_use),'best_angle', 'best_angle_all');
    coh_prop(j,:,:) = cellfun(@(a,b) sum(abs(a-b) <= coh_cutoff), best_angle_all, ...
        num2cell(best_angle))./cellfun(@(a) sum(~isnan(a)),best_angle_all);
end

% Plot out matrices
figure(345)
for j = 1:4
    subplot(2,3,j)
    imagesc(squeeze(coh_prop(j,:,:)))
    title([mouse_name_title(Mouse(j).sesh.circ2square(1).Animal) ...
        ': Coh. Neuron Proportion'])   
end
subplot(2,3,5)
imagesc(squeeze(mean(coh_prop,1)));
title('Coherent Neuron Prop. - All Mice')

% Simply into before - during - after
before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
during_pairs = [5 5 6 6 ; 5 6 5 6]';
after_pairs = [7 7 8 8; 7 8 7 8]';
mech_before_all = [];
mech_during_all = [];
mech_after_all = [];
for j = 1:4
    coh_prop_temp = squeeze(coh_prop(j,:,:));
    mouse_name = Mouse(j).sesh.circ2square(1).Animal;
    before = coh_prop_temp(sub2ind([8,8], before_pairs(:,1), before_pairs(:,2)));
    during = coh_prop_temp(sub2ind([8,8], during_pairs(:,1), during_pairs(:,2)));
    after = coh_prop_temp(sub2ind([8,8], after_pairs(:,1), after_pairs(:,2)));
    groups = cat(1,ones(size(before)), 2*ones(size(during)), ...
        3*ones(size(after)));
    
    scatterBox(cat(1,before,during,after),groups,'xLabels', {'Before', ...
        'During','After'},'yLabel','Prop. Coherent Neurons','transparency',0.7,...
        'Position',[1000 420 350 380]);
    title(mouse_name_title(mouse_name));
    set(gca,'tickdir','in')
    make_plot_pretty(gca)
    
    printNK(['Coherent Neuron Proportion - Before During After for ' mouse_name], '2env')
    
    mech_before_all = cat(1,mech_before_all,before);
    mech_during_all = cat(1,mech_during_all,during);
    mech_after_all = cat(1,mech_after_all,after);
end

% Plot the whole group and do stats on it
groups_all = cat(1,ones(size(mech_before_all)), 2*ones(size(mech_during_all)), ...
    3*ones(size(mech_after_all)));
bda_all = cat(1, mech_before_all, mech_during_all, mech_after_all);
scatterBox(bda_all,groups_all,'xLabels',{'Before','During','After'},'yLabel', ...
    'Prop. Coherent Neurons', 'transparency', 0.7, 'Position', [1000 420 350 380]);
title('All Mice');
set(gca,'tickdir','in','YLim',[0 0.8])
make_plot_pretty(gca)

printNK('Coherent Neuron Proportion -  Before During After for All Mice', '2env')

[p_bda, t_bda, bda_stats] = anova1(bda_all, groups_all, 'off');
figure; [c_bda, m_bda, h_bda] = multcompare(bda_stats);

%% S1c: Breakdown sessions into coherent (rate mod), coherent (no rate mod),
% Random remap, and silent/new
tic
coh_cutoff = 30; % degrees
DI_cutoff = 0.67; % Arbitrary between 0 and 1

mech_breakdown = nan(4,8,8,4); % num_animals x num_square_sesh x num_circ_sesh x num_categories
DI_all = cell(4,8,8);
num_silent_all = nan(4,8,8);
abs_diff_ang_all = cell(4,8,8);
for j = 1:4
    base_dir = ChangeDirectory_NK(Mouse(j).sesh.square(1),0);
    load(fullfile(base_dir,'full_rotation_analysis_circ2square_cm4_TMap_unsmoothed_shuffle1000.mat'),...
        'best_angle_all', 'best_angle');
    for k = 1:8
        session1 = Mouse(j).sesh.square(k);
        for ll = 1:8
            session2 = Mouse(j).sesh.circle(ll);
            [DI, num_silent] = getDI(session1, session2,...
                'Placefields_cm4_rot0.mat');
            silent_cells2 = abs(DI) == 1; % Get cells that have a calcium event
            % during the session but not above the speed threshold.
            valid_cells = ~isnan(DI) & ~isnan(best_angle_all{k,ll}) & ...
                ~silent_cells2;
            coh_cells = abs(best_angle_all{k,ll} - best_angle(k,ll)) < coh_cutoff;
            highDI = abs(DI) > DI_cutoff;
            total_cells = sum(valid_cells) + num_silent + sum(silent_cells2);
            coh_lowDI = ~highDI & coh_cells & valid_cells;
            coh_highDI = highDI & coh_cells & valid_cells;
            rand_remap = ~coh_cells & valid_cells;
            
            coh_nomod_p = sum(coh_lowDI)/total_cells;
            coh_mod_p = sum(coh_highDI)/total_cells;
            rand_remap_p = sum(rand_remap)/total_cells;
            silent_p = (num_silent + sum(silent_cells2))/total_cells;
            
            mech_breakdown(j,k,ll,:) = [coh_nomod_p, coh_mod_p, rand_remap_p, ...
                silent_p];
            
            DI_all{j,k,ll} = DI;
            num_silent_all(j,k,ll) = num_silent;
            abs_diff_ang_all{j,k,ll} = abs(best_angle_all{k,ll} - ...
                best_angle(k,ll));
        end
    end
end
toc
base_dir = ChangeDirectory_NK(Mouse(1).sesh.square(1),0);
save(fullfile(base_dir,'pat_sep_mechs.mat'),'mech_breakdown','coh_cutoff',...
    'DI_cutoff','DI_all','num_silent_all','abs_diff_ang_all');

%% Get all pairs <= 1 day apart - sig diff.
coh_cutoff = 45; % degrees
DI_cutoff = 0.7; % Arbitrary between 0 and 1

before_pairs = [1 1 2 2 3 3 4 4; 1 2 1 2 3 4 3 4]';
during_pairs = [5 6; 6 5]'; %[5 5 6 6 ; 5 6 5 6]'; % This includes only pairs exactly 1 day apart
after_pairs = [7 7 8 8; 7 8 7 8]';

mech_before_all = nan(4,size(before_pairs,1),4);
mech_during_all = nan(4,size(during_pairs,1),4);
mech_after_all = nan(4,size(after_pairs,1),4);
highDI_before_all = nan(4,size(before_pairs,1));
highDI_during_all = nan(4,size(during_pairs,1));
highDI_after_all = nan(4,size(after_pairs,1));
cohprop_before_all = nan(4,size(before_pairs,1));
cohprop_during_all = nan(4,size(during_pairs,1));
cohprop_after_all = nan(4,size(after_pairs,1));

for j = 1:4
    highDIsum = cellfun(@(a) sum(abs(a) > DI_cutoff)/length(a), ...
        squeeze(DI_all(j,:,:))); % Get numbers of neurons with a high DI for each mouse
%     highDIsum = cellfun(@(a) sum(abs(a) > DI_cutoff & abs(a) ~= 1)/length(a), ...
%         squeeze(DI_all(j,:,:))); % Get numbers of neurons with a high DI for each mouse
    cohpropsum = cellfun(@(a) sum((a <= coh_cutoff))/sum(~isnan(a)), ...
        squeeze(abs_diff_ang_all(j,:,:)));
    for k = 1:size(before_pairs,1)
        mech_before_all(j,k,:) = mech_breakdown(j, before_pairs(k,1),...
            before_pairs(k,2),:);
        highDI_before_all(j,k) = highDIsum(before_pairs(k,1),...
            before_pairs(k,2),:);
        cohprop_before_all(j,k) = cohpropsum(before_pairs(k,1),...
            before_pairs(k,2),:);
    end
    
    for k = 1:size(during_pairs,1)
        mech_during_all(j,k,:) = mech_breakdown(j, during_pairs(k,1),...
            during_pairs(k,2),:);
        highDI_during_all(j,k) = highDIsum(during_pairs(k,1),...
            during_pairs(k,2),:);
        cohprop_during_all(j,k) = cohpropsum(during_pairs(k,1),...
            during_pairs(k,2),:);
    end
    
    for k = 1:size(after_pairs,1)
        mech_after_all(j,k,:) = mech_breakdown(j, after_pairs(k,1),...
            after_pairs(k,2),:);
        highDI_after_all(j,k) = highDIsum(after_pairs(k,1),...
            after_pairs(k,2),:);
        cohprop_after_all(j,k) = cohpropsum(after_pairs(k,1),...
            after_pairs(k,2),:);
    end
end

% Do some scatterBoxes for # cells modulation event rate significantly
% between sessions - useful!
try close(25); catch; end
highDI_bda_all = cat(1,highDI_before_all(:), highDI_during_all(:), highDI_after_all(:));
groups_all = cat(1, ones(size(highDI_before_all(:))), 2*ones(size(highDI_during_all(:))),...
    3*ones(size(highDI_after_all(:))));
figure(25); set(gcf,'Position', [630 575 720 380]);
h = subplot(1,2,1);
scatterBox(highDI_bda_all, groups_all, 'xLabels', {'Before', 'During', 'After'},...
    'ylabel','Proportion High DI Neurons','Position', [1000 420 350 380],...
    'transparency', 0.7,'h',h);
% ylim([0 0.6])
DI_cutoff_str = num2str(DI_cutoff);
DI_cutoff_str(regexpi(DI_cutoff_str,'\.')) = '_';
title(['DI thresh = ' num2str(DI_cutoff)])
make_plot_pretty(gca)

[DI_p_bda, DI_t_bda, DI_bda_stats] = anova1(highDI_bda_all, groups_all, 'off');
[DI_c_bda, DI_m_bda, DI_h_bda] = multcompare(DI_bda_stats,'display','off');
subplot(1,2,2);
text(0.1, 0.7, ['pANOVA = ' num2str(DI_p_bda)])
text(0.1, 0.5, ['pBD = ' num2str(DI_c_bda(1,6),'%0.2g')])
text(0.1, 0.3, ['pDA = ' num2str(DI_c_bda(3,6),'%0.2g')])
axis off

printNK(['High DI Before During After thresh ' DI_cutoff_str],'2env');

% Ditto for propotion of coherent cells between sessions - useful!
try close(26); catch; end
cohprop_bda_all = cat(1,cohprop_before_all(:), cohprop_during_all(:), cohprop_after_all(:));
groups_all = cat(1, ones(size(cohprop_before_all(:))), 2*ones(size(cohprop_during_all(:))),...
    3*ones(size(cohprop_after_all(:))));
figure(26); set(gcf,'Position', [630 94 720 380]);
h = subplot(1,2,1);
scatterBox(cohprop_bda_all, groups_all, 'xLabels', {'Before', 'During', 'After'},...
    'ylabel','Proportion Coh. Neurons','Position', [1000 420 350 380],...
    'transparency', 0.7, 'h', h);
ylim([0 0.9])
title(['Coh cutoff <= ' num2str(coh_cutoff)])
chance_level = length(-coh_cutoff:15:coh_cutoff)/length(0:15:345);
hold on; plot(get(gca,'xlim'), [chance_level, chance_level],'k--')
make_plot_pretty(gca)

[cohprop_p_bda, cohprop_t_bda, cohprop_bda_stats] = ...
    anova1(cohprop_bda_all, groups_all, 'off');
[cohprop_c_bda, cohprop_m_bda, cohprop_h_bda] = ...
    multcompare(cohprop_bda_stats,'display','off');
subplot(1,2,2);
text(0.1, 0.7, ['pANOVA = ' num2str(cohprop_p_bda)])
text(0.1, 0.5, ['pBD = ' num2str(cohprop_c_bda(1,6),'%0.2g')])
text(0.1, 0.3, ['pDA = ' num2str(cohprop_c_bda(3,6),'%0.2g')])
axis off


printNK(['Coh Prop - Before During After thresh ' num2str(coh_cutoff)],'2env');


%% Plot it out 
% % Pie chart doesn't really tell us anything, but keep code around just in
% case.
% figure; set(gcf,'Position',[ 190 164 1553 406])
% subplot(1,3,1)
% pie(squeeze(mean(mean(before_all,2),1))); 
% title('Cell Propotion Before Conn.'); 
% legend('Coh. No Mod','Coh. Mod', 'Rand. Remap','Silent')
% subplot(1,3,2)
% pie(squeeze(mean(mean(during_all,2),1))); 
% title('Cell Propotion During Conn/'); 
% legend('Coh. No Mod','Coh. Mod', 'Rand. Remap','Silent')
% subplot(1,3,3)
% pie(squeeze(mean(mean(after_all,2),1))); 
% title('Cell Propotion After Conn'); 
% legend('Coh. No Mod','Coh. Mod', 'Rand. Remap','Silent')

% Do some scatterBoxes for full breakdown for each cell type. Again, not
% really helpful for a figure but good for me to understand what is going
% on

titles = {'Coh. No Mod','Coh. Mod', 'Rand. Remap','Silent'};
figure; set(gcf,'Position',[2015 45 1081 883])
for j = 1:4
    tempb = mech_before_all(:,:,j);
    tempd = mech_during_all(:,:,j);
    tempa = mech_after_all(:,:,j);
    h = subplot(2,2,j);
    scatterBox(cat(1,tempb(:),tempd(:),tempa(:)), cat(1, ones(size(tempb(:))),...
        2*ones(size(tempd(:))),3*ones(size(tempa(:)))),'xLabels', {'Before',...
        'During', 'After'},'ylabel','Proportion','h',h, 'transparency', 0.7);
    title(titles{j})
    
end



