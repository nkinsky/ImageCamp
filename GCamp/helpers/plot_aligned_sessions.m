function [ ] = plot_aligned_sessions( sesh, align_filename )
% plot_aligned_sessions( sesh, align_filename )
% Use to check aligned session plots obtained from batch_align_pos. 
%
%   INPUTS
%   sesh:input the sessions to analyze.
%
%   align_filename: aligned position filename to use.  default =
%   Pos_align.mat

if nargin < 2
    align_filename = 'Pos_align.mat';
end

disp(['Plotting aligned positions in file ''' align_filename '''']);

figure(100);
for j = 1:length(sesh)
    dirstr = ChangeDirectory(sesh(j).Animal, sesh(j).Date, sesh(j).Session, 0);
    load(fullfile(dirstr, align_filename));
    % Plot on an individual subplot
    subplot_auto(length(sesh) + 1,j+1);
    plot(x_adj_cm, y_adj_cm);
    xlim([xmin xmax]); ylim([ymin ymax])
    title(['Session ' num2str(j)])
    % Plot everything on top of the other
    subplot_auto(length(sesh) + 1, 1);
    hold on
    plot(x_adj_cm, y_adj_cm);
    xlim([xmin xmax]); ylim([ymin ymax])
    hold off
    title('All Sessions')
end

end

