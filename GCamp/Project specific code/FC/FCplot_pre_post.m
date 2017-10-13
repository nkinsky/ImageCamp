%% Plot pre/post and video image for FC pilots

Animals_plot = ''; % specify only 1 session for each mouse
num_figs = ceil(length(Animals_plot)/4);

MD = MakeMouseSessionListER('Eichentron');
for j = 1:num_figs
    figure
    try
        for k = 1:4
            animal_num = 4*(j-1) + k;
            sesh_use_bool = find(arrayfun(@(a,b) strcmpi(a.Animal,...
                Animals_plot(animal_num)) && strcmpi(a.Date,'base')),MD);
            sesh_use = MD(sesh_use_bool);
            
            subplot(3,4,k)
            plot_traj(sesh_use,'xy_append','AVI','h_in',gca,'dir_append','Pre Exposure');
            
            subplot(3,4,4+k)
            plot_traj(sesh_use,'xy_append','AVI','h_in',gca,'dir_append','Exposure');
            
            subplot(3,4,8+k)
            plot_traj(sesh_use,'h_in',gca,'dir_append','Exposure','plot_vid', true);
        end
    catch
    end
end