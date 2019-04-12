function [ ha, hpts] = plot_split_v_perf(perf, split_prop, acclim_bool, ...
    forced_bool, ha, linreg)
% [ha, hpts, split_prop, legit_bool] = plot_split_v_perf(perf, split_prop, ...
%   acclim_bool, forced_bool, ha, linreg)
%   Plots splitters versus performance. Use data from get_split_v_perf.
%   linreg = true plots a line of best fit (from a linear regression) and 
%   displays stats on the plot

% Create a new plot if not specified
if nargin < 2
    figure;
    set(gcf,'Position',[1070 250 700 600]);
    ha = gca;
end
axes(ha)

legit_bool = ~acclim_bool & ~forced_bool;
hpts = plot(perf(legit_bool), split_prop(legit_bool),'o');
xlabel('Performance'); ylabel('Splitter Cell Proportion')

hold on
hacclim = plot(perf(acclim_bool), split_prop(acclim_bool),'x');
hforced = plot(perf(forced_bool), split_prop(forced_bool),'*');
hcomb = cat(1,hpts,hacclim,hforced);
hbool = [~isempty(hpts); ~isempty(hacclim); ~isempty(hforced)];
legend_text = {'Free', 'Acclimation', 'Forced'};
legend(hcomb, legend_text(hbool), 'Location', 'Northwest')

%% Fit line to legit data points & get correlation
if linreg
    glm = fitglm(perf(legit_bool),split_prop(legit_bool));
    [rho,pval] = corr(perf(legit_bool),split_prop(legit_bool),'type','Spearman');
    keyboard
end


end

