function [ output_args ] = compare_ten_ICA( NeuronImage, FT, trace, ICdir)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%
% parameters
ICthresh = 10;
ICtrace_thresh_mult = 1.5;

% Calc relevant variables
numFrames = size(FT,2);

%% Get numICs
j = 1; 
a = true; 
while a 
    if exist(fullfile(ICdir,['Obj_' num2str(j+1)]),'dir'); 
    else
        break;  
    end; 
    j = j + 1; 
end
numICs = j;

%% Load up ICs
IC = cell(numICs,1); 
ICtrace = nan(numICs,numFrames); 
for j = 1:numICs; 
    load(fullfile(ICdir,['Obj_' num2str(j)],['Obj_1 - IC image ' num2str(j) '.mat'])); 
    IC{j} = Object.Data; 
    load(fullfile(ICdir,['Obj_' num2str(j)],['Obj_2 - IC trace ' num2str(j) '.mat'])); 
    ICtrace(j,:) = Object.Data; 
end
ICroi = cellfun(@(a) a > ICthresh,IC,'UniformOutput',0);

%% Create allROImask and allICmask
allROImask = create_AllICmask(NeuronImage);
allICmask = create_AllICmask(ICroi);

%% Create hacked FT matrix, NeuronImage, and NeuronPixels and save in ICAout

NeuronImage_hack = ICroi;
bb = cellfun(@(a) regionprops(a,'PixelIdxList'),ICroi,'UniformOutput',0);
% Hacked FT matrix
FT_hack = zeros(numICs, numFrames);
NeuronPixels_hack = cell(1,numICs);
for j = 1:length(ICroi)
    % threshold if data has good SNR
    if max(ICtrace(j,:))/abs(min(ICtrace(j,:))) > 3
        thresh_use = ICtrace_thresh_mult*abs(min(ICtrace(j,:)));
        FT_hack(j,:) = ICtrace(j,:) > thresh_use;
    else % don't threshold if data is too noisy
    end
    % very much a hack
    NeuronPixels_hack{j} = bb{j}(1).PixelIdxList;
end

%% Scroll through stuff
figure(100)
j = 1;
stay_in = true;
while stay_in
    
    b = regionprops(ICroi{j},'Centroid');
    alt_xy = b.Centroid;
    neuron_id = get_neuron_from_ROI(NeuronImage, [], 'alt_xy', alt_xy );
    
    subplot(3,2,1)
    imagesc(allICmask + ICroi{j});
    title(['ICroi ' num2str(j)]);
    
    subplot(3,2,2)
    imagesc(allROImask + NeuronImage{neuron_id});
    title(['T3 ROI ' num2str(neuron_id)]);
    
    subplot(3,2,[3 4])
    plot(ICtrace(j,:)); hold on;
    plot(find(FT_hack(j,:)),ICtrace(j,logical(FT_hack(j,:))),'r.'); hold off;
    title('IC trace');
    
    subplot(3,2,[5 6]);
    plot(1:numFrames,trace(neuron_id,:),'b',...
        find(FT(neuron_id,:)),trace(neuron_id,logical(FT(neuron_id,:))),'r.')
    title('T3 trace')
    
    [j, stay_in] = LR_cycle(j,[1 numICs]);
    
%     waitforbuttonpress

end

%% Save hacked variables
clear FT NeuronImage trace
FT = FT_hack;
NeuronImage = NeuronImage_hack;
NeuronPixels = NeuronPixels_hack;
trace = ICtrace;

save ICout_hack.mat FT NeuronImage NeuronPixels
save NormTraces_hack.mat trace

%%
% keyboard


end

