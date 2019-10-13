% Eraser max projection figures...
ctrl_bef = MD(32); ctrl_aft = MD(38); % Marble 11 shock day -1 and day 1
% ani_bef = MD(102); ani_aft = MD(108); % Marble 19 shock day -1 and day 1 - not a good example, weakest drop of all mice
ani_bef = MD(130); ani_aft = MD(136); % Marble 25 shock day -1 and day 1
figure; set(gcf, 'Position', [200 90 880 660]);

sesh_all = cat(1, ctrl_bef, ctrl_aft, ani_bef, ani_aft);

names = {'Ctrl Bef', 'Ctrl Aft', 'Ani Bef', 'Ani Aft'};
for j = 1:4
    subplot(2,2,j)
    im_use = imread(fullfile(sesh_all(j).Location,'ICmovie_max_proj.tif'));
    imagesc(im_use); colormap('gray');
    axis off;
    title(names{j})
end