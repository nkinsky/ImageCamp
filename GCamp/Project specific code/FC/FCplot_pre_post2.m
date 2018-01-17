function [h] = FCplot_pre_post2(animal1, varargin)
% h = FCplot_pre_post2(animal1, animal2,...)
%
% Plot pre/post and video image for FC pilots with 2 pre and 2 post
% sessions.
%
%   INPUTS: animal names
%
%   OUTPUTS: figure handle to each figure
%
%   EXAMPLE:
%       FCplot_pre_post2('pf15','pf16','pf17','pf18');

Animals_plot = cat(1,animal1, varargin(:));
num_animals = length(Animals_plot);
sessions = {'pre-exposure1','pre-exposure2','shock','4hr','re-exposure1',...
    're-exposure2'};
num_sessions = length(sessions);

MD = MakeMouseSessionListER('Eichentron');

h = [];
for j = 1:num_animals
    h(j) = figure; set(gcf,'Position',[10 430 1250 510])
    
    for k = 1:num_sessions
        animal_num = j;
        
        sesh_use_bool = arrayfun(@(a) strcmpi(a.Animal,...
            Animals_plot{animal_num}) && strcmpi(a.Date,sessions{k}),MD);
        sesh_use = MD(sesh_use_bool);
        
        subplot(2,num_sessions,k)
        try
            plot_traj2(sesh_use,'xy_append','AVI','h_in',gca,'title_line2',...
                ['Freezing = ' num2str(sesh_use.Freezing) '%'],...
                'omit_session', true);
        catch
            text(0.1, 0.5, 'No Data Yet')
            axis off
        end
        
        try
        subplot(2,num_sessions,num_sessions+k);
        plot_traj2(sesh_use,'h_in',gca,'plot_vid', true,'title_line2',...
            sesh_use.Notes, 'omit_session', true);
        catch
            text(0.1, 0.5, 'No Data Yet')
            axis off
        end
        
    end
end
