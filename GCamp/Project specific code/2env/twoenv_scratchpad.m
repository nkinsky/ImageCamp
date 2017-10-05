%%
Tenaspis2_profile('GCamp6f_45','08_05_2015',3,'PF_only',1,'calc_half',1)
Tenaspis2_profile('GCamp6f_45','08_05_2015',3,'PF_only',1,'calc_half',2)
Tenaspis2_profile('GCamp6f_45','08_05_2015',4,'PF_only',1,'calc_half',1)
Tenaspis2_profile('GCamp6f_45','08_05_2015',4,'PF_only',1,'calc_half',2)
Tenaspis2_profile('GCamp6f_45','08_11_2015',1,'PF_only',1,'calc_half',1)
Tenaspis2_profile('GCamp6f_45','08_11_2015',1,'PF_only',1,'calc_half',2)

%%
sesh_use = all_sessions;
for j = 1:length(sesh_use)
%     Placefields(sesh_use(j),'minspeed',1,'Pos_data','Pos_align.mat');
    PlacefieldStats(sesh_use(j));
%     Placefields(sesh_use(j),'minspeed',1,'name_append','_rot_to_std','Pos_data','Pos_align_std_corr.mat');
    PlacefieldStats(sesh_use(j),'name_append','_rot_to_std');
end
%%
sesh_use = G48_oct;
limits_use = logical(G48_manual_limits);
batch_align_pos(sesh_use(1), sesh_use(2:end), 'auto_rotate_to_std',0,...
    'manual_limits', limits_use);
batch_align_pos(sesh_use(1), sesh_use(2:end), 'auto_rotate_to_std',1,...
    'manual_limits', limits_use);

%%
sesh_use = G48_square;
for j = 1:length(sesh_use)
    dirstr = ChangeDirectory(sesh_use(j).Animal, sesh_use(j).Date, sesh_use(j).Session);
    load(fullfile(dirstr,'Placefields.mat'),'TMap_unsmoothed','RunOccMap','PSAbool');
    spatInfo(TMap_unsmoothed,RunOccMap,PSAbool,true);
    load(fullfile(dirstr,'Placefields_rot_to_std.mat'),'TMap_unsmoothed','RunOccMap','PSAbool');
    spatInfo(TMap_unsmoothed,RunOccMap,PSAbool,true,'name_append','_rot_to_std');
end

%% Run Placefields_half
sesh_use = G48_square(5);

for j = 1
    [~, MD_use] = ChangeDirectory_NK(sesh_use(j),0);
    Placefields_half( MD_use, 'half', MD_use.exclude_frames, '_rot_to_std', 'Pos_data','Pos_align_std_corr.mat');
    Placefields_half( MD_use, 'half', MD_use.exclude_frames, '', 'Pos_data','Pos_align.mat');
    
end

%% tmap_corr_across_days debugging

figure(25)
for j = 1:50
    n2_use = map1_2_shuffle(j);
    if n2_use == 0
        continue
    else
        subplot(1,2,1);
        imagesc(sesh(k).TMap{j});
        title(num2str(j));
        subplot(1,2,2)
        imagesc(sesh(ll).TMap{n2_use});
        title(num2str(n2_use))
    waitforbuttonpress
    end
                  
                    
end

%% Two-env rotation analysis
sesh_use = G48_oct([1, 3:4]);
limits_use = G48_manual_limits([1, 3:4]);
rot_array_use = 0:15:345; % for circle % 0:90:270; % for square
adjust_base = false; % true = start from scratch, false = leave base sessions alone, only adjust registered sessions
batch_rot_arena(sesh_use(1), sesh_use(2:end), rot_array_use, logical(limits_use),...
    'base_adjust', adjust_base);

