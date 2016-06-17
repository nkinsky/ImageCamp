% DNMP figure export


sesh = MD(180);

trial_types = {'Forced L', 'Forced R', 'Free L', 'Free R'}; % {'Forced','Free'};
file_name_append = {'_forced_left.mat', '_forced_right.mat', '_free_left.mat', '_free_right.mat'}; %{'_forced.mat','_free.mat'}; % Must match block types above
plot_file = 'PFcompare_wpvalues';

%% Plot actual comparisons

% load all the variables
trials = load(fullfile(sesh.Location,['PlaceMapsv2' file_name_append{1}]),'TMap_gauss',...
    'RunOccMap','pval');
NumNeurons = length(trials(1).TMap_gauss);
for k = 2:length(trial_types)
    trials(k) = load(fullfile(sesh.Location,['PlaceMapsv2' file_name_append{k}]),'TMap_gauss',...
        'RunOccMap','pval');
end

for k = 1:length(trial_types)
    load(fullfile(sesh.Location,['PFstatsv2' file_name_append{k}]),'PFnumhits');
    trials(k).PFnumhits = PFnumhits;
end

figure(543)
cm = colormap('jet');
for j = 1184:NumNeurons
    
    % Refresh figure every 100 to prevent slowdowns
    if round(j/100) == (j/100)
        close 543
        figure(543)
    end
    for k = 1:length(trials)
        if length(trials) == 2
            subplot(1,2,k)
        elseif length(trials) == 4
            subplot(2,2,k)
        end
        [~, nan_map] = make_nan_TMap(trials(k).RunOccMap,trials(k).TMap_gauss{j},...
            'perform_smooth',1);
        imagesc_nan(nan_map,cm,[1 1 1]);
        title(['Neuron ' num2str(j) ' ' trial_types{k} ' Trials'])
        xlabel(['Number hits = ' num2str(max(trials(k).PFnumhits(j,:)))])
        ylabel(['pval = ' num2str(1 - trials(k).pval(j))])
    end
    
     export_fig(plot_file,'-pdf','-append')
    
end

%% Control comparisons

load(fullfile(sesh.Location,'PlaceMapsv2_onmaze.mat'),'TMap_half',...
    'RunOccMap')
title_str_append = {' 1st half Trials', ' 2nd half Trials'};

NumNeurons = length(TMap_half(1).TMap_gauss);

figure(550)
cm = colormap('jet');
for j = 1:NumNeurons
    
    for k = 1:2
        subplot(1,2,k)
        [~, nan_map] = make_nan_TMap(RunOccMap,TMap_half(k).TMap_gauss{j},...
            'perform_smooth',1);
        imagesc_nan(nan_map,cm,[1 1 1]);
        title(['Neuron ' num2str(j) title_str_append{k}])
    end
    
     export_fig('PFcompare_control','-pdf','-append')
% waitforbuttonpress

end