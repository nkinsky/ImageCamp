%% 2env PV silent cell vetting figures

%% Load Data
% optimal aligned data
twoenv_reference
opt_data = fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_PVsilent_cm4_local0-1000shuffles-2018-01-06.mat'); % '2env_PVsilent_cm4_local0-0shuffles-2018-01-03.mat' % works
% local aligned data
loc_data = fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_PVsilent_cm4_local1-0shuffles-2018-01-05.mat'); 

load(loc_data); Mouseloc = Mouse;
load(opt_data); %stays in Mouse variable

%% 1st plot all 4 animals PV curves for each condition (no silent cells, only 
% unambiguous silent cells, and any silent cells)

sesh_type = {'square','circle','circ2square'};
sesh_simple = {'', 'Same Arena', 'Different Arena'};

for k = 1:3; hcomb(k) = figure; end
hsep2 = figure; % Plots for silent_thresh = nan only for each mouse
corrs_byday_all = cell(length(sesh_type),3);
shuf_byday_all = cell(length(sesh_type),3);
for m = 1:length(sesh_type)
    
    hsep = figure;
    for k = 1:3% different silent_cell thresholds
        % Pre-allocate for later stats collection
        corrs_byday_all{m,k} = cell(7,1);
        shuf_byday_all{m,k} = cell(7,1);
        % Pre-allocate arrays for same vs different curves
        if ismember(k,[1 3])
            corr_simp_all = []; shuf_simp_all = [];
        end
        
        % Pre-allocate arrays for square v circle v circ2square curves
        corrs_all = []; shuf_all = []; local_all = [];
        for j = 1:length(Mouse)
            figure(hsep); hin = subplot(3,4,j + 4*(k-1)); % Ind. Mouse handle
%             if k == 1
                figure(hcomb(k)); hinc = subplot(2,2,m); hold on; % Combined handle
%             end
            if k == 1; figure(hsep2); hin2 = subplot(3,4,j+4*(m-1)); end
            
            % Make relevant variables small
            corrs_use = Mouse(j).PVcorrs.(sesh_type{m})(k).PVcorrs;
            shuf_use = Mouse(j).PVcorrs.(sesh_type{m})(k).PVshuf_corrs;
            local_use = Mouseloc(j).PVcorrs.(sesh_type{m})(k).PVcorrs;
            silent_thresh = Mouse(j).PVcorrs.(sesh_type{m})(k).silent_thresh;
            Animal_text = mouse_name_title(Mouse(j).sesh.(sesh_type{m})(1)...
                .Animal);
            
            % Plot it
            [~, ~, corrs_byday ,~, ~, ~, shuf_byday] = twoenv_plot_PVcurve(...
                corrs_use, sesh_type{m}, shuf_use, hin);
            title([Animal_text ' - ' sesh_type{m} ' silent\_thresh = ' ...
                num2str(silent_thresh)]);
            make_plot_pretty(gca);
            
            % Aggregate for later stats
            corrs_byday_all{m,k} = cellfun(@(a,b) cat(2,a,b), ...
                corrs_byday_all{m,k}, corrs_byday,'UniformOutput',false);
            shuf_byday_all{m,k} = cellfun(@(a,b) cat(2,a,b), ...
                shuf_byday_all{m,k}, shuf_byday,'UniformOutput',false);
            
            % Same as above but only for silent_thresh = nan and all mice
            % on one plot
            if k == 1
                twoenv_plot_PVcurve(corrs_use, sesh_type{m}, shuf_use, hin2);
                title([Animal_text ' - ' sesh_type{m}])
                make_plot_pretty(gca);
                set(gca,'XTick',0:7,'YLim',[-0.3 0.7])
                if j == 1 && m == 1
                    text(4,0.5,'Silent = nan')
                end
            end
            
            
            % Don't plot curves on combined/simple plots - wait for mean of all later
            twoenv_plot_PVcurve(corrs_use, sesh_type{m}, shuf_use, hinc,...
                false); hold on
