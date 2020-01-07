% Script to address reviewer #1 questions
% Note that most of the responses were folded directly into alt_fig1-7
% files...

%% Find # of consecutive bins that a splitter had...
sesh_use = alt_test_session(4);
load(fullfile(sesh_use.Location,'sigSplitters.mat'),'sigcurve','deltacurve');
[~, ~, sigbool] = parse_splitters(sesh_use);
[minc, maxc, totalsig, curvesum] = cellfun(@alt_consecutive_sigbins, ...
    sigcurve(sigbool), deltacurve(sigbool));

% The below was hastily written on a plane as my computer was about to die
% on 12/23/2019 - needs updating.
% proportion of splitters that don't have 3 consecutive bins significant in
% a row
prop_3less = sum(maxc < 3)/length(maxc);

% proportion of splitters that don't have > 3 bins active in one direction.
prop_nobias = sum(abs(curvesum) < 3)/length(totalsig);

% proportion of splitters that have less than 3 bins in a row that also
% don't have 3 total bins in one direction significant 
prop_3less_nobias = sum(abs(curvesum) < 3 & maxc < 3)/length(totalsig);

%% Get numbers for all above
free_sessions = alt_all(alt_all_free_bool);
nsesh = length(free_sessions);
[num_3less, prop_3less, num_nobias, prop_nobias, prop_3less_nobias,...
    num_3less_nobias, num_splitters, num_notruebias] = deal(nan(nsesh,1));
for j = 1:length(free_sessions)
   sesh_use = free_sessions(j);
   load(fullfile(sesh_use.Location,'sigSplitters.mat'),'sigcurve','deltacurve');
   [~, ~, sigbool] = parse_splitters(sesh_use);
   [minc, maxc, totalsig, curvesum] = cellfun(@alt_consecutive_sigbins, ...
       sigcurve(sigbool), deltacurve(sigbool));
   
   num_splitters(j) = length(maxc);
   
   % # and proportion of splitters that don't have 3 consecutive bins 
   % significant in a row
   num_3less(j) = sum(maxc < 3);
   prop_3less(j) = sum(maxc < 3)/length(maxc);
   
   % proportion of splitters that don't have > 3 bins active in one direction.
   prop_nobias(j) = sum(abs(curvesum) < 3)/length(totalsig);
   num_nobias(j) = sum(abs(curvesum) < 3);
   num_notruebias(j) = sum(curvesum == 0);
   
   % proportion of splitters that have less than 3 bins in a row that also
   % don't have 3 total bins in one direction significant
   prop_3less_nobias(j) = sum(abs(curvesum) < 3 & maxc < 3)/length(totalsig);
   num_3less_nobias(j) = sum(abs(curvesum) < 3 & maxc < 3);
   
end

%% Plot histograms
figure; set(gcf, 'Position', [   232    52   743   614])
subplot(2,2,1); histogram(num_3less); 
xlabel('# splitters with <3 consec. bins'); ylabel('# Sessions')
text(10,8,['mean = ' num2str(nanmean(num_3less), '%0.2g')])
subplot(2,2,2); histogram(prop_3less); 
xlabel('Proportion splitters with <3 consec. bins'); ylabel('# Sessions')
text(0.4,20,['mean = ' num2str(nanmean(prop_3less), '%0.2g')])
subplot(2,2,3); histogram(num_3less_nobias); 
xlabel('# splitters with <3 consec. bins & <3 total bins one direction'); 
ylabel('# Sessions')
text(1,40,['mean = ' num2str(nanmean(num_3less_nobias), '%0.2g')])
subplot(2,2,4); histogram(prop_3less_nobias); 
xlabel('# splitters with <3 consec. bins & <3 total bins one direction'); 
ylabel('# Sessions')
text(0.2,40,['mean = ' num2str(nanmean(prop_3less_nobias), '%0.2g')])
printNK('Splitter Consecutive Bin Plots','alt')

