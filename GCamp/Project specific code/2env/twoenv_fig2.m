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

%% Square coherency plot2 - Distal with arena rotated

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

printNK('Square Coherency Example 2 - Distal G30 Arena Rotated','2env')

%% Square coherency plot3 - No arena rotated

animal_use = 2;
rot_type = 'square'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 3; % must be square if circ2square
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

printNK('Square Coherency Example 3 - G31 LocalDistal No Rotation','2env')

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

%% Circle coherency plot 3 - Other
animal_use = 3;
rot_type = 'circle'; % see sesh_type above
k = find(cellfun(@(a) strcmpi(rot_type,a),sesh_type));
sesh1 = 3; % must be square if circ2square
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

printNK('Circle Coherency Example - G45 No rotation','2env')

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

% Run ranksum on all 3 combos - just do a kw test!!!
[p12all,h12all] = ranksum(g1(:),g2(:),'tail','both');
[p13all,h13all] = ranksum(g1(:),g3(:),'tail','right');
[p23all,h23all] = ranksum(g2(:),g3(:),'tail','right');
[p12rot,h12rot] = ranksum(g1(:,:,1),g2(:,:,1),'tail','both');
[p13rot,h13rot] = ranksum(g1(:,:,1),g3(:,:,1),'tail','right');
[p23rot,h23rot] = ranksum(g2(:,:,1),g3(:,:,1),'tail','right');
[p12nrot,h12nrot] = ranksum(g1(:,:,2),g2(:,:,2),'tail','both');
[p13nrot,h13nrot] = ranksum(g1(:,:,2),g3(:,:,2),'tail','right');
[p23nrot,h23nrot] = ranksum(g2(:,:,2),g3(:,:,2),'tail','right');

%% Figure 2b/c: Coherent Event Rate Maps Across Days
plot_local_aligned = 0; % true = plot with local cues aligned, false = as presented to mouse

% For figure 2c square - four example cells across days in each corner of square
% sesh_use = cat(2,G45_square([1:4, 7]),G45_oct(1)); 
% base_sesh = G45_square(1); 
% num_cols = length(sesh_use);
% best_angle_use = G45_both_best_angle([1 2 7 8 13 3]); 
% good_ind = [50 128 602 268]; 
% num_rows = length(good_ind);

% for figure 2e octagon
sesh_use = G30_oct([3 4]);
base_sesh = G30_square(1); 
num_cols = length(sesh_use);
best_angle_use = G30_circle_best_angle(3:4);
good_ind = [62 92 65 67]; 
num_rows = length(good_ind);

% For figure 2b - 3 example cells for calculating angles
% sesh_use = G30_square([1 6 7]); 
% base_sesh = G30_square(1);
% num_cols = length(sesh_use);
% best_angle_use = G30_square_best_angle([1 6 7]);
% good_ind = [27 90 156];
% num_rows = length(good_ind);

[base_dir, base_sesh_full] = ChangeDirectory_NK(base_sesh,0);
load(fullfile(base_dir,'batch_session_map.mat'));
batch_session_map_win = batch_session_map;
try
    load(fullfile(base_dir,'batch_session_map_trans.mat'));
    base_index = match_session(batch_session_map.session, base_sesh);
catch
    disp('no _trans map found')
end

% Assemble cells to plot
PF_plot = cell(1,length(sesh_use));
for j = 1:length(sesh_use)
    dirstr = ChangeDirectory_NK(sesh_use(j),0);
    if plot_local_aligned == 0
        [~, rot] = get_rot_from_db(sesh_use(j));
    elseif plot_local_aligned == 1
        rot = 0;
    elseif plot_local_aligned == 2
        rot = best_angle_use(j);
    end
    load(fullfile(dirstr,['Placefields_rot' num2str(rot) '.mat']),'TMap_gauss');
    sesh_use(j).tmap = TMap_gauss;
    sesh_use(j).nanmap = TMap_gauss{1};
    sesh_use(j).nanmap(~isnan(TMap_gauss{1})) = 0;
    sesh_use(j).sesh_index = match_session(batch_session_map.session, sesh_use(j));
    sesh_use(j).rot = rot;
