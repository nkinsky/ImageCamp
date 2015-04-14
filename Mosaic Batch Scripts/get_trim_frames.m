function [ trim_frames ] = get_trim_frames( bad_frames, last_frame )
% [ trim_frames ] = get_trim_frames( bad_frames, last_frame )
%   Calculates the appropriate frames to trim and concatenate into the full
%   movie to eliminate bad frames, keeping the movie the same length as the
%   original.  Will duplicate some frames.

% bad_frames = [2727 8007 20480 20884 22148 23618];
% last_frame = 25041;

% Re-sort bad frames if not in ascending order and spit out warning!
if sum(bad_frames ~= sort(bad_frames)) > 0
    bad_frames = sort(bad_frames);
    disp('Note - bad_frames not in ascending order.  They have been re-sorted. Check to make sure input frames are correct!');
end

n = 1; begin = 1;
for j = 1:length(bad_frames)
    trim_frames{1,n} = [begin, bad_frames(j)-2];
    trim_frames{1,n+1} = [bad_frames(j)-2 bad_frames(j)-1];
    n = n + 2;
    begin = bad_frames(j) + 1;
end

% Don't do this last step if the last frame is bad
if bad_frames(end) ~= last_frame
    trim_frames{1,n} = [begin, last_frame];
end

end

