function [h, hcb] = imagesc_nan(a,cm,nanclr,CLim)
% function [h, hcb] = imagesc_nan(a,cm,nanclr)
%  Plots just like imagesc, but with any nans labeled as nanclr
%
% a = matrix to plot with imagesc
% cm = colormap to use (e.g. cm = colormap('jet');
% nanclr = rgb color triplet, e.g. nanclr = [1 1 1] sets all NaN values to
% white
% CLim(optional) - if you want to adjust the scale of CLim artificially, enter
% 'CLim',[cmin cmax]. If left blank the max and min values will be set by
% the max and min of a.

%% Old try
% imagesc_nan(im_plot, varargin)
% Works just like imagesc but takes nans and sets them to the color of your
% choosing, default is white

% n_arg = nargin - 1;
% b = imagesc(im_plot, varargin{1:n_arg}); 
% set(b,'AlphaData',~isnan(im_plot));

%% New try (found online at http://stackoverflow.com/questions/8481324/contrasting-color-for-nans-in-imagesc)
%# find minimum and maximum
if nargin < 4
    amin=min(a(:));
    amax=max(a(:));
elseif nargin == 4
    amin = CLim(1);
    amax = CLim(2);
end
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

