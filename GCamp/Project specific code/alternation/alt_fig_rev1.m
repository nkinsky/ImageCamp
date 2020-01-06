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
[num_3less, prop_3less, num_nobias, prop_nobias, prob_3less_nobias,...
    num_3less_nobias] = deal(nan(nsesh,1));
for j = 1:length(free_sessions)
   sesh_use = free_sessions(j);
   load(fullfile(sesh_use.Location,'sigSplitters.mat'),'sigcurve','deltacurve');
   [~, ~, sigbool] = parse_splitters(sesh_use);
   [minc, maxc, totalsig, curvesum] = cellfun(@alt_consecutive_sigbins, ...
       sigcurve(sigbool), deltacurve(sigbool));
   
   % # and proportion of splitters that don't have 3 consecutive bins 
   % significant in a row
   num_3less(j) = sum(maxc < 3);
   prop_3less(j) = sum(maxc < 3)/length(maxc);
   
   % proportion of splitters that don't have > 3 bins active in one direction.
   prop_nobias(j) = sum(abs(curvesum) < 3)/length(totalsig);
   num_nobias(j) = sum(abs(curvesum) < 3);
   
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
