% Two-env plot mismatch session histogram

% edges = 0:(pi()/12):(2*pi());
edges = (-pi()/12):(pi()/6):(23*pi()/12);
ne = length(edges);
%%
mismatch_ang_all_sq = cell(1,4);
mismatch_bool_all_sq = nan(4,8,8);
for j = 1:4
    [~, delta_angle_med, arena_rot] = plot_pfangle_batch(all_square2(j,:));
    mismatch_bool = abs(delta_angle_med - arena_rot) > 45;
    mismatch_ang_all_sq{j} =  delta_angle_med(mismatch_bool);
    mismatch_bool_all_sq(j,:,:) = mismatch_bool;
end


%%
mismatch_ang_all_oct = cell(1,4);
mismatch_bool_all_oct = nan(4,8,8);
for j = 1:4
    [~, delta_angle_med, arena_rot] = plot_pfangle_batch(all_oct2(j,:));
    mismatch_bool = abs(delta_angle_med - arena_rot) > 45;
    mismatch_ang_all_oct{j} =  delta_angle_med(mismatch_bool);
    mismatch_bool_all_oct(j,:,:) = mismatch_bool;
end

%%
angles_all = cat(1,mismatch_ang_all_sq{:});
n_all = length(angles_all);
figure;
hsq = polarhistogram(circ_ang2rad(angles_all), edges, 'DisplayStyle', 'stairs',...
    'Normalization','probability');
hold on

angles_all = cat(1,mismatch_ang_all_oct{:});
n_all = length(angles_all);
hoct = polarhistogram(circ_ang2rad(angles_all), edges, 'DisplayStyle', ...
    'stairs','Normalization','probability');

% hc = polarplot(edges,n_all/(ne-1)*ones(size(edges)),'r--');
hc = polarplot(edges,1/(ne-1)*ones(size(edges)),'r--');
legend(cat(1,hsq,hoct,hc),{'Square','Octagon','Chance'})
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
