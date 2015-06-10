function [bootL,bootR,L_pval,R_pval] = bootsplit2(session,Alt,TMap)
%
%
%

%% Parameters and preallocate. 
    load(fullfile(session,'ProcOut.mat'),'NumNeurons'); 
    B = 200; 
    bootL = nan(NumNeurons,B); 
    bootR = nan(NumNeurons,B); 
    L_pval = nan(NumNeurons,1); 
    R_pval = nan(NumNeurons,1); 
    
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
    
    parfor this_neuron = 1:NumNeurons
        L_pval(this_neuron) = sum(bootL(this_neuron,:) > L_INFO(this_neuron))/B; 
        R_pval(this_neuron) = sum(bootR(this_neuron,:) > R_INFO(this_neuron))/B; 
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