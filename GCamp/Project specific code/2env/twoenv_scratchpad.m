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
sesh_use = G45_oct;
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
sesh_use = cat(2,G30_square, G31_square);
limits_use = G31_manual_limits;
rot_use = 0:15:345; % for circle % 0:90:270; % for square  
batch_rot_arena(sesh_use(1), sesh_use(2:end), rot_use, logical(limits_use));

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

%% Run immediately after above
for j = 1:length(sesh_use)
    disp(['Running Rotated Placefield Analysis on ' sesh_use(j).Animal ' - ' sesh_use(j).Date ' - session ' num2str(sesh_use(j).Session)])
    for k = 1:length(rot_use)
        Placefields(sesh_use(j),'minspeed',1,'name_append', ['_rot' num2str(rot_use(k))],'Pos_data', ['Pos_align_rot' num2str(rot_use(k)) '.mat']);
        PlacefieldStats(sesh_use(j),'name_append',['_rot' num2str(rot_use(k))]);
    end
end

%% two-env circle-to-square comparison - NOTE MAY NEED TO CORRECT G30 limits for this and RE-RUN all PFs!
sesh_use = cat(2,G30_botharenas, G31_botharenas); limits_use = G48_both_manual_limits;
rot_array = 0:15:345;
batch_rot_arena(sesh_use(1), sesh_use(2:end), rot_array, logical(limits_use), 'circ2square', true);

%% Make batch_session_map if not done already
neuron_reg_batch(sesh_use(1), sesh_use(2:end), 'name_append', '_trans');

%% QC above
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

%% Run immediately after above
sesh_use = cat(2, G45_square(2:end), G48_square, G30_square, G31_square);
rot_array_circle = 0:15:345;
rot_array_square = 90:90:270;
for j = 1:length(sesh_use)
    [dirstr, full_sesh] = ChangeDirectory(sesh_use(j).Animal, sesh_use(j).Date, sesh_use(j).Session);
    disp(['Running Circle2Square Rotated Placefield Analysis on ' sesh_use(j).Animal ...
        ' - ' sesh_use(j).Date ' - session ' num2str(sesh_use(j).Session)])
    
    if ~isempty(regexpi(full_sesh.Env,'octagon'))
        rot_array_use = rot_array_circle;
    elseif ~isempty(regexpi(full_sesh.Env,'square'))
        rot_array_use = rot_array_square;
    end
    
    for k = 1:length(rot_array_use)
        Placefields(sesh_use(j),'minspeed',1,'name_append', ['_trans_rot' num2str(rot_array_use(k))],...
            'Pos_data', ['Pos_align_trans_rot' num2str(rot_array_use(k))]);
        PlacefieldStats(sesh_use(j),'name_append',['_trans_rot' num2str(rot_array_use(k))]);
    end
end

%% Fix batch_align_pos
sesh_use = G31_botharenas;

%% Plot TMaps for all arenas with ideally aligned rotations
sesh_use = G45_botharenas;
rot_use = G45_both_best_angle;
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
        load(fullfile(dirstr,['Placefields_trans_rot' num2str(rot_use(j)) '.mat']),'TMap_gauss');
    elseif ~isempty(regexpi(dirstr,'square')) || (~isempty(regexpi(dirstr,'oct')) && ~trans)
        load(fullfile(dirstr,['Placefields_rot' num2str(rot_use(j)) '.mat']),'TMap_gauss');
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
name_append_full{1} = '_trans_rot0';
rot_full = [];
n = 1;
for j = 1:length(sesh_use)
    rot_to_std = get_rot_from_db(sesh_use(j));
    for k = 1:length(rot_array)
        reg_sesh_full(n) = sesh_use(j);
        man_limits_full(n) = G48_manual_limits(j);
        rot_full(n) = rot_array(k) + rot_to_std;
        name_append_full{n+1} = ['_trans_rot' num2str(rot_array(k))];
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

%% Run full rotation analysis on each mouse/comparison type
close all

sesh_type = {'square', 'circle', 'circ2square'};
save_dir = 'J:\GCamp Mice\Working\2env plots figures variables\full rotation analysis plots';
sessions{1} = G48_square;
sessions{2} = G48_oct;
sessions{3} = G48_botharenas;
for j = 1:3
    twoenv_rot_analysis_full(sessions{j}, sesh_type{j}, 'save_dir', save_dir);
end

