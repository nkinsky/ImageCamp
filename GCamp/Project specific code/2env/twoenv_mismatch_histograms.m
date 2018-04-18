% Two-env plot mismatch session histogram

% edges = 0:(pi()/12):(2*pi());
edges = (-pi()/12):(pi()/6):(23*pi()/12);
% edges2 = 0:(pi()/12):(2*pi());
edges2 = (-pi()/8):(pi()/4):(15*pi()/8);
ne = length(edges);
ne2 = length(edges2);

mismatch_cutoff = 22.5;
%%
mismatch_ang_all_sq = cell(1,4);
mismatch_bool_all_sq = nan(4,8,8);
for j = 1:4
    [~, delta_angle_med, arena_rot] = plot_pfangle_batch(all_square2(j,:));
    mismatch_bool = abs(delta_angle_med - arena_rot) > mismatch_cutoff;
    mismatch_ang_all_sq{j} =  delta_angle_med(mismatch_bool);
    mismatch_bool_all_sq(j,:,:) = mismatch_bool;
end


%%
mismatch_ang_all_oct = cell(1,4);
mismatch_bool_all_oct = nan(4,8,8);
for j = 1:4
    [~, delta_angle_med, arena_rot] = plot_pfangle_batch(all_oct2(j,:));
    mismatch_bool = abs(delta_angle_med - arena_rot) > mismatch_cutoff;
    mismatch_ang_all_oct{j} =  delta_angle_med(mismatch_bool);
    mismatch_bool_all_oct(j,:,:) = mismatch_bool;
end

%%
angles_all_sq = cat(1,mismatch_ang_all_sq{:});
% n_all = length(angles_all);
figure(35); set(gcf,'Position',[2225 420 1100 370]);
subplot(1,2,1)
hsq = polarhistogram(circ_ang2rad(angles_all_sq), edges, 'DisplayStyle', 'stairs',...
    'Normalization','probability');
hold on

angles_all_oct = cat(1,mismatch_ang_all_oct{:});
% n_all = length(angles_all);
hoct = polarhistogram(circ_ang2rad(angles_all_oct), edges, 'DisplayStyle', ...
    'stairs','Normalization','probability');

% hc = polarplot(edges,n_all/(ne-1)*ones(size(edges)),'r--');
hc = polarplot(edges,1/(ne-1)*ones(size(edges)),'r--');
legend(cat(1,hsq,hoct,hc),{'Square','Octagon','Chance'})
title('Mismatch session PF rot angles')

subplot(1,2,2)
hsq2 = histogram(angles_all_sq, circ_rad2ang(edges2), 'DisplayStyle', 'bar',...
    'Normalization','probability');
hold on
hoct2 = histogram(angles_all_oct, circ_rad2ang(edges2), 'DisplayStyle', ...
    'stairs','Normalization','probability');
hc2 = plot(circ_rad2ang(edges2),1/(ne2-1)*ones(size(edges2)),'r--');
hold off
legend(cat(1,hsq2,hoct2,hc2),{'Square','Octagon','Chance'})
xlim([-22.5 382.5])
set(gca,'XTick',0:45:360,'XTickLabels', ...
    arrayfun(@num2str,0:45:360,'UniformOutput',false));
title('Mismatch session PF rot angles')

%%
sq_time_diff = make_timediff_mat(G30_square);
oct_time_diff = make_timediff_mat(G30_oct);

%%
% angles_all = cat(1,mismatch_ang_all_oct{:});
% n_all = length(angles_all);
% figure;
% polarhistogram(circ_ang2rad(angles_all), edges, 'DisplayStyle', 'stairs')
% hold on
% polarplot(edges,n_all/(ne-1)*ones(size(edges)),'r--')
% title('Octagon Mismatch session PF rot angles')
