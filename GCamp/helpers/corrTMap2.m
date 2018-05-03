function [ rough_corrs ] = corrTMap2( sesh1, sesh2, rotate2, map_name_append,...
    PFname)
% rough_corrs = corrTMap2( sesh1, sesh2, rotate2, map_name_append, PFname )
%   Peforms a rough correlation between sesh1 and sesh2 at rotations of
%   TMap2 (90 degree increments). uses
%   neuron_map.....session2map_name_append.mat to register neurons and
%   loads TMap_gauss from PFname (default = Placefields.mat).

if nargin < 5
    PFname = 'Placefields.mat';
    if nargin < 4
        map_name_append = '';
        if nargin < 3
            rotate2 = 0;
        end
    end
end

sesh1 = complete_MD(sesh1); sesh2 = complete_MD(sesh2);

[TMap1, TMap2] = register_tmaps(sesh1, sesh2, PFname, 'gauss', 'name_append',...
    map_name_append);

rough_corrs = corrTMap(TMap1, TMap2, rotate2);



end

