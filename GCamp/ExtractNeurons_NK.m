function [] = ExtractNeurons_NK(infile,roomstr,mask)
% [] = ExtractNeurons2015()
% Make sure that ICmovie.h5 (motion corrected and cropped with one round of
% 3-pixel disc smoothing) and Pos.mat (manually corrected mouse positions)
% are in the directory

if (nargin < 2)
    roomstr = '201b';
end

if ~exist('ChangeMovie.h5','file') % skip 1st two steps if already done.
%% Step 1: Smooth the movie
TempSmoothMovie(infile,'SMovie.h5',20);

%% Step 2: Take the first derivative
ChangeMovie('SMovie.h5','ChangeMovie.h5');
!del SMovie.h5
end
%% Step 3: Determine the threshold
disp('Determining threshold')
[meanframe,stdframe] = moviestats('ChangeMovie.h5');
thresh = 4*mean(stdframe);
save Blobthresh.mat thresh;

%% Step 4 (optional): Create the mask
disp('Creating mask')
if (nargin < 3)
    EstimateBlobs('ChangeMovie.h5',0,thresh);
    beep;
    MakeBlobMask();
    load mask.mat;
end


% Step 5: Extract Blobs
disp('Extracting Blobs')
ExtractBlobs('ChangeMovie.h5',0,thresh,mask);

%% Step 6: String Blobs into calcium transients
disp('String Blobs into transients')
load CC.mat
MakeTransients('ChangeMovie.h5',cc);

%% Step 7: Decide which transients (segments) belong to the same neuron
disp('Proessing Segments')
load Segments.mat;
ProcessSegs(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim);

% Step 8: Calculate Placefields
disp('Calculating Placefields')
CalculatePlacefields(roomstr);

% Step 9: Calculate Placefield stats
disp('Calculating Placefield statistics')
PFstats();

% Step 10: Extract Traces
ExtractTracesProc('ChangeMovie.h5',infile)

% Step 11: Browse placefields
PFbrowse('ChangeMovie.h5');

