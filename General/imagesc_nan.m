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

%% Parse Inputs
ip = inputParser;
ip.addRequired('a', @isnumeric);
ip.addOptional('cm', 'jet', @(a) ischar(a) || (isnumeric(a) && size(a,2) == 3));
ip.addParameter('z', nan, @(a) isnumeric(a));

ip.parse(a, varargin{:})
cm = ip.Results.cm;
z = ip.Results.z;

%% Plot

if isnan(z) % Plot in 2d using imagesc if no z-value specified
    h = imagesc(a);
    set(h,'alphadata',~isnan(a));
    cm_out = colormap(cm);
    
    if nansum(a(:)) == 0
        caxis([0 1])
    end
else
    h = surf(a);
    set(h,'CDataMode','manual','ZData',z*ones(size(h.ZData)),...
        'EdgeAlpha',0,'AlphaData', ~isnan(a));
    cm_out = colormap(cm);
    
    if nansum(a(:)) == 0
        caxis([0 1])
    end
end

end

