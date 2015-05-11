function [] = Tenaspis_NK(infile,mask)
% [] = Tenaspis(infile,mask)
% Technique for Extracting Neuronal Activity from Single Photon Image
% Sequences, by David Sullivan
%
% inputs:
% infile: name of the movie, e.g., 'mouse1.h5'
% mask (optional): binary matrix specifying pixels that are included/excluded from neuron detection

if ~exist(infile,'file') || isempty(infile)
    skip_D1moviemake = 1;
else
    skip_D1moviemake = 0;
end
% static parameters:
SmoothWindowWidth = 20; % width of window for temporally smoothing the movie with a gaussian (currently using the acquisition sampling rate)
threshfactor = 4; % baseline threshold for detecting cells

if skip_D1moviemake ~= 1
%% Step 1: Smooth the movie
TempSmoothMovie(infile,'SMovie.h5',SmoothWindowWidth);

%% Step 2: Take the first derivative
DFDT_Movie('SMovie.h5','D1Movie.h5');
end
%% Step 3: Determine the threshold
[meanframe,stdframe] = moviestats('D1movie.h5');
thresh = threshfactor*mean(stdframe);
save Blobthresh.mat thresh;

%% Step 4 (optional): Create the mask
if (~exist('mask')) || isempty(mask)
    EstimateBlobs('D1Movie.h5',0,thresh);
    beep;
    MakeBlobMask();
    load mask.mat;
end

% Step 5: Extract Blobs
ExtractBlobs('D1Movie.h5',0,thresh,mask);

%% Step 6: String Blobs into calcium transients
MakeTransients('D1Movie.h5');

%% Step 7: Decide which transients (segments) belong to the same neuron
MakeNeurons();



