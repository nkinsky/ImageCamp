function [ PSAbool_sort, sort_ind ] = sortPSA(PSAbool, varargin )
% [PSAbool_sort, sort_ind] = sortPSA(PSAbool, varargin)
%   Takes PSAbool and sorts it by first PSA for each neuron. Spits out the
%   re-sorted PSAbool (PASbool_sort) and indices of each neuron from 
%   PSAbool in sort_ind.
%
%   varargin: 'alt_sort' followed by an array matching the number of rows
%   of PSAbool will sort PSAbool by this array rather than recruit time.
%   Will sort highest value at top and lowest value at bottom of
%   PSAbool_sort

num_neurons = size(PSAbool,1);

ip = inputParser;
ip.addRequired('PSAbool', @islogical);
ip.addParameter('alt_sort', nan, @(a) all(isnan(a)) || isnumeric(a) ...
    && length(a) == num_neurons);
ip.parse(PSAbool, varargin{:});
alt_sort_array = ip.Results.alt_sort;

recruit_time = nan(num_neurons,1);

% ID any neurons that no have PSAs for some reason and dump them to the end
no_PSA = ~any(PSAbool,2);
PSAbool_temp = PSAbool;
PSAbool_temp(no_PSA, size(PSAbool,2)) = true;

if all(isnan(alt_sort_array)) % Sort by recruit time
    for j = 1:num_neurons
        recruit_time(j) = find(PSAbool_temp(j,:),1,'first');
    end
    [~, sort_ind] = sort(recruit_time);
else % Sort by alt_sort_array
    [~, sort_ind] = sort(alt_sort_array,'descend');
end

PSAbool_sort = PSAbool(sort_ind,:);

end

