% twoenv_registration_figs

%% Sanity check to display same day vs 3 day vs 7 day registrations
sesh_comps = [1 2 7 15];
for j = 1:4
    sesh_use = all_sesh2(j,:);
    Animal_text = mouse_name_title(sesh_use(1).Animal);
    if ismember(j,[1 3])
        figure
    end
    for k = 1:3
        comp_sesh = sesh_comps(k+1);
        ha = subplot(2,3,3*mod(j-1,2)+k);
        plot_registration(sesh_use(1),sesh_use(comp_sesh),'',ha);
        title([Animal_text ' - session 1 vs. session ' num2str(comp_sesh)]);
    end
end

%% Print out registration for all sesssions for each mouse

for j = 1:4
    sesh_use = all_sesh2(j,:);
    Animal = sesh_use(1).Animal;
    Animal_text = mouse_name_title(Animal);
    for k = 2% :16
        plot_registration(sesh_use(1), sesh_use(k));
        title([Animal_text ' - session 1 vs. session ' num2str(k)]);
        hold off
        printNK([ Animal ' - all registrations'],'2env','append',true);
        close(gcf)
    end

end