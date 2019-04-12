function [] = plot_ROI_orientations(MD)
% plot_ROI_orientations(MD)
%   plots ROI orientations color-coded

dir_use = ChangeDirectory_NK(MD,0);
load(fullfile(dir_use,'FinalOutput.mat'),'NeuronImage');
min_proj = imread(fullfile(dir_use,'ICmovie_min_proj.tif'));

stats = cellfun(@(a) regionprops(a,'Orientation'), NeuronImage);
orientations = arrayfun(@(a) a.Orientation, stats);
orient_n = (orientations + 90)/180;

figure; set(gcf, 'Position', [2360 140 900 690])
ha = gca;
cmap = colormap(hsv(64));
[~, ~, bin] = histcounts(orient_n,0:1/64:1);
plot_neuron_outlines(min_proj, NeuronImage, 'colors', cmap(bin,:),...
    'h', ha);
title([mouse_name_title(MD.Animal) ' ' mouse_name_title(MD.Date) '-s' ...
    num2str(MD.Session)])

end

