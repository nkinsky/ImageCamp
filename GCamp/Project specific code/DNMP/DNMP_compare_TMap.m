% DNMP figure export

sesh = MD(162);

trial_types = {'Forced','Free'};
file_name_append = {'_forced.mat','_free.mat'}; % Must match block types above
plot_file = 'PFcompare';

% load all the variables
trials = load(fullfile(sesh.Location,['PlaceMapsv2' file_name_append{1}]),'TMap_gauss',...
    'RunOccMap');
NumNeurons = length(trials(1).TMap_gauss);
for k = 2:length(trial_types)
    trials(k) = load(fullfile(sesh.Location,['PlaceMapsv2' file_name_append{k}]),'TMap_gauss',...
        'RunOccMap');
end

for k = 1:length(trial_types)
    load(fullfile(sesh.Location,['PFstats' file_name_append{k}]),'PFnumhits');
    trials(k).PFnumhits = PFnumhits;
end

figure(543)
cm = colormap('jet');
for j = 1:NumNeurons
    for k = 1:length(trials)
        subplot(1,2,k)
        [~, nan_map] = make_nan_TMap(trials(k).RunOccMap,trials(k).TMap_gauss{j},...
            'perform_smooth',1);
        imagesc_nan(nan_map,cm,[1 1 1]);
        title(['Neuron ' num2str(j) ' ' trial_types{k} ' Trials'])
        xlabel(['Number hits = ' num2str(max(trials(k).PFnumhits(j,:)))])
    end
    
     export_fig(plot_file,'-pdf','-append')
    
end