function [inbin,FT] = GetPixLocation(FT,ind)
%
%
%


%% Bin spatial position.
    [loc_index,bins,~,FT] = SpatBin(FT,ind); 
    
    %Eliminate bins that the mouse visited fewer than two frames. 
    hits = hist(loc_index,bins); 
    bins(hits<2) = []; 
    NumBins = length(bins); 
    
%% Useful parameters. 
    NumFrames = size(loc_index,2); 
    inbin = logical(zeros(NumBins,NumFrames)); 
    
%% Find where the mouse is in each bin. 
    parfor i=1:NumBins
        this_bin = bins(i); 
        
        %P(A) logical for passing through pcond. 
        inbin(i,:) = loc_index == this_bin; 
    end
    
end