function [ PSAbool_sort, sort_ind ] = sortPSA(PSAbool )
% [PSAbool_sort, sort_ind] = sortPSA(PSAbool)
%   Takes PSAbool and sorts it by first PSA for each neuron. Spits out the
%   re-sorted PSAbool (PASbool_sort) and indices of each neuron from 
%   PSAbool in sort_ind.

num_neurons = size(PSAbool,1);
recruit_time = nan(num_neurons,1);

% ID any neurons that no have PSAs for some reason and dump them to the end
no_PSA = ~any(PSAbool,2);
PSAbool_temp = PSAbool;
PSAbool_temp(no_PSA, size(PSAbool,2)) = true;

for j = 1:num_neurons

    recruit_time(j) = find(PSAbool_temp(j,:),1,'first');
    
end

[~, sort_ind] = sort(recruit_time);
PSAbool_sort = PSAbool(sort_ind,:);

end

