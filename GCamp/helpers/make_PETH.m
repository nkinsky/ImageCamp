function [ PETH_out, trace_out ] = make_PETH(PSAbool, traces, times, frame_buffer )
% [PETH_out, traces_out] = make_PETH(PSAbool, times, time_buffer )
%   Detailed explanation goes here

if nargin < 4
    frame_buffer = [20 20];
end

num_neurons = size(PSAbool,1);
num_events = length(times);
num_frames = sum(frame_buffer);

PETH_out = nan(num_neurons, num_events, num_frames+1);
trace_out = nan(num_neurons,num_events, num_frames+1);

for j = 1:length(times)
    frames_use = max([1, times(j)-frame_buffer(1)]):min([size(PSAbool,2), times(j)+frame_buffer(2)]);
    PETH_out(:,j,:) = PSAbool(:,frames_use);
    trace_out(:,j,:) = traces(:,frames_use);
end

end

