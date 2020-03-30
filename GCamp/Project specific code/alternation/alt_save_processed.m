function [] = alt_save_processed(MD)
% alt_save_processed(MD)
%   Saves bare minimum processed data for upload to Mendeley. PSAbool,
%   NeuronImage, and ICmovie_min_projand x/y position data plus AVI
%   timestamps interpolated to 20 frames/sec.

dir_use = MD.Location;

load(fullfile(dir_use,'FinalOutput.mat'), 'NeuronImage', 'PSAbool', ...
    'NeuronTraces')
min_proj = imread('ICmovie_min_proj.tif');
raw_trace = NeuronTraces.RawTrace;
load(fullfile(dir_use, 'Pos.mat'), 'xpos_interp', 'ypos_interp', ...
    'time_interp')

save('processed_minimum', 'NeuronImage', 'PSAbool', 'raw_trace', 'min_proj', ...
    'xpos_interp', 'ypos_interp', 'time_interp')

end

