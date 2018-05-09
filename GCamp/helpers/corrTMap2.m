function [ rough_corrs ] = corrTMap2( sesh1, sesh2, rotate2, map_name_append,...
    PFname, varargin)
% rough_corrs = corrTMap2( sesh1, sesh2, rotate2, map_name_append, PFname,... )
%   Peforms a rough correlation between sesh1 and sesh2 at rotations of
%   TMap2 (90 degree increments). uses
%   neuron_map.....session2map_name_append.mat to register neurons and
%   loads TMap_gauss from PFname (default = Placefields.mat). If sesh1 ==
%   sesh2, will look for Placefield_halves variable in PFname and do within session
%   comparisons (1st half to 2nd half). varargins after PFname
%   corresponding to neuron_map_simple or neuron_register should work.

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

if ~sesh_equal(sesh1, sesh2)
    [TMap1, TMap2] = register_tmaps(sesh1, sesh2, PFname, 'gauss', 'name_append',...
        map_name_append, varargin{:});
elseif sesh_equal(sesh1, sesh2)
    load(fullfile(sesh1.Location,PFname),'Placefields_halves')
    TMap1 = Placefields_halves{1}.TMap_gauss; %#ok<*USENS>
    TMap2 = Placefields_halves{2}.TMap_gauss;
end

rough_corrs = corrTMap(TMap1, TMap2, rotate2);

end

