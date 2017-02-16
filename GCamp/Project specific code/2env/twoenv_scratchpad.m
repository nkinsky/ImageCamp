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
sesh_use = all_sessions;

for j = 63:length(sesh_use)
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
sesh_use = G31_oct;
limits_use = G45_manual_limits;
rot_use = 0:15:345; % for circle % 0:90:270; % for square  
batch_rot_arena(sesh_use(1), sesh_use(2:end), rot_use, logical(limits_use));

%% GC above
figure(35)
n = 1;
rot_check = [90 270]; % [45 330];
[dirstr, ~]  = ChangeDirectory_NK(sesh_use(j),0);
load(fullfile(dirstr,'Pos_align_rot0.mat'),'xmin','xmax','ymin','ymax');
for j = 1:length(sesh_use)
    
    [dirstr, temp]  = ChangeDirectory_NK(sesh_use(j),0);
    for k = 1:2
        ax(n) = subplot(4,6,n);
        load(fullfile(dirstr,['Pos_align_rot' num2str(rot_check(k)) '.mat']),'x_adj_cm','y_adj_cm');
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
sesh_use = G48_botharenas; limits_use = G48_both_manual_limits;
rot_array = 0:15:345;
batch_rot_arena(sesh_use(1), sesh_use(2:end), rot_array, logical(limits_use), 'circ2square', true);

%% Make batch_session_map if not done already
neuron_reg_batch(sesh_use(1), sesh_use(2:end), 'name_append', '_trans');

%% QC above
figure(35)
n = 1;
rot_check = [45 330];
[dirstr, temp]  = ChangeDirectory_NK(sesh_use(j),0);
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
        load(fullfile(dirstr,'Pos_align_trans_rot0.mat'),'x_adj_cm','y_adj_cm');
        plot(x_adj_cm, y_adj_cm)
        xlabel(temp.Env)
        title([mouse_name_title(temp.Date) ' - session ' num2str(temp.Session)])
        n = n+1;
        xlim([xmin xmax]); ylim([ymin ymax])
    end
            
end
linkaxes(ax);

%% Run immediately after above
for j = 1:length(sesh_use)
    [dirstr, full_sesh] = ChangeDirectory(sesh_use(j).Animal, sesh_use(j).Date, sesh_use(j).Session);
    disp(['Running Circle2Square Rotated Placefield Analysis on ' sesh_use(j).Animal ' - ' sesh_use(j).Date ' - session ' num2str(sesh_use(j).Session)])
    if ~isempty(regexpi(full_sesh.Env,'octagon'))
        for k = 1:length(rot_array)
            Placefields(sesh_use(j),'minspeed',1,'name_append', ['_trans_rot' num2str(rot_array(k))],'Pos_data', ['Pos_align_trans_rot' num2str(rot_array(k))]);
            PlacefieldStats(sesh_use(j),'name_append',['_trans_rot' num2str(rot_array(k))]);
        end
    elseif ~isempty(regexpi(full_sesh.Env,'square'))
        Placefields(sesh_use(j),'minspeed',1,'name_append', '_trans_rot0','Pos_data', 'Pos_align_trans_rot0.mat');
        PlacefieldStats(sesh_use(j),'name_append','_trans_rot0');
    end
end

%% Fix batch_align_pos
sesh_use = G31_botharenas;

