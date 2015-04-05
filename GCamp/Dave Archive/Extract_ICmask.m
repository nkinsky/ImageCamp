function [] = Extract_ICmask(NumICA,MinThreshPixels)
% ExtractTraces v 0.90 9/19/2014
% Using Inscopix Mosaic generated IC files and a DF/F corrected movie,
% generate accurate, sensitive traces for the cells

close all;

% "Magic numbers"
MicronsPerPix = 1.22; % correctish
SR = 20; % Sampling rate in Hz
OutNoiseRad = 40; % Radius from cell center to calculate Noise

if (nargin == 1)
    MinThreshPixels = 60;
end

% Load the independent components, edit them if this is the first time
[ICThresh,IC,NumICA,x,y] = EditICA(NumICA,MinThreshPixels); % 

Xdim = size(IC{1},1)
Ydim = size(IC{1},2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Calculating signal masks'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create new IC filters with values less than ICThresh zeroed
% This isolates the pixels that are part of the neuron
figure;hold on;
Sum_Mask = zeros(size(IC{1}));

for i = 1:NumICA
  temp = IC{i};
  temp(find(temp < ICThresh(i))) = 0;
  RawIC{i} = temp;
  temp(find(temp > 0)) = 1;
  ICMask{i} = temp;
  ICnz{i} = find(temp == 1);
  COM{i} = centerOfMass(temp);
  subplot(1,2,1);plot(x{i},y{i});hold on;
  Sum_Mask = Sum_Mask+ICMask{i};
end

subplot(1,2,2);imagesc(Sum_Mask);set(gca,'YDir','normal');

save ICAoutlines.mat IC ICnz ICThresh x y NumICA;

end