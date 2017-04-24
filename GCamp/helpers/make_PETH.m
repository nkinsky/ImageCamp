function [ PETH_out, trace_out ] = make_PETH(PSAbool, traces, event_frames, frame_buffer )
%  [ PETH_out, trace_out ] = make_PETH(PSAbool, traces, event_frames, frame_buffer )
%   Input is PSAbool, LPtrace from Pos_align.mat, event_frames are frames
%   when each event occurs, and frame_buffer is the number of frames
%   before/after to display (e.g. [20 40] looks 20 frames before and 40
%   after).  Default = [40 40];

if nargin < 4
    frame_buffer = [40 40];
end

num_neurons = size(PSAbool,1);
num_events = length(event_frames);
num_frames = sum(frame_buffer)+1;

PETH_out = nan(num_neurons, num_events, num_frames);
trace_out = nan(num_neurons,num_events, num_frames);

for j = 1:length(event_frames)
    start_frame = max([1, event_frames(j)-frame_buffer(1)]);
    end_frame = min([size(PSAbool,2), event_frames(j)+frame_buffer(2)]);
    frames_use = start_frame:end_frame;
    if length(frames_use) == num_frames
        PETH_out(:,j,:) = PSAbool(:,frames_use);
        trace_out(:,j,:) = traces(:,frames_use);
    else
        if start_frame == 1
            ind_use = (num_frames-length(frames_use)+1):num_frames;
        elseif end_frame == size(PSAbool,2)
            ind_use = 1:length(frames_use);
        end
        PETH_out(:,j,ind_use) = PSAbool(:,frames_use);
        trace_out(:,j,ind_use) = traces(:,frames_use);
    end
end

end

