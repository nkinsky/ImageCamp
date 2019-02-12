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

%% Reactivation Probability versus time - all mouse examples
sesh_use = alt_all_cell;
matchER = true;
trial_type = 'free_only';

% One day looks great
alt_plot_stab_v_cat(1, 'exact', sesh_use, false, 'PFname', 'Placefields_cm1.mat', ...
    'matchER', matchER, 'trial_type', trial_type);

% 5 and 7 day don't exactly match the section below, maybe due to
% non-parametric stats in this 
alt_plot_stab_v_cat(4, 'exact', sesh_use, false, 'PFname', 'Placefields_cm1.mat', ...
    'matchER', matchER, 'trial_type', trial_type);

%% Prob maintains phenotype versus days...looks good when I include ALL sessions
% but falls apart a bit when I don't include forced sessions. Could be due
% to a lot of shorter sessions with G48. Might need to only include
% sessions that were longer than a certain amount of time...yes!!!
max_day_lag = 14;
sessions = alt_all_cell; % Change this to make plots for each mouse...
matchER = true; % March event-rate in non-splitters to splitters
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

% Get zero and 1 points due to low # cells starting out as splitter/armPC 
% phenotype in G30 lag 5 and G48 lag 8,9,10,and 13 analyses. Recommend
% including since they are still real, especially since it only occurs for
% one phenotype at a time!
elim_outliers = false; 
ntrial_thresh = 20; % exclude any session comparisons with less than this many trials in 1st session
figure; set(gcf,'Position',[2030 240 890 740])
h = subplot(3,1,1:2);

if ~elim_outliers
    outlier_bool = false(size(coactive_prop_all(:,1)));
elseif elim_outliers
    outlier_bool = coactive_prop_all(:,1) == 0 | coactive_prop_all(:,1) == 1 ...
        | coactive_prop_all(:,3) == 0 | coactive_prop_all(:,3) == 1;
end

ntrial_bool = ntrials1_all >= ntrial_thresh;
good_bool = ~outlier_bool & ntrial_bool;
    
[~,~, hs_sp] = scatterBox(coactive_prop_all(good_bool,1), ...
    grps_all(good_bool,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', h, 'plotBox', false, 'transparency', 0.3,...
    'circleColors', [0, 0.7, 0]);
[~, ~, hs_apc] = scatterBox(coactive_prop_all(good_bool,3), ...
    grps_all(good_bool,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', h, 'plotBox', false, ...
    'circleColors', [0.7, 0, 0], 'transparency', 0.3);


legend(cat(1,hs_sp,hs_apc), {'Splitters', 'Arm PCs'})
plot((0:max_day_lag)', stay_mean(:,1),'g-')
plot((0:max_day_lag)', stay_mean(:,3),'r-')
xlabel('Lag (days)')
title(['All Mice, matchER=' num2str(matchER) ' trial\_type=' trial_type])
make_plot_pretty(gca)

prks = arrayfun(@(a) ranksum(coactive_prop_all(a == grps_all(:,1) & good_bool,1), ...
    coactive_prop_all(a == grps_all(:,1) & good_bool,3)),1:max_day_lag);
psign = arrayfun(@(a) signtest(coactive_prop_all(a == grps_all(:,1) & good_bool,1), ...
    coactive_prop_all(a == grps_all(:,1) & good_bool,3)),1:max_day_lag);

subplot(3,1,3)
text(0.1, 0.7, 'Ranksum results below')
text(0.1, 0.5, num2str(prks))
text(0.1, 0.3, 'Signed-test results below')
text(0.1, 0.1, num2str(psign))
axis off

% Adjust groups of data to offset and see pattern a bit better.
hs_apc.XData = hs_apc.XData - 0.1;
hs_sp.XData = hs_sp.XData + 0.1;


printNK(['Coactivity vs time - All Mice matchER=' num2str(matchER)...
    ' trial_type=' trial_type 'max_lag=' num2str(max_day_lag)], 'alt')

%% Same as above but for difference between curves
figure; set(gcf,'Position',[2030 240 890 740])
hd = subplot(3,1,1:2);


[~,~, hs_diff] = scatterBox(coactive_prop_all(good_bool,1) - ...
    coactive_prop_all(good_bool,3), grps_all(good_bool,1), 'xLabels', ...
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
histogram(num_trans,0:5:185,'Normalization','probability')
hold on; histogram(num_trans(sigSplitters),0:5:185,'Normalization','probability')
hold on; histogram(num_trans(pval < 0.05),0:5:185,'Normalization','probability')
hold on; histogram(num_trans(pval < 0.01),0:5:185,'Normalization','probability')

%% PF versus splitter tuning fidelity across days
[PFcorr_by_day, PFcorr_by_day_split, unique_lags] = ...
    splitcorr_v_time(G48_alt, 'free_only');

%%
figure;
psign = nan(1,8);
for j = 2:8 % day + 1
    ha = subplot(2,4,j);
    x_use = [PFcorr_by_day_split{j}, PFcorr_by_day{j}];
    match_bool = all(~isnan(x_use),2); % Get only valid data points.
    x_use = x_use(match_bool,:);
    groups = ones(size(x_use)).*[1 2];
    paired_ind = repmat((1:sum(match_bool))',1,2);
    scatterBox(x_use(:), groups(:), 'xLabels', {'Splitters Only', 'All Stem Neurons'},...
        'yLabel', '\rho_{PF,mean}','paired_ind', paired_ind, 'h', ha);
    title([num2str(j-1) ' Day Lag'])
    psign(j) = signtest(x_use(:,1), x_use(:,2), 'tail', 'right');
    
end