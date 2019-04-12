% two env justification/explanation of PV effects and more support of what
% is going on
load('2env_PVsilent_cm4_local0-1000shuffles-2018-05-24.mat')

%% 1st, get place field dispersion metric for all animals to see if PFs rotate
% less accurately across arenas or as a result of arena connection
disp_metric_c2s = nan(4,8,8);
disp_metric_sq = nan(4,8,8);
disp_metric_oct = nan(4,8,8);
coh_bool_c2s = cell(4,8,8);
coh_bool_sq = cell(4,8,8);
coh_bool_oct = cell(4,8,8);
for j = 1:4
    [~, ~, ~, ~, ~, ~, coh_bool_c2s(j,:,:), ~, disp_metric_c2s(j,:,:)] = ...
        plot_pfangle_batch(all_square2(j,:), all_oct2(j,:), 1, false, 30, ...
        false, 1);
    [~, ~, ~, ~, ~, ~, coh_bool_sq(j,:,:), ~, disp_metric_sq(j,:,:)] = ...
        plot_pfangle_batch(all_square2(j,:), [], 1, false, 30, false, 1);
    [~, ~, ~, ~, ~, ~, coh_bool_oct(j,:,:), ~, disp_metric_oct(j,:,:)] = ...
        plot_pfangle_batch(all_oct2(j,:), [], 1, false, 30, false, 1);
end

% form boolean to exclude circ2square sessions at a day lag of 7, just to
% make sure they aren't solely accounting for the difference
exclude_lag7 = true(4,8,8);
exclude_lag7(:,1:2,7:8) = false;

%% Look at distributions for ALL mice across all days, including connected
% days... can use indices in twoenv_on_off to look at non-connected days
% only too.
figure(645); set(gcf, 'Position', [2439, 350, 650, 450])
hplot = subplot(1,2,1);
scatterBox(cat(1,disp_metric_oct(:),disp_metric_sq(:),disp_metric_c2s(exclude_lag7)),...
    cat(1,ones(size(cat(1,disp_metric_oct(:),disp_metric_sq(:)))), ...
    2*ones(size(disp_metric_c2s(exclude_lag7)))), 'xLabels', {'Same', 'Diff'},...
    'yLabel','mean PF_{disp}','transparency',0.7, 'circleColors', [0.3, 0.3, 0.3], ...
    'h', hplot);
xlabel('Arena')
hplot.FontName = 'SansSerif';
subplot(1,2,2);
prks_disp_metric = ranksum(cat(1,disp_metric_oct(:),disp_metric_sq(:)),...
    disp_metric_c2s(exclude_lag7),'tail','left');
text(0.1,0.5,['prks_{PFdisp} = ' num2str(prks_disp_metric, '%0.2g')])
axis off
make_figure_pretty(gcf)
printNK('PF rotational accuracy', '2env')

% Do I need to do this for connected days also? yes... probably should just
% re-incorporate to twoenv_on_off to make life easier, or maybe not? % do
% this ONLY for stuff you have already ran, e.g. separate days.

save('2env_PFrot_accuracy', 'coh_bool_c2s', 'coh_bool_sq', 'coh_bool_oct',...
    'disp_metric_c2s', 'disp_metric_sq', 'disp_metric_oct')


%% DI analysis - which direction does rate remapping occur?
DIcutoff_plot = 0.66; % cutoff for highly selective neurons removed that 
% contribute to discrimination between arenas

edges = -1:0.05:1; % for DI histogram
centers = edges(1:end-1)+mean(diff(edges));
nbins = length(edges)-1;
DIall = cell(4,8,8);
rPVall_c2s = cell(4,8,8); % rate only PVs (no spatial bin corrs)
rPVall_sq = cell(4,8,8);
rPVall_oct = cell(4,8,8);
hcounts = nan(4,8,8,nbins);
hcounts_nosil = nan(4,8,8,nbins);
for j = 1:4
    for k = 1:8
        for ll = 1:8
            PVuse_c2s = squeeze(max(reshape(Mouse(j).PVcorrs.circ2square(2).PV{k,ll},2,[],...
                size(Mouse(j).PVcorrs.circ2square(2).PV{k,ll},4)),[],2));
            rPVall_c2s{j,k,ll} = PVuse_c2s;
            
            rPVall_sq{j,k,ll} = squeeze(max(reshape(Mouse(j).PVcorrs.square(2).PV{k,ll},2,[],...
                size(Mouse(j).PVcorrs.square(2).PV{k,ll},4)),[],2));
            rPVall_oct{j,k,ll} = squeeze(max(reshape(Mouse(j).PVcorrs.circle(2).PV{k,ll},2,[],...
                size(Mouse(j).PVcorrs.circle(2).PV{k,ll},4)),[],2));
            
            DIall{j,k,ll} = (PVuse_c2s(1,:)-PVuse_c2s(2,:))./sum(PVuse_c2s,1);
            hcounts(j,k,ll,:) = histcounts(DIall{j,k,ll}, edges,...
                'Normalization', 'probability');
            hcounts_nosil(j,k,ll,:) = histcounts(DIall{j,k,ll}...
                (abs(DIall{j,k,ll}) ~= 1), edges, ...
                'Normalization', 'probability');
            
            
        end
    end