end
sparse_map = batch_session_map.map(:,arrayfun(@(a) a.sesh_index, sesh_use)+1); % get map for just the 4 days in question
% Uncomment here to scroll through all good cells
% good_ind = find(sum(sparse_map ~= 0 & ~isnan(sparse_map),2) == num_cols); % neurons active on all 4 days
% num_rows = 4;

figure; set(gcf,'Position',[2100 20 750 875]);

neurons_plot = 1:num_rows;
base_dir = ChangeDirectory_NK(sesh_use(1),0);
for m = 1:(floor(length(good_ind)/num_rows))
    for k = 1:length(sesh_use)
        map_use = get_neuronmap_from_batchmap(batch_session_map.map, ...
            base_index, sesh_use(k).sesh_index);
        %%% Run Correlation Analysis to eventually put into the plot? %%%
%         if k > 1 
%             [~, sesh_use_full] = ChangeDirectory_NK(sesh_use(k),0);
%             if regexpi(base_sesh_full.Env,'square') && regexpi(sesh_use_full.Env,'square') 
%                 batch_map_use = batch_session_map_win;
%                 rot_array = 0:90:270;
%                 trans = false;
%             elseif regexpi(base_sesh_full.Env,'octagon') && regexpi(sesh_use_full.Env,'octagon')
%                 batch_map_use = batch_session_map_win;
%                 rot_array = 0:15:345;
%                 trans = false;
%             else
%                 batch_map_use = batch_session_map;
%                 rot_array = 0:15:345;
%                 trans = true;
%             end
%             corr_mat = corr_rot_analysis( sesh_use(1), sesh_use(k), batch_map_use, ...
%                 rot_array, 'trans', trans);
%         end
        for j = 1:length(neurons_plot)
            neuron_use = map_use(good_ind(neurons_plot(j)));
%             corr_use = 
            subplot(num_rows + 1, num_cols, num_cols*(j-1)+k)
            if isnan(neuron_use)
                title('Sketchy neuron mapping')
            elseif neuron_use == 0
                imagesc_nan(rot90(sesh_use(k).nanmap,1));
                title('Neuron not active')
            elseif neuron_use > 0
                if sum(isnan(sesh_use(k).tmap{neuron_use}(:))) == length(sesh_use(k).tmap{neuron_use}(:)) % edge case where bug in Placefields has cause TMap_gauss to be all NaNs
                    imagesc_nan(rot90(sesh_use(k).nanmap,1));
                else
                    imagesc_nan(rot90(sesh_use(k).tmap{neuron_use},1));                    
                end
%                 if k == 1 % only label neuron in first session
                       title({['Neuron ' num2str(neuron_use)], ['Rot = ' ...
                           num2str(sesh_use(k).rot)]})
%                 elseif j == 1 && k ~= 1
%                     title(['Rot = ' num2str(sesh_use(k).rot)])
%                 end
            end
%             axis equal 
            axis tight
            axis off
            ylabel(num2str(good_ind(neurons_plot(j))))
            try
            if j == 1
                dirstr = ChangeDirectory_NK(sesh_use(k),0);
                load(fullfile(dirstr,'FinalOutput.mat'),'NeuronImage');
                reg_filename = fullfile(base_dir,['RegistrationInfo-' sesh_use(k).Animal '-' sesh_use(k).Date '-session' num2str(sesh_use(k).Session) '.mat']);
                load(reg_filename);
                if neuron_use ~= 0 && ~isnan(neuron_use)
                    ROI_reg = imwarp_quick(NeuronImage{neuron_use}, RegistrationInfoX);
                    b = bwboundaries(ROI_reg,'noholes');
                    
                    subplot(num_rows + 1, num_cols, num_cols*num_rows+k)
                    plot(b{1}(:,2),b{1}(:,1));
                    if k == 1
                        cent_ROI = mean(b{1},1);
                        xlims = [cent_ROI(2) - 15, cent_ROI(2) + 15];
                        ylims = [cent_ROI(1) - 15, cent_ROI(1) + 15];
                    end
                    xlim(xlims); ylim(ylims);
                elseif neuron_use == 0 || isnan(neuron_use)
                    subplot(num_rows + 1, num_cols, num_cols*num_rows+k)
                    text(0.1,0.5,'Bad Neuron Mapping - no ROI out')
                end
