%% Plot pre/post and video image for FC pilots

Animals_plot = {'pf10', 'pf11', 'pf12', 'pf13'}; %'3pf1','3pf2','3pf3','2pf6','2pf8','2pf9','2pf7','3pf4'}; % specify only 1 session for each mouse
num_figs = ceil(length(Animals_plot)/4);

MD = MakeMouseSessionListER('Eichentron');
try
    for j = 1:num_figs
        figure
        
        for k = 1:4
            animal_num = 4*(j-1) + k;
            sesh_use_bool = find(arrayfun(@(a) strcmpi(a.Animal,...
                Animals_plot{animal_num}) && strcmpi(a.Date,'base'),MD));
            sesh_use_pre = find(arrayfun(@(a) strcmpi(a.Animal,...
                Animals_plot{animal_num}) && strcmpi(a.Date,'pre-exposure'),MD));
            sesh_use_post = find(arrayfun(@(a) strcmpi(a.Animal,...
                Animals_plot{animal_num}) && strcmpi(a.Date,'exposure'),MD));
            sesh_use = MD(sesh_use_bool);
            sesh_use_pre = MD(sesh_use_pre); if length(sesh_use_pre) > 1; sesh_use_pre = sesh_use_pre(1); end
            sesh_use_post = MD(sesh_use_post); if length(sesh_use_post) > 1; sesh_use_post = sesh_use_post(1); end
            
            if ~isempty(sesh_use_pre)
                subplot(3,4,k)
                plot_traj2(sesh_use_pre,'xy_append','AVI','h_in',gca,'title_line2',...
                    ['Freezing = ' num2str(sesh_use_pre.Freezing) '%']);
            end
            
            if ~isempty(sesh_use_pre)
                subplot(3,4,4+k)
                plot_traj2(sesh_use_post,'xy_append','AVI','h_in',gca,'title_line2',...
                    ['Freezing = ' num2str(sesh_use_post.Freezing) '%']);
            end
            
            if ~isempty(sesh_use_pre) || isempty(sesh_use_post) % Skip plotting if neither are there
                if ~isempty(sesh_use_post)
                    sesh_use_vid = sesh_use_post;
                elseif ~isempty(sesh_use_pre)
                    sesh_use_vid = sesh_use_pre;
                end
                subplot(3,4,8+k)
                plot_traj2(sesh_use_vid,'h_in',gca,'plot_vid', true,'title_line2',...
                    sesh_use_vid.Notes);
            end
        end
    end
catch
    disp('Done plotting trajectories')
end