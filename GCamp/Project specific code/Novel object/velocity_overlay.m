function [ ] = velocity_overlay( MD)
% velocity_overlay( MD)
% Plots ecdf of velocity from all sessions overlaid on each other.

num_sessions = length(MD);

date_legend = cell(num_sessions,1);
figure;
for j= 1:num_sessions
    [dirstr, sesh_full] = ChangeDirectory_NK(MD(j),0);
    load(fullfile(dirstr,'Pos_align.mat'),'speed')
    ecdf(speed);
    hold on
    date_legend{j} = sesh_full.Date;
end
xlabel('Velocity (cm/s)');
legend(cellfun(@mouse_name_title, date_legend,'UniformOutput',0))
hold off


end

