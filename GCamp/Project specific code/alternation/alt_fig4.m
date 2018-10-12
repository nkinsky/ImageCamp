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
% sessions that were longer than a certain amount of time...
max_day_lag = 7;
sessions = alt_all_cell; % Change this to make plots for each mouse...
matchER = true; % March event-rate in non-splitters to splitters
trial_type = 'all';

nmice = length(sessions);
stay_prop_v_days = cell(1, max_day_lag + 1);
coactive_prop_v_days = cell(1, max_day_lag + 1);

% Get probabilities for each mouse and day lag
hw = waitbar(0,'Get proportions across days');
for j = 0:max_day_lag
    [ stay_prop, coactive_prop, cat_names ] = ...
        alt_stab_v_cat_batch(j, 'exact', sessions, 'Placefields_cm1.mat', ...
        matchER, trial_type);
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
title(['All Mice, matchER=' matchER ' trial\_type=' trial_type])
make_plot_pretty(gca)

[h, p] = arrayfun(@(a) ttest2(coactive_prop_all(a == grps_all(:,1),1), ...
    coactive_prop_all(a == grps_all(:,1),3)),0:max_day_lag);
prks = arrayfun(@(a) ranksum(coactive_prop_all(a == grps_all(:,1),1), ...
    coactive_prop_all(a == grps_all(:,1),3)),0:max_day_lag);
subplot(3,1,3)
text(0.1, 0.7, 'Unpaired t-test results below')
text(0.1, 0.5, num2str(p))
text(0.1, 0.3, 'Ranksum results below')
text(0.1, 0.1, num2str(prks))
axis off

printNK(['Coactivity vs time - All Mice matchER=' num2str(matchER)...
    ' trial_type=' trial_type], 'alt')

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
