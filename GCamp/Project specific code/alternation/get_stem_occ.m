function [ stemBinOccLRc, stemBinOccLRi ] = get_stem_occ( x , y, Alt )
% [ stemBinOccLRc, stemBinOccLRi ] = get_stem_occ( x , y, Alt )
%   Takes x/y position and Alt and spits out bins on the stem for LR
%   correct and incorrect trials. 
%
% Make 2 row vector: top = stem bins on L correct trials only, bottom =
% stem bins on R correct trials only. NaN = not on stem.

nbins = 80;
%Linearize trajectory.
mazetype = 'tmaze';
X = LinearizeTrajectory(x,y,mazetype);

%Find indices for when the mouse is on the stem and for left/right
%trials.
load(fullfile(pwd,'Alternation.mat'));
onstem = Alt.section == 2;                      %Logical.
correct = Alt.alt == 1;                         %Logical.
left = Alt.choice == 1;
right = Alt.choice == 2;

%Occupancy histogram.
[~,edges] = histcounts(X,nbins);
[stemOcc] = histcounts(X(onstem),edges);
%Bin numbers for the center stem.
stemBins = find(stemOcc,1,'first'):find(stemOcc,1,'last');

% Assign bin number to each time point. 0 = not on stem
[~,~,stemBinOcc] = histcounts(X,edges(stemBins(1):(stemBins(end)+1)));

% Make 2 row vector: top = stem bins on L correct trials only, bottom =
% stem bins on R correct trials only
stemBinOccLRc = nan(2,length(stemBinOcc));
stemBinOccLRi = nan(2,length(stemBinOcc));

stemBinOccLRc(1,correct & left & onstem) = stemBinOcc(correct & left & onstem);
stemBinOccLRc(2,correct & right & onstem) = stemBinOcc(correct & right & onstem); 
stemBinOccLRi(1,~correct & left & onstem) = stemBinOcc(~correct & left & onstem);
stemBinOccLRi(2,~correct & right & onstem) = stemBinOcc(~correct & right & onstem);
    
end

