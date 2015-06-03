function INFO = CalculateSpatialInfo(session)
%
%
%   

%% Load appropriate files. 
    load(fullfile(session,'ProcOut.mat')); 
    
%% Useful parameters.
    Pix2Cm = 0.15;
    cmperbin = .25;
    [num_cells,num_frames] = size(FT); 

%% Align tracking to imaging then rotate. 
    %Align. 
    [x,y,speed,FT,FToffset,FToffsetRear] = AlignImagingToTracking(Pix2Cm,FT);
    
    %Rotate animal trajectory. 
    try 
        load(fullfile(session,'rotated.mat')); 
    catch
        [bounds,rot_x,rot_y] = sections(x,y);     
    end

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
    lambda = nan(num_cells,1); 
    lambda_i = nan(num_cells,num_bins); 
    p_i = nan(num_cells,num_bins); 
    INFO = nan(num_cells,1); 

    for this_neuron = 1:num_cells
        if mod(this_neuron,10) == 0
            disp(['Calculating spatial information score for neuron #', num2str(this_neuron), '...']); 
        end
        lambda(this_neuron) = mean(FT(this_neuron,:));                     %Lambda. 
        
        parfor i = 1:num_bins
            in_bin = loc_index == i; 
            dwell = sum(in_bin); 
            p_i(i,this_neuron) = dwell / num_frames;                       %p_i. 
            
            lambda_i(i,this_neuron) = sum(FT(this_neuron,in_bin))/dwell;   %Lambda_i. 
        end
        
        INFO(this_neuron) = nansum(p_i(:,this_neuron).*lambda_i(:,this_neuron).*log2(lambda_i(:,this_neuron)./lambda(this_neuron)));
    end
end

    