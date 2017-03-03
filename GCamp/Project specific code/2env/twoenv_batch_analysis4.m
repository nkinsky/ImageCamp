% 2env batch analysis

%% Set-up everything
twoenv_reference;

Mouse(1).sesh.square = G30_square;
Mouse(1).sesh.circle = G30_oct;
Mouse(1).sesh.circ2square = G30_botharenas;
Mouse(1).best_angle.square = G30_square_best_angle;
Mouse(1).best_angle.circle = G30_circle_best_angle;
Mouse(1).best_angle.circ2square = G30_both_best_angle;

Mouse(2).sesh.square = G31_square;
Mouse(2).sesh.circle = G31_oct;
Mouse(2).sesh.circ2square = G31_botharenas;
Mouse(2).best_angle.square = G31_square_best_angle;
Mouse(2).best_angle.circle = G31_circle_best_angle;
Mouse(2).best_angle.circ2square = G31_both_best_angle;

Mouse(3).sesh.square = G45_square;
Mouse(3).sesh.circle = G45_oct;
Mouse(3).sesh.circ2square = G45_botharenas;
Mouse(3).best_angle.square = G45_square_best_angle;
Mouse(3).best_angle.circle = G45_circle_best_angle;
Mouse(3).best_angle.circ2square = G45_both_best_angle;

Mouse(4).sesh.square = G48_square;
Mouse(4).sesh.circle = G48_oct;
Mouse(4).sesh.circ2square = G48_botharenas;
Mouse(4).best_angle.square = G48_square_best_angle;
Mouse(4).best_angle.circle = G48_circle_best_angle;
Mouse(4).best_angle.circ2square = G48_both_best_angle;

days.square = square_days;
days.circle = circle_days;
days.circ2square = all_days;

days_diff.square = 0:6;
days_diff.circle = 0:6;
days_diff.circ2square = [0:5 7];

num_animals = length(Mouse);

animal_names = cell(1,num_animals);
for j = 1:num_animals
    animal_names{j} = Mouse(j).sesh.square(1).Animal;
end
    

%% Run rotation analysis

sesh_type = {'square', 'circle', 'circ2square'};
disp('Performing best angle rotation analysis')
p = ProgressBar(length(sesh_type)*num_animals);
for j = 1:num_animals
    for k = 1:length(sesh_type)
        circ2square_flag = strcmpi(sesh_type{k},'circ2square');
        [corr_mat, shuffle_mat] = twoenv_batch_rot_analysis(Mouse(j).sesh.(sesh_type{k}),...
            Mouse(j).best_angle.(sesh_type{k}), circ2square_flag);
        Mouse(j).corr_mat.(sesh_type{k}) = corr_mat;
        Mouse(j).shuffle_mat.(sesh_type{k}) = shuffle_mat;
        p.progress;
    end

end
p.stop;