%                 axis equal
                axis tight
                axis off
            end
            catch
                disp('Some error in plotting ROIs')
            end
                
        end

    end
    neurons_plot = (max(neurons_plot)+1):(max(neurons_plot)+num_rows);
    waitforbuttonpress
end

% Plot figure showing neuron outlines from above
ncolors = [1 0 0; 0 1 0; 0 0 1; 1 0 1]; % Plot example neurons as r g b cyan
ncolors = resize(ncolors, [length(good_ind), 3]); % Add in more intermediate colors if needed
figure; set(gcf,'Position',[2500 150 950 770])
h = gca;
load(fullfile(base_dir,'FinalOutput.mat'),'NeuronImage')
hall = plot_neuron_outlines(nan,NeuronImage,h,'colors',[0.5 0.5 0.5]);
hold on
[~, ~, hneuron] = plot_neuron_outlines(nan,NeuronImage(good_ind((end-3):end)),hall,...
    'colors', ncolors, 'scale_bar', false);
legend(hneuron,arrayfun(@(a) ['Neuron ' num2str(a)], ...
    good_ind,'UniformOutput',false))
axis tight

%% Get rotation angles for 2b
neurons_get67 = [27 90 156];
load(fullfile(ChangeDirectory_NK(G30_square(1),0),'batch_session_map'));
[delta_angle, ~, ~, angles67, ~, neuronid] = get_PF_angle_delta(...
    G30_square(6), G30_square(7),batch_session_map,'TMap_gauss',1,false,...
    false,0);
inds_use67 = arrayfun(@(a) find(a == neuronid(:,1)),neurons_get12);
delta_angles67 = delta_angle(inds_use67)-360

%% Get rotation angles for 2c
neurons_get12 = [50 128 602 268];
load(fullfile(ChangeDirectory_NK(G45_square(1),0),'batch_session_map'));
[delta_angle, ~, ~, angles12, ~, neuronid] = get_PF_angle_delta(...
    G45_square(1),G45_square(2),batch_session_map,'TMap_gauss',1,false,...
    false,0);
inds_use12 = arrayfun(@(a) find(a == neuronid(:,1)),neurons_get12);
delta_angles12 = delta_angle(inds_use12)-360

neurons_get34 = [40 181 233 260];
load(fullfile(ChangeDirectory_NK(G45_square(1),0),'batch_session_map'));
[delta_angle, ~, ~, angles34, ~, neuronid] = get_PF_angle_delta(...
    G45_square(3),G45_square(4),batch_session_map,'TMap_gauss',1,false,...
    false,0);
inds_use34 = arrayfun(@(a) find(a == neuronid(:,1)),neurons_get34);
delta_angles34 = delta_angle(inds_use34)-360

neurons_get34b = [182 95 262 140];
load(fullfile(ChangeDirectory_NK(G30_oct(1),0),'batch_session_map'));
[delta_angle, ~, ~, angles34b, ~, neuronid] = get_PF_angle_delta(...
    G30_oct(3),G30_oct(4),batch_session_map,'TMap_gauss',1,false,...
    false,0);
inds_use34b = arrayfun(@(a) find(a == neuronid(:,1)),neurons_get34b);
delta_angles34b = delta_angle(inds_use34b)-360

%% Plot center-out square-square and octagon-octagon histograms

