% Alternation Reviewer 3 response figures

%% Gete everything setup
alternation_reference;
if strcmpi('natlaptop', getenv('COMPUTERNAME'))
    [MD, ~, ref] = MakeMouseSessionListEraser('natlaptop');
end

if strcmpi('natlaptop', getenv('COMPUTERNAME'))
    sessions{1} = MD(32:42); % Eraser session for Marble11 = 12 week virus in system at start!
    sessions{1} = MD([15, 28]); % Eraser reference for Marble07 - 9 week virus in system!
    sessions{1} = MD([155, 168]); % Eraser reference for Marble29 - 10 week virus in system!
else
% sessions{1} = MD([238, 258]); % G30 session at beginning and end of recording
% sessions{2} = MD([226, 235]); % G31 beginning/end session 
% sessions{3} = MD([335, 363]); % G45 beginning/end session 
% sessions{4} = MD([401, 452]); % G48 beginning/end session
    sessions = cellfun(@(a,b) a(b), alt_all_cell, alt_all_free_boolc, ...
        'UniformOutput', false);
    sessions_sp = cellfun(@(a,b) a(b), alt_all_cell_sp, alt_all_free_boolc_sp, ...
        'UniformOutput', false);
end
%% Get transient 1/2 lengths for beginning and end session
sesh_txt = {'first', 'last'};

half_all_mean_comb = cell(4,2);
half_mean_comb = cell(4,2);
for nn = 1:length(sessions)
    sessions_use = sessions{nn}([1, end]);
    for m = 1:2
        session = sessions_use(m);
        dir_use = ChangeDirectory_NK(session);
        clear SampleRate
        load(fullfile(dir_use,'FinalOutput.mat'), 'PSAbool', 'NeuronTraces',...
            'SampleRate');
        if ~exist('SampleRate', 'var')
            SampleRate=20;
            disp('SampleRate not found in FinalOutput.mat - must be older, using 20')
        end
        
        nneurons = size(PSAbool,1);
        
        % Generate plots for random # neurons
        nplot = 10; % must be even
        neuron_ind = randperm(nneurons, nplot);
        figure('Position', [40, 70, 1380, 700]);
        for j = 1:nplot
            k = neuron_ind(j);
            plot_aligned_trace(PSAbool(k,:), NeuronTraces.RawTrace(k,:), ...
                NeuronTraces.LPtrace(k,:),'SR', SampleRate, 'ax', subplot(2,nplot/2,j));
        end
        if ~strcmpi('natlaptop', getenv('COMPUTERNAME'))
            printNK([session.Animal sesh_txt{m} ' session traces'],'alt');
        end
        
        % Now calculate stats for all neurons
        [half_all_mean, half_mean, LPerror, legit_trans] = ...
            get_session_trace_stats(session);
        half_mean_comb{nn,m} = half_mean;
        half_all_mean_comb{nn,m} = half_all_mean;
        
        % Now plot all in a histogram
        if m == 1
            hcomb = figure; set(gcf,'Position', [50, 50, 950, 600])
        else
            figure(hcomb);
        end
        
        subplot(2,2,1+(m-1)*2)
        histogram(half_mean); hold on;
        plot([1 1]*nanmean(half_mean), get(gca,'YLim'),'k-')
        xlabel('\tau_{1/2,mean} (sec)')
        text(0.5*max(get(gca,'xlim')),0.7*max(get(gca,'ylim')), ...
            ['mean = ' num2str(nanmean(half_mean),'%0.2g') ', std = ' ...
            num2str(nanstd(half_mean), '%0.2g')])
        title([mouse_name_title(session.Animal) ': ' mouse_name_title(session.Date) ...
            '-s' num2str(session.Session)])
        if m == 2
            [h,p,~,stats] = ttest2(half_mean_comb{nn,1}, half_mean_comb{nn,2});
            text(0.5*max(get(gca,'xlim')),0.6*max(get(gca,'ylim')), ...
                ['t-test: p=' num2str(p,'%0.2g') ' tstat=' num2str(stats.tstat,...
                '%0.3g') ' df=' num2str(stats.df)])
        end
        make_plot_pretty(gca,'fontsize',10,'linewidth',1.5)
        
        subplot(2,2,2+(m-1)*2)
        histogram(half_all_mean); hold on;
        plot([1 1]*nanmean(half_all_mean), get(gca,'YLim'),'k-')
        text(0.5*max(get(gca,'xlim')),0.7*max(get(gca,'ylim')), ...
            ['mean = ' num2str(nanmean(half_all_mean),'%0.2g') ', std = ' ...
            num2str(nanstd(half_all_mean), '%0.2g')])
        xlabel('tau_{1/2,all,mean} (sec)')
        if m == 2
            [h,p,~,stats] = ttest2(half_all_mean_comb{nn,1}, half_all_mean_comb{nn,2});
            text(0.5*max(get(gca,'xlim')),0.6*max(get(gca,'ylim')), ...
                ['t-test: p=' num2str(p,'%0.2g') ' tstat=' num2str(stats.tstat,...
                '%0.3g') ' df=' num2str(stats.df)])
        end
        make_plot_pretty(gca,'fontsize',10,'linewidth',1.5)
        if m == 2
            if ~strcmpi('natlaptop', getenv('COMPUTERNAME'))
                printNK([session.Animal ' first to last sesh trace stats'],...
                    'alt', 'hfig', hcomb)
            end
        end
    end
