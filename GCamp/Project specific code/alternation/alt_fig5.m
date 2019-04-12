% Alternation Figure 5: More Consistent Spatial Coding in Splitters than
% Arm PCs (and non-splitter stem PCs).

%% PF versus splitter tuning fidelity across days
for mouse = 1:4
    
    sessions_use = alt_all_cell{mouse};
    pval_thresh = 0.05;
    ntrans_thresh = 5;
    sigthresh = 3;
    [PFcorr_by_day_split, PFcorr_by_day_spc, PFcorr_by_day_apc, ...
        PFcorr_by_day_snpc, PFcorr_by_day_stem_nonsplit, unique_lags] = ...
        splitcorr_v_time(sessions_use, 'comp_type', 'free_only', 'pval_thresh', ...
        pval_thresh, 'ntrans_thresh', ntrans_thresh, 'sigthresh', sigthresh,...
        'debug', false);
    
    % %% Old code that plots splitters versus ALL OTHER CELLS...
    % figure;
    % psign = nan(1,8);
    % for j = 2:8 % day + 1
    %     ha = subplot(2,4,j);
    %     x_use = [PFcorr_by_day_split{j}, PFcorr_by_day{j}];
    %     match_bool = all(~isnan(x_use),2); % Get only valid data points.
    %     x_use = x_use(match_bool,:);
    %     groups = ones(size(x_use)).*[1 2];
    %     paired_ind = repmat((1:sum(match_bool))',1,2);
    %     scatterBox(x_use(:), groups(:), 'xLabels', {'Splitters Only', 'All Stem Neurons'},...
    %         'yLabel', '\rho_{PF,mean}','paired_ind', paired_ind, 'h', ha);
    %     title([num2str(j-1) ' Day Lag'])
    %     psign(j) = signtest(x_use(:,1), x_use(:,2), 'tail', 'right');
    %
    % end
    
    % Better code that looks at everything...
    figure;
    psignrank = nan(7,2);
    for j = 2:8 % day + 1
        ha = subplot(2,4,j);
        x_use = [PFcorr_by_day_split{j}, PFcorr_by_day_spc{j}, PFcorr_by_day_apc{j}];
        match_bool = all(~isnan(x_use),2); % Get only valid data points.
        x_use = x_use(match_bool,:);
        groups = ones(size(x_use)).*[1 2 3];
        paired_ind = repmat((1:sum(match_bool))',1,3);
        scatterBox(x_use(:), groups(:), 'xLabels', {'Splitters', 'Stem PCs'...
            'Arm PCs'},...
            'yLabel', '\rho_{PF,mean}','paired_ind', paired_ind, 'h', ha);
        title([num2str(j-1) ' Day Lag'])
        
        % ANOVA is probably more approriate, but want to keep simple! should do
        % bonferroni correction at each day...
        psignrank(j-1,1) = signrank(x_use(:,1), x_use(:,2), 'tail', 'right');
        psignrank(j-1,2) = signrank(x_use(:,1), x_use(:,3), 'tail', 'right');
        psignrank(j-1,3) = signrank(x_use(:,2), x_use(:,3), 'tail', 'right');
        
    end
    
    subplot(2,4,1)
    text(0.1, 0.9, mouse_name_title(sessions_use(1).Animal))
    text(0.1, 0.8, 'signed-rank test values (split v spc, split v apc, spc v apc)')
    text(0.1, 0.1, num2str(psignrank, '%0.2g \t'))
    axis off
    
end