% Plot TMaps for continuous v delay and compare to continuous within
% session

pval_thresh = 0.1;

session = MD(160); % Continuous block(s)
session(2) = MD(161); % Delay block(s)

% Load relevant variables from each session
ChangeDirectory_NK(session(1));
load('PlaceMaps.mat', 'RunOccMap', 'TMap_gauss', 'pval');
TMap_continuous = TMap_gauss;
RunOccMap_continuous = RunOccMap;
pval_continuous = pval;

ChangeDirectory_NK(session(2));
load('PlaceMaps.mat', 'RunOccMap', 'TMap_gauss', 'pval');
TMap_delay = TMap_gauss;
RunOccMap_delay = RunOccMap;
pval_delay = pval;

% filter neurons - keep ones that have ok pval in either session
neuron_use_either = find(pval_continuous > (1 - pval_thresh) | ...
    pval_delay > (1-pval_thresh));

%scroll through and plot everything
figure(501); 
cm = colormap('jet');
for j = 1:length(neuron_use_either) 
    
    % Make non-occupied spots white
    [~, TMap_cont_nan] = make_nan_TMap(RunOccMap_continuous,...
        TMap_continuous{neuron_use_either(j)}); % Continuous blocks
    [~, TMap_delay_nan] = make_nan_TMap(RunOccMap_delay,...
        TMap_delay{neuron_use_either(j)}); % Delayed blocks
    
    corr_plot(j) = corr(TMap_continuous{neuron_use_either(j)}(:),...
        TMap_delay{neuron_use_either(j)}(:)); % Get correlation value
    
%     % Make non-occupied spots white - continuous by block 
%     for k = 1:2
%         [~, TMap_cont_half_nan{k}] = make_nan_TMap(RunOccMap,...
%             TMap_cont_half(k).TMap_gauss{neuron_use_either(j)}); 
%     end
    
    subplot(2,1,1); 
    imagesc_nan(rot90(TMap_cont_nan,1), cm, [1 1 1]);
    title(['Continuous - neuron ' num2str(neuron_use_either(j)) ...
        ' with correlation = ' num2str(corr_plot(j))])
    
    subplot(2,1,2); 
    imagesc_nan(rot90(TMap_delay_nan,1), cm, [1 1 1]);
    title(['Delayed - neuron ' num2str(neuron_use_either(j))])
    
%     half_name = {'1st','2nd'};
%     for k = 1:2
%         subplot(2,2,2+k)
%         imagesc_nan(TMap_cont_half_nan{k},dm,[1 1 1]);
%         title(['Continuous ' half_name{k} ' - neuron ' num2str(neuron_use_either(j))])
%     end
%     
    waitforbuttonpress; 
end