end

try close(147); end
figure(147); set(gcf,'Position',[1950 150 1800 800])

% % Plot of change in PV between sessions above
% subplot(1,2,1)
% plot(ones(size(PVuse)).*[1 2]', PVuse, 'ko-')

% Histogram of DI between sessions

DIcat = cat(2,DIall{:});
subplot(2,3,1)
histogram(DIcat,edges,'Normalization','probability')
hold on
plot([-DIcutoff_plot, -DIcutoff_plot], get(gca,'YLim'), 'k--', ...
    [DIcutoff_plot, DIcutoff_plot], get(gca,'YLim'), 'k--')
xlabel('DI'); ylabel('Probability')
title('All Mice/Sessions, with silent cells')

subplot(2,3,2)
histogram(DIcat(abs(DIcat) ~= 1),edges,'Normalization','probability')
hold on
plot([-DIcutoff_plot, -DIcutoff_plot], get(gca,'YLim'), 'k--', ...
    [DIcutoff_plot, DIcutoff_plot], get(gca,'YLim'), 'k--')
xlabel('DI'); ylabel('Probability')
title('All Mice/Sessions, no silent cells')

subplot(2,3,3)
text(0.1, 0.4,'What stats do I run for this? t-test vs zero?')
axis off

subplot(2,3,4)
histogram(DIall{3,3,4}, edges,'Normalization','probability')
hold on
plot([-DIcutoff_plot, -DIcutoff_plot], get(gca,'YLim'), 'k--', ...
    [DIcutoff_plot, DIcutoff_plot], get(gca,'YLim'), 'k--')
xlabel('DI'); ylabel('Probability')
title('Example Session-Pair, no silent cells')
make_figure_pretty;
printNK('Rate Modulation Direction Histograms','2env')

subplot(2,3,5)
histogram(DIall{3,3,4}(abs(DIall{3,3,4}) ~= 1), edges,...
    'Normalization','probability')
hold on
plot([-DIcutoff_plot, -DIcutoff_plot], get(gca,'YLim'), 'k--', ...
    [DIcutoff_plot, DIcutoff_plot], get(gca,'YLim'), 'k--')
xlabel('DI'); ylabel('Probability')
title('Example Session-Pair, no silent cells')
make_figure_pretty;
printNK('Rate Modulation Direction Histograms','2env')

% These look weird - don't use

% subplot(2,2,3)
% DI_95CI = quantile(reshape(hcounts,[],40),[0.025 0.5 0.975],1); % median and 95% CIs
% hCI = plot(centers, DI_95CI,'k-');
% arrayfun(@(a) set(a,'LineStyle','--'),hCI([1 3]))
% xlabel('DI'); ylabel('Probability')
% 
% subplot(2,2,4)
% DI_95CI = quantile(reshape(hcounts_nosil,[],40),[0.025 0.5 0.975],1); % median and 95% CIs
% hCI = plot(centers, DI_95CI,'k-');
% arrayfun(@(a) set(a,'LineStyle','--'),hCI([1 3]))
% xlabel('DI'); ylabel('Probability')

%% PV analysis looking at rate only!!! Addresses comment about how I have to 
% rotate the PVs before asking any questions about similarity. Show that I
% can do so also just by looking at max rate alone without regard to
% spatial bin. 

% Get rate only correlations
corrs_oct_all = cellfun(@(a) corr(a(1,:)',a(2,:)','rows','complete'),...
    rPVall_oct(~cellfun(@isempty,rPVall_oct)));
corrs_sq_all = cellfun(@(a) corr(a(1,:)',a(2,:)','rows','complete'),...
    rPVall_sq(~cellfun(@isempty,rPVall_sq)));
corrs_c2s_all = cellfun(@(a) corr(a(1,:)',a(2,:)','rows','complete'),...
    rPVall_c2s(~cellfun(@isempty,rPVall_c2s)));

% How do I get shuffled values? basically run above in a for loop?

figure(148); set(gcf,'Position',[1950 40 1200 950])
subplot(2,2,1)
[~, hs] = barscatter(cat(1,corrs_oct_all,corrs_sq_all),corrs_c2s_all);
arrayfun(@(a) set(a,'MarkerEdgeAlpha',0.5),hs)
xlabel('Comp type'); set(gca,'XTickLabel',{'Same', 'Diff'});
ylabel('\rho_{rPV}')
title('Rate only PV discrimination')
make_plot_pretty(gca)

prks = ranksum(cat(1,corrs_oct_all,corrs_sq_all),corrs_c2s_all);
subplot(2,2,2)
text(0.1,0.5,['prks = ' num2str(prks,'%0.2g')])
axis off

h = subplot(2,2,3);
scatterBox(cat(1,corrs_oct_all,corrs_sq_all,corrs_c2s_all), ...
    cat(1, ones(length(corrs_oct_all) + length(corrs_sq_all),1),2*ones(size(corrs_c2s_all))),...
    'h', h, 'circleColors',[0.3 0.3 0.3])
make_plot_pretty(gca)

subplot(2,2,4)
text(0.1, 0.5, 'Put this into text only')
axis off

printNK('Rate only PV discrim (max bin only used)','2env')

%% PV contribution analysis - look at PVs from coherent cells only to get a metric
% of how much rate modulation contributes, then look at PVs with silent
% cells removed

load('2env_PV_conn_1000shuffles-2018-05-17.mat')
Mouse(1).PV.connfilt.none; % gives you PV for all connected sessions 
% can easily remove cells silent in one session and calculcate PV corrs to
% see the effect of silent cells on PV discrimination.

% Run with all cells, get PV discrimination. Then run with random remapping
% cells removed to see if coherent cells and silent cells can still
% discriminate. Then remove silent cells too to see if coherent cells can
% discriminate on their own via rate changes. Then, remove top quartile to
% see at which point stop being able to discriminate above chance levels.

% Then I can run twoenv_on_off (after adding in some code to capture the
% coherent boolean for each session) to get the cells that are coherent
% between sessions and then plug that into the above? Or will this be
% impossible to do?

% OK, try the above without looking at connected sessions by halves...

%% Take 2: first, run pairwise PVcorrs to get correlations between each half
% during connection (toward bottom of twoenv_scratchpat).
% Get correlations and DIs to identify silent cells.

% % Old method where rotations are not reversed... bad
% load(fullfile(ChangeDirectory_NK(G30_square(1)),...
%     '2env_PVdiscrimination_2018-08-20.mat')); 

% New version with rotations between each half reversed before calculating
% PVs
load(fullfile(ChangeDirectory_NK(G30_square(1)),...
    '2env_PVdiscrimination_2018-08-21_maybegood2.mat'));
same_bool = nan(8,8);
same_bool(sub2ind([8,8], sub_use(:,1), sub_use(:,2))) = ...
    logical([0 1 0 0 1 0 0 1 0 0 1 0]');
same_bool = shiftdim(repmat(same_bool,1,1,4),2);

DIcutoff = 0.66; % Only include neurons with discrimination ratios less than this...
corr_cutoff = 0.2;
nactive_cutoff = 25; % Only include session-pairs with this many cells passing
% the above criteria through.

corrmat = cell(size(PVconns_filt));
corrmat(~cellfun(@isempty, PVconns_filt)) = cellfun(@(a) ...
    corr3d(squeeze(a(:,:,:,1)), squeeze(a(:,:,:,2))), ...
    PVconns_filt(~cellfun(@isempty, PVconns_filt)),'UniformOutput',false);
corrmatmeans = cellfun(@(a) nanmean(a(:)), corrmat);

% Next, get coherent vs not cells for each session-pair by running
% plot_delta_angle_hist with same parameters as corrs.
DImat = cell(size(PVconns_filt));
DImat(~cellfun(@isempty,PVconns_filt)) = cellfun(@(a) get_discr_ratio(...
    max(reshape(a(:,:,:,1),[],size(a,3))),max(reshape(a(:,:,:,2),[],size(a,3)))),...
    PVconns_filt(~cellfun(@isempty, PVconns_filt)),'UniformOutput', false);

DImat_all = cell(size(PVconns_all));
[~, ~, DImat_all(~cellfun(@isempty,PVconns_all))] = cellfun(@(a) get_discr_ratio(...
    max(reshape(a(:,:,:,1),[],size(a,3))),max(reshape(a(:,:,:,2),[],size(a,3)))),...
    PVconns_all(~cellfun(@isempty, PVconns_all)),'UniformOutput', false);
DImeanmat_all = cell(size(PVconns_all));
[~, ~, DImeanmat_all(~cellfun(@isempty,PVconns_all))] = cellfun(@(a) get_discr_ratio(...
    nanmean(reshape(a(:,:,:,1),[],size(a,3))),nanmean(reshape(a(:,:,:,2),[],size(a,3)))),...
    PVconns_all(~cellfun(@isempty, PVconns_all)),'UniformOutput', false);
corrs_all = cell(4,8,8);
corrs_all(~cellfun(@isempty, PVconns_all)) = cellfun(@(a) corr3d(a(:,:,:,1), ...
    a(:,:,:,2),12), PVconns_all(~cellfun(@isempty, PVconns_all)), ...
    'UniformOutput', false);

silent_bool_all = cellfun(@(a) abs(a') == 1, DImat_all,'UniformOutput', false);

rate_mod_bool_all = cellfun(@(a) abs(a') <= DIcutoff, DImat_all, 'UniformOutput',...
    false);
meanrate_mod_bool_all = cellfun(@(a) abs(a') <= DIcutoff, DImeanmat_all, ...
    'UniformOutput', false);
highcorr_bool_all = cellfun(@(a) a > corr_cutoff, corrs_all, ...
    'UniformOutput', false);

% Pre-allocate a coherent boolean for ALL cells.
coh_bool_conns_full = ...
    cellfun(@(a) false(size(a)), filt_all, 'UniformOutput', false);
for j = 1:4
    for k = 1:8
        for ll = 1:8
            if ~isempty(neuron_id_conns{j,k,ll})
                coh_bool_conns_full{j,k,ll}...
                    (neuron_id_conns{j,k,ll}(:,1)) = coh_bool_conns{j,k,ll};
            end
        end
    end
end 

% Now you have the filtered cells in filt_all, coherent cells in
% coh_bool_conns_full, and silent cells in silent_bool_all.

% Only neurons that meet our filter criteria (ntrans >= 5, pval < 1, no
% overlap with other neuron ROIs to be considered a silent cell (those with
% overlap excluded from analysis)
PVconns_filt_check = cellfun(@(a,b) a(:,:,b,:), PVconns_all, filt_all, ...
    'UniformOutput', false);
nfilt = cellfun(@(a) size(a,3), PVconns_filt_check);
% Filter out silent cells (|DI| = 1)
PVnosil = cellfun(@(a,b,c) a(:,:,(b & ~c),:), PVconns_all, filt_all, ...
    silent_bool_all, 'UniformOutput', false);
nnosil = cellfun(@(a) size(a,3), PVnosil);
% Filter our silent cells and random remapping cells
PVnosil_or_remap = cellfun(@(a,b,c,d) a(:,:,(b & ~c & d),:), PVconns_all, ...
    filt_all, silent_bool_all, coh_bool_conns_full, 'UniformOutput', false);
nnosil_or_remap = cellfun(@(a) size(a,3), PVnosil_or_remap);
% Filter out random remapping cells and "rate modulating" cells (those with
% |DI| <= DIcutoff above)
PVnomod_or_remap = cellfun(@(a,b,c,d) a(:,:,(b & c & d),:), PVconns_all, ...
    filt_all, rate_mod_bool_all, coh_bool_conns_full, 'UniformOutput', false);
nnomod_or_remap = cellfun(@(a) size(a,3), PVnomod_or_remap);
% Same as above but using mean calcium event rate to calculate DI ratio
PVnomeanmod_or_remap = cellfun(@(a,b,c,d) a(:,:,(b & c & d),:), PVconns_all, ...
    filt_all, meanrate_mod_bool_all, coh_bool_conns_full, 'UniformOutput', false);
nnomeanmod_or_remap = cellfun(@(a) size(a,3), PVnomeanmod_or_remap);
% No silent or low correlation neurons - sanity check
PVnosil_or_lowcorr = cellfun(@(a,b,c,d) a(:,:,(b & ~c & d),:), PVconns_all, ...
    filt_all, silent_bool_all, highcorr_bool_all, 'UniformOutput', false);
nnosil_or_lowcorr = cellfun(@(a) size(a,3), PVnosil_or_lowcorr);

% Get PV means for each session
[filt_means, ~, nfilt_exc] = twoenv_PVconn_means(PVconns_filt_check, nactive_cutoff);
[nosil_means, ~, nnosil_exc] = twoenv_PVconn_means(PVnosil, nactive_cutoff);
[nosil_or_remap_means, nosil_or_remap_corrmat, nnosil_or_remap_exc] = ...
    twoenv_PVconn_means(PVnosil_or_remap, nactive_cutoff);
[nomod_or_remap_means, nomod_or_remap_corrmat, nnomod_or_remap_exc] = ...
    twoenv_PVconn_means(PVnomod_or_remap, nactive_cutoff);
[nomeanmod_or_remap_means, nomeanmod_or_remap_corrmat, nnomeanmod_or_remap_exc] = ...
    twoenv_PVconn_means(PVnomeanmod_or_remap, nactive_cutoff);
[nosil_or_lowcorr_means, nosil_or_lowcorr_corrmat, nnosil_or_lowcorr_exc] = ...
    twoenv_PVconn_means(PVnosil_or_lowcorr, nactive_cutoff);

%% Plot the above via scatterbox
% Lots of data here:  figure 688 (below) is simpler and is used
% for the final plot

try close(678); end
figure(678)
hfilt = subplot(2,6,1);
scatterBox([filt_means(same_bool == 1); filt_means(same_bool == 0)], ...
    [ones(16,1); 2*ones(32,1)], 'h', hfilt, 'xLabels', {'Same', 'Diff'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');
xlabel('Arena')
title('All filtered cells')
ylim([-0.1 0.6])

subplot(2,6,7)
prks_filt = ranksum(filt_means(same_bool == 1),...
    filt_means(same_bool == 0));
text(0.1, 0.5, ['prks = ' num2str(prks_filt, '%0.2g')]);
text(0.1, 0.9, ['nthresh >= ' num2str(nactive_cutoff)])
text(0.1, 0.8, [num2str(nfilt_exc) ' sesh-pairs excluded'])
text(0.1, 0.7, num2str(round(mean(nfilt(nfilt > nactive_cutoff)))))
axis off

hnosil = subplot(2,6,2);
scatterBox([nosil_means(same_bool == 1); nosil_means(same_bool == 0)], ...
    [ones(16,1); 2*ones(32,1)], 'h', hnosil, 'xLabels', {'Same', 'Diff'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');
xlabel('Arena')
title('No silent cells')
ylim([-0.1 0.6])

subplot(2,6,8)
prks_nosil = ranksum(nosil_means(same_bool == 1),...
    nosil_means(same_bool == 0));
text(0.1, 0.5, ['prks = ' num2str(prks_nosil, '%0.2g')]);
text(0.1, 0.9, ['nthresh >= ' num2str(nactive_cutoff)])
text(0.1, 0.8, [num2str(nnosil_exc) ' sesh-pairs excluded'])
text(0.1, 0.7, num2str(round(mean(nnosil(nnosil > nactive_cutoff)))))
axis off

hnosil_or_remap = subplot(2,6,3);
scatterBox([nosil_or_remap_means(same_bool == 1); nosil_or_remap_means(same_bool == 0)], ...
    [ones(16,1); 2*ones(32,1)], 'h', hnosil_or_remap, 'xLabels', {'Same', 'Diff'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');
xlabel('Arena')
title('No silent or rnd. remap')
ylim([-0.1 0.6])

subplot(2,6,9)
prks_nosil_or_remap = ranksum(nosil_or_remap_means(same_bool == 1),...
    nosil_or_remap_means(same_bool == 0));
text(0.1, 0.5, ['prks = ' num2str(prks_nosil_or_remap, '%0.2g')]);
text(0.1, 0.9, ['nthresh >= ' num2str(nactive_cutoff)])
text(0.1, 0.8, [num2str(nnosil_or_remap_exc) ' sesh-pairs excluded'])
text(0.1, 0.7, num2str(round(mean(nnosil_or_remap(nnosil_or_remap > nactive_cutoff)))))
axis off

hnomod_or_remap = subplot(2,6,4);
scatterBox([nomod_or_remap_means(same_bool == 1); nomod_or_remap_means(same_bool == 0)], ...
    [ones(16,1); 2*ones(32,1)], 'h', hnomod_or_remap, 'xLabels', {'Same', 'Diff'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');
xlabel('Arena')
title('No rate mod. or rnd. remap')
ylim([-0.1 0.6])

subplot(2,6,10)
prks_nomod_or_remap = ranksum(nomod_or_remap_means(same_bool == 1),...
    nomod_or_remap_means(same_bool == 0));
text(0.1, 0.4, ['prks = ' num2str(prks_nomod_or_remap, '%0.2g')]);
text(0.1, 0.9, ['nthresh >= ' num2str(nactive_cutoff)])
text(0.1, 0.8, [num2str(nnomod_or_remap_exc) ' sesh-pairs excluded'])
text(0.1, 0.7, num2str(round(mean(nnomod_or_remap(nnomod_or_remap > nactive_cutoff)))))
text(0.1, 0.5, ['DI\_thresh <= ' num2str(DIcutoff)])
axis off

hnomeanmod_or_remap = subplot(2,6,5);
scatterBox([nomeanmod_or_remap_means(same_bool == 1); nomeanmod_or_remap_means(same_bool == 0)], ...
    [ones(16,1); 2*ones(32,1)], 'h', hnomeanmod_or_remap, 'xLabels', {'Same', 'Diff'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');
xlabel('Arena')
title('No mean rate mod. or rnd. remap')
ylim([-0.1 0.6])

subplot(2,6,11)
prks_nomeanmod_or_remap = ranksum(nomeanmod_or_remap_means(same_bool == 1),...
    nomeanmod_or_remap_means(same_bool == 0));
text(0.1, 0.5, ['prks = ' num2str(prks_nomeanmod_or_remap, '%0.2g')]);
text(0.1, 0.9, ['nthresh >= ' num2str(nactive_cutoff)])
text(0.1, 0.8, [num2str(nnomeanmod_or_remap_exc) ' sesh-pairs excluded'])
text(0.1, 0.7, num2str(round(mean(nnomeanmod_or_remap(nnomeanmod_or_remap > nactive_cutoff)))))
axis off

hnosil_or_lowcorr = subplot(2,6,6);
scatterBox([nosil_or_lowcorr_means(same_bool == 1); nosil_or_lowcorr_means(same_bool == 0)], ...
    [ones(16,1); 2*ones(32,1)], 'h', hnosil_or_lowcorr, 'xLabels', {'Same', 'Diff'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');
xlabel('Arena')
title('No silent or low corr')
ylim([-0.1 0.6])

subplot(2,6,12)
prks_nosil_or_lowcorr = ranksum(nosil_or_lowcorr_means(same_bool == 1),...
    nosil_or_lowcorr_means(same_bool == 0));
text(0.1, 0.4, ['prks = ' num2str(prks_nosil_or_lowcorr , '%0.2g')]);
text(0.1, 0.9, ['nthresh >= ' num2str(nactive_cutoff)])
text(0.1, 0.8, [num2str(nnosil_or_lowcorr_exc) ' sesh-pairs excluded'])
text(0.1, 0.7, num2str(round(mean(nnosil_or_lowcorr(nnosil_or_lowcorr > nactive_cutoff)))))
text(0.1, 0.5, ['corr\_cutoff > ' num2str(corr_cutoff)])
axis off

%% Compare full filtered PV to PVs with different subpopulations removed.
try close(688); end

figure(688); set(gcf,'Position',[2080 380 1160 490])
hcomb = subplot(1,4,1:3);
scatterBox([filt_means(same_bool == 1); filt_means(same_bool == 0); ...
    nosil_means(same_bool == 0); nosil_or_remap_means(same_bool == 0); ...
    nomod_or_remap_means(same_bool == 0); nomeanmod_or_remap_means(same_bool == 0); ...
    nosil_or_lowcorr_means(same_bool == 0)], [ones(16,1); 2*ones(32,1); ...
    3*ones(32,1); 4*ones(32,1); 5*ones(32,1); 6*ones(32,1); 7*ones(32,1)],...
    'h', hcomb, 'xLabels', {'Same All', 'Diff All', 'No sil', 'No sil. or remap',...
    'No mod. or remap', 'No meanmod. or remap', 'No sil. or low corr.'},...
    'transparency', 0.7, 'yLabel', '\rho_{PV}');

psame_diff = prks_filt;
psame_nosil = ranksum(filt_means(same_bool == 1),...
    nosil_means(same_bool == 0));
psame_nosil_or_remap = ranksum(filt_means(same_bool == 1),...
    nosil_or_remap_means(same_bool == 0));
psame_nomod_or_remap = ranksum(filt_means(same_bool == 1),...
    nomod_or_remap_means(same_bool == 0));
psame_nomeanmod_or_remap = ranksum(filt_means(same_bool == 1),...
    nomeanmod_or_remap_means(same_bool == 0));
psame_nosil_or_lowcorr = ranksum(filt_means(same_bool == 1),...
    nosil_or_lowcorr_means(same_bool == 0));

subplot(1,4,4)
text(0.1, 0.9, ['DI\_thresh <= ' num2str(DIcutoff)])
text(0.1, 0.8,['psame\_diff = ' num2str(psame_diff, '%0.2g')])
text(0.1, 0.7,['psame\_nosil = ' num2str(psame_nosil, '%0.2g')])
text(0.1, 0.6,['psame\_nosil\_or\_remap = ' num2str(psame_nosil_or_remap, '%0.2g')])
text(0.1, 0.5,['psame\_nomod\_or\_remap = ' num2str(psame_nomod_or_remap, '%0.2g')])
text(0.1, 0.4,['psame\_nomeanmod\_or\_remap = ' num2str(psame_nomeanmod_or_remap, '%0.2g')])

text(0.1, 0.2, ['corr\_cutoff > ' num2str(corr_cutoff)])
text(0.1, 0.1,['psame\_nosil\_or\_lowcorr = ' num2str(psame_nosil_or_lowcorr, '%0.2g')])
axis off

try close(689); end

figure(689); set(gcf,'Position',[2080 380 1160 490])
hcomb = subplot(1,3,1:2);
scatterBox([filt_means(same_bool == 1); filt_means(same_bool == 0); ...
    nosil_or_remap_means(same_bool == 0); ...
    nomod_or_remap_means(same_bool == 0)], [ones(16,1); 2*ones(32,1); ...
    3*ones(32,1); 4*ones(32,1)],...
    'h', hcomb, 'xLabels', {'Same All', 'Diff All', 'Diff No sil/remap',...
    'Diff No mod/remap'}, 'transparency', 0.7, 'circleColors', [0.3 0.3 0.3],...
    'yLabel', '\rho_{PV}');
hcomb.FontName = 'SansSerif';
make_plot_pretty(gca);

psame_diff = prks_filt;
psame_nosil = ranksum(filt_means(same_bool == 1),...
    nosil_means(same_bool == 0));
psame_nosil_or_remap = ranksum(filt_means(same_bool == 1),...
    nosil_or_remap_means(same_bool == 0));
psame_nomod_or_remap = ranksum(filt_means(same_bool == 1),...
    nomod_or_remap_means(same_bool == 0));
psame_nomeanmod_or_remap = ranksum(filt_means(same_bool == 1),...
    nomeanmod_or_remap_means(same_bool == 0));
psame_nosil_or_lowcorr = ranksum(filt_means(same_bool == 1),...
    nosil_or_lowcorr_means(same_bool == 0));

subplot(1,3,3)
text(0.1, 0.9, ['DI\_thresh <= ' num2str(DIcutoff)])
text(0.1, 0.8,['psame\_diff = ' num2str(psame_diff, '%0.2g')])
text(0.1, 0.6,['psame\_nosil\_or\_remap = ' num2str(psame_nosil_or_remap, '%0.2g')])
text(0.1, 0.5,['psame\_nomod\_or\_remap = ' num2str(psame_nomod_or_remap, '%0.2g')])
axis off
% printNK('PV discrimination subpopulation breakdown final','2env')


%% Double check why coherent neurons don't seem to have high correlation values...
% Get coherent neurons between sessions and plot placefields to double
% check that they all are rotating the same amount (for G30 day 5 1st half
% sq vs 1st half oct they should only rotate ~30 degrees).
j = 1; k = 1;
[~, delta_mean, ~, ~, ~, ~, coh_bool_test, neuron_id_test, ~, delta_angle] = ...
    plot_delta_angle_hist(all_sessions2(j,pairs(k,1)), ...
    all_sessions2(j,pairs(k,2)), [], 'circ2square', true, ...
    'half_use', halves(k,:), 'plot_flag', false, 'bin_size', ...
    '_half_cm1_speed1_inMD', 'coh_ang_thresh', 30);

%%

load(fullfile(ChangeDirectory_NK(all_sessions2(j,pairs(k,1)),0),...
    'Placefields_half_cm1_speed1_inMD'));
tmap1test = Placefields_halves{halves(k,1)}.TMap_gauss;
load(fullfile(ChangeDirectory_NK(all_sessions2(j,pairs(k,2)),0),...
    'Placefields_half_cm1_speed1_inMD'));
tmap2test = Placefields_halves{halves(k,2)}.TMap_gauss;

load(fullfile(ChangeDirectory_NK(all_sessions2(j,pairs(k,1)),0),...
    ['Placefields_half_cm4_trans_rot' ...
    num2str(all_best_ang2_rev(j,pairs(k,1))) '_inMD']));
tmap1test_4cm = Placefields_halves{halves(k,1)}.TMap_gauss;
load(fullfile(ChangeDirectory_NK(all_sessions2(j,pairs(k,2)),0),...
    ['Placefields_half_cm4_trans_rot' ...
    num2str(all_best_ang2_rev(j,pairs(k,2))) '_forPV_inMD']));
tmap2test_4cm = Placefields_halves{halves(k,2)}.TMap_gauss;

coh_bool_test_full = false(size(tmap1test));
coh_bool_test_full(neuron_id_test(:,1)) = coh_bool_test;
coh_ind = find(coh_bool_test_full);

delta_angle_full = nan(size(tmap1test));
delta_angle_full(neuron_id_test(:,1)) = delta_angle;
%% Check coherency - works, all the neurons identified DO rotate the correct amount


figure(567)
ncoh = length(coh_ind);
for j = 1:ceil(ncoh/5)
    neurons_use = coh_ind(((j-1)*5 + 1):(5*j));
    for k = 1:5
       subplot(2,5,k)
       imagesc_nan(tmap1test{neurons_use(k)});
       axis off
       title(['Neuron ' num2str(neurons_use(k))]);
       subplot(2,5,k+5)
       imagesc_nan(tmap2test{neurons_use(k)});
       title(['\Delta_{ang} = ' num2str(delta_angle_full(neurons_use(k)),...
           '%0.0f')]);
       axis off
    end
    waitforbuttonpress
    
end

%%

figure(568)
for j = 1:ceil(ncoh/2)
    neurons_use = coh_ind(((j-1)*5 + 1):(5*j));
    for ll = 1:2
        nuse = neurons_use(ll);
        subplot(2,5,5*(ll-1)+1)
        imagesc_nan(tmap1test{nuse});
        axis off
        title(['Neuron ' num2str(nuse)]);
        
        subplot(2,5,5*(ll-1)+2)
        imagesc_nan(tmap2test{nuse});
        title(['\Delta_{ang} = ' num2str(delta_angle_full(nuse),...
            '%0.0f')]);
        axis off
        
        subplot(2,5,5*(ll-1)+3)
        imagesc_nan(tmap1test_4cm{nuse});
        title(['Sesh 1 rotated ' num2str(all_best_ang2(j,pairs(ll,1))) ' degrees'])
        axis off
        
        subplot(2,5,5*(ll-1)+4)
        imagesc_nan(tmap2test_4cm{nuse});
        title(['Sesh 2 rotated ' num2str(all_best_ang2(j,pairs(ll,2))) ' degrees'])
        axis off
        
        subplot(2,5,5*(ll-1)+5)
        hold off
        title(['1cm map spearman = ' num2str(corr(tmap1test{nuse}(:),...
            tmap2test{nuse}(:),'rows','complete','type','Spearman'),'%0.2f')])
        xlabel(['4cm map spearman = ' num2str(corr(tmap1test_4cm{nuse}(:),...
            tmap2test_4cm{nuse}(:),'rows','complete','type','Spearman'),'%0.2f')])
    end
    waitforbuttonpress
    
end





