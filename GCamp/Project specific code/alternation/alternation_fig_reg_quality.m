% Alternation registration quality plots


%% Plot all neuron reg stats versus shuffled (note only plots 1st session versus
% all subsequent sessions. Next cell does ALL pairwise comparisons).
% Run step 3.5 in alternation_workflow first to get relevant variables.

sesh_plot = G48_alt;
filename = 'G48_regstats.mat';

stats_use = importdata(fullfile(sesh_plot(1).Location,filename));

% Get number shuffles
n1 = length(stats_use{1}.orient_diff);
nshuf = length(stats_use{1}.shuffle.orient_diff)/n1;
nsesh = length(stats_use);

% Calculate mean orientation diff for each session/shuffle
diff_means = cellfun(@(a) mean(abs(a.orient_diff)),stats_use);
shuf_diff_means = mean(abs(reshape(stats_use{1}.shuffle.orient_diff, n1, nshuf)));

% Calculate 95% CI for mean of orientation diff for shuffled distribution
CI = quantile(shuf_diff_means, [0.0275, 0.5, 0.975]);

try close(10); end
figure(10); set(gcf, 'Position', [2150 100 1560 800])

% Plot to ID any bad registrations
subplot(2,3,1:2)
plot(diff_means, 'o');
xlabel('Session #')
ylabel('|\Delta_{orient}|_{mean}')
hold on
hshuf = plot([0.5, nsesh + 0.5], [CI([1 3]); CI([1 3])], 'k--');
legend(hshuf(1), 'Shuffled 95% CI')
ylim([0 80])
xlim([0.5, nsesh + 0.5])
set(gca,'XTick',1:nsesh)
title([mouse_name_title(stats_use{1}.base.Animal) ' reg quality '])

% ScatterBox of good versus shuffled means
hsb = subplot(2,3,3);
scatterBox([diff_means; shuf_diff_means'], [ones(size(diff_means)); ...
    2*ones(size(shuf_diff_means'))], 'h', hsb, 'xLabels', {'Data', 'Shuffled'},...
    'ylabel', '|\Delta_{orient}|_{mean}', 'transparency', 1, ...
    'circleSize', 20, 'circleColor', [0.5 0.5 0.5])
subplot(2,3,6)
prks = ranksum(diff_means, shuf_diff_means);
text(0.1, 0.5, ['prksum data v shuf = ' num2str(prks, '%0.2g')])
axis off

%% Make confusion matrix for all pairwise registrations and calculate p-value?
% Yes, but only calculate shuffled distribution for one session-pair for
% now to save time.

sesh_plot = G48_alt;
nsesh = length(G48_alt);
ncomps = nsesh*(nsesh-1)/2;
name_append = ''; % '' buy default, use others to debug

mean_dorient_mat = nan(nsesh);
hw = waitbar(0,['Running pair-wise regisration qc for ' ...
    mouse_name_title(sesh_plot(1).Animal) ' ...']);
n = 1;
for j = 1:(nsesh - 1)
    for k = (j+1):nsesh
        try
            if j == 1 && k == 2 % n == 1
                reg_stats_wshuf = neuron_reg_qc(sesh_plot(j), sesh_plot(k), ...
                    'shuffle', 1000, 'name_append', name_append);
                reg_stats_temp = reg_stats_wshuf;
            else
                reg_stats_temp = neuron_reg_qc(sesh_plot(j), sesh_plot(k), ...
                    'shuffle', 0, 'name_append', name_append);
            end
            mean_dorient_mat(j,k) = mean(abs(reg_stats_temp.orient_diff));
        catch
            disp(['Error registering session ' num2str(j) ' to ' num2str(k)])
            mean_dorient_mat(j,k) = nan;
        end
        waitbar(n/ncomps, hw);
        n = n+1;
    end
end
close(hw)

% Calculate shuffled means
n1 = length(reg_stats_wshuf.orient_diff);
nshuf = length(reg_stats_wshuf.shuffle.orient_diff)/n1;
shuf_mean_dorient = mean(abs(reshape(reg_stats_wshuf.shuffle.orient_diff,...
    n1, nshuf)))';

% Get p-values, put into matrix
reg_p_mat = 1 - sum(mean_dorient_mat < ...
    shiftdim(repmat(shuf_mean_dorient,1,nsesh,nsesh),1),3)/nshuf;
reg_p_mat(tril(true(nsesh))) = nan;

savename = fullfile(sesh_plot(1).Location, ['reg_stats' name_append '_mat.mat']);
if exist(savename,'file')
    save(fullfile(sesh_plot(1).Location, ['reg_stats' name_append ...
        '_mat_archive.mat']), 'mean_dorient_mat', 'reg_p_mat', ...
        'reg_stats_wshuf', 'sesh_plot')
end

save(savename, 'mean_dorient_mat', 'reg_p_mat', 'reg_stats_wshuf', 'sesh_plot')

%% Fix any bad sessions by running neuron_registerMD with name_append set to 
% '_masks'

%% If you find ANY sessions you want to exclude, save them to reg_sesh_filter 
% with a 'false' in the appropriate index
% e.g.
% i = find(mean_dorient_mat > 30) OR find(reg_p_mat > 0.01)
% reg_sesh_filter = triu(true(nsesh),1);
% reg_sesh_filter(i) = false;
% sessions = sesh_plot;
% save(fullfile(sesh_plot(1).Location,'reg_sesh_filter'), 'reg_sesh_filter',...
%     'sessions')

% otherwise just run the following to let all through
sessions = sesh_plot;
nsesh = length(sesh_plot);
reg_sesh_filter = triu(true(nsesh),1);

save(fullfile(sesh_plot(1).Location,'reg_sesh_filter'), 'reg_sesh_filter',...
    'sessions')

