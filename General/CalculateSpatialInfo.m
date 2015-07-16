function [INFO,p_i,lambda,lambda_i] = CalculateSpatialInfo(session,stem_only,varargin)
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
    load(fullfile(session,'ProcOut.mat'),'FT','NumNeurons'); 
    
%% Useful parameters.
    Pix2Cm = 0.15;
    cmperbin = .25;

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
    
    %Get section number. 
    sect = getsection(x,y,'skip_rot_check',1); 
    
%% Optional: For looking at left/right spatial information in Alternation. 
    if exist('varargin','var')
        turn_ind = varargin{1};
    else
        turn_ind = logical(ones(NumFrames,1)); 
    end
    
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
    
    %Linearize bins. loc_index is a Tx1 vector where T is number of frames.
    %It contains the pixel that the mouse is in at a timestep. 
    loc_index = sub2ind([NumXBins,NumYBins],Xbin,Ybin);
    
    if stem_only
        bins = loc_index(sect(:,2) == 2);
        bins = unique(bins); 
    elseif ~stem_only
        bins = unique(loc_index); 
    end
    
    num_bins = length(bins); 
    
%% Find spatial information.
    %Preallocate.
    lambda = nan(NumNeurons,1);                     %Mean firing rate of each neuron. 
    lambda_i = nan(NumNeurons,num_bins);            %Mean firing rate of each neuron in each bin. 
    p_i = nan(1,num_bins);                          %Number of frames occupying this pixel divided by total session length. 
    INFO = nan(NumNeurons,1);                       %Spatial information for each neuron. 
    in_bin = logical(zeros(NumFrames,num_bins));    %R: Timestep. C: Spatial bin. Boolean vector where 1 means in that bin at that time.  
    dwell = nan(num_bins,1);                        %Sum of in_bin across time. 
    LR_Frames = sum(turn_ind); 
    
    for i = 1:num_bins
        %Find all frames where the mouse was in that spatial bin. 
        this_bin = bins(i);
        in_bin(:,i) = loc_index == this_bin; 

        %Number of frames in spatial bin.
       	dwell(i) = sum(in_bin(turn_ind,i)); 
        p_i(i) = dwell(i) / LR_Frames;              %p_i.
    end
     
    %Eliminate frames where occupancy < 50 ms. 
    dwell(dwell <= 1) = nan; 
    p_i(isnan(dwell)) = nan; 
    
    %Find good bins. 
    good = find(~isnan(p_i)); 
    num_good = length(good); 
     
    for this_neuron = 1:NumNeurons
        if mod(this_neuron,10) == 0
            disp(['Calculating spatial information for neuron #', num2str(this_neuron), '...']); 
        end
        
        %Mean firing rate. 
        lambda(this_neuron) = mean(FT(this_neuron,turn_ind'));                                   %Lambda. 

        %Mean firing rate for each neuron for each bin. 
        for this_bin = 1:num_good
            i = good(this_bin); 
            lambda_i(this_neuron,i) = sum(FT(this_neuron,turn_ind & in_bin(:,i)))/dwell(i);     %Lambda_i. 
        end
        
        %I = sum(p_i * lambda_i * log2(lambda_i/lambda))
        %I think we forgo normalizing with lambda here because of the low
        %firing rate of our cells. Normalizing to mean firing rate will
        %give high spatial information to neurons that fire extremely
        %rarely because they will necessarily only fire in one place in
        %that one instance. Below is how Tonegawa does it, but not Skaggs,
        %though Skaggs used ephys data.
        INFO(this_neuron) = nansum(p_i.*lambda_i(this_neuron,:).*log2(lambda_i(this_neuron,:)./lambda(this_neuron)));
    end
    
end