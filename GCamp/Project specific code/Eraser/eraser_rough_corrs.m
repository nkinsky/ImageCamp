% Rough eraser script to get correlations between day -2, day -1

%%
before_shock = [ 1 2; 1 3; 2 3];
% before_rotate = [ 0; 0; 0]; % for Marble7 open
before_rotate = [0 180 180]; % Marble7 shock

after_shock = [ 4 5; 4 6; 4 7; 5 6; 5 7; 6 7];
% after_rotate = [0 0 180 0 180 180]'; % for Marble7 open
after_rotate = [0 0 0 180 180 0]'; % for Marble7 shock

before_after = [1 4; 1 5; 1 6; 1 7; 2 4; 2 5; 2 6; 2 7; 3 4; 3 5; 3 6; 3 7];
% before_after_rotate = [0 0 0 180 0 0 0 180 0 0 0 180]'; % for Marble7 open
before_after_rotate = [180 180 180 180 0 180 0 0 180 180 0 180]'; % for Marble7 shock rough

nbefore = size(before_shock,1);
nafter = size(after_shock,1);
nbef_aft = size(before_after,1);
%% Calculate correlations between all sessions before the shock
before_corrs = nan(size(before_shock,1),1);

sesh_use = Marble7_shock;
load(fullfile(sesh_use(1).Location,'batch_session_map.mat'));
for j = 1:size(before_shock,1)
    sesh1 = sesh_use(before_shock(j,1));
    sesh2 = sesh_use(before_shock(j,2));
    rough_corrs = corrTMap2(sesh1, sesh2, before_rotate(j), '', ...
        'Placefields_1cm_speed1.mat', 'batch_map', batch_session_map);
    before_corrs(j) = nanmean(rough_corrs);
end

%% Calculate correlations between all sessions after the shock
after_corrs = nan(size(after_shock,1),1);
for j = 1:size(after_shock,1)
    sesh1 = sesh_use(after_shock(j,1));
    sesh2 = sesh_use(after_shock(j,2));
    rough_corrs = corrTMap2(sesh1, sesh2, after_rotate(j), '', ...
        'Placefields_1cm_speed1.mat', 'batch_map', batch_session_map);
    after_corrs(j) = nanmean(rough_corrs);
end

%% Calculate correlations between sessions before-after the shock
before_after_corrs = nan(size(before_after,1),1);
for j = 1:size(before_after,1)
    sesh1 = sesh_use(before_after(j,1));
    sesh2 = sesh_use(before_after(j,2));
    rough_corrs = corrTMap2(sesh1, sesh2, before_after_rotate(j), '', ...
        'Placefields_1cm_speed1.mat', 'batch_map', batch_session_map);
    before_after_corrs(j) = nanmean(rough_corrs); 
end

%% Rough bar plot
try close(310); end
figure(310); set(gcf,'Position',[2300 350 600 400]);
h = gca;

frz_all = cat(1,before_corrs, after_corrs, before_after_corrs, ...
    before_after_corrs((end-3):end));
frz_groups = cat(1,ones(nbefore,1),2*ones(nafter,1),3*ones(nbef_aft,1),...
    4*ones(4,1));

scatterBox(frz_all, frz_groups, 'xLabel', {'Before Shock', 'After Shock',...
    'Before vs After Shock', 'Day 0 vs After'}, 'yLabel', 'Mean TMap Corr', ...
    'h', h, 'transparency', 0.95)
hold on
plot([3.5 3.5], get(gca,'YLim'),'k--')
title('Marble7 open field')

