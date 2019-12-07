% Alternation Reviewer 3 response figures

%% Gete everything setup
alternation_reference;
if strcmpi('natlaptop', getenv('COMPUTERNAME'))
    [MD, ~, ref] = MakeMouseSessionListEraser('natlaptop');
end

if strcmpi('natlaptop', getenv('COMPUTERNAME'))
    sessions{1} = MD(32:42); % Eraser session for reference ! session at beginning and end of recording
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
        printNK([session.Animal sesh_txt{m} ' session traces'],'alt');
        
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
            printNK([session.Animal ' first to last sesh trace stats'],...
                'alt', 'hfig', hcomb)
        end
    end
end

%% Next step - toss out all neurons with values over threshold - 
% look at good PFs and good splitters - do they have high half-lives?

%% Get min fluorescence and plot with stats      23         202        1001         403
hall = figure; set(gcf,'Position', [75, 150, 1001, 403]);
hcrop = figure; set(gcf,'Position', [23, 202, 1001, 403]);
hcomb = cat(1,hall,hcrop);
titles = {'Whole', 'Cropped'};
for nn = 1:length(sessions_sp)
    sessions_use = sessions_sp{nn};
    [fmin_mean, ~, fmincrop_mean] = arrayfun(@get_baseline_fluor, sessions_use); % get mean min fluor across all sessions
    fmin_comb = [fmin_mean; fmincrop_mean];
    
    for j = 1:2
        f_use = fmin_comb(j,:);
        figure(hcomb(j));
        subplot(2,3,nn)
        plot(f_use)
        xlabel('Session #')
        ylabel('Mean Min. F')
        title([mouse_name_title(sessions_use(1).Animal) ': ' titles{j}])
        
        % run stats (correlation?)
        [r, p] = corr((1:length(f_use))', f_use');
        text(0.7*length(f_use), max(f_use)-0.1*range(f_use), 'Pearson Correlation')
        text(0.7*length(f_use), max(f_use)-0.2*range(f_use), ['r=' num2str(r,'%0.2g')])
        text(0.7*length(f_use), max(f_use)-0.3*range(f_use), ['p=' num2str(p, '%0.2g')])
        make_plot_pretty(gca)
    end
end
printNK('Mean Min F over time','alt','hfig',hall)
printNK('Mean Min Cropped F over time','alt','hfig',hcrop)