%             twoenv_plot_PVcurve(corrs_use, sesh_type{m}, shuf_use, hins,...
%                 false); hold on

            % Aggregate each mouse's correlations together
            corrs_all = cat(3, corrs_all, corrs_use);
            shuf_all = cat(3, shuf_all, shuf_use);
            local_all = cat(3,local_all, local_use);
            
        end
        
        % Get simple mouse mean and plot
        corrs_mean = nanmean(corrs_all,3);
        [~, unique_lags_all{m,k}, mean_PVcorr_all{m,k},~, CI{m,k}, day_lag_all{m,k}] = ...
            twoenv_plot_PVcurve(corrs_mean, sesh_type{m}, shuf_all, hinc,...
            true); hold off
        [~, unique_days_check{m,k}, mat_ind_all{m,k}] = group_mat(corrs_mean, ...
            day_lag_all{m,k});
        title(['Combined - ' sesh_type{m} ' silent\_thresh = ' ...
            num2str(silent_thresh)]);
        make_plot_pretty(gca);
               
        % Get local aligned correlations for later comparison
        local_mean = nanmean(local_all,3);
        [~, ~, mean_PVlocal_all{m,k}, ~, ~] = ...
            twoenv_plot_PVcurve(local_mean, sesh_type{m}, [], 'dont_plot', true);
        
    end
end

for k = 1:3
    silent_thresh = Mouse(j).PVcorrs.(sesh_type{1})(k).silent_thresh;
    figure(hcomb(k)); subplot(2,2,4); 
    text(0.2,0.5,['Silent = ' num2str(silent_thresh)]);
    axis off
