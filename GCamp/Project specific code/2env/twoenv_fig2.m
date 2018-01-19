% 2env Figure 2

%% Load data if required
load(fullfile(ChangeDirectory_NK(G30_square(1),0),...
    '2env_batch_analysis4_workspace_1000shuffles_2018JAN11.mat'));

sesh_type = {'square','circle','circ2square'};

%% Keep limits the same for tuning curves
tuning_ylim = [-0.7 0.7];

% Paper positions - will need to scale by ~42% in illustrator after - I'm
% sure there is a better way
paper_pos = [2204 192 600 400]; % for square and circle
paper_pos2 = [2204 192 285 200]; % for circ2square

num_comps = [28 28 64];
% Note that you will need to adjust the histogram y-axes individually
%% Square coherency plot - Distal 

animal_use = 2;
rot_type = 'square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 1; % must be square if circ2square
sesh2 = 6; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 50])

figure(hh(2))
subplot(2,2,4)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off

printNK('Square Coherency Example - Distal G31','2env')

%% Square coherency plot2 - Distal 

animal_use = 1;
rot_type = 'square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 3; % must be square if circ2square
sesh2 = 4; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 300])

figure(hh(2))
subplot(2,2,4)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off

printNK('Square Coherency Example 2 - Distal G30','2env')

%% Circle coherency plot - Local
animal_use = 3;
rot_type = 'circle'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 1; % must be square if circ2square
sesh2 = 2; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)

figure(hh(2))
subplot(2,2,4)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off

printNK('Circle Coherency Example - Local G45','2env')

%% Circle coherency plot - Other
animal_use = 4;
rot_type = 'circle'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 1; % must be square if circ2square
sesh2 = 2; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)

figure(hh(2))
subplot(2,2,4)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off

printNK('Circle Coherency Example - Other G48','2env')

%% Circ2square remapping plot
animal_use = 1;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 7; % must be square if circ2square
sesh2 = 5; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 20])

figure(hh(2))
printNK('Circ2square Remapping Example - G30','2env','append',true)
figure; set(gcf,'Position',hh(2).Position)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off
printNK('Circ2square Remapping Example - G30','2env','append',true)

%% Circ2square Coherent plot
animal_use = 4;
rot_type = 'circ2square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 5; % must be square if circ2square
sesh2 = 5; % must be circle if circ2square
if strcmpi(rot_type, 'circ2square')
    sesh_use = cat(2, Mouse(animal_use).sesh.square(sesh1),...
        Mouse(animal_use).sesh.circle(sesh2));
    base_sesh = Mouse(animal_use).sesh.square(1);
else
    sesh_use = Mouse(animal_use).sesh.(rot_type)([sesh1 sesh2]);
    base_sesh = Mouse(animal_use).sesh.(rot_type)(1);
end
sig_values_comb = cat(3, Mouse(animal_use).coherency.(rot_type).pmat,...
    Mouse(animal_use).global_remap_stats.(rot_type).shuf_test.p_remap);
sig_value_use = max(sig_values_comb,[],3);
sig_value_use = sig_value_use([sesh1 sesh2], [sesh1 sesh2]);
sig_star = sig_value_use < alpha/num_comps(k); % Determine significance

