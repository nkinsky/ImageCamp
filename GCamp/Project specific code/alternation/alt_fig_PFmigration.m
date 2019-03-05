% Alternation plots of migration of tuning curve within AND across sessions

%% Within sessions
sesh_use = G30_alt(G30_free_bool); 
for j = 1:length(sesh_use)
        track_COM_win_sesh(sesh_use(j)); ...
        printNK('Delta COM by trial', 'alt', 'append', true); 
end
close all

sesh_use = G31_alt(G31_free_bool); 
for j = 1:length(sesh_use) 
    track_COM_win_sesh(sesh_use(j)); 
    printNK('Delta COM by trial', 'alt', 'append', true); 
end
close all

sesh_use = G45_alt(G45_free_bool); 
for j = 1:length(sesh_use)
    track_COM_win_sesh(sesh_use(j)); 
    printNK('Delta COM by trial', 'alt', 'append', true); 
end
close all

sesh_use = G48_alt(G48_free_bool); 
for j = 1:length(sesh_use)
    track_COM_win_sesh(sesh_use(j)); 
    printNK('Delta COM by trial', 'alt', 'append', true); 
end
close all

%% Across sessions
diffs_all = [];
for k = 1:4
    sesh_use = alt_all_cell{k}(alt_all_free_boolc{k});
    COM_bwall = [];
    for j = 1:length(sesh_use)-1
        try
            COM_bw_sesh2 = alt_COM_across_days(sesh_use(j), sesh_use(j+1));
        catch
            COM_bw_sesh2 = [];
            disp(['Error processing session ' num2str(j) ' to ' num2str(j+1)])
        end
        COM_bwall = cat(1, COM_bwall, ...
            COM_bw_sesh2(all(~isnan(COM_bw_sesh2),2),:));
    end
    
    figure; set(gcf, 'Position', [2180 360 700 450]);
    med_diff = median(diff(COM_bwall,1,2));
    histogram(diff(COM_bwall,1,2),20);
    hold on;
    hmed = plot([med_diff, med_diff], get(gca, 'YLim'), 'r--');
    xlabel('COM1 - COM2 (- = moved backwards)')
    ylabel('Count')
    title(['Stem PF migration between sessions: ' mouse_name_title(sesh_use(1).Animal)])
    legend(hmed, 'Median')
    
    diffs_all = [diffs_all; diff(COM_bwall,1,2)];
end


figure; set(gcf, 'Position', [2180 360 700 450]);
med_diff = median(diffs_all);
histogram(diffs_all,20);
hold on;
hmed = plot([med_diff, med_diff], get(gca, 'YLim'), 'r--');
xlabel('COM1 - COM2 (- = moved backwards)')
ylabel('Count')
title(['Stem PF migration between sessions: All Mice'])
legend(hmed, 'Median')