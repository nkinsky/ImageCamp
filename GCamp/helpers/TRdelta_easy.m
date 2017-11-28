function [T1, T2 ] = TRdelta_easy( batch_session_map, ind1, ind2, plot_flag, silent_include )
% TRdelta_easy( batch_map, ind1, ind2, plot_flag, silent_include )
%   Wrapper function for get_TRdelta for easy use with just a
%   batch_session_map as input.

if nargin < 5
    silent_include = false;
    if nargin < 4
        plot_flag = true;
    end
end
batch_session_map = fix_batch_session_map(batch_session_map);

calc_half = false;
if ind1 == ind2
    calc_half = true;
end

neuron_map = get_neuronmap_from_batchmap(batch_session_map,ind1,ind2);
neuron_map_rev = get_neuronmap_from_batchmap(batch_session_map,ind2,ind1);

sesh1 = batch_session_map.session(ind1);
sesh2 = batch_session_map.session(ind2);

[T1, T2] = get_TRdelta(neuron_map, sesh1, sesh2, 'plot_flag', plot_flag,...
    'silent_include', silent_include,'neuron_map_rev', neuron_map_rev,...
    'calc_half', calc_half);

end

