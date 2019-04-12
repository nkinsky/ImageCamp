% Alternation Script to Calculate/Plot Stability v Corrs
%% get group stats on corrs_v_cat

rhos_mean_all = [];
rhos_median_all = [];
coactive_all = [];
for j = 1:4
    sesh_use = alt_all_cell{j};
    num_sessions = length(sesh_use);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            [~, ~, ~, rho_mean, rho_med] = alt_plot_corrs_v_cat(...
                sesh_use(k),sesh_use(ll), 'plot_flag',false);
            rhos_mean_all = [rhos_mean_all; rho_mean];
            rhos_median_all = [rhos_median_all; rho_med];
            
            [~, ~, coactive_prop] = alt_stability_v_cat(sesh_use(k),sesh_use(ll),...
                'plot_flag',false);
            coactive_all = [coactive_all; coactive_prop];
        end
    end
end

%% Plot Correlations vs category.
cat_names = {'Splitters','Arm PCs', 'Arm NPCs', 'Stem PCs', 'Stem NPCs'};
cats = repmat(1:5,size(rhos_mean_all,1),1);
pos = [520 420 770 380];
scatterBox(rhos_mean_all(:), cats(:),'yLabel','\rho_{mean}','xLabels',...
    cat_names, 'transparency',0.5, 'position',pos);
scatterBox(rhos_median_all(:), cats(:),'yLabel','\rho_{median}','xLabels',...
    cat_names, 'transparency', 0.5, 'position', pos);
[pmed,tmed,rho_med_stats] = anova1(rhos_median_all(:),cats(:),'off');
[pmean,tmean,rho_mean_stats] = anova1(rhos_mean_all(:),cats(:),'off');
figure; [cmed,mmed,hmed] = multcompare(rho_med_stats);
figure; [cmean,mmean,hmean] = multcompare(rho_mean_stats);
[htmed, ptmed] = ttest2(rhos_median_all(:,1),rhos_median_all(:,2));

%%% Take-home is that none of these seem to be significant yet for
%%% individual sessions.  However, the next step is to take the means for
%%% all sessions, remove any remapping sessions (or at least restrict to 1
%%% day comparisons to start) and then do paired comparisons.

%% Plot coactivity v corrs and get stats
cat2 = repmat(1:5,size(coactive_all,1),1);
scatterBox(coactive_all(:),cats2(:),'yLabel','Reactivation Probability','xLabels',...
    cat(2,cat_names, 'ntrans < 5'), 'transparency', 0.5, 'position', pos);
make_plot_pretty(gca);
[pco, tco, co_stats] = anova1(coactive_all(:), cats2(:), 'off');
figure; [cco, mco, hco] = multcompare(co_stats);
