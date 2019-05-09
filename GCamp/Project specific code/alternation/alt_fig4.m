% Alternation Figure 4: Reactivation dynamics over time

%% Reactivation Probability versus time - single mouse examples - will need to
% redo with only stem and arm place cells to make pkw accurate... 

% Remove upper loop and use alt_all_cell as sesh_use for ALL mice.
trial_types = {'all', 'free_only', 'forced_only', 'no_loop'};
hw = waitbar(0,'Running reactivation prob vs phenotype...');
n = 1;
for j = 1:4
    sesh_use = alt_all_cell{j};
    mouse_name = sesh_use(1).Animal;
    for m = 0:1
        matchER = logical(m);
        for ttype = 1:4
            trial_type = trial_types{ttype};
            for days = 0:7
                try
                    alt_plot_stab_v_cat(days, 'exact', sesh_use, false, ...
                        'PFname', 'Placefields_cm1.mat', ...
                        'matchER', matchER, 'trial_type', trial_type);
                    printNK(['Coactivity by phenotype - ' mouse_name ' ' ...
                        ' matchER=' num2str(matchER) ' trial_type=' ...
                        trial_type], 'alt', 'append', true)
                    close(gcf)
                catch
                    disp(['Error with ' mouse_name ' ' ...
                        num2str(days) ' days matchER=' ...
                        num2str(matchER) ' trial_type=' trial_type ' - Skipping'])
                end
                waitbar(n/(4*2*4*8),hw)
                n = n+1;
            end
            
        end
    end
end
close(hw)

%% Reactivation Probability at different time lags
sesh_use = alt_all_cell; %alt_all_cell = all mice, alt_all_cell[1} = mouse 1
matchER = true;
trial_type = 'free_only';

% One day looks great - all mice
alt_plot_stab_v_cat(1, 'exact', sesh_use, false, 'PFname', 'Placefields_cm1.mat', ...
    'matchER', matchER, 'trial_type', trial_type);
printNK(['All Mice Split v PC Prob present at 1 day lag matchER=' ...
    num2str(matchER)],'alt')

% 7 day - all mice
alt_plot_stab_v_cat(7, 'exact', sesh_use, false, 'PFname', 'Placefields_cm1.mat', ...
    'matchER', matchER, 'trial_type', trial_type);
printNK(['All Mice Split v PC Prob present at 7 day lag matchER=' ...
    num2str(matchER)],'alt')

% One day for G48
alt_plot_stab_v_cat(1, 'exact', alt_all_cell{4}, false, 'PFname', ...
    'Placefields_cm1.mat', 'matchER', matchER, 'trial_type', trial_type);
printNK(['G48 Split v PC Prob present at 1 day lag matchER=' ...
    num2str(matchER)],'alt')

% 7 day - G45
alt_plot_stab_v_cat(7, 'exact', alt_all_cell{3}, false, 'PFname', 'Placefields_cm1.mat', ...
    'matchER', matchER, 'trial_type', trial_type);
printNK(['G45 Split v PC Prob present at 7 day lag matchER=' ...
    num2str(matchER)],'alt')

%% Prob maintains phenotype versus days...looks good when I include ALL sessions
% but falls apart a bit when I don't include forced sessions. Could be due
% to a lot of shorter sessions with G48. Might need to only include
% sessions that were longer than a certain amount of time...yes!!!
max_day_lag = 21;
sessions = alt_all_cell; % Change this to make plots for each mouse...
matchER = false; % March event-rate in non-splitters to splitters
trial_type = 'free_only'; % 'no_loop';

nmice = length(sessions);
stay_prop_v_days = cell(1, max_day_lag + 1);
coactive_prop_v_days = cell(1, max_day_lag + 1);
ncoactive_v_days = cell(1, max_day_lag + 1);
ntrials1_v_days = cell(1, max_day_lag + 1);

% Get probabilities for each mouse and day lag
hw = waitbar(0,'Get proportions across days');
for j = 1:max_day_lag
    [ stay_prop, coactive_prop, cat_names, ncoactive_all, ntrials1] = ...
        alt_stab_v_cat_batch(j, 'exact', sessions, 'Placefields_cm1.mat', ...
        matchER, trial_type);
    stay_prop_v_days{j+1} = stay_prop;
    coactive_prop_v_days{j+1} = coactive_prop;
    ncoactive_v_days{j+1} = ncoactive_all;
    ntrials1_v_days{j+1} = ntrials1;
    waitbar((j+1)/(max_day_lag+1),hw);
    
    % Identify sessions with prob = 0 or 1 - why??
    for k = 1:4
       try
           outlier_test = coactive_prop{k}(:,3) == 0 | coactive_prop{k}(:,1) == 0 ...
               | coactive_prop{k}(:,3) == 1 | coactive_prop{k}(:,1) == 1;
           if any(outlier_test)
               disp(['Outlier in mouse ' num2str(k) ' at lag ' num2str(j)])
           end
       catch
           
       end
    end