end
%% Plot same env overlap and different env overlap
load(opt_data);
silent_thresh_array = [nan 0 1];
figure(602); set(gcf,'Position',[2150 20 1400 940]);
pt_colors = [0 0 0; 0 0 0; 1 0 0];
for silent_ind = 1:3% 1:3
    silent_thresh = silent_thresh_array(silent_ind);
    hs = subplot(2,2,silent_ind);
    
    % First plot individual data points (means of each session-pair for all
    % 4 mice)
    hold on; 
    for k = 1:3
        [xout, grpsout] = scatterbox_reshape(mean_PVcorr_all{k,silent_ind}, ...
            unique_lags_all{k,silent_ind});
        [~, ~, hscat(k)] = scatterBox(xout, grpsout, 'plotBox', false, 'h', hs,...
            'circleColors', pt_colors(k,:), 'sf', 0.02);
    end
    
    % Now plot curves with error bars (sem)
    same_env = cellfun(@(a,b) [a; b], mean_PVcorr_all{1,silent_ind}, ...
        mean_PVcorr_all{2,silent_ind},'UniformOutput',false);
    diff_env = mean_PVcorr_all{3,silent_ind};
    local_same_env = cellfun(@(a,b) [a; b], mean_PVlocal_all{1,silent_ind}, ...
        mean_PVlocal_all{2,silent_ind},'UniformOutput',false);
    
    h1 = errorbar(unique_lags_all{1,silent_ind}, cellfun(@mean, same_env), ...
        cellfun(@std, same_env)./sqrt(cellfun(@length, same_env)), 'k.-');
    hold on
    h2 = errorbar(unique_lags_all{3,silent_ind}, cellfun(@mean, diff_env), ...
        cellfun(@std, diff_env)./sqrt(cellfun(@length, diff_env)), 'r.-');
    h3 = errorbar(unique_lags_all{1,silent_ind}, cellfun(@mean, local_same_env), ...
        cellfun(@std, local_same_env)./sqrt(cellfun(@length, local_same_env)), 'c.--');
    xlabel('Day lag')
    ylabel('Mean PV correlation')
    title(['PV Correlations - silent\_thresh = ' num2str(silent_thresh)])
    xlim([-0.5 7.5]); % ylim([-0.1 0.7])
    
    % Get mean CIs from all three comparisons
    n = 1;
    CIalltemp = cat(2,cat(1,unique_lags_all{:,silent_ind}), ...
        cat(1,CI{:,silent_ind})); % 1st col = lags, 2/3 = max/min CI at each lag
    CIplot = nan(8,2);
    for ll = 0:7
       CIplot(n,:) = nanmean(CIalltemp(CIalltemp(:,1) == ll,2:3),1);
       n = n+1;
    end
    
    hshufline = plot((0:7)', CIplot(:,1), 'Color', [1 0 1 0.7], 'LineStyle', ':');
    legend(cat(1,h1,h2,h3,hshufline), {'Same Arena', 'Different Arena', ...
        'Local Aligned', 'Shuffled'})
    make_plot_pretty(gca)

end
subplot(2,2,4)
text(0.2,0.8,['Lccal aligned = ' ...
    num2str(Mouse(1).PVcorrs.square(1).local_aligned) ' for subplot 1'])
text(0.2,0.65, 'Local aligned = 0 for subplot 2 and 3')
text(0.2,0.5, 'Silent thresh = nan -> no silent cells included')
text(0.2,0.35, 'Silent thresh = 0 -> only silent cells with non-overlapping ROIs included')
text(0.2,0.2, 'Silent thresh = 1 -> all silent cells included')

axis off


%% Run GLM to get stats on everything
%%% NRK - to re-run this you need to change k from 1 to 3 below manually
%%% and comment out the non-significant predictors (e.g. don't include # 3
%%% (square ~= circle) for k = 1).  Hence the keyboard statement.  I've
%%% gone through and done this to minimize the AIC and noted the
%%% significant predictors below.
%% NRK Note - play around with stepwiseglm to see if you get the same results as below!!!
fittype = 'linear'; % interactions are explicitly modeled in design_mat below

% Make connected indices
conn_indsep = false(8);
conn_indsep(5:6,:) = true;
conn_indsep(:,5:6) = true;
conn_indsep = conn_indsep & ~isnan(day_lag_all{1});
conn_indcomb = false(16);
conn_indcomb(9:12,:) = true;
conn_indcomb(:,9:12) = true;
conn_indcomb = twoenv_squeeze(conn_indcomb) & ~isnan(day_lag_all{3});
conn_ind_cell{1} = conn_indsep; conn_ind_cell{2} = conn_indsep;
conn_ind_cell{3} = conn_indcomb;

PVvec_all = [];
design_mat_all = [];
for k = 1:3
    temp = cat(1,mean_PVcorr_all{:,k});
    PVvec = cat(1,temp{:});
    
    % construct vectors of design matrix
    day_vec = [];
    conn_vec = [];
    bda_vec = []; % before/during/after is weird - ignore for now
    for m = 1:length(sesh_type)
        nsesh(m) = sum(cellfun(@length, mat_ind_all{m,k})); %number of sessions
        day_vec = [day_vec; day_lag_all{m,k}(cat(1,mat_ind_all{m,k}{:}))]; % day lag
        conn_vec = [conn_vec; conn_ind_cell{m}(cat(1,mat_ind_all{m,k}{:}))]; % boolean (1 = connected in one session, 0 = not)
    end
    
    % Create boolean for same arena or different arena
    % 1s if the same, 0 if no
    same_vec = ones(length(day_vec),1);
    same_vec(sum([nsesh(1:2),1]):end) = 0;
    nsesh_cum = cumsum(nsesh);
    square_vec = zeros(sum(nsesh),1); square_vec(1:nsesh_cum(1)) = 1;
    circle_vec = zeros(sum(nsesh),1); circle_vec((nsesh_cum(1)+1):nsesh_cum(2)) = 1;
    diff_vec = ~same_vec;
    
    % Construct Design Matrices - add in covariates and evaluate
    % 1) What is the mean of all the data?
    design_mat = cell(0); GLM = cell(0);
    mm = 1;
    design_mat{mm} = ones(size(PVvec)); mm = mm + 1;
    % 2) Are same v diff arena comparisons different?
    design_mat{mm} = same_vec; mm = mm + 1;
    % 3) Are square v circle different different?
    design_mat{mm} = [design_mat{mm-1} circle_vec]; mm = mm + 1;
    % 4) Does connecting the arena change the PV correlations?
    design_mat{mm} = [design_mat{mm-1} conn_vec]; mm = mm + 1;
    % 5) Is there a drift with time overall?
    design_mat{mm} = [design_mat{mm-1} day_vec]; mm = mm + 1;
    % 6) Is there a diferent drift in same arena than in different arenas?
    design_mat{mm} = [design_mat{mm-1} day_vec.*same_vec]; mm = mm + 1;
    % 7) Control sanity check - does adding in some randomly designated group make
    % a better model? (Answer should be no)
%     design_mat{mm} = [design_mat{mm-1} binornd(1,0.5,size(design_mat{4},1),1)]; 
%     mm = mm + 1;
%     % 8) Are square v circle different different?
%     design_mat{mm} = [design_mat{mm-1} circle_vec]; mm = mm + 1;
%     % 9) Does connecting the arena change the PV correlations?
%     design_mat{mm} = [design_mat{mm-1} conn_vec]; mm = mm + 1;
    
    % Include only covariates that actually improve GLM for each silent
    % cell threshold
    predictor_names = {'Constant', 'Same Arena > Diff Arena', 'Square ~= Circle',...
        'Connected vs Not', 'Temporal Drift', 'Temporal Drift x Same/Diff Arena',...
        'Noise - Sanity Check'};
