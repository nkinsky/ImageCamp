function plot_splitter(session)
%
%
%

%% Load appropriate files. 
    load(fullfile(session,'PlaceMaps.mat'),'x','y','FT'); 
    load(fullfile(session,'Splitters.mat')); 
    load(fullfile(session,'Stemcells.mat'),'cell_ind'); 
    
    try
        load(fullfile(session,'Alternation.mat')); 
    catch
        Alt = postrials(x,y,0); 
    end
    
%% Useful parameters.
    cell_ind = unique(cell_ind); 
    sig_splitters = cell_ind(pval<0.05); 
    num_splitters = length(sig_splitters); 

%% Plot.
    for this_splitter = 1:num_splitters
        splitID = sig_splitters(this_splitter); 
        stem = Alt.frames(Alt.section == 2); 
        left = Alt.frames(Alt.choice == 1); 
        right = Alt.frames(Alt.choice == 2); 
        
        spk = find(FT(splitID,:) == 1);
        spk_left = intersect(spk,intersect(stem,left));
        spk_right = intersect(spk,intersect(stem,right)); 
        
        figure;
            subplot(2,2,1:2);
                plot(x,y);
                hold on;
                plot(x(spk_left),y(spk_left),'r.','markersize',20); 
                hold off;
                title(['Neuron #', num2str(splitID), ': Left Trials'],'fontsize',12); 
                set(gca,'ticklength',[0 0]); 
            
            subplot(2,2,3:4); 
                plot(x,y);
                hold on;
                plot(x(spk_right),y(spk_right),'r.','markersize',20); 
                hold off;
                title('Right Trials','fontsize',12); 
                set(gca,'ticklength',[0 0]); 

    end
end
        
        
        