function [] = PostProcessICA()
% this function takes an ICA .mat file as written by Inscopix Mosaic,
% does a bit of post-processing, and hopefully spits out something
% that will form the basis for my continued employment as a scientist

close all;

folder = uigetdir('','Pick your Directory');

cd(folder);

% "Magic numbers"
NumICA = 200;
ZeroThresh = 5; % Below this the IC gets zeroed out
RingThresh = 15; % Dividing line between inside and outside of cell ROI
SR = 20;

% STEP 1: Input the independent components

for i = 1:NumICA % load the ICA .mat file, put it in a data structure
    filename = ['Obj_',int2str(i),'_1 - IC filter ',int2str(i),'.mat'];
    load(filename); % loads two things, Index and Object
    IC{i} = Object(1).Data;
end

Xdim = size(IC{1},1);
Ydim = size(IC{1},2);


% STEP 2: Fix the filter(s)

% theory: IC's have mean 0 and std 1 but have long right hand tails

% righthand tail


for i = 1:NumICA
    % just zero out everything less than 5 
    temp = IC{i};
    tempOut = IC{i};
    
    temp(temp < RingThresh) = 0;
    tempOut(tempOut < ZeroThresh) = 0;
    tempOut(tempOut > RingThresh) = 0;
    FixedIC{i} = temp;
    FixedICnz{i} = find(FixedIC{i} > 0);
    FixedICOut{i} = tempOut;
    FixedICOutnz{i} = find(FixedICOut{i} > 0);
end

% STEP 3: load the frickin movie
% I'm going to assume that the movie file is in the same directory as the 
% IC .mat files.


display('Loading movie data');
if exist('ICmovie.h5') == 2
    MovieData = h5read('ICmovie.h5','/Object'); % MovieData dims are X,Y,T
else
    [ movie_file movie_dir] = uigetfile('*.h5','Select movie file to load:');
    moviepath = [movie_dir movie_file];
    MovieData = h5read(moviepath,'/Object'); % MovieData dims are X,Y,T
end

NumFrames = size(MovieData,3);
t = (1:NumFrames)/SR;

% STEP 4: Use filters to get traces
for j = 1:NumFrames
  tempFrame = double(squeeze(MovieData(:,:,j)));
  display(['Calculating F traces for movie frame ',int2str(j),' out of ',int2str(NumFrames)]);
    for i = 1:NumICA
      FLData(i,j) = sum(sum(FixedIC{i}(FixedICnz{i}).*tempFrame(FixedICnz{i}))); 
      FLDataOut(i,j) = sum(sum(FixedICOut{i}(FixedICOutnz{i}).*tempFrame(FixedICOutnz{i})));
    end
end

% STEP 5: Compensate the fluorescence signal
for i = 1:NumICA
    MeanRatio = mean(FLData(i,:))/mean(FLDataOut(i,:));
    CFLData(i,:) = zscore(FLData(i,:)-MeanRatio*FLDataOut(i,:));
    CFLData(i,:) = NP_QuickFilt(CFLData(i,:),0.01,4,SR);
end

keyboard;

c = 6;
cIC = union(FixedICnz{c},FixedICOutnz{c});


% Step 6: Manually step through
figure(1);
for i = 1:NumICA
    subplot(2,1,1);imagesc(FixedIC{i}+FixedICOut{i});axis square;caxis([0 15]);
    subplot(2,1,2);plot(t,CFLData(i,:))
    ToKeep = input('Keep this one or not? [y,n] --->','s');
    if (strcmp(ToKeep,'y') ~= 1)
        GoodIC(i) = 0;
    else
        GoodIC(i) = 1;
    end
end
keyboard;



    



