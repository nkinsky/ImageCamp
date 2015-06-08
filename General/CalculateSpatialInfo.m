function [INFO,p_i,lambda,lambda_i] = CalculateSpatialInfo(session)
%INFO = CalculateSpatialInfo(session)
%
%   Finds the spatial information of each neuron according to the formula
%   in Tonegawa's paper that Howard sent to us on 6/2/2015. 
%
%   INTPUT: 
%       session: Directory containing ProcOut.mat.
%
%   OUTPUTS: 
%       INFO: Nx1 vector containing spatial information content for each
%       neuron. 
%
%       p_i: 1xB vector (where B is the number of spatial bins) containing
%       the probability of the mouse being in a single spatial bin. 
%
%       lambda: Nx1 vector containing the mean firing rate for each neuron.
%       
%       lambda_i: NxB vector containing the mean firing rate for each
%       neuron in each spatial bin. 
%

%% Load appropriate files. 
    load(fullfile(session,'ProcOut.mat')); 
    
%% Useful parameters.
    Pix2Cm = 0.15;
    cmperbin = .5;

%% Align tracking to imaging then rotate. 
    %Align. 
    [x,y,speed,FT,FToffset,FToffsetRear] = AlignImagingToTracking(Pix2Cm,FT);
    
    %Rotate animal trajectory. 
    try 
        load(fullfile(session,'rotated.mat')); 
    catch
        [bounds,rot_x,rot_y] = sections(x,y);     
    end

    NumFrames = size(FT,2); 
    x = rot_x; y = rot_y;
    
%% Bin spatial position.
    %Range in XY position. 
    Xrange = max(x)-min(x);
    Yrange = max(y)-min(y);

    %Number of bins. 
    NumXBins = ceil(Xrange/cmperbin);
    NumYBins = ceil(Yrange/cmperbin);

    %Edges. 
    Xedges = (0:NumXBins)*cmperbin+min(x);
    Yedges = (0:NumYBins)*cmperbin+min(y);

    %Bin spatial position. 
    [Xcounts,Xbin] = histc(x,Xedges);
    [Ycounts,Ybin] = histc(y,Yedges);
    
    %Realign binning. 
    Xbin(Xbin == (NumXBins+1)) = NumXBins;
    Ybin(Ybin == (NumYBins+1)) = NumYBins;

    Xbin(Xbin == 0) = 1;
    Ybin(Ybin == 0) = 1;
    
    %Linearize bins. 
    loc_index = sub2ind([NumXBins,NumYBins],Xbin,Ybin);
    num_bins = length(unique(loc_index)); 
    
%% Find spatial information.
    %Preallocate.
    lambda = nan(NumNeurons,1); 
    lambda_i = nan(NumNeurons,num_bins); 
    p_i = nan(1,num_bins); 
    INFO = nan(NumNeurons,1); 
    in_bin = logical(zeros(NumFrames,num_bins)); 
    dwell = nan(num_bins,1); 
    
    parfor i = 1:num_bins
        %Find all frames where the mouse was in that spatial bin. 
        in_bin(:,i) = loc_index == i; 

        %Number of frames in spatial bin.
        dwell(i) = sum(in_bin(:,i)); 
        p_i(i) = dwell(i) / NumFrames;                                             %p_i.
    end
     
    %Eliminate frames where occupancy < 50 ms. 
    dwell(dwell <= 1) = nan; 
    p_i(isnan(dwell)) = nan; 
    
    %Find good bins. 
    good = find(~isnan(p_i)); 
    num_good = length(good); 
     
    for this_neuron = 1:NumNeurons
        if mod(this_neuron,10) == 0
            disp(['Calculating spatial information score for neuron #', num2str(this_neuron), '...']); 
        end
        
        %Mean firing rate. 
        lambda(this_neuron) = mean(FT(this_neuron,:));                              %Lambda. 

        %Mean firing rate for each neuron for each bin. 
        for this_bin = 1:num_good
            i = good(this_bin); 
            lambda_i(this_neuron,i) = sum(FT(this_neuron,in_bin(:,i)))/dwell(i);    %Lambda_i. 
        end
        
        %I = sum(p_i * lambda_i * log2(lambda_i/lambda))
        %I think we forgo normalizing with lambda here because of the low
        %firing rate of our cells. Normalizing to mean firing rate will
        %give high spatial information to neurons that fire extremely
        %rarely because they will necessarily only fire in one place in
        %that one instance. Below is how Tonegawa does it, but not Skaggs,
        %but Skaggs used ephys data.
        INFO(this_neuron) = nansum(p_i.*lambda_i(this_neuron,:).*log2(lambda_i(this_neuron,:)./lambda(this_neuron)));
    end
    
    save SpatInfo.mat INFO lambda lambda_i p_i; 
end

    