%% GC above
figure(35)
n = 1;
rot_check = [90]; %[90 270]; % 
[dirstr, ~]  = ChangeDirectory_NK(sesh_use(1),0);
load(fullfile(dirstr,'Pos_align_rot0.mat'),'xmin','xmax','ymin','ymax');
for j = 1:length(sesh_use)
    
    [dirstr, temp]  = ChangeDirectory_NK(sesh_use(j),0);
    for k = 1:length(rot_check)
        ax(n) = subplot(4,6,n);
        load(fullfile(dirstr,['Pos_align_rot' num2str(rot_check(k)) '.mat']),'x_adj_cm','y_adj_cm','xmin','xmax','ymin','ymax');
        plot(x_adj_cm, y_adj_cm)
        xlabel(temp.Env)
        title([mouse_name_title(temp.Date ) ' - session ' num2str(temp.Session)])
        n = n + 1;
        xlim([xmin xmax]); ylim([ymin ymax])
    end

            
end
linkaxes(ax);

%% Run immediately after above - run square or circle PF analysis on aligned data
cmperbin_use = 4;
sesh_use = G30_square(1); %all_square; %all_oct; % all_sessions
rot_array_use = 0:90:270; %0:15:345;
if cmperbin_use ~= 1; cm_append = ['_cm' num2str(cmperbin_use)]; else ; cm_append = ''; end
tic
for j = 1:length(sesh_use)
    disp(['Running Rotated Placefield Analysis on ' sesh_use(j).Animal ' - ' sesh_use(j).Date ' - session ' num2str(sesh_use(j).Session)])
    [~,sesh_full] = ChangeDirectory_NK(sesh_use,0); % fill in partial struct
    for k = 1:length(rot_array_use)
        name_append_full = [cm_append '_rot' num2str(rot_array_use(k))];
        Placefields(sesh_full,'minspeed',1,'name_append', name_append_full,...
            'Pos_data', ['Pos_align_rot' num2str(rot_array_use(k)) '.mat'], ...
            'exclude_frames', sesh_full.exclude_frames, 'cmperbin', cmperbin_use);
        PlacefieldStats(sesh_use(j),'name_append', name_append_full);

    end
end
toc

%% two-env circle-to-square comparison - NOTE MAY NEED TO CORRECT G30 limits for this and RE-RUN all PFs!
sesh_use = cat(2,G48_square(1), G48_oct(1:4)); limits_use = G48_both_manual_limits([1 3 4 5 6]);
rot_array = 0:15:345;
adjust_base = false; % true = start from scratch, false = leave base sessions alone, only adjust registered sessions
batch_rot_arena(sesh_use(1), sesh_use(2:end), rot_array, logical(limits_use),...
    'circ2square', true, 'base_adjust', adjust_base);

%% Make batch_session_map if not done already
neuron_reg_batch(sesh_use(1), sesh_use(2:end), 'name_append', '_trans');

%% QC above
sesh_use = G48_botharenas;
figure(35)
n = 1;
rot_check = [45 330];
[dirstr, temp]  = ChangeDirectory_NK(sesh_use(1),0);
load(fullfile(dirstr,'Pos_align_trans_rot0.mat'),'xmin','xmax','ymin','ymax');
for j = 1:length(sesh_use)
    
    [dirstr, temp]  = ChangeDirectory_NK(sesh_use(j),0);
    if ~isempty(regexpi(temp.Env,'octagon'))
        for k = 1:2
            ax(n) = subplot(4,6,n);
            load(fullfile(dirstr,['Pos_align_trans_rot' num2str(rot_check(k)) '.mat']),'x_adj_cm','y_adj_cm');
            plot(x_adj_cm, y_adj_cm)
            xlabel(temp.Env)
            title([mouse_name_title(temp.Date ) ' - session ' num2str(temp.Session)])
            n = n + 1;
            xlim([xmin xmax]); ylim([ymin ymax])
        end
    elseif ~isempty(regexpi(temp.Env,'square'))
        ax(n) = subplot(4,6,n);
        load(fullfile(dirstr,'Pos_align_trans_rot180.mat'),'x_adj_cm','y_adj_cm');
        plot(x_adj_cm, y_adj_cm)
        xlabel(temp.Env)
        title([mouse_name_title(temp.Date) ' - session ' num2str(temp.Session)])
        n = n+1;
        xlim([xmin xmax]); ylim([ymin ymax])
    end
            
end
linkaxes(ax);

%% Double check you've copied over all the appropriate old Placefield files before
% running the below
sesh_use = G48_botharenas;
archive_log = false(1,length(sesh_use));
curr_dir = cd;
for j = 1:length(sesh_use)
    ChangeDirectory_NK(sesh_use(j));
    cd('old placefields without MI')
    temp = ls;
    archive_log(j) = (size(temp,1) >= 6);
