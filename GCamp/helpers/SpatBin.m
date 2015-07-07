function [loc_index,bins,allbins,FT,NumXBins,NumYBins] = SpatBin(FT,ind)
%
%
%

%% Useful parameters. 
    Pix2Cm = 0.15;
    cmperbin = .25;

%% Align tracking to imaging then rotate. 
    %Align. 
    [x,y,~,FT] = AlignImagingToTracking(Pix2Cm,FT);
    
    %Rotate animal trajectory. 
    try 
        load(fullfile(session,'rotated.mat')); 
    catch
        [bounds,rot_x,rot_y] = sections(x,y,1);     
    end

    x = rot_x; y = rot_y; 
    
    %Only look at the data points indicated by ind. 
    if ~strcmp(ind,'all');
        x = x(ind); 
        y = y(ind);
    end
    
%% Bin. 
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
    
    %Bin numbers. 
    bins = unique(loc_index); 
    allbins = [1:NumXBins*NumYBins]; 
end