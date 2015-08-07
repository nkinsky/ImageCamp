% image reg transitive test
% allmap2 is all-session_map starting from the 2nd day of registration,
% all_map is all_session_map starting from the base day (1st day)
num_neurons(1) = find(cellfun(@(a) ~isempty(a), all_map(:,2)),1,'last');
num_neurons(2) = find(cellfun(@(a) ~isempty(a), all_map2(:,2)),1,'last');

trans_check = cell(2, size(all_map,2)-1);
for j = 1:num_neurons
    neuron2 = all_map{j,3}; % Neuron in 2nd session that matches neuron j in the base session
    
    trans_check(1,:) = all_map(j,2:end);
    if ~isempty(neuron2) && ~isnan(neuron2)
    trans_check(2,2:end) = all_map2(neuron2,2:end);
    elseif isempty(neuron2) 
        [trans_check{2,2:end}] = deal([]); 
    elseif isnan(neuron2)
        [trans_check{2,2:end}] = deal(nan); 
    end
    trans_check
    pause
end