end
cd(curr_dir);

%% Run immediately after above
sesh_use = all_sessions; %cat(2,G31_square(1),G31_oct(1)); % cat(2, G45_square(2:end), G48_square, G30_square, G31_square);
cmperbin_use = 4;
rot_array_circle = 0:15:345;
rot_array_square = 0:90:270;
run_win_too = true; % true = run square only and circle only too!
if cmperbin_use ~= 1; cm_append = ['_cm' num2str(cmperbin_use)]; else ; cm_append = ''; end
for j = 1:length(sesh_use)
    [dirstr, full_sesh] = ChangeDirectory(sesh_use(j).Animal, sesh_use(j).Date, sesh_use(j).Session);
    disp(['Running Circle2Square Rotated Placefield Analysis on ' full_sesh.Animal ...
        ' - ' full_sesh.Date ' - session ' num2str(full_sesh.Session)])
    
    if ~isempty(regexpi(full_sesh.Env,'octagon'))
        rot_array_use = rot_array_circle;
    elseif ~isempty(regexpi(full_sesh.Env,'square'))
        rot_array_use = rot_array_square;
    end
    
    
    for k = 1:length(rot_array_use)
        name_append_full = [cm_append '_trans_rot' num2str(rot_array_use(k))];
        Placefields(full_sesh,'minspeed',1,'name_append', name_append_full,...
            'Pos_data', ['Pos_align_trans_rot' num2str(rot_array_use(k))],...
            'cmperbin', cmperbin_use);
        PlacefieldStats(full_sesh,'name_append',name_append_full);
    end
    
    if run_win_too % Run within square or within circle sessions too!
        disp(['Running ' full_sesh.Env ' Analysis'])
        Placefields(full_sesh,'minspeed',1,'name_append', name_append_full,...
            'Pos_data', ['Pos_align_rot' num2str(rot_array_use(k)) '.mat'], ...
            'exclude_frames',full_sesh.exclude_frames, 'cmperbin', cmperbin_use);
        PlacefieldStats(full_sesh,'name_append',name_append_full);
    end
end

%% Fix batch_align_pos
sesh_use = G31_botharenas;

%% Plot TMaps for all arenas with ideally aligned rotations
sesh_use = G45_botharenas;
rot_array_use = G45_both_best_angle;
trans = false;

base_dir = ChangeDirectory(sesh_use(1).Animal, sesh_use(1).Date, ...
    sesh_use(1).Session, 0);
load(fullfile(base_dir,'batch_session_map_trans.mat'));
batch_map = batch_session_map;

disp('Loading TMaps for all sessions')
num_sessions = length(sesh_use);
num_neurons = size(batch_session_map.map,1);
TMap_rot = cell(1,num_sessions);
for j = 1:num_sessions
    dirstr = ChangeDirectory(sesh_use(j).Animal, sesh_use(j).Date, ...
        sesh_use(j).Session, 0);
    if ~isempty(regexpi(dirstr,'oct')) && trans 
        load(fullfile(dirstr,['Placefields_trans_rot' num2str(rot_array_use(j)) '.mat']),'TMap_gauss');
    elseif ~isempty(regexpi(dirstr,'square')) || (~isempty(regexpi(dirstr,'oct')) && ~trans)
        load(fullfile(dirstr,['Placefields_rot' num2str(rot_array_use(j)) '.mat']),'TMap_gauss');
    end
    TMap_rot{j} = TMap_gauss;
end

figure
cm = colormap('jet');
TMap_nada = nan(size(TMap_rot{1}{1}));
% TMap_nada(~isnan(TMap_rot{1}{1})) = 0;
for j = 1:num_neurons
    for k = 1:num_sessions
        neuron_use = batch_session_map.map(j,k+1);
        subplot_auto(num_sessions,k);
        if ~isnan(neuron_use) && neuron_use ~= 0
           imagesc_nan(TMap_rot{k}{neuron_use}, cm, [1 1 1]);
           title(num2str(k))
        else
            imagesc_nan(TMap_nada, cm, [1 1 1]);
        end
    end
    waitforbuttonpress
