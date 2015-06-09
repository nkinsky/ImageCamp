function boot = bootsplit2(session,Alt,TMap)
%
%
%

%% Parameters and preallocate. 
    load(fullfile(session,'ProcOut.mat'),'NumNeurons'); 
    B = 50; 
    bootL = nan(NumNeurons,B); 
    bootR = nan(NumNeurons,B); 
    
%% Empirical.
    [L_INFO,R_INFO,active] = splitter_info(session,Alt,TMap); 
    
%% Permutation test. 
    parfor i=1:B
        Alt_shuff = shuff_trials(Alt); 
        
        [bootL(:,i),bootR(:,i),~] = splitter_info(session,Alt_shuff,TMap); 
    end
    
    boot = [bootL; bootR]; 
    boot = boot(:); 
    
%% Plot.
    figure;
    ecdf(L_INFO);
    hold on;
    ecdf(R_INFO); 
    ecdf(boot); 

end