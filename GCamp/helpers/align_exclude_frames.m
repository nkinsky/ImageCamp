function [ exclude_frames_aligned, FToffset_array, end_array ] = align_exclude_frames( session_struct )
% exclude_frames_aligned  = align_exclude_frames( session_struct )
%   Aligns exclude frames in raw movie to aligned pos files

num_sessions = length(session_struct);
% Get frames to exclude
[~, full_sesh_cell] = arrayfun(@(a) ChangeDirectory_NK(a,0), ...
    session_struct,'UniformOutput',false);
exclude_frames_cell = cellfun(@(a) a.exclude_frames, full_sesh_cell, ...
    'UniformOutput', false); % Need to adjust to pos_align coordinates
% Adjust exclude_frames_cell - get FT offset and subtract from all exclude
% frames that are non empty!
exclude_frames_aligned = cell(size(exclude_frames_cell));
end_array = nan(num_sessions,1);
FToffset_array = nan(num_sessions,1);
for j = 1:num_sessions
    try
        load(fullfile(full_sesh_cell{j}.Location,'Pos_align.mat'),...
            'FToffset','speed')
        end_array(j) = length(speed);
    catch
        load(fullfile(full_sesh_cell{j}.Location,'FinalOutput'),'PSAbool')
        [~,~,~,PSAaligned,FToffset] = AlignImagingToTracking(1,PSAbool,0,'basedir',...
            full_sesh_cell{j}.Location);
        end_array(j) = size(PSAaligned,2);
    end
    exclude_frames_aligned{j} = exclude_frames_cell{j} - FToffset;
    FToffset_array(j) = FToffset;
    
end



end