end

%% Add in all rotations to square sessions to circ2square alignments
sesh_use = G31_square;
manual_limits = G31_manual_limits;
rot_array = 90:90:270;
reg_sesh_full = sesh_use(1);
man_limits_full = [];
name_append_full = cell(1,length(sesh_use)*length(rot_array)+1);
name_append_full{1} = '_trans_rot0'; %'_rot0';
rot_full = [];
n = 1;
for j = 1:length(sesh_use)
    rot_to_std = get_rot_from_db(sesh_use(j));
    for k = 1:length(rot_array)
        reg_sesh_full(n) = sesh_use(j);
        man_limits_full(n) = manual_limits_use(j);
        rot_full(n) = rot_array(k) + rot_to_std;
        name_append_full{n+1} = ['_trans_rot' num2str(rot_array(k))]; % '_rot'
        n = n + 1;
    end
end

%%% NRK - need to add in the appropriate value for each of the parameters
%%% above to make it the appropriate length
man_limits_full = logical([manual_limits(1) man_limits_full]);
rot_full = [0 rot_full];
rot_full(rot_full >= 360) = rot_full(rot_full >= 360) - 360;

batch_align_pos(sesh_use(1), reg_sesh_full,'skip_skew_fix', true, 'rotate_data', rot_full,...
    'manual_limits', man_limits_full, 'name_append', name_append_full, ...
    'suppress_output', true, 'skip_trace_align', true, 'base_adjust', false);

%% Get halfway point for each connected sessions
sesh_use = G31_square(5:6 );
figure; 
curr_dir = cd;
for j = 1:length(sesh_use)
    [dirstr, MD_use] = ChangeDirectory_NK(sesh_use(j));
    load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool');
    x = AlignImagingToTracking(MD_use.Pix2CM,PSAbool,0);
    plot(x);
    title([mouse_name_title(MD_use.Animal) ' ' mouse_name_title(MD_use.Date)]);
    keyboard
end
cd(curr_dir)

%% Run PF_half for each mouse on connected days
sesh_use = cat(2,G30_square(5:6),G30_oct(5:6),G31_square(5:6),G31_oct(5:6));

for j = 1:length(sesh_use)
    [dirstr, MD_use] = ChangeDirectory_NK(sesh_use(j));
    Placefields_half( MD_use, 'half', MD_use.exclude_frames, '','half_custom',...
        MD_use.half, 'Pos_data','Pos_align_rot0.mat');
end

%% Run full rotation analysis for each mouse/comparison type
% close all
tic
sesh_type = {'square', 'circle', 'circ2square'};
num_shuffles = 1000;
rot_array_use = {0:90:270, 0:15:345, 0:15:345};
incr_use = [90, 15, 15];
plot_comb = false;
alpha = 0.05; % significance level

% Pre-allocate figure axes
if plot_comb
    for j = 1:3
        hcomb(j) = figure(40+j);
    end
end

for mm = 3:4 % 1:num_animals
    Animal_use = Mouse(mm);
    sessions{1} = Animal_use.sesh.square;
    sessions{2} = Animal_use.sesh.circle;
    sessions{3} = Animal_use.sesh.circ2square;
    % Run analysis and save individual plots for each comparison
    for j = 1:length(sesh_type)
        file_save_name = [Animal_use.sesh.(sesh_type{j})(1).Animal ...
            ' - Combined Tuning Curves - ' sesh_type{j} ' - ' num2str(num_shuffles) ' shuffle'];

        htemp = twoenv_squeeze(Animal_use.global_remap_stats.(sesh_type{j}).h_remap);
        sig_value = twoenv_squeeze(Animal_use.global_remap_stats.(sesh_type{j}).p_remap);
        sig_star = ~isnan(htemp) & htemp ~= 1;
        [~, best_angle_all, ~, ~, corr_means, CI, hh, best_angle_shuf_all] = ...
            twoenv_rot_analysis_full(sessions{j}, sesh_type{j}, 'save_fig', ...
            true, 'num_shuffles', num_shuffles,...
            'sig_star', sig_star, 'sig_value', sig_value);
        close(hh)
        
        % Plot combined curve and save
        gr_remap_log = ~isnan(Animal_use.remapping_type.global.(sesh_type{j})) & ...
            (Animal_use.remapping_type.global.(sesh_type{j}) ~= 0);
        if plot_comb
            h2 = twoenv_plot_full_rot(corr_means, rot_array_use{j}, gr_remap_log, ...
                'CI', CI);
            printNK(file_save_name, '2env_rot')
            close(h2);
        end

        if plot_comb
            twoenv_plot_full_rot(corr_means, rot_array_use{j}, gr_remap_log, ...
                'CI', CI, 'h', hcomb(j)); % Combine all mice for each sesh_type
        end
        
        % Plot rotation difference
        rotd_save_name = [Animal_use.sesh.(sesh_type{j})(1).Animal ...
            ' - Rot Diffs - ' sesh_type{j} ' - ' num2str(num_shuffles) ' shuffle'];
