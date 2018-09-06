function [ perf_calc, perf_notes, perf_by_trial ] = alt_get_perf( MD )
% [perf_calc, perf_notes, perf_by_trial] = alt_get_perf( MD )
%   gets performance data on alternation task for all sessions indicated in
%   MD. perf_calc pulls data from Will's automated trial parsing code,
%   perf_notes pulls it directly from the notes in MD.

perf_notes = nan(length(MD),1);
perf_calc = nan(length(MD),1);
perf_by_trial = cell(length(MD),1);
for j = 1:length(MD)
    [dirstr,sesh_use] = ChangeDirectory_NK(MD(j),0);
    try
        perf_notes(j) = sesh_use.perf/100;
    catch
        keyboard
    end
    load(fullfile(dirstr,'Alternation.mat'));
    num_correct = sum(Alt.summary(:,3));
    num_trials = size(Alt.summary,1);
    perf_calc(j) = num_correct/num_trials;
    perf_by_trial{j} = Alt.summary(:,3);

end

