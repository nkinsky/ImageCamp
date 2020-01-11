function [h, cm_out] = imagesc_nan(a, varargin)
% function [h, hcb] = imagesc_nan(a, cm, ...)
%  Plots just like imagesc, but with any nans labeled as nanclr
%
%   INPUTS
%
%   a = matrix to plot with imagesc
%
%   cm (optional) = colormap to use (e.g. cm = colormap('jet');
%
%   z (parameter) = make the imagesc plot 3d and set the z-plane at this
%   point, e.g. imagesc_nan(array,'hsv','z',2) sets z-plane to 2 with
%   colormap hsv
%
%   ha (parameter) = axes to plot into. default = gca.

%% Parse Inputs
ip = inputParser;
ip.addRequired('a', @(a) isnumeric(a) || islogical(a));
ip.addOptional('cm', 'parula', @(a) ischar(a) && ~ismember(a,{'z','ha'}) ...
    || (isnumeric(a) && size(a,2) == 3));
ip.addParameter('z', nan, @(a) isnumeric(a));
ip.addParameter('ha', [], @(a) ishandle(a) || isempty(a));

ip.parse(a, varargin{:})
cm = ip.Results.cm;
z = ip.Results.z;
ha = ip.Results.ha;

if isempty(ha)
    ha = gca;
end

%% Plot

if isnan(z) % Plot in 2d using imagesc if no z-value specified
    h = imagesc(ha, a);
    set(h,'alphadata',~isnan(a));
    cm_out = colormap(gca,cm);
    
    if nansum(a(:)) == 0
        caxis([0 1])
    end
else
    h = surf(ha, a);
    set(h,'CDataMode','manual','ZData',z*ones(size(h.ZData)),...
        'EdgeAlpha',0,'AlphaData', ~isnan(a));
    cm_out = colormap(gca,cm);
    
    if nansum(a(:)) == 0
        caxis([0 1])
    end
end

end

