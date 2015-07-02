function [bootL,bootR,pval] = bootsplit2(session,Alt,TMap)
%
%
%

%% Parameters and preallocate. 
    load(fullfile(session,'ProcOut.mat'),'NumNeurons'); 
    B = 500; 
    bootL = nan(NumNeurons,B); 
    bootR = nan(NumNeurons,B); 
    pval = nan(NumNeurons,1); 
    
%% Empirical.
    try 
        load(fullfile(session,'Splitter_Info.mat')); 
    catch
        [L_INFO,R_INFO,active] = splitter_info(session,Alt,TMap); 
    end
    
%% Permutation test. 
    parfor i=1:B
        Alt_shuff = shuff_trials(Alt); 
        
        [bootL(:,i),bootR(:,i),~] = splitter_info(session,Alt_shuff,TMap); 
    end
    
    %Difference between spatial information scores for left and right. 
    INFO_DIFF = abs(L_INFO - R_INFO); 
    bootINFO_DIFF = abs(bootL - bootR); 
    
    parfor this_neuron = 1:NumNeurons
        pval(this_neuron) = sum(bootINFO_DIFF(this_neuron,:) > INFO_DIFF(this_neuron))/B; 
    end
    
    boot = [bootL; bootR]; 
    boot = boot(:); 
    
%% Plot.
    figure;
    ecdf(L_INFO);
    hold on;
    ecdf(R_INFO); 
    ecdf(boot); 
    hold off;
        legend({'Left','Right','Permuted'}); 

end