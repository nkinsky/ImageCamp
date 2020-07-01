function [PSAcomb, first_trans_times, first_trans_trials, hf1, hfhist] = ...
    alt_plot_recruit_times(session, plot_bool)
% [PSAcomb, first_trans_times, first_trans_trials, h1, hhists] = ...
%    alt_plot_recruit_times(session, plot_bool)
%   
%   Plots rasters for splitters vs place cells vs other cells sorted by
%   recruitment time and quantifies relative recruitment time and
%   recruitment trial. plot_bool = false does not plot but calculates all
%   the relevant stuff.

if nargin < 2
    plot_bool = true;
end

% Standard thresholds used throughout the rest of figures
sigthresh = 3; 
pval_thresh = 0.05;
ntrans_thresh = 5;

% Filter out neurons per globally set variables
[~, ~, ~, ~, exclude_both] = alt_filt_cell_count(session);

% Load variables
load(fullfile(session.Location, 'Placefields_cm1.mat'), 'PSAbool');
load(fullfile(session.Location, 'Alternation.mat'),'Alt');

% Break into categories
categories = alt_parse_cell_category(session, pval_thresh, ntrans_thresh, ...
    sigthresh, 'Placefields_cm1.mat');
sig_split = categories == 1; % splitters
sig_place = categories == 2 | categories == 4; % stem and arm place cells
sig_other = categories == 3 | categories == 5; % stem and arm non-place cells

% Organize variables in a nice way
PSAsplit = PSAbool(~exclude_both & sig_split,:);
PSAplace = PSAbool(~exclude_both & sig_place,:);
PSAother = PSAbool(~exclude_both & sig_other,:);
PSAcomb{1} = sortPSA(PSAsplit); PSAcomb{2} = sortPSA(PSAplace); 
PSAcomb{3} = sortPSA(PSAother);

% Calculate recruitment frame/time/trial (frame/time/trial of 1st
% transient)
first_trans_frames = cellfun(@get_first_transient, PSAcomb, 'UniformOutput',...
    false); % Get frame # of first transient for each group
first_trans_times = cellfun(@(a) a/20, first_trans_frames,...
    'UniformOutput', false); % Convert frames to seconds
Alt.trial(1:find(Alt.trial == 1, 1, 'first')) = 1; % Set frames prior to 1st trial as trial 1.
first_trans_trials = cellfun(@(a) Alt.trial(a)', first_trans_frames, ...
    'UniformOutput', false); % Convert recruit times to trials

if plot_bool
    names = {'Splitters', 'Place Cells', 'Other Cells'};
    hf1 = figure; set(gcf,'Position', [176 77 1300 700]);
    for j = 1:3
        ha = subplot(2,3,j); imagesc(PSAcomb{j});
        ha.XTickLabels = arrayfun(@num2str, round(get(ha, 'XTick')/20), ...
            'UniformOutput', false); % Set xticks to seconds
        xlabel('Seconds'); ylabel('Cell #');
        title(names{j});
        hold on
    end
   
    sub_cell = {subplot(2,3,1), subplot(2,3,2), subplot(2,3,3)};

    % Go back and plot time of first transient line over images above 
    cellfun(@(a,b) plot(a, b, 1:length(b),'r-'), sub_cell, first_trans_frames);
    
    % Plot ecdfs of everything
    for j = 1:3
        hc(1) = subplot(2,3,4);
        ecdf(first_trans_times{j}); hold on;
        hc(2) = subplot(2,3,5);
        ecdf(first_trans_trials{j}); hold on;
    end
    
    hc(1).XTickLabels = arrayfun(@num2str, round(get(hc(1), 'XTick')), ...
        'UniformOutput', false);
    xlabel(hc(1),'t (seconds)'); ylabel(hc(1),'F(t)')
    xlabel(hc(2),'Trial #'); ylabel(hc(2),'F(Trial #)')
    for s = 1:2; legend(hc(s), {'Splitters','PCs','Others'}); end
    
    % run stats on recruitment time for splitters versus pcs...
    [~, pfr, kstatfr] = kstest2(first_trans_times{1}, first_trans_times{2},...
        'tail','larger');
    [~, ptr, kstattr] = kstest2(first_trans_trials{1}, first_trans_trials{2},...
        'tail','larger');
    
    subplot(2,3,6);
    text(0.1, 0.9, 'mean time of 1st transient (split, pc, other):')
    text(0.1, 0.8, num2str(round(cellfun(@mean, first_trans_times),1)))
    text(0.1, 0.7, ['1-sided kstest: p=' num2str(pfr, '%0.2g') ' ksstat=' ...
        num2str(kstatfr, '%0.2g')])
    text(0.1, 0.6, ['nneurons = ' num2str(cellfun(@length, first_trans_times))])
    
    text(0.1, 0.5, 'mean trial of 1st transient (split, pc, other):')
    text(0.1, 0.4, num2str(round(cellfun(@mean, first_trans_trials),1)))
    text(0.1, 0.3, ['1-sided kstest: p=' num2str(ptr, '%0.2g') ' ksstat=' ...
        num2str(kstattr, '%0.2g')])
    text(0.1, 0.2, ['nneurons = ' num2str(cellfun(@length, first_trans_trials))])
    axis off
    
    hfhist = figure; set(gcf,'Position', [176 77 1200 700]);
    for j = 1:3
        subplot(2,3,j);
        histogram(first_trans_trials{j})
        xlabel('1st transient trial');
        ylabel('Neuron count')
        title(names{j})
    end
    
    subplot(2,3,4)
    max_trials = max(cellfun(@max, first_trans_trials(1:2)));
    hhist_sp = histogram(first_trans_trials{1},'BinLimits', [0, max_trials],...
        'Normalization', 'Probability');
    hold on;
    hhist_pc = histogram(first_trans_trials{2}, 'BinEdges', ...
        hhist_sp.BinEdges, 'Normalization', 'Probability');
    legend(cat(1,hhist_sp, hhist_pc), {'Splitters', 'Place Cells'})
    xlabel('1st Transient Trial'); ylabel('Probability')
    
    % plot all PSAbools separately to see if you can get good looking
    % pictures if you zoom out more
    for j = 1:3
        figure;  set(gcf,'Position', [217    42   659   642])
        imagesc(PSAcomb{j}); ha2(j) = gca; hold on;
        ha2(j).XTickLabels = arrayfun(@num2str, round(get(ha2(j), 'XTick')/20), ...
            'UniformOutput', false); % Set xticks to seconds
        xlabel('Seconds'); ylabel('Cell #');
        title(names{j});
        hold on
    end
    
    % Go back and plot time of first transient line over images above
    sub_cell2 = {ha2(1), ha2(2), ha2(3)};
    cellfun(@(a,b) plot(a, b, 1:length(b),'r-'), sub_cell2, first_trans_frames);
    
else
    hf1 = nan;
    hfhist = nan;
end

end