%     included_predictors = 1:7;
    if k == 1
        included_predictors = [1 2 4 5 6];
    elseif k == 2
        included_predictors = [1 2 3 4 5 6];
    elseif k == 3
        included_predictors = [1 2 3 4 5 6];
    end
    
    clear B dev stats pval
    design_mat_use = design_mat; %design_mat(included_predictors);
    % Do constant term explicitly
    [B{1}, dev(1), stats{1}] = glmfit(design_mat_use{1}, PVvec, 'normal','constant',...
        'off');
    GLM{1} = fitglm(design_mat_use{1}, PVvec, fittype, 'Intercept', false);
    
    % Evaluate the rest normally
    for j = 2:length(design_mat_use)
        [B{j}, dev(j), stats{j}] = glmfit(design_mat_use{j}, PVvec, 'normal');
        GLM{j} = fitglm(design_mat_use{j}, PVvec, fittype);
    end
    
    % Calculate F-stat and pvalue for adding in each successive covariate
    for j = 1:length(B)-1
        p2 = length(B{j+1}); % # parameters in model 1
        p1 = length(B{j}); % # parameters in model 2
        F(j) = (sum(stats{j}.resid.^2) - sum(stats{j+1}.resid.^2))/(p2-p1)/...
            (sum(stats{j+1}.resid.^2)/stats{j+1}.dfe);
        pval(j) = 1 - fcdf(F(j),p2-p1,stats{j+1}.dfe);
    end
    
    GLMall(k).F = F;
    GLMall(k).pval = pval;
    GLMall(k).B = B;
    GLMall(k).dev = dev;
    GLMall(k).stats = stats;
    
    
    cellfun(@(a) a.ModelCriterion.AIC,GLM)
    [~, model_use] = min(cellfun(@(a) a.ModelCriterion.AIC,GLM));
    GLMall(k).model = model_use;
    GLMall(k).GLM = GLM;
    GLMall(k).significant_predictors = predictor_names(included_predictors);

    if k == 1 || k == 2
        % Add in a silent = nan vs silent = 0 term AND an interaction term 
        % between silent cells included and temporal drift 
        design_mat_all = cat(1,design_mat_all, ...
            [design_mat{end} ones(size(design_mat{end},1),1)*(k-1) design_mat{end}(:,5)*(k-1)]);
        PVvec_all = cat(1,PVvec_all, PVvec);
    end
end

% Now do a comparison between active only PVs and silent_cell_thresh = 0
% PVs
GLM2 = fitglm(design_mat_all, PVvec_all, fittype);
silent_v_not_coefCIs_summary = cat(2,num2cell(GLM2.coefCI),...
        cat(1,predictor_names(1:6)',{'Silent'; 'Silent x Temporal Drift'}));

%% Save
file_name = fullfile(ChangeDirectory_NK(G30_square(1),0),...
    ['PV_GLMs-' datestr(now,29) '.mat']);
save(file_name,'GLMall')

%% Make tables for later plotting
table_both = GLMall(1).GLM{5}.Coefficients(:,1);
table_both = horzcat(table_both, array2table(GLMall(1).GLM{5}.coefCI));
table_both.Properties.RowNames = GLMall(1).significant_predictors';
table_both.Properties.VariableNames = {'Mean', 'CIlower', 'CIupper'};
writetable(table_both, fullfile(ChangeDirectory_NK(G30_square(1),0),...
    'PVtable_activeboth.xls'),'WriteRowNames', true);

table_sil0 = GLMall(2).GLM{6}.Coefficients(:,1);
table_sil0 = horzcat(table_sil0, array2table(GLMall(2).GLM{6}.coefCI));
table_sil0.Properties.RowNames = GLMall(2).significant_predictors';
table_sil0.Properties.VariableNames = {'Mean', 'CIlower', 'CIupper'};
writetable(table_sil0, fullfile(ChangeDirectory_NK(G30_square(1),0),...
    'PVtable_sil0.xls'),'WriteRowNames', true);

%% Code to get pval for PV correlation vs shuffled
% 1 - sum(Mouse(1).PVcorrs.square.PVcorrs - ...
%     Mouse(1).PVcorrs.square.PVshuf_corrs > 0,3)/num_shuffles;
