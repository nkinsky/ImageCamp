% Alternation Figure 5: More Consistent Spatial Coding in Splitters than
% Arm PCs (and non-splitter stem PCs).

%% PF versus splitter tuning fidelity across days
plot_type = 'all'; % options 'All' (split v stem pc v arm pc), 'split_v_apc'
nsesh_at_lag = cell(4,1);
PFcorr_by_day_split = cell(4,1);
PFcorr_by_day_spc = cell(4,1);
PFcorr_by_day_apc = cell(4,1);
PFcorr_by_day_snpc = cell(4,1);
PFcorr_by_day_stem_nonsplit = cell(4,1);
unique_lags = cell(4,1);
psignrank_all = cell(4,1);
for mouse = 1:4
    
    sessions_use = alt_all_cell{mouse};
    pval_thresh = 0.05;
    ntrans_thresh = 5;
    sigthresh = 3;
    [PFcorr_by_day_split{mouse}, PFcorr_by_day_spc{mouse}, PFcorr_by_day_apc{mouse}, ...
        PFcorr_by_day_snpc{mouse}, PFcorr_by_day_stem_nonsplit{mouse}, unique_lags{mouse}] = ...
        splitcorr_v_time(sessions_use, 'comp_type', 'free_only', 'pval_thresh', ...
        pval_thresh, 'ntrans_thresh', ntrans_thresh, 'sigthresh', sigthresh,...
        'debug', false);
    
    % Aggregate nsesh at each lag for each mouse
    nsesh_at_lag{mouse}(:,1) = unique_lags{mouse}; % First col is unique lags
    nsesh_at_lag{mouse}(:,2) = cellfun(@length, PFcorr_by_day_split{mouse}); % 2nd col is #sesh-pairs at that lag
    
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
    nlags = length(unique_lags{mouse});
    figure;
    psignrank = nan(nlags,5);
    psignrank(:,1) = unique_lags{mouse};
    psignrank(:,2) = nsesh_at_lag{mouse}(:,2);
    lags_plot = 1:7;
    for j = 1:nlags
        lag = unique_lags{mouse}(j);
        
        % assemble matrices for stats/plotting
        if strcmpi(plot_type, 'all')
            x_use = [PFcorr_by_day_split{mouse}{j}, ...
                PFcorr_by_day_spc{mouse}{j}, PFcorr_by_day_apc{mouse}{j}];
            match_bool = all(~isnan(x_use),2); % Get only valid data points.
            x_use = x_use(match_bool,:);
            groups = ones(size(x_use)).*[1 2 3];
            paired_ind = repmat((1:sum(match_bool))',1,3);
            
            if ismember(lag, lags_plot)
                ha = subplot(2,4,lag);
                scatterBox(x_use(:), groups(:), 'xLabels', {'Splitters', 'Stem PCs'...
                    'Arm PCs'}, 'yLabel', '\rho_{PF,mean}',...
                    'paired_ind', paired_ind, 'h', ha);
                title([num2str(lag) ' Day Lag'])
            end
        elseif strcmpi(plot_type, 'split_v_apc')
            x_use = [PFcorr_by_day_split{mouse}{j}, ...
                PFcorr_by_day_apc{mouse}{j}];
            match_bool = all(~isnan(x_use),2); % Get only valid data points.
            x_use = x_use(match_bool,:);
            groups = ones(size(x_use)).*[1 2];
            paired_ind = repmat((1:sum(match_bool))',1,2);
            
            if ismember(lag, lags_plot)
                ha = subplot(2,4,lag);
                scatterBox(x_use(:), groups(:), 'xLabels', {'Splitters', ...
                    'Arm PCs'}, 'yLabel', '\rho_{PF,mean}', ...
                    'paired_ind', paired_ind, 'h', ha);
                title([num2str(lag) ' Day Lag'])
            end
        end
        
        % ANOVA is probably more approriate, but want to keep simple! should do
        % bonferroni correction at each day...
        try
            psignrank(j,3) = signrank(x_use(:,1), x_use(:,2), 'tail', 'right');
            if strcmpi(plot_type, 'all') % Add extra cols if doing all comparisons
                psignrank(j,4) = signrank(x_use(:,1), x_use(:,3), 'tail', 'right');
                psignrank(j,5) = signrank(x_use(:,2), x_use(:,3), 'tail', 'right');
            end
        catch ME
            if strcmp(ME.identifier, 'stats:signrank:NotEnoughData')
                disp(['Not enough data for mouse ' num2str(mouse) ' at lag ' ...
                    num2str(lag)])
            end
        end
            
    end
    psignrank_all{mouse} = psignrank;
    
    subplot(2,4,8)
    text(0.1, 0.9, mouse_name_title(sessions_use(1).Animal))
    text(0.1, 0.8, 'signed-rank test values (day lag, npts, split v spc, split v apc, spc v apc)')
    text(0.1, 0.1, num2str(psignrank, '%0.2g \t'))
    axis off
    printNK(['Spatial Consistency close-up plots - ' plot_type ' - ' ...
        alt_all_cell{mouse}(1).Animal], 'alt');
    
end

%% Now re-arrange stuff and plot again as a group
max_lag = 21; min_lag = 1;

% First concatenate everything
lags_combined = cat(1,unique_lags{1:4,1});
PFapc_combined = cat(1, PFcorr_by_day_apc{1:4,1});
PFspc_combined = cat(1, PFcorr_by_day_spc{1:4,1});
PFstem_combined = cat(1, PFcorr_by_day_stem_nonsplit{1:4,1});

% No re-arrange to have only one array corresponding to each lag
lags_combined_unique = unique(lags_combined(lags_combined <= max_lag ...
    & lags_combined >= min_lag));
PFapc_combined_unique = arrayfun(@(a) cat(1, ...
    PFapc_combined{lags_combined == a}), lags_combined_unique, ...
    'UniformOutput', false);
PFspc_combined_unique = arrayfun(@(a) cat(1, ...
    PFspc_combined{lags_combined == a}), lags_combined_unique, ...
    'UniformOutput', false);
PFstem_combined_unique = arrayfun(@(a) cat(1, ...
    PFstem_combined{lags_combined == a}), lags_combined_unique, ...
    'UniformOutput', false);

[~, ha1] = plot_corrs_v_time(PFapc_combined_unique, PFspc_combined_unique, ...
    lags_combined_unique, 'grp_labels', {'Arm PCs', 'Splitters'});
xlim(ha1(1),[min_lag - 0.5, max_lag + 0.5])
make_plot_pretty(gca);
printNK('Spatial Consistency - Split v APCs - All Mice', 'alt')
[~, ha2] = plot_corrs_v_time(PFstem_combined_unique, PFspc_combined_unique, ...
    lags_combined_unique, 'grp_labels', {'Stem PCs', 'Splitters'});
xlim(ha2(1),[min_lag - 0.5, max_lag + 0.5])
printNK('Spatial Consistency - Split v stem PCs - All Mice', 'alt')
make_plot_pretty(gca);

%% Now plot for individual mice...could do in splitcorr_v_time but now 
% plot_corrs_v_time is a better plotting function and is consistent with
% the above...
max_lag = 21; min_lag = 1;

for j = 1:4
    [~, ha1] = plot_corrs_v_time(PFcorr_by_day_apc{j}, PFcorr_by_day_spc{j}, ...
        unique_lags{j}, 'grp_labels', {'Arm PCs', 'Splitters'});
    xlim(ha1(1),[min_lag - 0.5, max_lag + 0.5])
    title(ha1(1), mouse_name_title(alt_all_cell{j}(1).Animal))
    make_plot_pretty(gca);
    printNK(['Spatial Consistency - Split v APCs - ' ...
        alt_all_cell{j}(1).Animal], 'alt')
    [~, ha2] = plot_corrs_v_time(PFcorr_by_day_apc{j}, PFcorr_by_day_stem_nonsplit{j}, ...
        unique_lags{j}, 'grp_labels', {'Stem PCs', 'Splitters'});
    xlim(ha2(1),[min_lag - 0.5, max_lag + 0.5])
    title(ha2(1), mouse_name_title(alt_all_cell{j}(1).Animal))
    printNK(['Spatial Consistency - Split v stem PCs - ' ...
        alt_all_cell{j}(1).Animal], 'alt')
    make_plot_pretty(gca);
end