[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(sesh_use, rot_type,...
    'num_shuffles', 1000, 'local_ref', false, 'sig_star', sig_star,...
    'sig_value', sig_value_use, 'map_session', base_sesh);
arrayfun(@(a) set(a, 'Position', paper_pos2), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
set(hh(1).Children,'YLim',tuning_ylim)
set(hh(2).Children,'YLim',[0 50])

figure(hh(2))
printNK('Circ2square Coherency Example - G48','2env','append',true)
figure; set(gcf,'Position',hh(2).Position)
text(0.1,0.7, ['Shuffle test pval = ' num2str(Mouse(animal_use)...
    .global_remap_stats.(rot_type).shuf_test.p_remap(sesh1,sesh2))])
text(0.1,0.5, ['chi2stat = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).chi2stat(sesh1,sesh2))])
text(0.1,0.3, ['chi2 pval = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).pmat(sesh1,sesh2))])
text(0.1,0.1, ['chi2 df = ' num2str(Mouse(animal_use).coherency...
    .(rot_type).df)])
axis off
printNK('Circ2square Coherency Example - G48','2env','append',true)

%% Make Coherency and Rotation Breakdown Plot
rot_type = {'rotation','no_rotation'}; rot_text = {'Rotation', 'No Rotation'};
breakdown_type = {'Full', 'Simple'};
colors = [0.2081 0.1663 0.5292; 0.9763 0.9831 0.0538; 0.2178 0.7250 0.6193];

figure(18)
set(gcf,'Position', [2208 130 1060 659])
group_means = nan(4,3,2); % # mice x # comp_types x # rot_type
for m = 1:length(rot_type)
    
    %%% Full Breakdown %%%
    subplot(2, 2, (m-1)*2 + 1)
    
    % Assemble Matrices
    square_mean = mean(All.ratio_plot_all2.(rot_type{m}).square,1);
    circle_mean = mean(All.ratio_plot_all2.(rot_type{m}).circle,1);
    circ2square_mean = mean(All.ratio_plot_all2.(rot_type{m}).circ2square,1);
    
    h = bar(1:length(align_type),[square_mean', circle_mean', circ2square_mean']);
    for j = 1:length(h)
        set(h(j),'FaceColor',colors(j,:));
    end
    set(gca,'XTickLabel',align_text)
    legend('Within square', 'Within circle', 'Square to Circle')
    xlabel('Remapping Type')
    ylabel('Proprotion of Comparisons')
    
    % Now do each mouse
    compare_type = {'square','circle','circ2square'};
    hold on
    for j = 1:length(compare_type)
%         plot(repmat(h(j).XData + h(j).XOffset, num_animals,1),...
%             All.ratio_plot_all2.(rot_type{m}).(compare_type{j}),'ko')
        xplot = repmat(h(j).XData + h(j).XOffset, num_animals,1);
        xplot = xplot + randn(size(xplot))*0.01; % jitter x points
        yplot = All.ratio_plot_all2.(rot_type{m}).(compare_type{j});
        hs = scatter(xplot(:),yplot(:));
        set(hs,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor','k');
        
    end
    hold off
    if m == 2
        set(gca,'XTickLabel', {'', 'Coherent - Local/Distal Cues', 'Coherent - Other', 'Global Remapping'})
    end
    title([rot_text{m} ' - ' breakdown_type{1} ' Breakdown'])
    
    %%% Simple Breakdown %%%
    subplot(2, 2, (m-1)*2 + 2)
    
    % Assemble matrices
    square_mean2 = mean([sum(All.ratio_plot_all2.(rot_type{m}).square(:,1:3),2) ...
        All.ratio_plot_all2.(rot_type{m}).square(:,4)]);
    circle_mean2 = mean([sum(All.ratio_plot_all2.(rot_type{m}).circle(:,1:3),2) ....
        All.ratio_plot_all2.(rot_type{m}).circle(:,4)]);
    circ2square_mean2 = mean([sum(All.ratio_plot_all2.(rot_type{m}).circ2square(:,1:3),2) ....
        All.ratio_plot_all2.(rot_type{m}).circ2square(:,4)]);
    
    % Plot
    h = bar(1:2,[square_mean2', circle_mean2', circ2square_mean2']);
    for j = 1:length(h)
        set(h(j),'FaceColor',colors(j,:));
    end
    set(gca,'XTickLabel',cellfun(@mouse_name_title,{'Coherent','Global Remapping'},'UniformOutput',0))
    legend('Within square', 'Within circle', 'Square to Circle')
    xlabel('Remapping Type')
    ylabel('Proprotion of Comparisons')
    
    % Now do each mouse
    compare_type = {'square','circle','circ2square'};
    hold on
    for j = 1:length(compare_type)
        plot_mat = [sum(All.ratio_plot_all2.(rot_type{m}).(compare_type{j})(:,1:3),2) ...
            All.ratio_plot_all2.(rot_type{m}).(compare_type{j})(:,4)];
        plot_mat2 = plot_mat./sum(plot_mat,2); % Hack to fix an error above where I'm dividing by the wrong number to get my ratios - need to fix later
%         plot(repmat(h(j).XData + h(j).XOffset, num_animals,1),...
%             plot_mat2,'ko')
        xplot = repmat(h(j).XData + h(j).XOffset, num_animals,1);
        xplot = xplot + randn(size(xplot))*0.02;
        hs = scatter(xplot(:),plot_mat2(:));
        set(hs,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor','k');
        group_means(:,j,m) = plot_mat2(:,1);
    end
    hold off

    title([rot_text{m} ' - ' breakdown_type{2} ' Breakdown'])

end

make_figure_pretty(gcf)

%% Do stats on above

% Pull out variables
g1 = group_means(:,1,:); % circle
g2 = group_means(:,2,:); % square
g3 = group_means(:,3,:); % circ2square

% Run ranksum on all 3 combos
[p12all,h12all] = ranksum(g1(:),g2(:),'tail','both');
[p13all,h13all] = ranksum(g1(:),g3(:),'tail','right');
[p23all,h23all] = ranksum(g2(:),g3(:),'tail','right');
[p12rot,h12rot] = ranksum(g1(:,:,1),g2(:,:,1),'tail','both');
[p13rot,h13rot] = ranksum(g1(:,:,1),g3(:,:,1),'tail','right');
[p23rot,h23rot] = ranksum(g2(:,:,1),g3(:,:,1),'tail','right');
[p12nrot,h12nrot] = ranksum(g1(:,:,2),g2(:,:,2),'tail','both');
[p13nrot,h13nrot] = ranksum(g1(:,:,2),g3(:,:,2),'tail','right');
[p23nrot,h23nrot] = ranksum(g2(:,:,2),g3(:,:,2),'tail','right');


