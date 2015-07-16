function plot_splitter(session,splitters,stem_only)
%
%
%

%% Load data.
    load(fullfile(session,'Alternation.mat')); 
    load(fullfile(session,'PlaceMaps.mat'),'x','y','FT'); 
    load(fullfile(session,'Splitter_Info.mat')); 
    load(fullfile(session,'Splitter_Info_pval.mat')); 
    
%% Useful parameters.
    num_splitters = length(splitters); 

%% Plot.
    for this_splitter = 1:num_splitters
        splitID = splitters(this_splitter); 
        stem = Alt.frames(Alt.section == 2); 
        left = Alt.frames(Alt.choice == 1); 
        right = Alt.frames(Alt.choice == 2); 
        
        spk = find(FT(splitID,:) == 1);
        
        if stem_only
            spk_left = intersect(spk,intersect(stem,left));
            spk_right = intersect(spk,intersect(stem,right)); 
        elseif ~stem_only
            spk_left = intersect(spk,left);
            spk_right = intersect(spk,right); 
        end
        
        if any(spk_left) || any(spk_right)
            figure;
                subplot(2,2,1:2);
                    plot(x,y);
                    hold on;
                    plot(x(spk_left),y(spk_left),'r.','markersize',20); 
                    hold off;
                    title(['Neuron #', num2str(splitID), ': Left Trials, Info: ',num2str(L_INFO(splitID)), ', p=', num2str(L_pval(splitID))],'fontsize',12); 
                    set(gca,'ticklength',[0 0]); 

                subplot(2,2,3:4); 
                    plot(x,y);
                    hold on;
                    plot(x(spk_right),y(spk_right),'r.','markersize',20); 
                    hold off;
                    title(['Neuron #', num2str(splitID), ': Right Trials, Info: ',num2str(R_INFO(splitID)), ', p=', num2str(R_pval(splitID))],'fontsize',12); 
                    set(gca,'ticklength',[0 0]); 
        end

    end
end
        
        
        