end

%% Next step is to do this for ALL sessions and plot mean value across time...
plot_days = true; % False = plot by session #, true = plot by absolute day
ylabels = {'Mean','All Mean'};
for nn = 1:length(sessions) 
    figure; set(gcf,'Position', [75, 150, 900, 300]);
    mean_plot = []; mean_all_plot = []; std_plot = []; std_all_plot = [];
    sessions_use = sessions{nn};
    hw = waitbar(0,['Getting trace stats for animal ' num2str(nn)]);
    for m = 1:length(sessions_use)
        session = sessions_use(m);
        [half_all_mean, half_mean, LPerror, legit_trans] = ...
            get_session_trace_stats(session);
        mean_plot = [mean_plot, nanmean(half_mean)];
        std_plot = [std_plot, nanstd(half_mean)];
        mean_all_plot = [mean_all_plot, nanmean(half_all_mean)];
        std_all_plot = [std_all_plot, nanstd(half_all_mean)];
        waitbar(m/length(sessions_use),hw);
    end
    
    % Get time between sessions or session #
    if plot_days
        days_from_start = arrayfun(@(a) get_time_bw_sessions(sessions_use(1),a),...
            sessions_use); % Get days from start
        
        % Add 0.5 to any sessions that occur in the PM if a session has
        % already occurred in the AM
        days_from_start(find(diff(days_from_start) == 0) + 1) = ...
            days_from_start(find(diff(days_from_start) == 0) + 1) + 0.5;
    else
        days_from_start = 1:length(sessions_use);
    end
    
    % Plot with stats
    mean_comb = [mean_plot; mean_all_plot];
    std_comb = [std_plot; std_all_plot];
    close(hw)
    for j = 1:2
        subplot(1,2,j)
        plot(days_from_start, mean_comb(j,:), 'k.')
        hold on;
        errorbar(days_from_start, mean_comb(j,:), std_comb(j,:))
        
        [r, p] = corr(days_from_start', mean_comb(j,:)');
        text(0.5*max(get(gca,'xlim')), 0.7*max(get(gca,'ylim')),...
            ['r_{pearson}=' num2str(r,'%0.3g') ' p=' num2str(p, '%0.3g')])
        title(mouse_name_title(session.Animal))
        if plot_days; xlabel('Days from Start'); else; xlabel('Session #'); end
        ylabel(['\tau_{1/2,' ylabels{j} '} (sec)'])
        
        make_plot_pretty(gca,'fontsize',10,'linewidth',1.5)
    end
    printNK([ session.Animal ' trace stats over time'],'alt')
    
end
    
%% Next step - toss out all neurons with values over threshold - 
% look at good PFs and good splitters - do they have high half-lives?

