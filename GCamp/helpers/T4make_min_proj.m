function [ ] = T4make_min_proj( sesh, filetype )
% T4make_min_proj( sesh, filetype )
%   Saves min projection of movie file as ICmovie_min_proj.tif. Can do for
%   either h5 or tiff files, must specify as 'h5', or 'tif', or 'tiff' in
%   filetype.

currdir = cd;
dir_use = ChangeDirectory_NK(sesh);
filename = ls(fullfile(dir_use, ['*.' filetype]));
fullpath = fullfile(dir_use,filename);
savefile = fullfile(dir_use,'ICmovie_min_proj.tif');

minproj = h5mov_proj(fullpath,'min');
imwrite(mat2gray(minproj),savefile);

cd(currdir);

end