end
close(hw)

grps_all = []; stay_prop_all = []; coactive_prop_all = []; 
ntrials1_all = [];
stay_mean = nan(max_day_lag + 1, 6);
stay_std = nan(max_day_lag + 1, 6);
stay_diff_mean = nan(max_day_lag + 1, 6);
stay_diff_std = nan(max_day_lag + 1, 6);

for j = 1:max_day_lag
    prop_for_day = cat(1, stay_prop_v_days{j+1}{:});
    stay_prop_all = cat(1, stay_prop_all, prop_for_day);
    coactive_for_day = cat(1, coactive_prop_v_days{j+1}{:});
    coactive_prop_all = cat(1, coactive_prop_all, coactive_for_day);
    ntrials1_for_day = cat(1, ntrials1_v_days{j+1}{:});
    ntrials1_all = cat(1, ntrials1_all, ntrials1_for_day);
    grps_by_day = ones(size(prop_for_day))*j;
    grps_all = cat(1, grps_all, grps_by_day);
    
    stay_mean(j+1,:) = nanmean(coactive_for_day);
    stay_std(j+1,:) = nanstd(coactive_for_day);
    
    stay_diff_mean(j+1,:) = nanmean(coactive_for_day(:,1) - ...
        coactive_for_day(:,3)); 
    stay_diff_std(j+1,:) = nanstd(coactive_for_day(:,1) - ...
        coactive_for_day(:,3)); 
    
end

%% Plot it!
other_type = 'Arm NPCs'; % specify neuron phenotype to plot versus splitters

% Get zero and 1 points due to low # cells starting out as splitter/armPC 
% phenotype in G30 lag 5 and G48 lag 8,9,10,and 13 analyses. Recommend
% including since they are still real, especially since it only occurs for
% one phenotype at a time!
alpha = 0.05; % significance level
elim_outliers = false; 
ntrial_stem_thresh = 20; % exclude any session comparisons with less than this many trials in 1st session
figure; set(gcf,'Position',[2030 240 890 740])
h = subplot(3,1,1:2);

split_ind = find(strcmpi('splitters', cat_names));
other_ind = find(strcmpi(other_type, cat_names));

if ~elim_outliers
    outlier_bool = false(size(coactive_prop_all(:,split_ind)));
elseif elim_outliers
    outlier_bool = coactive_prop_all(:,split_ind) == 0 | coactive_prop_all(:,split_ind) == 1 ...
        | coactive_prop_all(:,other_ind) == 0 | coactive_prop_all(:,other_ind) == 1;
end

ntrial_bool = ntrials1_all >= ntrial_stem_thresh;
good_bool = ~outlier_bool & ntrial_bool;
    
%%% NRK - below is plotting pairs of points where one does not have at
%%% least 10 cells, which is below our #cells threshold. This is ok because
%%% while they are plotted they are NOT used for stats!

