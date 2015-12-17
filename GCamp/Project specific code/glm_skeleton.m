%% MLE playing around

%% Load splitter data

ChangeDirectory_NK(MD(ref.G48.alternation(end)));
load('splittersByTrialType.mat')
load('sigSplitters.mat')

%%
sig_cells = find(cellfun(@(a) ~isempty(a) && sum(a < 0.05) >= 1 ,pvalue));
% use cell 446 to start

cell_use = 446;

cell_raster{1} = cellRespsByTrialType{cell_use,1};
cell_raster{2} = cellRespsByTrialType{cell_use,2};

phat{1} = mle(cell_raster{1});
phat{2} = mle(cell_raster{2});
