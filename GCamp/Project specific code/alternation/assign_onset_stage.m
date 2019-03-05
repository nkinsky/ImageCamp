function [onset_stage] = assign_onset_stage(sesh_use, learning_stage_ends, ...
    onsetsesh)
% [onset_stage] = assign_onset_stage(sesh_use, learning_stage_ends, ...
%     onsetsesh)
%   Delegates onset session in onsetsesh to early/middle/late. Needs
%   sessions being considered in onsetsesh (sesh_use) and a structure
%   denoting end sessions for each stage.

stage_bool = get_learning_stage(sesh_use, learning_stage_ends);
nstages = size(stage_bool,1);

onset_stage = nan(size(onsetsesh));
for j = 1:nstages
    stage_start = find(stage_bool(j,:),1,'first');
    stage_end = find(stage_bool(j,:),1,'last');
    if ~isempty(stage_start) & ~isempty(stage_end)
        onset_stage(onsetsesh >= stage_start & onsetsesh <= stage_end) = j;
    end
end

end

