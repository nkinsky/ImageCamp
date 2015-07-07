function [BayesScore,BayesFlat] = GetBayesScore(FT,ind)
%
%
%

%% Useful parameters.
    if ~strcmp(ind,'all')
        FT = FT(:,ind); 
    end
    NumNeurons = size(FT,1);
    
%% Get Bayes Score. 
    [inbin,FT,allbins,goodbins,NumXBins,NumYBins] = GetPixLocation(FT,ind);
    NumBins = length(allbins); 
    NumGoodBins = length(goodbins);
    BayesScore = nan(NumBins,NumNeurons); 
    
    for i=1:NumGoodBins
        this_bin = goodbins(i); 
        
        if mod(i,50) == 0
            disp(['Getting Bayes Score for Bin #', num2str(i), ' of ', num2str(NumGoodBins)]); 
        end
        
        occ = inbin(this_bin,:); 
        
        parfor this_neuron=1:NumNeurons
            spks = FT(this_neuron,:); 
            
            [pBgA,pA,pB] = pcond(occ,spks,NumGoodBins); 
            
            BayesScore(this_bin,this_neuron) = pBgA * pA / pB; 
        end
    end
    
%% Unpack Bayes Score. De-linearize. 
    binidx = [1:NumBins]; 
    [x,y] = ind2sub([NumXBins,NumYBins],binidx); 
    
    %Preallocate. 
    BayesFlat = nan(max(x),max(y),NumNeurons); 
    
    for this_neuron=1:NumNeurons
        for i=1:NumBins                
            BayesFlat(x(i),y(i),this_neuron) = BayesScore(i,this_neuron);
        end
    end
end