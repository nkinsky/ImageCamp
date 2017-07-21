function [ ] = twoenv_corrvSI( Mouse_var, sesh1_ind, sesh2_ind, comp_type, ...
    metric, plot_type)
% twoenv_corrvSI( Mouse_var, sesh1_ind, sesh2_ind, comp_type, metric, plot_type)
%   Plot corr between sesh1 and sesh2 vs spatial info metric (metric = 1:
%   use pval, metric = 2: use MI
%
%   plot_type: 1 = plot metric1 v metric2 v corr, 2 = plot mean of
%   metric1 & metric2 v corr, 3 = plot 45 degree projection vs corr

if nargin < 6
    plot_type = 1; % default = 3d plot
end
%% Get appropriate sessions
if strcmpi(comp_type,'circ2square')
    square_ind = [1 2 7 8 9 12 13 14];
    circ_ind = [3 4 5 6 10 11 15 16];
    sesh{1} = Mouse_var.sesh.(comp_type)(square_ind(sesh1_ind));
    sesh{2} = Mouse_var.sesh.(comp_type)(circ_ind(sesh2_ind));
    sesh{1}.arena = 'square';
    sesh{2}.arena = 'circle';
    file_load = 'Placefields_trans_rot0.mat';
else
    sesh{1} = Mouse_var.sesh.(comp_type)(sesh1_ind);
    sesh{2} = Mouse_var.sesh.(comp_type)(sesh2_ind);
    sesh{1}.arena = comp_type;
    sesh{2}.arena = comp_type;
    file_load = 'Placefields_rot0.mat';
end

%% Get correlations to use
corr_mat_use = Mouse_var.corr_mat.(comp_type);
if strcmpi(comp_type,'circ2square')
    corr_mat_use = twoenv_squeeze(corr_mat_use);
end

corrs_use = corr_mat_use{sesh1_ind,sesh2_ind};

%% Get p-values or SI to use
for  j = 1:2
    dir_use = ChangeDirectory_NK(sesh{j},0);
    if metric == 1
        load(fullfile(dir_use,file_load),'pval');
        sesh{j}.info_metric = pval;
        sesh{j}.num_neurons = length(pval);
        metric_use = 'pval';
    elseif metric == 2
        load(fullfile(dir_use,file_load),'MI');
        sesh{j}.info_metric = MI;
        sesh{j}.num_neurons = length(MI);
        metric_use = 'MI';
    end
end

%% Register neurons from sesh2 to sesh1
base_dir = ChangeDirectory_NK(Mouse_var.sesh.(comp_type)(1),0);
if strcmpi(comp_type,'circ2square')
    load(fullfile(base_dir,'batch_session_map_trans.mat'));
    neuron_map = get_neuronmap_from_batchmap(batch_session_map, ...
        square_ind(sesh1_ind), circ_ind(sesh2_ind));
else 
    load(fullfile(base_dir,'batch_session_map.mat'));
    neuron_map = get_neuronmap_from_batchmap(batch_session_map, sesh1_ind, ...
        sesh2_ind);
end

%% Assign stuff
% sesh1_only = find(neuron_map == 0); % Sesh1 only neurons
% sesh2_only = find(~arrayfun(@(a) any(a == neuron_map),1:sesh{j}.num_neurons)); % sesh2 only neurons
both1 = find(neuron_map ~= 0 & ~isnan(neuron_map));
both2 = neuron_map(both1);

% Assign full vector for neurons active in both sessions
info1 = sesh{1}.info_metric(both1);
info2 = sesh{2}.info_metric(both2);
corr_plot = corrs_use(both1);

figure
subplot(3,3,[1:2 4:5])
switch plot_type
    case 1
        plot3(info1,info2,corr_plot,'.')
        xlabel({['A - ' mouse_name_title(sesh{1}.Date) ' - s' num2str(sesh{1}.Session) ...
            ': ' metric_use], sesh{1}.arena})
        ylabel({['B - ' mouse_name_title(sesh{2}.Date) ' - s' num2str(sesh{2}.Session) ...
            ': ' metric_use], sesh{2}.arena})
        zlabel('TMap correlation')
    case 2
        plot(mean([info1 info2],2), corr_plot, '.')
        xlabel(['Mean ' metric_use '(' ...
            mouse_name_title(sesh{1}.Date) ' - s' num2str(sesh{1}.Session) ...
            ' & ' mouse_name_title(sesh{2}.Date) ' - s' num2str(sesh{2}.Session) ')']);
        ylabel('TMap correlation')
    case 3
        [~, y45] = proj45(info1, info2);
        plot(y45, corr_plot, '.')
        xlabel(['45 projection of ' metric_use '(' ...
            mouse_name_title(sesh{1}.Date) ' - s' num2str(sesh{1}.Session) ...
            ' & ' mouse_name_title(sesh{2}.Date) ' - s' num2str(sesh{2}.Session) ')']);
        ylabel('TMap correlation')
    otherwise
        error('plot_type needs to be either 1, 2, or 3')
end
title(mouse_name_title(sesh{1}.Animal))

subplot(3,3, 7:8)
histogram(sesh{1}.info_metric, 30);
xlabel({metric_use, 'Session A'}); ylabel('Count');

subplot(3,3,[3 6])
histogram(sesh{2}.info_metric, 30);
xlabel({metric_use, 'Session B'}); ylabel('Count');

subplot(3,3,9)
hist45(sesh{1}.info_metric, sesh{2}.info_metric, 30);
xlabel({metric_use, 'Session A-B projected'}); ylabel('Count');

end

