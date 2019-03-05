function [hsesh, hday] = alt_plot_lc_overlaid(MD_cell, window)
%UNTITLED Plots learning curves overlaid aligned at start and end by 
% session number and from start via absolute day. Must enter in a cell of
% sessions to grab

%% 4 session smoothing window by default
if nargin < 2
    window = 4;
end

%% Get learning data
nmice = length(MD_cell);
perf_plot = cell(nmice,1);
abs_day = cell(nmice,1);
start_align_sesh = cell(nmice,1);
for j = 1:nmice
    % Grab each mouse out
    MD_use = MD_cell{j};

    % Get free sessions only
    legit_bool = alt_get_sesh_type(MD_use); 
    MDlegit = MD_use(legit_bool);

    % Calculate performance
    [perf_calc, perf_notes, ~] = alt_get_perf(MDlegit);
    perf_plot{j} = 100*nanmean([perf_calc, perf_notes],2);
    
    % Get absolute day
    abs_day{j} = arrayfun(@(a) datenum(a.Date) - datenum(MDlegit(1).Date) + 1,...
        MDlegit); % Align days to day 1
    
    
    % Add in half day if multiple sessions on that day
    abs_day{j}(find(diff(abs_day{j}) == 0)+1) = ...
        abs_day{j}(find(diff(abs_day{j}) == 0)+1) + 0.5;
    
    start_align_sesh{j} = 1:length(MDlegit);
end

% Align sessions/days to max # for any animal
end_align_sesh = cellfun(@(a) a - a(end) + max(cellfun(@length, ...
    start_align_sesh)), start_align_sesh,'UniformOutput', false);
end_align_abs_day = cellfun(@(a) a - a(end) + max(cellfun(@(a) a(end),abs_day)), ...
    abs_day,'UniformOutput', false);

% Since G30 and G31 seem to learn faster than G45 and G48, stretch out G30
% and G31 to make everything match for determining learning phase
norm_sesh = arrayfun(@(a) (1:a)/a, cellfun(@length, abs_day), ...
    'UniformOutput', false);

% Now normalize performance to max/min!
perf_norm_sm = cellfun(@(a) (a - min(a))/(max(a) - min(a)), ...
    cellfun(@(b) movmean(b,window), perf_plot, 'UniformOutput', false), ...
    'UniformOutput', false);

%% Now plot everything
hsesh = figure; set(gcf, 'Position', [2000 20 1020 940]);

% start aligned raw - by sesh
subplot(3,2,1); hold on;
cellfun(@(a,b) plot(a,b), start_align_sesh, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Session Number'); ylabel('Perf. (%)')
title('Start Aligned Sessions Unsmoothed')

% start aligned smoothed - by sesh
subplot(3,2,2); hold on;
cellfun(@(a,b) plot(a,movmean(b,window)), start_align_sesh, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Session Number'); ylabel('Perf. (%)')
title(['Start Aligned window=' num2str(window)])

% end aligned raw - by sesh
subplot(3,2,3); hold on;
cellfun(@(a,b) plot(a,b), end_align_sesh, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Session Number'); ylabel('Perf. (%)')
title('End Aligned Sessions Unsmoothed')

% end aligned smoothed - by sesh
subplot(3,2,4); hold on;
cellfun(@(a,b) plot(a,movmean(b,window)), end_align_sesh, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Session Number'); ylabel('Perf. (%)')
title(['End Aligned window=' num2str(window)])

hday = figure; set(gcf, 'Position', [2000 20 1710 940]);
% start aligned raw - by abs day
subplot(3,3,1); hold on;
cellfun(@(a,b) plot(a,b), abs_day, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Absolute Day'); ylabel('Perf. (%)')
title('Start Aligned Unsmoothed - By Abs Day')

% start aligned smoothed - by abs day
subplot(3,3,2); hold on;
cellfun(@(a,b) plot(a, movmean(b, window)), abs_day, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Absolute Day'); ylabel('Perf. (%)')
title(['Start Aligned window=' num2str(window)])

% end aligned raw - by abs day
subplot(3,3,4); hold on;
cellfun(@(a,b) plot(a,b), end_align_abs_day, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Absolute Day'); ylabel('Perf. (%)')
title('End Aligned Unsmoothed - By Abs Day')

% end aligned raw - by abs day
subplot(3,3,5); hold on;
cellfun(@(a,b) plot(a,movmean(b,window)), end_align_abs_day, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Absolute Day'); ylabel('Perf. (%)')
title(['End Aligned window=' num2str(window)])

% Normalized Sessions Raw
subplot(3,3,7); hold on;
cellfun(@(a,b) plot(a,b), norm_sesh, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Normalized Sesh'); ylabel('Perf. (%)')
title('Normalized LC Raw')

% Normalized Session Smoothed
subplot(3,3,8); hold on;
cellfun(@(a,b) plot(a,movmean(b,window)), norm_sesh, perf_plot);
plot(get(gca,'XLim'),[70 70],'r--')
make_plot_pretty(gca)
xlabel('Normalized Sesh'); ylabel('Perf. (%)')
title(['Smoothed window=' num2str(window)])

% Normalized Session Normalized Perf Smoothed
subplot(3,3,9); hold on;
cellfun(@(a,b) plot(a,b), norm_sesh, perf_norm_sm);
plot(get(gca,'XLim'),[0.33 0.33],'k--')
plot(get(gca,'XLim'),[0.67 0.67],'k--')
make_plot_pretty(gca)
xlabel('Normalized Sesh'); ylabel('Perf. Normalized')
title(['Smoothed window=' num2str(window)])



end