%         coh_sig = Mouse(mm).global_remap_stats.(sesh_type{j}).h_remap;
%         coh_sig(~isnan(coh_sig)) = ~coh_sig(~isnan(coh_sig));
        num_comps = sum(~cellfun(@isempty, best_angle_all(:))); % number of comparisons
        p_mat = calc_coherency2(best_angle_all, best_angle_shuf_all, sesh_type{j}, 1);
        coh_sig = p_mat < alpha/num_comps;
        [rotd, h3] = twoenv_plot_rotd(best_angle_all, incr_use(j), coh_sig, true);
        subplot(8,8,1); title([mouse_name_title(sessions{j}(1).Animal) ' - ' sesh_type{j}])
        set(h3,'PaperPositionMode','auto', 'PaperOrientation','landscape',...
            'PaperType', 'arch-b')
%         keyboard
        printNK(rotd_save_name,'2env_rot','')
        close(h3);

%         close(hh); close(h2); close(h3);
    end
end

if plot_comb
    for j = 1:3
        file_save_name = ['All Mice - Combined Tuning Curves - ' sesh_type{j} ' - ' ...
            num2str(num_shuffles) ' shuffle'];
        figure(hcomb(j))
        printNK(file_save_name,'2env_rot')
    end
end
toc

%% Plot PVcorrs between arenas before, during, after for all mice
% Looking for local changes in PV near hallway - don't really see
% anything...
PVcorrb_all = []; PVcorrd_all = []; PVcorra_all = [];
figure(300);
for k = 1:num_animals
    
    % Before
    PVcorrb = []; 
    for j = 1:4
        PVcorrb = cat(3,PVcorrb,squeeze(Mouse(k).PV_corrs.circ2square.PV_corr(...
            square_sesh(j),circ_sesh(j),:,:))); 
    end
    
    % During
    PVcorrd = []; 
    for j = 5:6
        PVcorrd = cat(3,PVcorrd,squeeze(Mouse(k).PV_corrs.circ2square.PV_corr(...
            square_sesh(j),circ_sesh(j),:,:))); 
    end
    
    % After
    PVcorra = [];
    for j = 7:8
        PVcorra = cat(3,PVcorra,squeeze(Mouse(k).PV_corrs.circ2square.PV_corr(...
            square_sesh(j),circ_sesh(j),:,:)));
    end
    subplot(5,3,3*(k-1)+1)
    imagesc_nan(nanmean(PVcorrb,3)); colorbar
    subplot(5,3,3*(k-1)+2)
    imagesc_nan(nanmean(PVcorrd,3)); colorbar
    subplot(5,3,3*(k-1)+3)
    imagesc_nan(nanmean(PVcorra,3)); colorbar
    
    PVcorrb_all = cat(3,PVcorrb_all,PVcorrb);
    PVcorrd_all = cat(3,PVcorrd_all,PVcorrd);
    PVcorra_all = cat(3,PVcorra_all,PVcorra);

end

subplot(5,3,13)
imagesc_nan(nanmean(PVcorrb_all,3)); colorbar
subplot(5,3,14)
imagesc_nan(nanmean(PVcorrd_all,3)); colorbar
subplot(5,3,15)
imagesc_nan(nanmean(PVcorra_all,3)); colorbar
