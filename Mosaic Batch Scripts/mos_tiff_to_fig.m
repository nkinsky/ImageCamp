function h = mos_tiff_to_fig(mos_image, save_name, title_label )
% h = mos_tiff_to_fig(mos_image, save_name )
%   Takes a figure produced through the mosaic API, saves it as
%   save_name.tif, and spits out a figure with a title (title_label).
%   h is a handle to the figure it spits out

if nargin == 2
    title_label = '';
end

if isempty(regexpi(save_name,'.tif'))
    save_name = [save_name '.tif'];
else
end

mosaic.saveImageTiff(mos_image, save_name);

image_use = imread(save_name);

h = figure;
imagesc(image_use); colormap(gray);
title(title_label)


end

