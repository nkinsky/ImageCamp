function [h, hcb] = imagesc_nan(a,cm,nanclr)
% function [h, hcb] = imagesc_nan(a,cm,nanclr)

%% Old try
% imagesc_nan(im_plot, varargin)
% Works just like imagesc but takes nans and sets them to the color of your
% choosing, default is white

% n_arg = nargin - 1;
% b = imagesc(im_plot, varargin{1:n_arg}); 
% set(b,'AlphaData',~isnan(im_plot));

%% New try (found online at http://stackoverflow.com/questions/8481324/contrasting-color-for-nans-in-imagesc)
%# find minimum and maximum
amin=min(a(:));
amax=max(a(:));
%# size of colormap
n = size(cm,1);
%# color step
dmap=(amax-amin)/n;

%# standard imagesc
him = imagesc(a);
%# add nan color to colormap
colormap([nanclr; repmat(cm(1,:),4,1); cm]);
%# changing color limits
try
    caxis([amin-dmap amax]);
catch
    % Skip this step if it fails
end
%# place a colorbar
% hcb = colorbar;
hcb = '';
%# change Y limit for colorbar to avoid showing NaN color
% ylim(hcb,[amin amax])

if nargout > 0
    h = him;
end

end

