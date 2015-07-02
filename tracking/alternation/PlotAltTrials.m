function PlotAltTrials(Alt)
%PlotAltTrials(Alt)
%   
%   Plots all the trials in an alternation session. 
%   
%   INPUT:
%       Alt: Struct array output from postrials. 
%

%% Get parameters. 
    xmin = min(Alt.x); xmax = max(Alt.x);
    ymin = min(Alt.y); ymax = max(Alt.y); 
    
    numtrials = max(Alt.summary(:,1)); 
    
%% Plot trials.
    for i = 1:numtrials
        choice = unique(Alt.choice(Alt.trial==i));
        alternated = unique(Alt.alt(Alt.trial==i)); 
        
        if choice == 1
            choice = 'L';
        elseif choice == 2
            choice = 'R';
        end
        
        if alternated == 1
            alternated = 'Correct';
        elseif alternated == 0
            alternated = 'Wrong'; 
        end
        
        figure;
        plot(Alt.x(Alt.trial==i),Alt.y(Alt.trial==i));
            title(['Trial ', num2str(i), ' ', choice, ' ', alternated]); 
            xlim([xmin, xmax]);
            ylim([ymin, ymax]); 
    end
    
end