%% Get min fluorescence and plot with stats
plot_days = true; % False = plot by session #, true = plot by absolute day
hall = figure; set(gcf,'Position', [18, 42, 1001, 642]);
hcrop = figure; set(gcf,'Position', [18, 42, 1001, 642]);
hcomb = cat(1,hall,hcrop);
titles = {'Whole', 'Cropped'};
for nn = 1:length(sessions_sp)
    sessions_use = sessions_sp{nn};
    [fmin_mean, ~, fmincrop_mean] = arrayfun(@get_baseline_fluor, sessions_use); % get mean min fluor across all sessions
    fmin_comb = [fmin_mean; fmincrop_mean];
    
    if plot_days
        days_from_start = arrayfun(@(a) get_time_bw_sessions(sessions_use(1),a),...
            sessions_use); % Get days from start
        
        % Add 0.5 to any sessions that occur in the PM if a session has
        % already occurred in the AM
        days_from_start(find(diff(days_from_start) == 0) + 1) = ...
            days_from_start(find(diff(days_from_start) == 0) + 1) + 0.5;
    else
        days_from_start = 1:length(sessions_use);
    end
    
    for j = 1:2
        f_use = fmin_comb(j,:);
        figure(hcomb(j));
        
        subplot(2,3,nn)
        plot(days_from_start, f_use)
        if plot_days; xlabel('Days from Start'); else; xlabel('Session #'); end
        ylabel('Mean Min. F')
        title([mouse_name_title(sessions_use(1).Animal) ': ' titles{j}])
        
        % run stats (correlation?)
        [r, p] = corr(days_from_start', f_use');
        text(0.7*max(days_from_start), max(f_use)-0.1*range(f_use), 'Pearson Correlation')
        text(0.7*max(days_from_start), max(f_use)-0.2*range(f_use), ['r=' num2str(r,'%0.2g')])
        text(0.7*max(days_from_start), max(f_use)-0.3*range(f_use), ['p=' num2str(p, '%0.2g')])
        make_plot_pretty(gca)
    end
end
printNK('Mean Min F over time','alt','hfig',hall)
printNK('Mean Min Cropped F over time','alt','hfig',hcrop)

%% Plot side-by-side F0 and half-life for each mouse
hff = figure; set(gcf, 'Position', [22   300   989   266]);
clear haf
for j = 1:4
    haf(j) = subplot(1,4,j);
end
hft = figure; set(gcf, 'Position', [22   30   989   266]);
clear hat
for j = 1:4
    hat(j) = subplot(1,4,j);
end

phalf = nan(1,4); pf = nan(1,4);
[~, ha1, phalf(1), pf(1)] = track_neuron_trace_stats(alt_all_cell{1}(1), alt_all_cell{1}(3),...
    cat(1,haf(1), hat(1)));
arrayfun(@(a) title(a, 'G30 Habituation Week'), ha1);
[~, ha2, phalf(2), pf(2)] = track_neuron_trace_stats(alt_all_cell{1}(3), alt_all_cell{1}(5), ...
    cat(1,haf(2), hat(2)));
arrayfun(@(a) title(a, 'G30 Looping Week'), ha2);
[~, ha3, phalf(3), pf(3)] = track_neuron_trace_stats(alt_all_cell{1}(5), alt_all_cell{1}(9), ...
    cat(1,haf(3), hat(3)));
arrayfun(@(a) title(a, 'G30 Free Week 1'), ha3);
[~, ha4, phalf(4), pf(4)] = track_neuron_trace_stats(alt_all_cell{1}(9), alt_all_cell{1}(13), ...
    cat(1,haf(4), hat(4)));
arrayfun(@(a) title(a, 'G30 Free Week 2'), ha4);
% arrayfun(@(a) ylim(a, [500, 2100]), haf); % Limits of all data
arrayfun(@(a) ylim(a, [375, 3200]), haf); % Plots effective range of Fl we could detect
arrayfun(@(a) ylim(a, [0, 6.5]), hat);
printNK('F0 tracking matched neurons - G30', 'alt', 'hfig', hff);
printNK('half life tracking matched neurons - G30', 'alt', 'hfig', hft);

%% g31
hff = figure; set(gcf, 'Position', [22   300   989   266]);
clear haf
for j = 1:4
    haf(j) = subplot(1,4,j);
end
hft = figure; set(gcf, 'Position', [22   30   989   266]);
clear hat
for j = 1:4
    hat(j) = subplot(1,4,j);
end

[~, ha1, p_half1, p_F01] = track_neuron_trace_stats(alt_all_cell{2}(1), alt_all_cell{2}(3),...
    cat(1,haf(1), hat(1)));
arrayfun(@(a) title(a, 'G31 Week 1'), ha1);
[~, ha2, p_half2, p_F02] = track_neuron_trace_stats(alt_all_cell{2}(3), alt_all_cell{2}(6), ...
    cat(1,haf(2), hat(2)));