% Plot spliiters
[~,~, hs_sp] = scatterBox(coactive_prop_all(good_bool, split_ind), ...
    grps_all(good_bool,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', h, 'plotBox', false, 'transparency', 0.3,...
    'circleColors', [0, 0.7, 0]);

% Plot arm PCs
[~, ~, hs_other] = scatterBox(coactive_prop_all(good_bool, other_ind), ...
    grps_all(good_bool,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', h, 'plotBox', false, ...
    'circleColors', [0.7, 0, 0], 'transparency', 0.3);

% Label stuff
legend(cat(1,hs_sp,hs_other), {'Splitters', other_type})
plot((0:max_day_lag)', stay_mean(:,split_ind),'g-')
plot((0:max_day_lag)', stay_mean(:,other_ind),'r-')
xlabel('Lag (days)')
title(['All Mice, matchER=' num2str(matchER) ' trial\_type=' ...
    mouse_name_title(trial_type)])
make_plot_pretty(gca)

% Get ranksum and signed-test stats
prks = arrayfun(@(a) ranksum(coactive_prop_all(a == grps_all(:, split_ind) & good_bool, split_ind), ...
    coactive_prop_all(a == grps_all(:, other_ind) & good_bool, other_ind)),1:max_day_lag);
psign = arrayfun(@(a) signtest(coactive_prop_all(a == grps_all(:, split_ind) & good_bool, split_ind), ...
    coactive_prop_all(a == grps_all(:, other_ind) & good_bool, other_ind),'tail','right'),1:max_day_lag);
prsign = arrayfun(@(a) signrank(coactive_prop_all(a == grps_all(:, split_ind) & good_bool, split_ind), ...
    coactive_prop_all(a == grps_all(:, other_ind) & good_bool, other_ind),'tail','right'),1:max_day_lag);

% Set-up holm-bonferroni correction
ngrps = length(unique(grps_all));
pthresh = alpha/ngrps:alpha/ngrps:alpha; % set up incremental sig levels
[~, isort] = sort(psign); % get indices for signed-test values sorted from smallest to largest
pthresh_holm_sort = nan(1,ngrps);
pthresh_holm_sort(isort) = pthresh; % Put significance values in appropriate place
days_pass_holm = find(prsign < pthresh_holm_sort);

subplot(3,1,3)
text(0.1, 1.1, '2-sided Ranksum results below')
text(0.1, 1.0, num2str(prks))
text(0.1, 0.8, '1-sided Signed-test results below')
text(0.1, 0.7, num2str(psign))
text(0.1, 0.5, '1-sided Signed-rank test results below')
text(0.1, 0.4, num2str(prsign))
text(0.1, 0.2, 'Days passing signed-rank test after holm-bonferroni correction')
text(0.1, 0.1, num2str(days_pass_holm))
text(0.1, -0.1, 'Days passing signed-rank test after Bonferroni correction')
text(0.1, -0.2, num2str(find(prsign < alpha/ngrps)))
axis off

% Adjust groups of data to offset and see pattern a bit better.
hs_other.XData = hs_other.XData - 0.1;
hs_sp.XData = hs_sp.XData + 0.1;


printNK(['Coactivity vs time split v ' other_type ' - All Mice matchER=' num2str(matchER)...
    ' trial_type=' trial_type 'max_lag=' num2str(max_day_lag)], 'alt')

%% Same as above but for difference between curves
figure; set(gcf,'Position',[2030 240 890 740])
hd = subplot(3,1,1:2);

diff_all = coactive_prop_all(good_bool,1) - coactive_prop_all(good_bool,3);
[~,~, hs_diff] = scatterBox(diff_all, grps_all(good_bool,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Delta Prob. Co-active', 'h', hd, 'plotBox', false, 'transparency', 0.3,...
    'circleColors', [0.3, 0.3, 0.3]);


% Plot mean and 25%/75% quantiles
dmean = arrayfun(@(a) nanmean(diff_all(grps_all(good_bool,1) == a)), ...
    1:max_day_lag);
hdm = plot(1:max_day_lag, dmean,'k-');
q75 = arrayfun(@(a) quantile(diff_all(grps_all(good_bool,1) == a),0.75), ...
    1:max_day_lag);
q25 = arrayfun(@(a) quantile(diff_all(grps_all(good_bool,1) == a),0.25), ...
    1:max_day_lag);

h0 = plot(get(gca,'XLim'),[0, 0], 'k-');
set(h0,'Color',[0.5 0.5 0.5])
hdq = plot(1:max_day_lag, [q75; q25],'k--');
legend(cat(1,hdm,hdq(1)), {'Mean','25%/75% Quantiles'})
xlabel('Lag (days)')
title(['Split - Arm PCs, All Mice, matchER=' num2str(matchER) ' trial\_type=' trial_type])
make_plot_pretty(gca)

% prks = arrayfun(@(a) ranksum(coactive_prop_all(a == grps_all(:,1) & good_bool,1), ...
%     coactive_prop_all(a == grps_all(:,1) & good_bool,3)),1:max_day_lag);
% psign = arrayfun(@(a) signtest(coactive_prop_all(a == grps_all(:,1) & good_bool,1), ...
%     coactive_prop_all(a == grps_all(:,1) & good_bool,3)),1:max_day_lag);

% subplot(3,1,3)
% text(0.1, 0.7, 'Ranksum results below')
% text(0.1, 0.5, num2str(prks))
% text(0.1, 0.3, 'Signed-test results below')
% text(0.1, 0.1, num2str(psign))
% axis off
% 
% % Adjust groups of data to offset and see pattern a bit better.
% hs_apc.XData = hs_apc.XData - 0.1;
% hs_sp.XData = hs_sp.XData + 0.1;

printNK(['Coactivity Diff vs time - All Mice matchER=' num2str(matchER)...
    ' trial_type=' trial_type 'max_lag=' num2str(max_day_lag)], 'alt')

%% ScatterBox with lines for all day lags
figure
for j = 1:7
    ha = subplot(2,4,j+1);
    coactive_use = cat(1,coactive_prop_v_days{j+1}{:});
    nneurons = size(coactive_use,1);
    x_use = cat(2, coactive_use(:,1), coactive_use(:,3));
    match_bool = all(~isnan(x_use),2); % ID only sessions that aren't NaN in BOTH categories
    x_use = x_use(match_bool,:); % Keep only valid pairs
    grps = cat(2, ones(nneurons,1), 2*ones(nneurons,1));
    grps = grps(match_bool,:);
    
    paired_ind = cat(2, (1:nneurons)', (1:nneurons)');
    paired_ind = paired_ind(match_bool,:);
    
    scatterBox(x_use(:), grps(:), 'paired_ind', paired_ind(:), 'xLabels', {'Splitter', ...
        'Arm PCs'}, 'yLabel', 'Prob. Present', 'h', ha);
    title(ha,[num2str(j) ' Day Lag'])
%     make_plot_pretty(gca)
end

%% Plot above as double-sided violin plot - looks sketchy!!! Too much data 
% massaging!!!
divFactor = 1;

figure; set(gcf, 'Position', [305         221        1191         738])

distributionPlot(coactive_prop_all(:,1), 'groups', grps_all(:,1),...
    'histOri','right','color','g','widthDiv',[2 2],'showMM',0,'histOpt', 1, ...
    'divFactor', divFactor)
distributionPlot(coactive_prop_all(:,3), 'groups', grps_all(:,1), ...
    'histOri','left','color','r','widthDiv',[2 1],'showMM',0, 'histOpt', 1,...
    'divFactor', divFactor)

%% Does # transients affect things? splitters definitely fire more transients
% than other cells. 

% Plot below shows this
load('FinalOutput.mat', 'PSAbool')
num_trans = get_num_activations(PSAbool);
load('sigSplitters.mat', 'sigcurve')
sigSplitters = find(cellfun(@(a) sum(a) >= 3, sigcurve));
load('Placefields_cm1.mat', 'pval')
% histogram(num_trans,0:5:185,'Normalization','probability')

figure; set(gcf,'Position',[2676 327 700 442]);
hold on; hsp = histogram(num_trans(sigSplitters),0:5:185,'Normalization',...
    'probability');
hold on; hpf = histogram(num_trans(pval < 0.05),0:5:185,'Normalization',...
    'probability');
legend(cat(1,hsp,hpf),{'Splitters','Arm PCs'})
ylabel('Probability'); xlabel('Num. Ca^{2+} events')
plot(ones(1,2)*mean(num_trans(sigSplitters)), get(gca,'YLim'),'b-')
plot(ones(1,2)*mean(num_trans(pval < 0.05)), get(gca,'YLim'),'r-')
make_plot_pretty(gca);
% hold on; histogram(num_trans(pval < 0.01),0:5:185,'Normalization','probability')

printNK('Example Event Rate Comparison Between Splitters and Arm PCs','alt')

%% Last sub-figure: Re-activation versus dmax
% day_lag = 7;
comp_type = 'exact';
rely_res = 0.05;
rely_range = [0.6 1];
delta_res = 0.1;
delta_range = [0 1];

ntrial_stem_thresh_use = 1:25;

p_res_use = 'superfine';
switch p_res_use
    case 'gross'
        p_range = [0 1];
        p_res = 0.1;
    case 'fine'
        p_range = [0 0.5];
        p_res = 0.05;
    case 'superfine'
        p_range = [0 0.5];
        p_res = 0.025;
    case 'superfine2'
        p_range = [0 0.25];
        p_res = 0.025;
end

% splitters_only = true;
[rdnorm, pdnorm, rdintn, pdintn, rdmax, pdmax] = ...
    deal(nan(1,length(ntrial_stem_thresh_use)));
for splitters_only = false
    if ~splitters_only
        split_text = '';
    elseif splitters_only
        split_text = 'splitters only';
        rely_range = [0.95 1];
        rely_res = 0.005;
    end
    for day_lag = 7 %[1 7] % [7 11 15]
        disp(['Running day lag ' num2str(day_lag) ' analysis...'])
        for j = 1:length(ntrial_stem_thresh_use) %[1 5 10 15] % 1:20
            ntrial_stem_thresh = ntrial_stem_thresh_use(j);
            try
%                 if ntrial_thresh > 15 && ntrial_thresh <= 18
%                     
%                     delta_res = 0.08;
%                     delta_range = [0 0.8];
%                 elseif ntrial_thresh > 18 && ntrial_thresh <= 18
                    
                [h, rdnorm(j), pdnorm(j), rdintn(j), pdintn(j), rdmax(j), pdmax(j)] = ...
                    alt_split_v_recur_batch(day_lag, comp_type, alt_all_cell, ...
                    'ntrial_stem_thresh', ntrial_stem_thresh, 'splitters_only', ...
                    splitters_only, 'rely_res', rely_res, 'rely_range', rely_range,...
                    'p_range', p_range, 'p_res', p_res, 'delta_res', ...
                    delta_res, 'delta_range', delta_range);
                arrayfun(@(a) set(a ,'name', 'All Mice'), h);
                printNK(['Recur v split fine - All Mice ' split_text ' - ntrial_thresh='...
                    num2str(ntrial_stem_thresh) ' - daylag=' num2str(day_lag) comp_type], ...
                    'alt', 'hfig', h(1));
                printNK(['Recur v split gross - All Mice ' split_text ' - ntrial_thresh='...
                    num2str(ntrial_stem_thresh) ' - daylag=' num2str(day_lag) comp_type], ...
                    'alt', 'hfig', h(2));
                printNK(['Recur v psplit p_res=' p_res_use ' - All Mice ' split_text ' - ntrial_thresh='...
                    num2str(ntrial_stem_thresh) ' - daylag=' num2str(day_lag) comp_type], ...
                    'alt', 'hfig', h(3));
                close(h);
            catch
                disp(['error processing day_lag = ' num2str(day_lag) ...
                    ' & ntrial_thresh = ' num2str(ntrial_stem_thresh)])
                try close(h); end
            end
        end
    end
end

% figure; 
% plot(ntrial_thresh_use, rdnorm, ntrial_thresh_use, rdintn);
% xlabel('# trial threshold'); ylabel( '\rho_{Pearson}')
save(fullfile(G30_alt(1).Location,['recur_v_rho_stats_daylag' num2str(day_lag)...
    '_' comp_type '.mat']), 'rdnorm', 'pdnorm', 'rdintn', 'pdintn',...
    'ntrial_thresh_use')

% better plots...
figure; set(gcf,'Position', [2476 40 559 800])
subplot(2,1,1);
h1 = plot(ntrial_stem_thresh_use, rdnorm); hold on;
h2 = plot(ntrial_stem_thresh_use, rdintn);
legend(cat(1,h1,h2),{'\Deltamax_{norm}', '\Sigma\Deltamax_{norm}'});
ylabel('\rho_{Spearman}'); xlabel('# trials threshold');
make_plot_pretty(gca);
subplot(2,1,2);
text(0.1, 0.9, ['ntrial\_thresh = ' num2str(ntrial_stem_thresh_use, '%0.2g \t')])
text(0.1, 0.8, ['\rho_{sp} for \Delta_{norm} = ' num2str(rdnorm, '%0.2g \t')])
text(0.1, 0.7, ['pval for \Delta_{norm} = ' num2str(pdnorm, '%0.2g \t')])
text(0.1, 0.6, ['\rho_{sp} for \Sigma\Delta_{norm} = ' num2str(rdintn, '%0.2g \t')])
text(0.1, 0.5, ['pval for \Sigma\Delta_{norm} = ' num2str(pdintn, '%0.2g \t')])
axis off
printNK(['recur_v_rho_plot_daylag' num2str(day_lag) '_' comp_type], 'alt')

% plotyy(ntrial_thresh_use, rdnorm, ntrial_thresh, pdnorm);

%% Same as above but for splitters only
day_lag = 7;
comp_type = 'exact';
rely_res = 0.005;
rely_range = [0.95 1];
delta_res = 0.05;
delta_range = [0 1];

for ntrial_stem_thresh = 1
    h = alt_split_v_recur_batch(day_lag, comp_type, alt_all_cell, ...
        'ntrial_thresh', ntrial_stem_thresh, 'splitters_only', true, 'rely_range',...
        rely_range, 'rely_res', rely_res);
    arrayfun(@(a) set(a ,'name', 'All Mice'), h);
    printNK(['Recur v split fine - All Mice splitters only - ntrial_thresh='...
        num2str(ntrial_stem_thresh)], 'alt', 'hfig', h(1));
    printNK(['Recur v split gross - All Mice splitters only - ntrial_thresh='...
        num2str(ntrial_stem_thresh)], 'alt', 'hfig', h(2));
end

%% Last do the same as above but considering only super-fine levels of reliability
% value to see if there is a trend in the most splitty neurons - should be
% pretty similar to the above but doesn't require excluding non-splitters!
