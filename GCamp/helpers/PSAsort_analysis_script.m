%%% PSA sorting script

load('FinalOutput.mat','NeuronTraces','NeuronPixelIdxList','PSAbool')

% Get sorted traces for neurons with no buddies
[trace_nb_sort, sort_ind_nb] = sortPSA(PSAbool,NeuronTraces(1).LPtrace,NeuronPixelIdxList);
[PSA_nb_sort,~] = sortPSA(PSAbool,PSAbool,NeuronPixelIdxList);

% Calculate when each neuron is recruited
recruit_time_nb = nan(1,size(PSA_nb_sort,1));
for j = 1:size(PSA_nb_sort,1)
    recruit_time_nb(j) = find(PSA_nb_sort(j,:),1,'first');
end

% Calculate a proxy for firing rate
thresh = 7; % # of stdevs above which you consider the neuron to "fire"
ba_nb = nan(size(trace_nb_sort,1),2);
for j = 1:size(trace_nb_sort,1)
    before = trace_nb_sort(j,1:recruit_time_nb(j)-1); 
    after = trace_nb_sort(j,recruit_time_nb(j):size(trace_nb_sort,2));
    temp = NP_FindSupraThresholdEpochs(before,thresh*std(before)); 
    before_ratio = size(temp,1)/length(before); 
    temp = NP_FindSupraThresholdEpochs(after,thresh*std(after)); 
    after_ratio = size(temp,1)/length(after); 
    ba_nb(j,:) = [before_ratio, after_ratio]; 
end

% Get difference between "firing" probability from before recruitment to
% after (after-before)
ttt = diff(ba_nb,1,2);