%% Aggregate everything by time and type of comparison
All.days_v_corr2.square = cell(length(days_diff.square),1);
All.days_v_corr2.circle = cell(length(days_diff.circle),1);
All.days_v_corr2.circ2square = cell(length(days_diff.circ2square),1);
for j = 1:num_animals
    for k = 1:length(sesh_type)
        days_diff_use = days_diff.(sesh_type{k});
        % Get difference in time between sessions (actual and shuffled
        num_sesh = length(days.(sesh_type{k}));
        time_diff_mat = repmat(days.(sesh_type{k}), num_sesh, 1) - ...
            repmat(days.(sesh_type{k})', 1, num_sesh); % Get time between sessions
        
        corr_mat_temp = cellfun(@nanmean, Mouse(j).corr_mat.(sesh_type{k}));
        shuffle_mat_temp = cellfun(@nanmean, Mouse(j).shuffle_mat.(sesh_type{k}));
        
        valid_comp = ~isnan(corr_mat_temp);
        Mouse(j).days_v_corr.(sesh_type{k}) = [time_diff_mat(valid_comp), ...
            corr_mat_temp(valid_comp)];
        Mouse(j).days_v_shuf.(sesh_type{k}) = [time_diff_mat(valid_comp), ...
            shuffle_mat_temp(valid_comp)];
        
        % Put everything into a 2 column vector. 1: days between
        % comparison, 2 = mean correlation (Spearman)
        ttt = cell(length(days_diff_use),1);
        uuu = cell(length(days_diff_use),1);
        for ll = 1:length(days_diff_use)
            day_ind = Mouse(j).days_v_corr.(sesh_type{k})(:,1) == days_diff_use(ll);
            ttt{ll} = Mouse(j).days_v_corr.(sesh_type{k})(day_ind,2); 
            uuu{ll} = Mouse(j).days_v_shuf.(sesh_type{k})(day_ind,2);
            All.days_v_corr2.(sesh_type{k}){ll} = cat(1,...
                All.days_v_corr2.(sesh_type{k}){ll}, ttt{ll});
        end
        Mouse(j).days_v_corr2.(sesh_type{k}) = cellfun(@mean, ttt);
        Mouse(j).days_v_shuf2.(sesh_type{k}) = cellfun(@mean, uuu);
        
        
    end
end

for k = 1:length(sesh_type)
    figure
    days_diff_use = days_diff.(sesh_type{k});
    for j = 1:num_animals
        plot(Mouse(j).days_v_corr.(sesh_type{k})(:,1), ...
            Mouse(j).days_v_corr.(sesh_type{k})(:,2),'o');
        hold on
%         plot(days_diff,Mouse(j).days_v_corr2.(sesh_type{k}))
%         plot(days_diff,Mouse(j).days_v_shuf2.(sesh_type{k}),'k--')
    end
    for j = 1:num_animals
        plot(Mouse(j).days_v_shuf.(sesh_type{k})(:,1), ...
            Mouse(j).days_v_shuf.(sesh_type{k})(:,2),'k.');
        hold on
    end
    plot(days_diff_use, cellfun(@mean, All.days_v_corr2.(sesh_type{k})),'b-')
    legend(cellfun(@mouse_name_title, animal_names,'UniformOutput',0),'Shuffled')
    xlabel('Days between session'); 
    ylabel('Mean Spearman Correlation b/w TMaps')
    title(sesh_type{k})
    if strcmpi(sesh_type{k},'circ2square')
        xlim([-1 8]); ylim([-0.1 1]);
        set(gca,'XTick',0:7)
    else
        xlim([-1 7]); ylim([-0.1 1]);
        set(gca,'XTick',0:6)
    end
end

%% Remapping analysis
alpha = 0.05; % p-value cutoff

% Find global remappers

% Pre-allocate
for k = 1:length(sesh_type)
    All.global_remap_stats.num_sessions.(sesh_type{k}) = zeros(size(Mouse(1).corr_mat.(sesh_type{k})));
end

% Run it
for k = 1:length(sesh_type)
    for j = 1:num_animals
        valid_comp = cellfun(@(a) ~isempty(a), Mouse(j).corr_mat.(sesh_type{k}));
        h_mat = nan(size(valid_comp));
        p_mat = nan(size(valid_comp));
        num_comps = sum(valid_comp(:)); % Get number of comparisons
        [h,p] = cellfun(@(a,b) kstest2(a,b,'tail','smaller','alpha',alpha/num_comps),...
            Mouse(j).corr_mat.(sesh_type{k})(valid_comp),...
            Mouse(j).shuffle_mat.(sesh_type{k})(valid_comp));
        h_mat(valid_comp) = ~h;
        p_mat(valid_comp) = p;
        Mouse(j).global_remap_stats.(sesh_type{k}).h_remap = h_mat;
        Mouse(j).global_remap_stats.(sesh_type{k}).p_remap = p_mat;
        
        All.global_remap_stats.num_sessions.(sesh_type{k}) = ...
            All.global_remap_stats.num_sessions.(sesh_type{k}) + h_mat;
        
    end
end

% Get distal cue v local cue v incongruous comparisons
for k = 1:length(sesh_type)
    num_sessions = length(Mouse(1).sesh.(sesh_type{k}));
    for j = 1:num_animals
        Mouse(j).distal_rot_mat.(sesh_type{k}) = nan(num_sessions,num_sessions);
        angle_diff_mat = repmat(Mouse(j).best_angle.(sesh_type{k}), num_sessions, 1) - ...
            repmat(Mouse(j).best_angle.(sesh_type{k})', 1, num_sessions);
        for ll = 1:num_sessions-1
            [~, sesh1_rot] = get_rot_from_db(Mouse(j).sesh.(sesh_type{k})(ll));
            for mm = ll+1:num_sessions
                [~, sesh2_rot] = get_rot_from_db(Mouse(j).sesh.(sesh_type{k})(mm));
                distal_rot = sesh2_rot - sesh1_rot;
                if distal_rot < 0
                    distal_rot = distal_rot + 360;
                elseif distal_rot >= 360
                    distal_rot = distal_rot < 360;
                end
                
                Mouse(j).distal_rot_mat.(sesh_type{k})(ll,mm) = distal_rot;
                
                
            end
        end
        valid_comp = cellfun(@(a) ~isempty(a), Mouse(j).corr_mat.(sesh_type{k}));
        global_remap = zeros(num_sessions, num_sessions);
        global_remap(valid_comp) = Mouse(j).global_remap_stats.(sesh_type{k}).h_remap(valid_comp);
        
        distal_align_mat = double(angle_diff_mat == Mouse(j).distal_rot_mat.(sesh_type{k}) & ...
            Mouse(j).distal_rot_mat.(sesh_type{k}) ~= 0 & ~global_remap);
        local_align_mat = double(angle_diff_mat == 0 & ~global_remap);
        other_align_mat = double(angle_diff_mat ~= 0 & angle_diff_mat ~= Mouse(j).distal_rot_mat.(sesh_type{k}) ...
            & ~global_remap);
        global_remap = double(global_remap);
        
        distal_align_mat(~valid_comp) = nan;
        local_align_mat(~valid_comp) = nan;
        other_align_mat(~valid_comp) = nan;
        global_remap(~valid_comp) = nan;
        
        Mouse(j).remapping_type.distal_align.(sesh_type{k}) = distal_align_mat;
        Mouse(j).remapping_type.local_align.(sesh_type{k}) = local_align_mat;
        Mouse(j).remapping_type.other_align.(sesh_type{k}) = other_align_mat;
        Mouse(j).remapping_type.global.(sesh_type{k}) = global_remap;
        
    end
end

%%% NRK - need to QC above and then check for dist_rot_mat ==
%%% best_angle_diff!! There are 5 cases - distal/local aligned, distal,
%%% local, other rotation, global remapping.  Break into 4 - local, distal
%%% (only if not local), other rotation, global remapping

%%
align_type = {'distal_align','local_align','other_align','global'};

for k = 1:length(sesh_type)
    ratio_plot_all = zeros(num_animals, length(align_type));
    for j = 1:num_animals
        figure(10 + j)
        num_comps = sum(sum(cellfun(@(a) ~isempty(a), Mouse(j).corr_mat.(sesh_type{k}))));
        ratio_plot = zeros(size(align_type));
        for ll = 1:length(align_type)
            ratio_plot(ll) = nansum(Mouse(j).remapping_type.(align_type{ll}).(sesh_type{k})(:))/num_comps;
        end
        ratio_plot_all(j,:) = ratio_plot;
        
        subplot(length(sesh_type),1,k)
        bar(1:length(align_type), ratio_plot)
        xlim([0 length(align_type) + 1]); ylim([0 1]);
        set(gca,'XTick',1:length(align_type),'XTickLabel',cellfun(@mouse_name_title, align_type,'UniformOutput',0));
        ylabel('Ratio')
        title([mouse_name_title(animal_names{j}) ' - ' sesh_type{k}])
        
    end
    
    figure(10+num_animals+1)
    All.ratio_plot_all.(sesh_type{k}) = ratio_plot_all;
    
    subplot(length(sesh_type),1,k)
    bar(1:length(align_type), mean(ratio_plot_all,1))
    xlim([0 length(align_type) + 1]); ylim([0 1]);
    set(gca,'XTick',1:length(align_type),'XTickLabel',cellfun(@mouse_name_title, align_type,'UniformOutput',0));
    ylabel('Ratio')
    title(['All Mice - ' sesh_type{k}])
    
end
               



