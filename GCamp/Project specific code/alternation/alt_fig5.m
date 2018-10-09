% Alternation Figure 4: Reactivation dynamics over time

%% Reactivation Probability versus time - single session examples

%% Prob maintains phenotype versus days...
max_day_lag = 7;
sessions = alt_all_cell; % Change this to make plots for each mouse...
matchER = true; % March event-rate in non-splitters to splitters

nmice = length(sessions);
stay_prop_v_days = cell(1, max_day_lag + 1);
coactive_prop_v_days = cell(1, max_day_lag + 1);

% Get probabilities for each mouse and day lag
hw = waitbar(0,'Get proportions across days');
for j = 0:max_day_lag
    [ stay_prop, coactive_prop, cat_names ] = ...
        alt_stab_v_cat_batch(j, 'exact', sessions, 'Placefields_cm1.mat', ...
        matchER);
    stay_prop_v_days{j+1} = stay_prop;
    coactive_prop_v_days{j+1} = coactive_prop;
    waitbar((j+1)/(max_day_lag+1),hw);
end
close(hw)

grps_all = []; stay_prop_all = []; coactive_prop_all = [];
stay_mean = nan(max_day_lag + 1, 6);
stay_std = nan(max_day_lag + 1, 6);

for j = 0:max_day_lag
    prop_for_day = cat(1, stay_prop_v_days{j+1}{:});
    stay_prop_all = cat(1, stay_prop_all, prop_for_day);
    coactive_for_day = cat(1, coactive_prop_v_days{j+1}{:});
    coactive_prop_all = cat(1, coactive_prop_all, coactive_for_day);
    grps_by_day = ones(size(prop_for_day))*j;
    grps_all = cat(1, grps_all, grps_by_day);
    
    stay_mean(j+1,:) = nanmean(coactive_for_day);
    stay_std(j+1,:) = nanstd(coactive_for_day);
    
end

figure; set(gcf,'Position',[2030 240 890 740])
h = subplot(3,1,1:2);
[~,~, hs_sp] = scatterBox(coactive_prop_all(:,1), grps_all(:,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', h, 'plotBox', false, 'transparency', 0.5);
[~, ~, hs_apc] = scatterBox(coactive_prop_all(:,3), grps_all(:,1), 'xLabels', ...
    arrayfun(@num2str, 0:max_day_lag, 'UniformOutput', false), ...
    'yLabel', 'Prob. Co-active', 'h', h, 'plotBox', false, ...
    'circleColors', [0.7, 0, 0], 'transparency', 0.5);
legend(cat(1,hs_sp,hs_apc), {'Splitters', 'Arm PCs'})
plot((0:max_day_lag)', stay_mean(:,1),'k-')
plot((0:max_day_lag)', stay_mean(:,3),'r-')
xlabel('Lag (days)')
make_plot_pretty(gca)

[h, p] = arrayfun(@(a) ttest2(coactive_prop_all(a == grps_all(:,1),1), ...
    coactive_prop_all(a == grps_all(:,1),3)),0:max_day_lag);
subplot(3,1,3)
text(0.1, 0.5, 'Unpaired t-test results below')
text(0.1, 0.3, num2str(p))
axis off

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

% Select out place cells in 