arrayfun(@(a) title(a, 'G31 Week 1.5'), ha2);
[~, ha3, p_half3, p_F03] = track_neuron_trace_stats(alt_all_cell{2}(6), alt_all_cell{2}(7), ...
    cat(1,haf(3), hat(3)));
arrayfun(@(a) title(a, 'G31 Week 2'), ha3);
% arrayfun(@(a) ylim(a, [600, 2400]), haf); % Limits of all data
arrayfun(@(a) ylim(a, [440, 3220]), haf); % Plots effective range of Fl we could detect
arrayfun(@(a) ylim(a, [0, 7.25]), hat);
printNK('F0 tracking matched neurons - G31', 'alt', 'hfig', hff);
printNK('half life tracking matched neurons - G31', 'alt', 'hfig', hft);
% Same for others... - don't see a consistent increase!

%% G45
hff = figure; set(gcf, 'Position', [22   300   989   266]);
clear haf
for j = 1:4
    haf(j) = subplot(1,4,j);
end
hft = figure; set(gcf, 'Position', [22   30   989   266]);
clear hat
for j = 1:4
    hat(j) = subplot(1,4,j);
end

phalf = nan(1,4); pf = nan(1,4);
[~, ha1, phalf(1), pf(1)] = track_neuron_trace_stats(alt_all_cell{3}(1), alt_all_cell{3}(7),...
    cat(1,haf(1), hat(1)));
arrayfun(@(a) title(a, 'G45 Week 1'), ha1);
[~, ha2, phalf(2), pf(2)] = track_neuron_trace_stats(alt_all_cell{3}(7), alt_all_cell{3}(14), ...
    cat(1,haf(2), hat(2)));
arrayfun(@(a) title(a, 'G45 Week 2'), ha2);
[~, ha3, phalf(3), pf(3)] = track_neuron_trace_stats(alt_all_cell{3}(15), alt_all_cell{3}(20), ...
    cat(1,haf(3), hat(3)));
arrayfun(@(a) title(a, 'G45 Week 3'), ha3);
[~, ha4, phalf(4), pf(4)] = track_neuron_trace_stats(alt_all_cell{3}(20), alt_all_cell{3}(end), ...
    cat(1,haf(4), hat(4)));
arrayfun(@(a) title(a, 'G45 Week 4'), ha4);
% arrayfun(@(a) ylim(a, [500, 2100]), haf); % Limits of all data
arrayfun(@(a) ylim(a, [275, 4000]), haf); % Plots effective range of Fl we could detect
arrayfun(@(a) ylim(a, [0, 5.5]), hat);
printNK('F0 tracking matched neurons - G45', 'alt', 'hfig', hff);
printNK('half life tracking matched neurons - G45', 'alt', 'hfig', hft);

%% G48
hff = figure; set(gcf, 'Position', [22   300   989   266]);
clear haf
for j = 1:5
    haf(j) = subplot(1,5,j);
end
hft = figure; set(gcf, 'Position', [22   30   989   266]);
clear hat
for j = 1:5
    hat(j) = subplot(1,5,j);
end

phalf = nan(1,5); pf = nan(1,5);
[~, ha1, phalf(1), pf(1)] = track_neuron_trace_stats(alt_all_cell{4}(1), alt_all_cell{4}(7),...
    cat(1,haf(1), hat(1)));
arrayfun(@(a) title(a, 'G48 Week 1'), ha1);
[~, ha2, phalf(2), pf(2)] = track_neuron_trace_stats(alt_all_cell{4}(7), alt_all_cell{4}(13), ...
    cat(1,haf(2), hat(2)));
arrayfun(@(a) title(a, 'G48 Week 2'), ha2);
[~, ha3, phalf(3), pf(3)] = track_neuron_trace_stats(alt_all_cell{4}(15), alt_all_cell{4}(17), ...
    cat(1,haf(3), hat(3)));
arrayfun(@(a) title(a, 'G48 Week 3'), ha3);
[~, ha4, phalf(4), pf(4)] = track_neuron_trace_stats(alt_all_cell{4}(17), alt_all_cell{4}(27), ...
    cat(1,haf(4), hat(4)));
arrayfun(@(a) title(a, 'G48 Week 4'), ha4);
[~, ha5, phalf(5), pf(5)] = track_neuron_trace_stats(alt_all_cell{4}(27), alt_all_cell{4}(end), ...
    cat(1,haf(5), hat(5)));
