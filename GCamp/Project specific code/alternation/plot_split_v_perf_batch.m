function [glm_notime, glm_noperf, glm_both ] = ...
    plot_split_v_perf_batch( MD, max_sesh_num, ha_perf, ha_time  )
% [glm_notime, glm_noperf, glm_both ] = ...
%   plot_split_v_perf_batch( MD, max_sesh_num, ha_perf, ha_time )
%   Plots all sessions in MD, breaking out each mouse by color.
%   max_sesh_num indicates the maximum number of sessions to use for
%   calculating statistical significance (NOTE: ALL SESSSION WILL STILL BE
%   PLOTTED).

colors_use = {'r', 'g', 'b', 'c'};

%% Parse out animals
% unique_names = unique(arrayfun(@(a) a.Animal,MD,'UniformOutput',false));
% animal_ind = arrayfun(@(a) find(strcmpi(a.Animal,unique_names)),MD);
[unique_names,~,~,temp] = get_unique_values(MD);
animal_ind = temp(:,1)';
num_animals = length(unique_names);

%% Plot stuff
if nargin < 4
    figure;
    set(gcf,'Position',[2160 400 1240 520]);
    ha_perf = subplot(1,2,1);
    ha_time = subplot(1,2,2);
    if nargin < 2
        max_sesh_num = [];
    end
end

% Don't plot if both axes handles are set to NaN
plot_flag = true;
if isnan(ha_perf) && isnan(ha_time)
    plot_flag = false;
end

perf_all = [];
split_prop_all = [];
time_from_start_all = [];
for j = 1:num_animals
    % Get all the required info
    MD_use = MD(animal_ind == j);
    [ perf, split_prop, ~, acclim_bool, forced_bool ] = ...
        get_split_v_perf(MD_use);
    legit_bool = ~acclim_bool & ~forced_bool;
    
    if plot_flag
        % Plot everything
        [ha_perf, hpts(j) ] = plot_split_v_perf(perf, split_prop, acclim_bool, ...
            forced_bool, ha_perf, false);
        title(mouse_name_title(MD_use(1).Animal));
        hold on
        hpts(j).Color = colors_use{j};
        xlim([0 1])
    end
    
    % Get time of each session
    datenums = arrayfun(@(a) datenum(a.Date), MD_use) ...
        + arrayfun(@(a) a.Session == 2,MD_use)*0.5;
    time_from_start = datenums'-datenums(1);
    
    % Aggregate legit data
    if isempty(max_sesh_num)
        perf_all = [perf_all; perf(legit_bool)];
        split_prop_all = [split_prop_all; split_prop(legit_bool)];
        time_from_start_all = [time_from_start_all; time_from_start(legit_bool)];
    elseif ~isempty(max_sesh_num)
        % Randomly sub-sample sessions to match max_sesh_num
        legit_ind = find(legit_bool);
        nlegit = length(legit_ind);
        subsample_ind = legit_ind(sort(randperm(nlegit,...
            min(max_sesh_num,nlegit))));
        
        % Aggregate sub-sampled data only
        perf_all = [perf_all; perf(subsample_ind)];
        split_prop_all = [split_prop_all; split_prop(subsample_ind)];
        time_from_start_all = [time_from_start_all; time_from_start(subsample_ind)];
    end
    if plot_flag
        axes(ha_time)
        hpts2(j) = plot(time_from_start(legit_bool), split_prop(legit_bool), 'o');
        title(mouse_name_title(MD_use(1).Animal));
        xlabel('Time from start (days)'); ylabel('Splitter Cell Proportion')
        xlim([-1, round(max(time_from_start)) + 1])
        hold on
    end
    
end

if num_animals > 1 && plot_flag
    try
        legend(hpts,cellfun(@mouse_name_title,unique_names,'UniformOutput',false),...
            'Location','northwest')
        legend(hpts2,cellfun(@mouse_name_title,unique_names,'UniformOutput',false),...
            'Location','northwest')
    catch
        keyboard
    end
    axes(ha_perf)
    title('Multiple Mice')
    axes(ha_time)
    title('Multiple Mice')
end

%% Run linear regression
glm_notime = fitglm(perf_all, split_prop_all,'VarNames', ...
    {'perf', 'prop_split'});
glm_noperf = fitglm(time_from_start_all, split_prop_all, 'VarNames', ...
    {'time', 'prop_split'});
glm_both = fitglm([perf_all, time_from_start_all], split_prop_all, ...
    'VarNames', {'perf', 'time', 'prop_split'});
% [rho,pval] = corr(perf_all,split_prop_all,'type','Spearman');

% Plot regression lines and stats
if plot_flag
    axes(ha_perf)
    hold on
    ypred = feval(glm_notime,0:0.01:1);
    plot(0:0.01:1, ypred,'k-')
    ylims = get(gca,'YLim');
    xtext = 0.5; ytext = feval(glm_notime,xtext);
    htext = text(xtext-0.04,ytext,...
        ['pperf only = ' num2str(glm_notime.Coefficients.pValue(2),'%0.3g')]);
    htext2 = text(xtext-0.04,ytext+0.04,...
        ['pperf w/time = ' num2str(glm_both.Coefficients.pValue(3),'%0.3g')]);
    htext.HorizontalAlignment = 'right';
    set(gca,'XLim',[0 1],'YLim',ylims);
    make_plot_pretty(gca);
    hold off
    
    axes(ha_time)
    hold on
    ypred = feval(glm_noperf,0:1:(max(time_from_start_all)+1));
    plot(0:1:(max(time_from_start_all)+1), ypred,'k-')
    ylims = get(gca,'YLim');
    xtext = 0.5; ytext = feval(glm_notime,xtext);
    htext = text(xtext-0.04,ytext,...
        ['ptime only = ' num2str(glm_noperf.Coefficients.pValue(2),'%0.3g')]);
    htext2 = text(xtext-0.04,ytext+0.04,...
        ['ptime w/perf = ' num2str(glm_both.Coefficients.pValue(3),'%0.3g')]);
    htext.HorizontalAlignment = 'right';
    set(gca,'XLim',[-1, round(max(time_from_start)) + 1],'YLim',ylims);
    make_plot_pretty(gca);
    hold off
end

end

