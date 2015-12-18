%% MLE playing around

%% Load splitter data

ChangeDirectory_NK(MD(ref.G48.alternation(end)));
load('splittersByTrialType.mat')
load('sigSplitters.mat')

%%
sig_cells = find(cellfun(@(a) ~isempty(a) && sum(a < 0.05) >= 1 ,pvalue));

% use cell 446 to start
cell_use = 446;

cell_raster{1} = cellRespsByTrialType{cell_use,1};
cell_raster{2} = cellRespsByTrialType{cell_use,2};
tuning_curve_use = tuningcurves{cell_use};

%% Convert rasters to data vector
data_by_bin = cell(1,2);
for j = 1:2
    data_by_bin{j} = [];
    temp = [];
    for k = 1:size(cell_raster{j},1)
        max_num_transients = max(cell_raster{j}(k,:)); % Get max number transients
        % start looking for any bin with > 0 transients, 
        % up after that
        for thresh = 1:max_num_transients 
            temp = find(cell_raster{j}(k,:) >= thresh);
            data_by_bin{j} = [data_by_bin{j} temp];
        end
    end
    
end

%%
% Get trial averaged data and run the mle on it
for j = 1:2
    trial_avg(j,:) = mean(cell_raster{j},1);
    phat{j} = mle(data_by_bin{j});
    % How do we get rate differences out of this?  These could conceivably
    % come from the same distribution since they have similar means and
    % stdevs, even though left trials only have a transient event in one
    % trial versus most trials in right trials
end

%% try the glm?

plotspec_glm = {'r*','b*'};
plotspec_data = {'r--','b--'};

figure(123)
subplot(3,1,1);
imagesc(cell_raster{1});
subplot(3,1,2);
imagesc(cell_raster{2});
design_mat_comb = [];
y_comb = [];
for j = 1:2
    num_trials = size(cell_raster{j},1);
    num_bins = size(cell_raster{j},2);
    % Concatenate all data into a vector
    temp = cell_raster{j}';
    y = temp(:); % turn rasters into a row vector with each trial concatenate to the next
    %%% Create Design Matrix %%%
    const = ones(num_trials*num_bins,1); % Constant 
    x = repmat([1:num_bins]',num_trials,1);
    x2 = x.^2;
    x3 = x.^3;
    x4 = x.^4;
    x5 = x.^5;
    design_mat = [const x x2 x3 x4 x5];
    
    % Fit the glm
    [b{j}, dev{j}, stats{j}] = glmfit(design_mat,y,'normal','constant','off');
    % Evaluate the glm
    yfit{j} = glmval(b{j},design_mat,'identity','Constant','Off');
    % Plot it
    subplot(3,1,3);
    plot(x,yfit{j},plotspec_glm{j}); hold on
    plot(1:length(tuning_curve_use(j,:)), tuning_curve_use(j,:), ... 
        plotspec_data{j});
    hold on;
    
    % Run it combining both trial types into one and include left v right as a
    % categorical variable (0 = left, 1 = right)
    temp2 = [design_mat const*j];
    design_mat_comb = [design_mat_comb ; temp2];
    y_comb = [y_comb; y];
end

[b_comb, dev_comb, stats_comb] = glmfit(design_mat_comb, y_comb,'poisson',...
    'constant','off');
yfit_comb = glmval(b_comb, design_mat_comb,'log','Constant','Off');

figure(124)
subplot(3,1,1);
imagesc(cell_raster{1});
subplot(3,1,2);
imagesc(cell_raster{2});
subplot(3,1,3);
plot(design_mat_comb(:,2),yfit_comb,'b*'); hold on
for j = 1:2
    plot(1:length(tuning_curve_use(j,:)), tuning_curve_use(j,:), ...
        plotspec_data{j});
end