arrayfun(@(a) title(a, 'G48 Week 5'), ha5);
% arrayfun(@(a) ylim(a, [500, 2100]), haf); % Limits of all data
arrayfun(@(a) ylim(a, [400, 4120]), haf); % Plots effective range of Fl we could detect
arrayfun(@(a) ylim(a, [0, 6]), hat);
printNK('F0 tracking matched neurons - G48', 'alt', 'hfig', hff);
printNK('half life tracking matched neurons - G48', 'alt', 'hfig', hft);

%% Make plot of PSAbool for splitter versus place cells. 
wood_filt = true;
half_life_thresh = 2;
text_append = alt_set_filters(wood_filt, half_life_thresh);
[~, ~, ~, hf1, hfhist] = alt_plot_recruit_times(alt_test_session(1));
make_figure_pretty(hf1)
printNK(['G30 split v pc recruit times - one session' text_append], 'alt',...
    'hfig', hf1)
make_figure_pretty(hfhist)
printNK(['G30 split v pc recruit histograms - one session' text_append], 'alt',...
    'hfig', hfhist)

%% Now aggregate for all animals and plot
sessions = alt_all(alt_all_free_bool);
first_time_all = cell(1,3); first_trial_all = cell(1,3);
for j = 1:length(sessions)
    [~, first_time_temp, first_trial_temp] = alt_plot_recruit_times(...
        sessions(j), false);
    first_time_all = cellfun(@(a,b) cat(1,a,b), first_time_all, ...
        first_time_temp, 'UniformOutput', false);
    first_trial_all = cellfun(@(a,b) cat(1,a,b), first_trial_all, ...
        first_trial_temp, 'UniformOutput', false);
end

%%
figure; set(gcf, 'Position', [20, 100, 900, 700]);
subplot(2,2,1)
for j = 1:2; ecdf(first_time_all{j}); hold on; end
xlabel('First transient time (sec)')
ylabel('Cumulative Fraction');
legend('Splitters', 'Place Cells');
title('All Sessions')

subplot(2,2,2)
for j = 1:2; ecdf(first_trial_all{j}); hold on; end
xlabel('First transient trial')
ylabel('Cumulative Fraction');
legend('Splitters', 'Place Cells');
title('All Sessions')

subplot(2,2,3)
[~, ptime, kstime] = kstest2(first_time_all{1}, first_time_all{2}, ...
    'tail','larger');
[~, ptrial, kstrial] = kstest2(first_trial_all{1}, first_trial_all{2}, ...
    'tail','larger');

text(0.1, 0.9, 'mean time of 1st transient (split, pc, others):')
text(0.1, 0.8, num2str(round(cellfun(@mean, first_time_all),1)))
text(0.1, 0.7, ['1-sided kstest: p=' num2str(ptime, '%0.2g') ' ksstat=' ...
    num2str(kstime, '%0.2g')])

text(0.1, 0.5, 'mean trial of 1st transient (split, pc, other):')
text(0.1, 0.4, num2str(round(cellfun(@mean, first_trial_all),1)))
text(0.1, 0.3, ['1-sided kstest: p=' num2str(ptrial, '%0.2g') ' ksstat=' ...
    num2str(kstrial, '%0.2g')])
axis off
make_figure_pretty(gcf)
printNK(['Split v pc recruitment times - All Mice' text_append],'alt');

figure;
max_trials = max(cellfun(@max, first_trial_all(1:2)));
hhist_sp = histogram(first_trial_all{1},'BinLimits', [0, max_trials],...
    'Normalization', 'Probability');
hold on;
hhist_pc = histogram(first_trial_all{2}, 'BinEdges', ...
    hhist_sp.BinEdges, 'Normalization', 'Probability');
legend(cat(1,hhist_sp, hhist_pc), {'Splitters', 'Place Cells'})
xlabel('1st Trial Transient')
ylabel('Probability')
make_plot_pretty(gca)

printNK(['Combined Split v PC recruitment histograms'],'alt')


