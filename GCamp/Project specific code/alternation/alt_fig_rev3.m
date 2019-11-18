% Alternation Reviewer 3 response figures

%% Generate
sessions = MD([32, 42]); % session at beginning and end of recording
for m = 1:2
    session = sessions(m);
    load(fullfile(session.Location,'FinalOutput.mat'), 'PSAbool', 'NeuronTraces',...
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
    half_all_mean = nan(nneurons,1);
    half_mean = nan(nneurons,1);
    for j = 1:nneurons
        [half_all, half_mean(j), LPerror, bad_trans_error] = plot_aligned_trace(PSAbool(j,:), NeuronTraces.RawTrace(j,:), ...
            NeuronTraces.LPtrace(j,:),'SR', SampleRate, 'plot_flag', false);
        if LPerror
            disp(['Low-pass artifact discovered in neuron ' num2str(j)])
        end
        if bad_trans_error
            disp(['All transients are sketchy in neuron ' num2str(j)])
        end
        half_all_mean(j) = nanmean(half_all);
    end


    % Now plot all in a histogram
    if m == 1
        hcomb = figure; set(gcf,'Position', [200, 50, 1100, 700]);
    else
        figure(hcomb);
    end
    
    subplot(2,2,1+(m-1)*2)
    histogram(half_mean); hold on;
    plot([1 1]*nanmean(half_mean), get(gca,'YLim'),'k-')
    xlabel('\tau_{1/2,mean} (sec)')
    title([mouse_name_title(session.Animal) ': ' mouse_name_title(session.Date) ...
        ' -s' num2str(session.Session)])
    
    subplot(2,2,2+(m-1)*2)
    histogram(half_all_mean); hold on;
    plot([1 1]*nanmean(half_all_mean), get(gca,'YLim'),'k-')
    xlabel('tau_{1/2,all,mean} (sec)')
end