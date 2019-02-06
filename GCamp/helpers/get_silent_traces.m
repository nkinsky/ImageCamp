function [traces_reg, silent_bool, active_neighbor] = ...
    get_silent_traces(sesh1, sesh2)
% [silent_traces, active_traces] = get_silent_traces(sesh1, sesh2)
%   Takes all neurons in session 1 and gets low-pass filtered traces for those same ROIs in
%   session2. Also spits out booleans for if a cell is putatively "silent"
%   in session2 and a boolean designating if a neighboring ROI was active so 
%   that these epochs can be excluded.

%% Step 1: Load in ROIs from session 1, register to session 2
NeuronImage = []; PSAbool = [];
load(fullfile(sesh1.Location,'FinalOutput.mat'),'NeuronImage','PSAbool'); % Load sesh1 neurons
reginfo = image_registerX(sesh1.Animal, sesh2.Date, sesh2.Session, ...
    sesh1.Date, sesh1.Session); % register sesison 1 to session 2
ROIreg = cellfun(@(a) imwarp_quick(a, reginfo), NeuronImage, 'UniformOutput', false);
ROIorig = NeuronImage;

%% Step 2: Calculate pseudo-traces for each session
profile on
ptraces_orig = calc_pseudo_traces(fullfile(sesh1.Location,'BPDFF.h5'), ...
    ROIorig, 1);
profile viewer
ptraces_reg = calc_pseudo_traces(fullfile(sesh2.Location,'BPDFF.h5'), ...
    ROIreg, 2);

%%
keyboard
%% Step 3: Make boolean for silent neurons
[goodmap, silent_cells, ~, ambig_silent] = classify_cells(sesh1, sesh2, 0.5);

%% Step 3.5: Scroll through silent cell traces if specified!
std_thresh = 3;
figure 
set(gcf,'Position',[2100 110 1400 800])
h1 = subplot(2,1,1); h2 = subplot(2,1,2);
for j = 1:length(silent_cells)
    neuron_plot = silent_cells(j); 
    plot_neuron_traces(ptraces_orig(neuron_plot,:), nan, h1, ...
        'PSAbool', PSAbool(neuron_plot,:));
    h1.NextPlot = 'add';
    cross_thresh1 = std_thresh*std(h1.Children(end).YData);
    plot(h1, h1.XLim, ones(1,2)*cross_thresh1,'b--')
    h1.NextPlot = 'replace';
    title(h1, num2str(neuron_plot));
    
    plot_neuron_traces(ptraces_reg(neuron_plot,:),nan, h2); 
    h2.NextPlot = 'add';
    cross_thresh2 = std_thresh*std(h2.Children(end).YData);
    plot(h2.XLim, ones(1,2)*cross_thresh1,'b--')
    plot(h2.XLim, ones(1,2)*cross_thresh2,'k--')
    h2.NextPlot = 'replace';
    waitforbuttonpress; 
end

%% Step 4: Get std for each trace and compare between sessions - does it go down
% for silent cells and not for other cells?
std_diff = std(ptraces_orig,1,2) - std(ptraces_reg,1,2);
grps = ones(size(std_diff));
grps(silent_cells) = 2;
scatterBox(std_diff,grps);

std_all = [std(ptraces_orig,1,2), std(ptraces_reg,1,2)];
std_silent = std_all(silent_cells,:);
std_others = std_all(goodmap ~=0,:);
silent_id = repmat((1:length(silent_cells))',1,2);
silent_grps = ones(length(silent_cells),2).*[1 2];
scatterBox(std_silent(:),silent_grps(:),'paired_ind',silent_id(:))

%% Step 4.2: Threshold each trace at 3*std? and calc #frames above thresh/
% AUC, then compare between neurons and check to make sure they all go down
% for silent neurons more than for non-silent neurons

ncrossings = nan(size(ptraces_orig,1),2);
for j = 1:size(ptraces_orig,1)
    temp = NP_FindSupraThresholdEpochs(ptraces_orig(j,:),...
        std_thresh*std_all(j,1));
    ncrossings(j,1) = size(temp,1);
    temp = NP_FindSupraThresholdEpochs(ptraces_reg(j,:),...
        std_thresh*std_all(j,2));
    ncrossings(j,2) = size(temp,1);
end

%% Step 4.5: subtract out transients from neighboring neurons it step 4
% is too conservative! It appears to be - none of these seems to point to a
% decrease in FL in silent neurons!


%% For qc compare the traces generated from above with those from FinalOutput!



%% Step 4: Find nearest neighbors whose centroid is within a certain distance threshold
% (maybe < 10 microns? Make this into a sub-function so that I can easily
% run a parameter sweep on JUST this without creating traces each time) and
% make boolean if active. Or does BPDFF take care of this? Exclude falling phase too? Yes?
end

%% pseudo-trace calculation sub-function
function [pseudo_traces] = calc_pseudo_traces(mov_file, ROIs, seshnum)

% Step 1: Get movie info and chunking info
Set_T_Params(mov_file);
[NumFrames,FrameChunkSize] = Get_T_Params('NumFrames','FrameChunkSize');
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);
nneurons = length(ROIs);

% Step 2: Calculate pseudotraces for both sessions!
pseudo_traces = nan(nneurons, NumFrames);

% concatenate all ROIs and reshape to make compatible with frames_rs
ROI_rs = cat(3,ROIs{:});
ROI_rs = shiftdim(reshape(ROI_rs,[],nneurons),1);
% profile on
hw = waitbar(0,['Calculating pseudotraces for session ' num2str(seshnum)]);
% would parfor help here? try!!!
for j = 1:NumChunks
    FrameList = ChunkStarts(j):ChunkEnds(j);
    
    % load frame chunk and reshape to make 2d
    frames_use = LoadFrames(mov_file, FrameList);
    frames_rs = reshape(frames_use,[],size(frames_use,3));
    
    % Perform super fast array multiplication to get traces for that chunk
    pseudo_traces(:, FrameList) = ROI_rs*frames_rs;
    waitbar(j/NumChunks,hw)
end
close(hw)

end

