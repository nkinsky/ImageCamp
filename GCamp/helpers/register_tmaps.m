function [ TMap1, TMap2 ] = register_tmaps( MDbase, MDreg, PFname, smoothing )
% [ TMap1, TMap2 ] = register_tmaps( MDbase, MDreg, PFname, smoothing )
%   TMap1 and TMap2 are the same size and have the same neurons in each
%   row. PFname indicates placefield file name to load, smoothing = 'gauss'
%   or 'unsmoothed'

% get map between the two sessions
neuron_map = neuron_map_simple(MDbase, MDreg, 'suppress_output', true); 

% load tmaps
sesh = complete_MD(MDbase);
sesh(2) = complete_MD(MDreg);
for j = 1:2
    tmap_name = ['TMap_' smoothing];
    temp = load(fullfile(sesh(j).Location,PFname),tmap_name);
    sesh(j).TMap = temp.(tmap_name);
end

tmap_comb = align_tmaps(neuron_map, sesh(1).TMap, sesh(2).TMap);
TMap1 = tmap_comb(:,1);
TMap2 = tmap_comb(:,2);

end

