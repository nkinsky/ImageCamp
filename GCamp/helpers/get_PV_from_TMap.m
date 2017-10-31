function [ PV, minspeed, xEdges, yEdges ] = get_PV_from_TMap( session, varargin )
% [PV = get_PV_and_corr2( sessions )
%   Uses already calculated placefields to calculated population vectors
%   with same bin size and speed threshold

%% Parse Inputs
ip = inputParser;
ip.addRequired('session',@isstruct);
ip.addParameter('PFname_append','',@(a) ischar(a))
ip.addParameter('TMap_use','gauss',@(a) ischar(a) && strcmpi(a,'gauss') || ...
    strcmpi(a,'unsmoothed'));
ip.parse(session,varargin{:});
PFname_append = ip.Results.PFname_append;
TMap_use = ip.Results.TMap_use;


%% Get PV
dirstr = ChangeDirectory_NK(session,0);
load(fullfile(dirstr,['Placefields', PFname_append '.mat']),['TMap_' TMap_use],...
    'minspeed','xEdges','yEdges')
if strcmpi(TMap_use,'gauss')
    TMap_use = TMap_gauss;
else
    TMap_use = TMap_unsmoothed;
end
num_neurons = length(TMap_use);
[ny, nx] = size(TMap_use{1});

PV = nan(ny,nx,num_neurons);

for j = 1:num_neurons
   PV(:,:,j) = TMap_use{j};
end


end

