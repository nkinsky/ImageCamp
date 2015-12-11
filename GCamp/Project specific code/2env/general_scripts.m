%% Run neuron_reg_batch to fix previously screwed up registrations
neuron_reg_batch(MD(G30_oct_sesh(1)), MD(G30_oct_sesh(2:end)))
neuron_reg_batch(MD(G31_square_sesh(1)), MD(G31_square_sesh(2:end)))
neuron_reg_batch(MD(G31_oct_sesh(1)), MD(G31_oct_sesh(2:end)))

%%
neuron_reg_batch(MD(G30_square_sesh(1)),MD(G30_square_sesh(2):G30_oct_sesh(end)),...
    'name_append','_botharenas');
neuron_reg_batch(MD(G31_square_sesh(1)),MD(G31_square_sesh(2):G31_oct_sesh(end)),...
    'name_append','_botharenas');

%%
neuron_reg_batch(MD(G45_botharenas(1)),MD(G45_botharenas(2:end)),'name_append',...
    '_botharenas');
neuron_reg_batch(MD(G48_botharenas(1)),MD(G48_botharenas(2:end)),'name_append',...
    '_botharenas');

%% Check rotations

animal_indices = G31_botharenas;
MD_use = MD(animal_indices);

figure(215); 
for j = 1:length(MD_use); 
    ChangeDirectory_NK(MD_use(j)); 
    if j <=8
        n_plot = j;
    elseif j > 8
        n_plot = j+8;
    end
    
    subplot(4,8,n_plot);
    load('Pos_align_trans.mat');
    plot(x_adj_cm,y_adj_cm);
    title(num2str(get_rot_from_db(MD_use(j))));
    xlim([xmin xmax]); ylim([ymin ymax]);
    if j == 1 || j == 9
        ylabel('No rot')
    end
    
    subplot(4,8,n_plot+8);
    load('Pos_align_std_corr_trans.mat');
    plot(x_adj_cm,y_adj_cm);
    title(num2str(get_rot_from_db(MD_use(j))));
    xlim([xmin xmax]); ylim([ymin ymax]);
    if j == 1 || j == 9
        ylabel('Rot to std')
    end
    
end