function [] = pos_align_check(sesh)
% pos_align_check(sesh)
%  Check to make sure all sessions in sesh have their position data aligned
%  (e.g. check that batch_align_pos ran properly)
figure
for j = 1:length(sesh)
    
    % Load position data
    dir_use = ChangeDirectory_NK(sesh(j),0);
    load(fullfile(dir_use,'Pos_align.mat'),'x_adj_cm','y_adj_cm',...
        'xmin','xmax','ymin','ymax')
    
    % Plot on an individual subplot
    subplot_auto(length(sesh) + 1,j+1);
    plot(x_adj_cm,y_adj_cm);
    xlim([xmin xmax]); ylim([ymin ymax])
    title(['Session ' num2str(j)])
    
    % Plot everything on top of the other
    subplot_auto(length(sesh) + 1, 1);
    hold on
    plot(x_adj_cm,y_adj_cm);
    xlim([xmin xmax]); ylim([ymin ymax])
    hold off
    title('All Sessions')
end
end

