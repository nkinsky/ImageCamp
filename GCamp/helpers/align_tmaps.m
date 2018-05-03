function [ TMaps_comb] = align_tmaps( neuron_map, TMapbase, TMapreg )
% [ TMaps_comb ] = register_tmaps( neuron_map, TMapbase, TMapreg )
%   spits out a 2 column vector containing tmaps for all the neurons active
%   in both sessions as mapped in neuron_map

valid_bool = ~isnan(neuron_map) & neuron_map ~= 0; % get valid mappings
num_valid = sum(valid_bool);

TMaps_comb = cell(num_valid,2);
TMaps_comb(:,1) = TMapbase(valid_bool);
TMaps_comb(:,2) = TMapreg(neuron_map(valid_bool));

% Old code - still correct but I get a lot of empty values which make like
% inconvenient
% TMaps_comb(valid_bool,1) = TMapbase(valid_bool);
% TMaps_comb(valid_bool,2) = TMapreg(neuron_map(valid_bool));

end

