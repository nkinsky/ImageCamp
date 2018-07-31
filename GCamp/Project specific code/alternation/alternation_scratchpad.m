% Alternation scratchpad


%% Run Tenaspis
% sesh_use = cat(2,G30_alt(1),G31_alt(1),G45_alt(1),G48_alt(1));
% pause(3600)
alternation_reference;
sesh_use = cat(2,G30_alt(1:end), G31_alt(1:end), G45_alt(1:end), G48_alt(1:end));

success_bool = [];
for j = 1:length(sesh_use)
   try
       [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
       if exist(fullfile(pwd,'FinalOutput.mat'),'file')
           disp(['Sesiion #' num2str(j) ' - already run'])
           success_bool(j) = true;
       else
           Tenaspis4(sesh_run)
           success_bool(j) = true;
       end
   catch
       success_bool(j) = false;
   end
    
end

%% Check above

success_bool = [];
for j = 1:length(sesh_use)
    try
        [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
        success_bool(j) = exist(fullfile(pwd,'FinalOutput.mat'),'file');
    catch
        success_bool(j) = false;
    end
    
end

%% Run placefields on a bunch of data

%% Make Example splitting plots for ontogeny diagram
figure; set(gcf,'Position',[34 200 1020 425]);
curve = 0.02*randn(2,50);
for j = 1:5
    if j == 2 || j == 3
        curve(1,20:30) = curve(1,20:30) + 0.2;
    elseif j == 4 || j == 5
        curve(1,20:30) = curve(1,20:30) - 0.2;
    end
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,j);
    plot_smooth_curve(curve,ha);
end

for j = 1:5
    if j == 3
        curve(1,20:30) = curve(1,20:30) + 0.4;
    elseif j == 4 
        curve(1,20:30) = curve(1,20:30) - 0.4;
    end
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,5+j);
    plot_smooth_curve(curve,ha);
end

for j = 1:5
    if j == 3
        curve(1,20:30) = curve(1,20:30) + 0.4;
    end
    curve(2,:) = circshift(curve(2,:),10);
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,10+j);
    plot_smooth_curve(curve,ha);
end
%% Register all sessions to one another pair-wise fashion
fail_bool = cell(4,1);
for j = 1:4
    MD_use = alt_all_cell{j};
    num_sessions = length(MD_use);
    fail_bool{j} = false(num_sessions, num_sessions);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            try
                neuron_map_simple(MD_use(k),MD_use(ll));
            catch
                fail_bool{j}(k,ll) = true;
            end
        end
    end
end

%% When done with above, run to qc registrations - use plot_registration
for j = 3
    MD_use = alt_all_cell{j};
    num_sessions = length(MD_use);
    fail_bool{j} = false(num_sessions, num_sessions);
    num_comps = (num_sessions-1)*num_sessions/2;
    disp(['Running pair-wise registration check for Mouse ' num2str(j)])
    hw = waitbar(0,'Registration Check Progress!');
    n = 0;
    for k = 1%:num_sessions - 1
        hfig = figure;
        for ll = k+1%:num_sessions
            plot_registration(MD_use(k) ,MD_use(ll));
            if ll == num_sessions %&& k == (num_sessions - 1)
                num_shuffles = 100;
            else
                num_shuffles = 0;
            end
            n = n+1;
            waitbar(n/num_comps,hw);
        end
        reg_qc_plot_batch(MD_use(k), MD_use(k+1:num_sessions), 'hfig', hfig,...
            'num_shuffles', num_shuffles);
        make_figure_pretty(hfig)
        printNK([MD_use(1).Animal ' - Registration QC plot' ...
            num2str(k)],'alt')
    end
    close(hw)
end

%% Run sigSplitterplots
binthresh = 3;
success_bool = false(1,length(alt_all));
for j = 1:length(alt_all)
    try
        close all
        sesh_use = alt_all(j);
        filename =  fullfile(sesh_use.Location, ['Splitters - ' ...
            sesh_to_text(sesh_use,'file') ' - binthresh' num2str(binthresh) '.ps']);
        if ~exist(filename,'file')
            plotSigSplitters(sesh_use, 'plot_type', 7, 'invert_raster_color',2)
        end
        success_bool(j) = true;
    catch
    end
    
end

%% First attempt to get group stats on corrs_v_cat

rhos_all = [];
coactive_all = [];
for j = 1:4
    sesh_use = alt_all_cell{j};
    num_sessions = length(sesh_use);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            [~, rho_mean] = alt_plot_corrs_v_cat(sesh_use(k),sesh_use(ll),...
                'plot_flag',false);
            rhos_all = [rhos_all; rho_mean];
            
            [~, ~, coactive_prop] = alt_stability_v_cat(sesh_use(k),sesh_use(ll),...
                'plot_flag',false);
            coactive_all = [coactive_all; coactive_prop];
        end
    end
end

% Might be better to not use scatterBox if this is plotting means and not
% individual points
cats = repmat(1:5,size(rhos_all,1),1);
scatterBox(rho_all(:), cats(:))
cat2 = repmat(1:5,size(coactive_all,1),1);
scatterBox(coactive_all(:),cats2(:))

%% Check if all the sessions have a pos.mat, pos_align, and Placefields file
sesh_check = MD(ref.G48.alternation(1):ref.G48.alternation(2));
num_sesh = length(sesh_check);

pos_bool = false(1, num_sesh);
pos_align_bool = false(1, num_sesh);
split_sesh_bool = false(1, num_sesh);
pf_bool = false(1, num_sesh);
pf_bool1 = false(1, num_sesh);

for j = 1:length(sesh_check)
    dir_use = ChangeDirectory_NK(sesh_check(j),0);
    if ~isempty(dir_use)
        pos_bool(j) = exist(fullfile(dir_use,'Pos.mat'),'file');
        pos_align_bool(j) = exist(fullfile(dir_use,'Pos_align.mat'),'file');
        split_sesh_bool(j) = exist(fullfile(dir_use,'part1'),'dir');
        pf_bool1(j) = exist(fullfile(dir_use,'Placefields_cm1.mat'),'file');
        pf_bool(j) = exist(fullfile(dir_use,'Placefields.mat'),'file');
    end
    
end

gtg = sesh_check(pf_bool1);
change_pf_name = sesh_check(pf_bool & ~pf_bool1);
run_pos_align = sesh_check(~pf_bool1 & ~pf_bool & ~pos_align_bool & pos_bool);
run_pos_comb = sesh_check(~pf_bool1 & ~pf_bool & ~pos_bool & split_sesh_bool);
no_pos_file = sesh_check(~pos_bool & ~pf_bool1 & ~pf_bool & ~split_sesh_bool);
run_pf = sesh_check(~pf_bool & ~pf_bool1 & pos_align_bool);
disp('ran')