figure; set(gcf, 'Position', [ 32 52 400 614]);
subplot(2,1,1); histogram(num_nobias);
xlabel('# splitters with no bias (< 3 total bins one dir.)'); ylabel('# Sessions');
text(2,30, ['mean = ' num2str(nanmean(num_nobias), '%0.2g')]);
subplot(2,1,2); histogram(prop_nobias);
xlabel('prop. splitters with no bias (< 3 total bins one dir.)'); ylabel('# Sessions');
text(0.05, 30, ['mean = ' num2str(nanmean(prop_nobias), '%0.2g')]);
printNK('Splitter bin bias histograms', 'alt');

%% Get size of PF firing...
pval_thresh = 0.05;
ntrans_thresh = 5;
sigthresh = 3;

% Run test-sesh to get # categories
[ ~, cat_nums_temp, ~ ] = alt_parse_cell_category( ...
       G30_alt(end), pval_thresh, ntrans_thresh, sigthresh, 'Placefields_cm1.mat');

% pre-allocate
free_sessions = alt_all(alt_all_free_bool);
nsesh = length(free_sessions);
ncats = length(cat_nums_temp);
cat_area_means = nan(nsesh, ncats);
cat_area_all = [];
for k = 1:nsesh
    sesh_use = free_sessions(k);
    
    try
        % Load in PFarea stats you have already calculated
        [ categories, cat_nums, cat_names ] = alt_parse_cell_category( ...
            sesh_use, pval_thresh, ntrans_thresh, sigthresh, 'Placefields_cm1.mat');
        load(fullfile(sesh_use.Location, 'PlacefieldStats_cm1.mat'), 'PFarea', ...
            'bestPF');
        nneurons = length(bestPF);
        
        % Get only area for best placefield in case of multiple
        bestarea = PFarea(sub2ind(size(PFarea), (1:nneurons)', bestPF));
        
        % Now divy up into splitters, arm pcs and stem pcs - keep same column
        % structure as in cat_names.
        area_by_cat = nan(nneurons, ncats);
        for j = 1:ncats
            cat_use = cat_nums(j); % cell category to analyze in this loop
            cell_bool = categories == cat_use; % boolean of cells in that category
            area_by_cat(cell_bool, j) = bestarea(cell_bool);
        end
        
        % Aggregate data across all sessions
        cat_area_means(k,:) = nanmean(area_by_cat);
        cat_area_all = cat(1, cat_area_all, area_by_cat);
    catch ME
        if strcmp(ME.identifier, 'MATLAB:load:couldNotReadFile')
            disp(['PlacefieldStats_cm1.mat missing for sesh ' num2str(k)])
        end
    end
end


%% Plot and get stats
sp_ind = find(strcmpi('Splitters', cat_names));
arm_ind = find(strcmpi('Arm PCs', cat_names));
stem_ind = find(strcmpi('Stem PCs', cat_names));
psp_v_apc = signrank(cat_area_means(:,sp_ind), cat_area_means(:,arm_ind));
psp_v_spc = signrank(cat_area_means(:,sp_ind), cat_area_means(:,stem_ind));
papc_v_spc = signrank(cat_area_means(:,arm_ind), cat_area_means(:,stem_ind));
figure; set(gcf, 'Position', [209   226   900   423]);
ax_use = subplot(1,3,1:2);
areas_relevant = cat_area_means(:, [sp_ind, stem_ind, arm_ind]);
grps = repmat([1 2 3], nsesh, 1);
paired_inds = repmat((1:nsesh)', 1, 3);
scatterBox(areas_relevant(:), grps(:), 'h', ax_use, 'xLabels', ...
    {'Splitters', 'Stem PCs', 'Arm PCs'}, 'yLabel', 'mean PF size', ...
    'paired_ind', paired_inds );
arrayfun(@(a) set(a,'Color', [0 0 0 0.3]), ax_use.Children(1:end-2));
make_plot_pretty(gca);
subplot(1,3,3);
text(0.1,0.9, 'psignrank values')
text(0.1, 0.8, ['sp v spc = ' num2str(psp_v_spc,'%0.2g')])
text(0.1, 0.7, ['sp v apc = ' num2str(psp_v_apc,'%0.2g')])
text(0.1, 0.6, ['apc v spc = ' num2str(papc_v_spc,'%0.2g')])
printNK('Split v PC field size', 'alt')
