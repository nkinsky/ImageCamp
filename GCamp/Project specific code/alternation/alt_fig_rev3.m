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
    sessions = cellfun(@(a,b) a(b), alt_all_cell_sp, alt_all_free_boolc, ...
        'UniformOutput', false);
end
%% Get transient 1/2 lengths for beginning and end session


for nn = 1:length(sessions)
    sessions_use = sessions{nn}([1, end]);
    for m = 1:2
        session = sessions_use(m);
        dir_use = ChangeDirectory_NK(session);
        load(fullfile(dir_use,'FinalOutput.mat'), 'PSAbool', 'NeuronTraces',...
            'SampleRate');
        
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
        
        % Now calculate stats for all neurons
        [half_all_mean, half_mean, LPerror, legit_trans] = ...
            get_session_trace_stats(session);
        
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
        title([mouse_name_title(session.Animal) ': ' mouse_name_title(session.Date) ...
            '-s' num2str(session.Session)])
        
        subplot(2,2,2+(m-1)*2)
        histogram(half_all_mean); hold on;
        plot([1 1]*nanmean(half_all_mean), get(gca,'YLim'),'k-')
        xlabel('tau_{1/2,all,mean} (sec)')
    end
end

%% Next step - toss out all neurons with values over threshold - 
% look at good PFs and good splitters - do they have high half-lives?

%% Get min fluorescence and plot with stats
hall = figure; set(gcf,'Position', [18, 42, 1001, 642]);
hcrop = figure; set(gcf,'Position', [18, 42, 1001, 642]);
hcomb = cat(1,hall,hcrop);
titles = {'Whole', 'Cropped'};
for nn = 1:length(sessions)
    sessions_use = sessions{nn};
    [fmin_mean, ~, fmincrop_mean] = arrayfun(@get_baseline_fluor, sessions_use); % get mean min fluor across all sessions
    fmin_comb = [fmin_mean; fmincrop_mean];
    
    for j = 1:2
        f_use = fmin_comb(j,:);
        figure(hcomb(j));
        subplot(2,2,nn)
        plot(f_use)
        xlabel('Session #')
        ylabel('Mean Min. F')
        title([mouse_name_title(sessions_use(1).Animal) ': ' titles{j}])
        
        % run stats (correlation?)
        [r, p] = corr((1:length(f_use))', f_use');
        text(0.7*length(f_use), max(f_use)-0.1*range(f_use), 'Pearson Correlation')
        text(0.7*length(f_use), max(f_use)-0.2*range(f_use), ['r=' num2str(r,'%0.2g')])
        text(0.7*length(f_use), max(f_use)-0.3*range(f_use), ['p=' num2str(p, '%0.2g')])
    end
end


