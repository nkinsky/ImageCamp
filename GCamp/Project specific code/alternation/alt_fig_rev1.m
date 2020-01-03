% Script to address reviewer #1 questions
% Note that most of the responses were folded directly into alt_fig1-7
% files...

%% Find # of consecutive bins that a splitter had...
sesh_use = alt_test_session(1);
load(fullfile(sesh_use.Location,'sigSplitters.mat'),'sigcurve','deltacurve');
[~, ~, sigbool] = parse_splitters(sesh_use);
[minc, maxc, totalsig, curvesum] = cellfun(@alt_consecutive_sigbins, ...
    sigcurve(sigbool), deltacurve(sigbool));

% proportion of splitters that don't have 3 consecutive bins significant in
% a row
totalsig(maxc < 3);

prop_nobias = sum(abs(curvesum) < 3)/length(totalsig);
