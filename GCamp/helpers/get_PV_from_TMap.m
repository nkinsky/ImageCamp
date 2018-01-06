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
ip.addParameter('half_flag',false, @islogical); % true = calculate PV for each half of the session
ip.parse(session,varargin{:});
PFname_append = ip.Results.PFname_append;
TMap_use = ip.Results.TMap_use;
half_flag = ip.Results.half_flag;


%% Get PV
dirstr = ChangeDirectory_NK(session,0);
if ~half_flag
    load(fullfile(dirstr,['Placefields', PFname_append '.mat']),['TMap_' TMap_use],...
        'minspeed','xEdges','yEdges')
    if strcmpi(TMap_use,'gauss')
        TMap_use = TMap_gauss;
    else
        TMap_use = TMap_unsmoothed;
    end
    PV = calc_PV(TMap_use);
elseif half_flag
    try % Error-catching attempt
        load(fullfile(dirstr,['Placefields_half', PFname_append '.mat']))
    catch
        load(fullfile(dirstr,['Placefields', PFname_append '.mat']))
    end
    minspeed = Placefields_halves{1}.minspeed; %#ok<USENS>
    xEdges = Placefields_halves{1}.xEdges;
    yEdges = Placefields_halves{1}.yEdges;
    for j = 1:2
        
        if strcmpi(TMap_use,'gauss')
            TMap_use = Placefields_halves{j}.TMap_gauss;
        else
            TMap_use = Placefields_halves{j}.TMap_unsmoothed;
        end
        PV(j,:,:,:) = calc_PV(TMap_use);
    end
end



end

%% PV calc sub-function
function [PV] = calc_PV(TMap_use)

num_neurons = length(TMap_use);
[ny, nx] = size(TMap_use{1});

PV = nan(ny,nx,num_neurons);

for j = 1:num_neurons
   PV(:,:,j) = TMap_use{j};
end

end

