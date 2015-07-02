function BayesScore = GetBayesScore(FT,ind)
%
%
%

%% 
    if ~strcmp(ind,'all')
        FT = FT(:,ind); 
    end
    NumNeurons = size(FT,1); 
    
%% 
    [inbin,FT] = GetPixLocation(FT,ind);
    NumBins = size(inbin,1); 
    BayesScore = nan(NumBins,NumNeurons); 
    
    for i=1:NumBins
        if mod(i,10) == 0
            disp(['Getting Bayes Score for Bin #', num2str(i), '...']); 
        end
        
        for j=1:NumNeurons
            spks = FT(j,:); 

            [pBgA,pA,pB] = pcond(inbin(i,:),spks); 
            
            BayesScore(i,j) = pBgA * pA / pB; 
        end
    end
    
end