%% Plot splitters between sessions - do a bunch at each time lag!!!
% 1 day
plotSigSplitters_bw_sesh(G31_alt(5), G31_alt(6));
% 2 days
plotSigSplitters_bw_sesh(G30_alt(12), G30_alt(14));
plotSigSplitters_bw_sesh(G48_alt(11), G48_alt(14));
% 3 days
plotSigSplitters_bw_sesh(G48_alt(10), G48_alt(11)); % remapping b/w sessions
plotSigSplitters_bw_sesh(G48_alt(35), G48_alt(39));
% 4 days
plotSigSplitters_bw_sesh(G45_alt(6), G45_alt(7));
% 5 days
plotSigSplitters_bw_sesh(G45_alt(13), G45_alt(16)); % remapping b/w sessions
plotSigSplitters_bw_sesh(G45_alt(11), G45_alt(15)); 
% 6 days
plotSigSplitters_bw_sesh(G30_alt(8), G30_alt(11));
% 7 days
plotSigSplitters_bw_sesh(G45_alt(5), G45_alt(12));
% 8 days
plotSigSplitters_bw_sesh(G45_alt(4), G45_alt(13));
% 9 days
plotSigSplitters_bw_sesh(G48_alt(25), G48_alt(47)); % remapping b/w sessions
plotSigSplitters_bw_sesh(G30_alt(8), G30_alt(14)); % partial remapping
% 10 days
plotSigSplitters_bw_sesh(G45_alt(16), G45_alt(25));


%% Summary plot of all splitters and days before/after that they are splitters

% First get matrices tracking all cells that are splitters across days with
% their metrics.
[ relymat, deltamaxmat, sigmat, onsetsesh, days_aligned,...
    pkw, cmat, deltamax_normmat, sesh_final, dint_normmat, relymeanmat, ...
    sigpropmat] = cellfun(@(a) track_splitters(a(1), a(2:end)), alt_all_cell_sp, ...
    'UniformOutput', false);
sigmat_splitonly = cellfun(@(a,b) a(b,:), sigmat, split_bool, ...
    'UniformOutput', false);
split_bool = cellfun(@(a) any(a,2), sigmat, 'UniformOutput', false); % Cells that were splitters at ANY point
ndays_split = cellfun(@(a,b) nansum(a,2), sigmat_splitonly, ...
    'UniformOutput', false); % # days each splitter split

nunique_splitters = sum(cellfun(@sum, split_bool));

%%
figure; 
for j = 1:6 
    [onsetsort, isort] = sort(onsetsesh{j}(split_bool{j})); % sort by onset sesh
%     metric_sorted = relymat{j}(isort,:);
%     metric_sorted = sigmat_splitonly{j}(isort,:);
    metric_sorted = sigpropmat{j}(isort,:);
    subplot(2,3,j); imagesc(metric_sorted); hold on;
    plot(onsetsort, 1:length(onsetsort),'r-');
end

%% Combine all animals together, sort by day of recruitment, plot
ndays = cellfun(@(a) size(a,2), sigmat_splitonly); % # days a splitter

% Get # columns to nan pad at end of each array
nans_to_add = arrayfun(@(a) max(ndays) - a, ndays, 'UniformOutput', false);
nanpads = cellfun(@(a,b) nan(size(a,1),b), sigmat_splitonly, ...
    nans_to_add, 'UniformOutput', false);
% [onsetsort, isort] = cellfun(@(a,b) sort(a(b)),...
%     onsetsesh, split_bool, 'UniformOutput', false); % sort by onset sesh

% Now zero-pad the ends of the arrays and concatenate together vertically
% into one large array
sigmat_padtemp = cellfun(@(a,c) [nan_to_zero(a) c], sigmat_splitonly, nanpads, ...
    'UniformOutput', false);
sigmat_nanpad = cat(1, sigmat_padtemp{:});
sigprop_padtemp = cellfun(@(a,c) [nan_to_zero(a) c], sigpropmat, nanpads,...
    'UniformOutput', false);
sigprop_nanpad = cat(1, sigprop_padtemp{:});
rely_padtemp = cellfun(@(a,c) [nan_to_zero(a) c], relymat, nanpads, ...
    'UniformOutput', false);
rely_nanpad = cat(1, rely_padtemp{:});
dmax_padtemp = cellfun(@(a,c) [nan_to_zero(a) c], deltamaxmat, nanpads, ...
    'UniformOutput', false);
dmax_nanpad = cat(1, dmax_padtemp{:});
onset_all = [];

% Concatenate onsetsesh for all splitters and sort
for j = 1:6; onset_all = [onset_all; onsetsesh{j}(split_bool{j})]; end
[onall_sort, i_allsort] = sort(onset_all);

