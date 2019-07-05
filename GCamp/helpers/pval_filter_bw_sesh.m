function [ good_neurons ] = pval_filter_bw_sesh( pval1, pval2, neuron_map, varargin)
% good_neurons = pval_filter_bw_sesh( pval1, pval2, neuron_map, ... )
%   Takes an array for p-values for spatial firing from two sessions and
%   the mapping between them and spits out neurons that pass the filter.
%   Default = both session have a p-value < 0.05
%
%   INPUTS:
%
%   pval1, pval2: arrays of p-values (low value = high spatial information)
%   for each session
%
%   neuron_map: an array the length of pval1 that maps to the appropriate
%   index in pval2
%
%   OPTIONAL:
%   
%   filter_spec: 
%   1 = take neurons from both sessions that pass filter applied
%   to session 1 only
%   1 = same as 1 but for session 2
%   3 = take neurons that pass filter for BOTH session only (default)
%   4 = take neurons that pass filter for EITHER session
%
%   thresh: p-value thresh - only keep p-value less than this.  Default = 0.05.

%% Process varargins
filter_spec = 3; % default
thresh = 0.05; % default
for j = 1:length(varargin)
   if strcmpi('filter_spec',varargin{j})
       filter_spec = varargin{j+1};
   end
   if strcmpi('thresh',varargin{j})
       thresh = varargin{j+1};
   end
end
%% Deal out thresh variable to each session
if filter_spec == 1
    pval_filter = [thresh 1];
elseif filter_spec == 2
    pval_filter = [1 thresh];
elseif filter_spec == 3 || 4
    pval_filter = [thresh thresh];
end

try
    valid_map1 = find(neuron_map ~= 0 & ~isnan(neuron_map)); % Get validly mapped neurons
    valid_map2 = neuron_map(valid_map1);
    sesh1_filter = zeros(size(neuron_map));
    sesh2_filter = zeros(size(neuron_map));
    sesh1_filter(valid_map1) = pval1(valid_map1) < pval_filter(1);
    sesh2_filter(valid_map1) = pval2(valid_map2) < pval_filter(2);
    if filter_spec == 1 || filter_spec == 2 || filter_spec == 3
        good_neurons = find(sesh1_filter & sesh2_filter);
    elseif filter_spec == 4
        good_neurons = find(sesh1_filter | sesh2_filter);
    elseif isnan(filter_spec)
        good_neurons = valid_map1;
    end
    
catch
    disp('Error catching in pval_filter_bw_sesh')
    keyboard
end

end