[~, delta_mean_s, ~, ps, ~, coh_ratio_s] = plot_delta_angle_hist(...
    G45_square(1), G45_square(2), G45_square(1), 'TMap_type', 'TMap_gauss',...
    'bin_size', 1, 'nshuf', 1000);
ylims = get(gca,'YLim');
make_plot_pretty(gca,'linewidth',1,'fontsize',14)
set(gca,'YLim',ylims,'YTick',0:60:120)
printNK('Square to square center out histo','2env')

[~, delta_mean_o, ~, po, ~, coh_ratio_o] = plot_delta_angle_hist(...
    G30_oct(3), G30_oct(4), G30_oct(1), 'TMap_type', 'TMap_gauss',...
    'bin_size', 1, 'nshuf', 1000);
ylims = get(gca,'YLim');
make_plot_pretty(gca,'linewidth',1,'fontsize',14)
set(gca,'YLim',ylims,'YTick',0:50:100)
printNK('Octagon to octagon center out histo','2env')

%% Coh v Glob remapping breakdown: See twoenv_mismatch_hist

%% numbers and ratios of coh vs remapping neurons: see two_env_on_off

%% Make plot of mean ratio of coherent cells vs coh_ang_thresh
ang_plot = [15 22.5 30 45];
coh_ratio_means = nan(8,length(ang_plot),2); % mice/arena x angles x PCfilt
pcoh = nan(2,4);
for m = 0:1
    for j = 1:length(ang_plot)
        file_load = fullfile(ChangeDirectory_NK(G30_square(1),0),...
            ['2env_popstats_coh' num2str(round(ang_plot(j))) ...
            '_shuf1000_PCfilt_' num2str(m) '-2018-05-22.mat']);
        load(file_load)
        
        % count coh ratio
        sq_means_all = reshape(coh_ratio_sq,4,[]);
        oct_means_all = reshape(coh_ratio_oct,4,[]);
        means_comb_all = cat(1, sq_means_all, oct_means_all);
        coh_ratio_means(1:4,j,m+1) = nanmean(sq_means_all,2);
        coh_ratio_means(5:8,j,m+1) = nanmean(oct_means_all,2);
        pcoh(m+1,j) = signtest(means_comb_all(:), ang_plot(j)/180, ...
            'tail', 'right');
                
    end
end

try close(457); end
figure(457); set(gcf,'Position', [531 220 1069 649]);

subplot(1,2,1)
errorbar(1:4, mean(squeeze(coh_ratio_means(:,:,1))), ...
    std(squeeze(coh_ratio_means(:,:,1)))/sqrt(8));
hold on
hch = plot(1:4,ang_plot/180,'k--');
text(1, 0.7, ['p_{signtest,max} = ' num2str(max(pcoh(1,:)), '%0.2g')]);
xlim([0.5 4.5]); ylim([0, 0.8])
legend(hch,'Chance')
xlabel('Coh. Ang. Cutoff (+/-)');
ylabel('Proportion of Neurons')
set(gca,'XTick',1:4,'XTickLabel', arrayfun(@(a) num2str(a,'%0.1f'),...
    ang_plot, 'UniformOutput', false))
title('PCfilter = false')
make_plot_pretty(gca)

subplot(1,2,2)
errorbar(1:4, mean(squeeze(coh_ratio_means(:,:,2))), ...
    std(squeeze(coh_ratio_means(:,:,2)))/sqrt(8));
hold on
hch = plot(1:4,ang_plot/180,'k--');
text(1, 0.7, ['p_{signtest,max} = ' num2str(max(pcoh(2,:)), '%0.2g')]);
xlim([0.5 4.5]); ylim([0, 0.8])
legend(hch,'Chance')
xlabel('Coh. Ang. Cutoff (+/-)');
ylabel('Proportion of Neurons')
set(gca,'XTick',1:4,'XTickLabel', arrayfun(@(a) num2str(a,'%0.1f'),...
    ang_plot, 'UniformOutput', false))
title('PCfilter = true')
make_plot_pretty(gca)














