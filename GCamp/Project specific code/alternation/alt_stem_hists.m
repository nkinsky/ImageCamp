function [ha, hf] = alt_stem_hists(session, ha)
% [ha, hf] = alt_stem_hists(session)
%  Plots overall histogram of y-positions along the stem and at each of 6
%  bins along the stem.

if nargin < 2
    hf = figure; set(gcf,'Position', [2045 170 1412 700]);
    ha = subplot(3,2,[1 3]);
    ha(2) = subplot(3,2,2);
    ha(3) = subplot(3,2,4);
    ha(4) = subplot(3,2,6);
    ha(5) = subplot(3,2,5);
else
    hf = ha.Parent.CurrentFigure;
end
nbinsx = 6;
nbinsy = 5;

Alt = [];
load(fullfile(session.Location,'Alternation.mat'),'Alt');
ycent = Alt.y - mean([max(Alt.y(Alt.section == 2)) min(Alt.y(Alt.section == 2))]); % 0 = center of stem
xzero = Alt.x - min(Alt.x(Alt.section == 2)); % Set 0 to start of stem

cent_yrange =  max(ycent(Alt.section == 2)) - min(ycent(Alt.section == 2));
cent_xrange =  max(xzero(Alt.section == 2)) - min(xzero(Alt.section == 2));
cent_yedges = min(ycent(Alt.section == 2)):cent_yrange/nbinsy:...
    max(ycent(Alt.section == 2));
cent_xedges = min(xzero(Alt.section == 2)):cent_xrange/nbinsx:...
    max(xzero(Alt.section == 2));

axes(ha(1))
hl = histogram(ha(1), ycent(Alt.section == 2 & Alt.choice == 1), cent_yedges,...
    'Normalization','probability'); 
ha(1).NextPlot = 'add';
hr = histogram(ha(1), ycent(Alt.section == 2 & Alt.choice == 2), cent_yedges,...
    'Normalization','probability');
legend(cat(2,hl,hr),{'Left','Right'})
xlabel('Y position along stem')
ylabel('Count')
title([mouse_name_title(session.Animal) ' ' mouse_name_title(session.Date) ...
    ' session' num2str(session.Session)])
% Stats below are not legit
% [~, pks] = kstest2(hl.Values, hr.Values);
% title(ha(1), {[mouse_name_title(session.Animal) ' ' mouse_name_title(session.Date) ...
%     ' session' num2str(session.Session) ': p_{ks} = ' num2str(pks, '%0.2g')]})

axes(ha(2))
[n_bothl, ~, ~, binlx, binly] = histcounts2(xzero(Alt.section == 2 & Alt.choice == 1), ...
    ycent(Alt.section == 2 & Alt.choice == 1), cent_xedges, cent_yedges);
p_bothl = n_bothl/(max(n_bothl(:))); % Divide by max
imagesc(p_bothl');
xlabel('Dist. along stem (cm)')
ylabel('Dist. from stem center (cm)')
title('Left Trial 2d histo')
ha(2).XTick = 1:nbinsx; 
ha(2).XTickLabels = round(cent_xedges(1:end-1) + mean(diff(cent_xedges)));
ha(2).YTick = [0 max(ha(2).YTick)/2 max(ha(2).YTick)] + 0.5; 
ha(2).YTickLabels = [-1 0 1]*round(cent_yedges(1),1);

axes(ha(3))
[n_bothr, ~, ~, binrx, binry] = histcounts2(xzero(Alt.section == 2 & Alt.choice == 2), ...
    ycent(Alt.section == 2 & Alt.choice == 2), cent_xedges, cent_yedges);
p_bothr = n_bothr/(max(n_bothr(:))); % Divide by max
imagesc(p_bothr');
xlabel('Dist. along stem (cm)')
ylabel('Dist. from stem center (cm)')
ha(3).XTick = 1:nbinsx; 
ha(3).XTickLabels = round(cent_xedges(1:end-1) + mean(diff(cent_xedges)));
ha(3).YTick = [0 max(ha(3).YTick)/2 max(ha(3).YTick)] + 0.5; 
ha(3).YTickLabels = [-1 0 1]*round(cent_yedges(1),1);
title('Right Trial 2d histo')


axes(ha(4))
imagesc(p_bothr' - p_bothl');
xlabel('Dist. along stem (cm)')
ylabel('Dist. from stem center (cm)')
ha(4).XTick = 1:nbinsx; 
ha(4).XTickLabels = round(cent_xedges(1:end-1) + mean(diff(cent_xedges)));
ha(4).YTick = [0 max(ha(4).YTick)/2 max(ha(4).YTick)] + 0.5; 
ha(4).YTickLabels = [-1 0 1]*round(cent_yedges(1),1);
title('Right Trials - Left Trial 2d histo')

% Below is not legit stats...

% pks_fine = nan(1,size(p_bothr,1));
% for j = 1:size(p_bothr,1)
%     [~, pks_fine(j)] = kstest2(p_bothr(j,:), p_bothl(j,:));
% end
% axes(ha(5))
% text(0.1, 0.5, ['pks between L/R trials at each stem bin'])
% warning('off','MATLAB:printf:BadEscapeSequenceInFormat') %turn off annoying warning
% text(0.1, 0.4, num2str(pks_fine, '%0.2g \ t'))
% warning('on','MATLAB:printf:BadEscapeSequenceInFormat') %turn off annoying warning
axes(ha(5))
if regexpi(session.Notes, 'looping')
    text(0.1, 0.7, 'Looping session')
end
if regexpi(session.Notes, 'forced')
    text(0.1, 0.6, 'Forced session')
end
axis off

end

