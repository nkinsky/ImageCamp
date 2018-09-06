function [ ] = plot_split_v_perf_batch( MD, ha )
% plot_split_v_perf_batch(MD)
%   Plots all sessions in MD, breaking out each mouse by color

colors_use = {'r', 'g', 'b', 'c'};

%% Parse out animals
% unique_names = unique(arrayfun(@(a) a.Animal,MD,'UniformOutput',false));
% animal_ind = arrayfun(@(a) find(strcmpi(a.Animal,unique_names)),MD);
[unique_names,~,~,temp] = get_unique_values(MD);
animal_ind = temp(:,1)';
num_animals = length(unique_names);

%% Plot stuff
if nargin < 2
    figure
    set(gcf,'Position',[1070 250 700 600]);
    ha = gca;
end
perf_all = [];
split_prop_all = [];
for j = 1:num_animals
    % Get all the required info
    MD_use = MD(animal_ind == j);
    [ perf, split_prop, ~, acclim_bool, forced_bool ] = ...
        get_split_v_perf(MD_use);
    legit_bool = ~acclim_bool & ~forced_bool;
    
    % Plot everything
    [ha, hpts(j) ] = plot_split_v_perf(perf, split_prop, acclim_bool, ...
        forced_bool, ha, false);
    title(mouse_name_title(MD_use(1).Animal));
    hold on
    hpts(j).Color = colors_use{j};
    
    % Aggregate legit data
    perf_all = [perf_all; perf(legit_bool)];
    split_prop_all = [split_prop_all; split_prop(legit_bool)];
    
end
hold off
xlim([0 1])
if num_animals > 1
    legend(hpts,cellfun(@mouse_name_title,unique_names,'UniformOutput',false),...
        'Location','northwest')
    title('Multiple Mice')
end

%% Run linear regression
glm = fitglm(perf_all,split_prop_all);
% [rho,pval] = corr(perf_all,split_prop_all,'type','Spearman');
hold on
ypred = feval(glm,get(gca,'XLim'));
plot([0 1], ypred,'k-')
ylims = get(gca,'YLim');
xtext = 0.5; ytext = feval(glm,xtext);
htext = text(xtext-0.04,ytext,...
    ['p = ' num2str(glm.Coefficients.pValue(2),'%0.3g')]);
htext.HorizontalAlignment = 'right';
set(gca,'XLim',[0 1],'YLim',ylims);
make_plot_pretty(gca);

end

