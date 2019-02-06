function [hf, ha] = plot_phenotype_onset(pc_onset, split_onset, mouse_name)
% [hf, ha] = plot_phenotype_onset(pc_onset, split_onset)
%   Plots histograms of place cell onset and splitter conset relative to
%   1st day on the track. Also plots onset differences to determine if
%   place field formation precedes or follows splitter onset. pc_onset must
%   be the same size and contain all the same neurons!

%% Set up everything
% Set up figure
hf = figure; set(gcf,'Position', [1960 210 1810 720]);

% Set up subplots
for j = 1:6; ha(j) = subplot(2,3,j); end

% Find max onset day
last_day = max([pc_onset; split_onset]);

%% Histogram of place cell onsets
axes(ha(1));
histogram(ha(1), pc_onset, 1:last_day);
xlabel('Place Cell Onset Day');
ylabel('Count');
title(mouse_name);
make_plot_pretty(gca);

%% Histogram of splitter cell onsets
axes(ha(2));
histogram(ha(2), split_onset, 1:last_day);
xlabel('Splitter Onset Day');
ylabel('Count');
title(mouse_name);
make_plot_pretty(gca);

%% Overlaid
axes(ha(3));
hpc = histogram(ha(3), pc_onset(~isnan(pc_onset)), ...
    1:last_day, 'Normalization', 'probability');
ha(3).NextPlot = 'add'; % hold on
hsp = histogram(ha(3), split_onset(~isnan(split_onset)), ...
    1:last_day, 'Normalization', 'probability');
xlabel('Onset Day');
ylabel('Count');
title(mouse_name);
legend(cat(1,hpc,hsp),{'Place Cells', 'Splitters'})
make_plot_pretty(gca);

%% Absolute onset stats here - different distributions?
axes(ha(6));
text(ha(6), 0.1, 0,5, 'Onset Day stats here - different shape?')
axis off

%% Difference in onset day. - = splitter first, + = place cell first
axes(ha(4));
onset_diff = split_onset - pc_onset;
min_offset = min(onset_diff); max_offset = max(onset_diff);
histogram(ha(4), onset_diff, min_offset:1:max_offset);
xlabel('Split onset day - PC onset day');
ylabel('Count')
title(mouse_name)
make_plot_pretty(gca);

%% Onset diff stats here - is it skewed right or left?
axes(ha(5))
text(ha(5), 0.1, 0,5, 'Onset Difference Stats Here!')
axis off



end

