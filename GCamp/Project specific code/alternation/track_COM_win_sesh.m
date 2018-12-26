function [dCOMLmean, dCOMRmean] = track_COM_win_sesh(session)
 % [dCOMLmean, dCOMRmean] = track_COM_win_sesh(session)
% Track COM for each neuron's firing across a session (early, middle, late
% trials). Plot

% Get COMs for each trial
[COML, COMR, speedL, speedR, ~] = alt_COM_bytrial(session);
dCOML = COML - nanmedian(COML,1);
dCOMR = COMR - nanmedian(COMR,1);

%% Break into thirds
Lthirds = [1, 1 + round(size(COML,1)/3), 1 + 2*round(size(COML,1)/3); ...
    round(size(COML,1)/3), 2*round(size(COML,1)/3), size(COML,1)]';
Rthirds = [1, 1 + round(size(COMR,1)/3), 1 + 2*round(size(COMR,1)/3); ...
    round(size(COMR,1)/3), 2*round(size(COMR,1)/3), size(COMR,1)]';

nneurons = size(COML,2);
dCOMLmean = nan(3, nneurons); dCOMRmean = nan(3, nneurons);
for j = 1:3
    dCOMLmean(j,:) = nanmean(dCOML(Lthirds(j,1):Lthirds(j,2),:));
    dCOMRmean(j,:) = nanmean(dCOMR(Rthirds(j,1):Rthirds(j,2),:));
end

%% Plot out stuff - trial x trial dCOM for each direction (with regression
% lines and stats), velocity across all trials, and stats

figure; set(gcf, 'Position', [2080, 140, 1310, 780])
hLfine = subplot(2,2,1); hRfine = subplot(2,2,2); 
hV = subplot(2,2,3); hstats = subplot(2,2,4);

nneurons = size(dCOML,2);
ntrialsL = size(dCOML,1); ntrialsR = size(dCOMR,1);
trialmatL = repmat((1:ntrialsL)',1,nneurons);
trialmatR = repmat((1:ntrialsR)',1,nneurons);

% Plot Left trial deltaCOM at fine scale
scatterBox(dCOML(:), trialmatL(:), 'h', hLfine, 'xLabels', arrayfun(@num2str, ...
    1:ntrialsL, 'UniformOutput', false), 'yLabel', '\Delta_{COM} (cm)');
title(hLfine, 'Left Trials')
xlabel(hLfine, 'Trial #')
lmL = fitlm(trialmatL(:), dCOML(:));
hold on
plot(hLfine, [1 ntrialsL]', lmL.predict([1 ntrialsL]'), 'r--');
make_plot_pretty(hLfine);

% Plot Right trial deltaCOM at fine scale
scatterBox(dCOMR(:), trialmatR(:), 'h', hRfine, 'xLabels', arrayfun(@num2str, ...
    1:ntrialsR, 'UniformOutput', false), 'yLabel', '\Delta_{COM} (cm)');
title(hRfine, 'Right Trials')
xlabel(hRfine, 'Trial #')
lmR = fitlm(trialmatR(:), dCOMR(:));
hold on
plot(hRfine, [1 ntrialsR]', lmR.predict([1 ntrialsR]'), 'r--');
make_plot_pretty(hRfine);

% Plot velocity
hl = plot(hV, (1:ntrialsL)', speedL, 'b-', (1:ntrialsR)', speedR, 'r-.');
xlabel(hV, 'Trial #'); ylabel(hV, 'Speed (cm/s)'); legend(hl, {'Left', 'Right'})
make_plot_pretty(hV)
linkaxes(cat(1,hLfine,hRfine,hV),'x')

% Stats
text(hstats, 0.1, 0.8, [mouse_name_title(session.Animal) ': ' ...
    mouse_name_title(session.Date) ' -s' num2str(session.Session)])
text(hstats, 0.1, 0.6, ['Left Trials: Slope = ' num2str(lmL.Coefficients.Estimate(2), '%0.2g') ...
    ', p = ' num2str(lmL.Coefficients.pValue(2), '%0.2g') ', t = ' ...
    num2str(lmL.Coefficients.tStat(2), '%0.2g')])
text(hstats, 0.1, 0.4, ['Right Trials: Slope = ' num2str(lmR.Coefficients.Estimate(2), '%0.2g') ...
    ', p = ' num2str(lmR.Coefficients.pValue(2), '%0.2g') ', t = ' ...
    num2str(lmR.Coefficients.tStat(2), '%0.2g')])
hstats.Visible = 'off';
make_plot_pretty(hstats);
% set


end