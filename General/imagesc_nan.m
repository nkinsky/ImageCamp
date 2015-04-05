function [ ] = imagesc_nan(im_plot, varargin)
% imagesc_nan(im_plot, nan_color, varargin)
% Works just like imagesc but takes nans and sets them to the color of your
% choosing, default is white

n_arg = nargin - 1;
b = imagesc(im_plot, varargin{1:n_arg}); 
set(b,'AlphaData',~isnan(im_plot));

end

