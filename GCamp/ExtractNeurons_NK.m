function [] = ExtractNeurons_NK(infile)
% [] = ExtractNeurons2015()
% Make sure that ICmovie.h5 (motion corrected and cropped with one round of
% 2-pixel disc smoothing) and Pos.mat (manually corrected mouse positions)
% are in the directory

SR = 20;

tic
%% Step 1: Smooth the movie
if ~exist('ChangeMovie.h5','file')
TempSmoothMovie(infile,'SMovie.h5',20);

%% Step 2: Take the first derivative
ChangeMovie('SMovie.h5','D1Movie.h5');
!del SMovie.h5 
end
disp('Running moviestats')
[meanframe,stdframe] = moviestats('ChangeMovie.h5');

thresh = 4*mean(stdframe);

save Blobthresh.mat thresh;

% Step 3: Extract Ca2+ Events
disp('Running ExtractBlobs')
ExtractBlobs('ChangeMovie.h5',0,thresh);

%% Step 4: Make Segments
disp('Running MakeTransients')
load CC.mat
MakeTransients('ChangeMovie.h5',cc);
load Segments.mat;

% Step 4.5: Plot Transient Outlines
disp('Plotting Unclustered Transients')
PlotUnclusteredTransients();

% Step 5: Combine the segments by neuron
disp('Running ProcessSegs')
ProcessSegs(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim)

TotalTime = toc


% Step 6: Make Placefields
