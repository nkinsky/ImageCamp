% Eraser reg_qc scripts

%% First plot out paiwise registrations between all mice!

mice_to_plot = {'Marble14', 'Marble18', 'Marble20', 'Marble27', 'Marble29'};

for j = 1:length(mice_to_plot)
    sessions_use = 