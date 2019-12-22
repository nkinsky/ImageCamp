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

printNK(['Split v pc recruitment times - All Mice' text_append],'alt');

figure;
max_trials = max(cellfun(@max, first_trial_all(1:2)));
hhist_sp = histogram(first_trial_all{1},'BinLimits', [1, max_trials],...
    'Normalization', 'Probability');
hold on;
hhist_pc = histogram(first_trial_all{2}, 'BinEdges', ...
    hhist_sp.BinEdges, 'Normalization', 'Probability');
legend(cat(1,hhist_sp, hhist_pc), {'Splitters', 'Place Cells'})

printNK(['Combined Split v PC recruitment histograms'],'alt')

