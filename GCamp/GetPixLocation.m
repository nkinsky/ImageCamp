function [inbin,FT,allbins,goodbins,NumXBins,NumYBins] = GetPixLocation(FT,ind)
%
%
%


%% Bin spatial position.
    [loc_index,bins,allbins,FT,NumXBins,NumYBins] = SpatBin(FT,ind); 
    
    %Eliminate bins that the mouse visited fewer than two frames. 
    hits = hist(loc_index,bins); 
    goodbins = bins(hits>=2);
    NumBins = length(allbins);
    NumGoodBins = length(goodbins); 
    
%% Useful parameters. 
    NumFrames = size(loc_index,2); 
    
    %Preallocate logical array for ALL bins (not just occupied ones). 
    inbin = logical(zeros(NumBins,NumFrames)); 
    
%% Find where the mouse is in each bin. 
    for i=1:NumGoodBins
        this_bin = goodbins(i); 
        
        %P(A) logical for passing through pcond. Zeros where mouse didn't
        %visit. 
        inbin(this_bin,:) = loc_index == this_bin; 
    end
    
end