% Now plot - chop off sessions 12-16 for G48 since only a few splitters get
% recruited after that and no other animals have more than 12 sessions.
figure; set(gcf, 'Position', [91   217   800   440]);
subplot(1,2,1); 
imagesc_nan(sigmat_nanpad(i_allsort,1:11)); colorbar;
xlabel('Session'); ylabel('Neuron'); title('Sig. Splitter Sessions');
subplot(1,2,2);
imagesc_nan(sigprop_nanpad(i_allsort,1:11)); colorbar;
xlabel('Session'); ylabel('Neuron'); title('Splitting Extent');
make_figure_pretty(gcf);
printNK('Splitter and Extent Summary Plot', 'alt');

figure; set(gcf, 'Position', [91   217   800   440]);
subplot(1,2,1); 
imagesc_nan(dmax_nanpad(i_allsort,1:11)); colorbar;
xlabel('Session'); ylabel('Neuron'); title('\Delta_{max}');
subplot(1,2,2);
imagesc_nan(rely_nanpad(i_allsort,1:11)); colorbar;
xlabel('Session'); ylabel('Neuron'); title('Rely_{max}');
make_figure_pretty(gcf);
printNK('Max Discr and Rely Summary Plot', 'alt');

% Plot # days of splitting
figure; set(gcf, 'Position', [351   259   385   297]);
histogram(nansum(sigmat_nanpad,2));
xlabel('# Trajectory-Dependent Sessions'); ylabel('Count');
make_plot_pretty(gca);
printNK('Num Days Splitting Histogram','alt');


%% Run exp fit on all traces/sessions
sessions = alt_all(alt_all_free_bool);
hw = waitbar(0,'Calculating exponential fits');
for j = 1:length(sessions)
    exp_fit_traces(sessions(j), 'save_data', true);
    waitbar(j/length(sessions), hw);
end
close hw

%% Plot ecdfs overlaid on one another
ntrans_thresh = 5;
for j = 1:4
    sessions = alt_all_cell{j}(alt_all_free_boolc{j});
    nsesh = length(sessions);
    figure
    for k = 1:nsesh
        thalf = exp_fit_traces(sessions(k), 'use_saved_data', true);
        load(fullfile(sessions(k).Location,'FinalOutput.mat'), 'PSAbool');
        ntrans = get_num_trans(PSAbool);
        ecdf(thalf(ntrans >= ntrans_thresh));
        hold on;
    end
    ax_use = gca;
    cmap_use = parula(nsesh);
    for k = 1:nsesh
        ax_use.Children(k).Color = cmap_use(k,:);
    end
    xlabel('\tau_{1/2} (sec)')
    ylabel('Cumulative Proportion')
    legend(ax_use.Children([end round(nsesh/2) 1]), {'1st session', ...
        'Middle sesion', 'Last session'})
    title(['Mouse ' num2str(j)])
    xlim([0, 7])
    printNK(['thalf ecdf - Mouse ' num2str(j)],'alt');
end

%% Same as above but for fluorescence
ntrans_thresh = 5;
split = true; % split G45 and G48 into two sessions
mice_names = {'1', '2', '3a', '3b', '4a', '4b'};
for j = 1:6
    if split
        sessions = alt_all_cell_sp{j}(alt_all_free_boolc_sp{j});
    elseif ~split
        sessions = alt_all_cell{j}(alt_all_free_boolc{j});
    end
    nsesh = length(sessions);
    figure
    for k = 1:nsesh
        F0 = get_ROIbaseline_fluor(sessions(k));
        load(fullfile(sessions(k).Location,'FinalOutput.mat'), 'PSAbool');
        ntrans = get_num_trans(PSAbool);
        ecdf(F0(ntrans >= ntrans_thresh));
        hold on;
    end
    ax_use = gca;
    cmap_use = parula(nsesh);
    for k = 1:nsesh
        ax_use.Children(k).Color = cmap_use(k,:);
    end
    xlabel('F0 (au)')
    ylabel('Cumulative Proportion')
    legend(ax_use.Children([end round(nsesh/2) 1]), {'1st session', ...
        'Middle sesion', 'Last session'})
    if ~split
        title(['Mouse ' num2str(j)])
        printNK(['F0 ecdf - Mouse ' num2str(j)],'alt');
    elseif split
        title(['Mouse ' mice_names{j}])
        printNK(['F0 ecdf - Mouse ' mice_names{j}],'alt');
    end
end
