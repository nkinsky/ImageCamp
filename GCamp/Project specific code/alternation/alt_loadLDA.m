function [LDAperf, LDAperf_shuf] = alt_loadLDA(session, no_shuf)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    no_shuf = false;
end

text_append = alt_get_filter_text();

LDAperf = nan; LDAperf_shuf = nan;
if no_shuf
    load(fullfile(session.Location,['LDAperf' text_append '.mat']), ...
        'LDAperf', 'LDAperf_shuf');
else
    load(fullfile(session.Location,['LDAperf_w_shuf' text_append '.mat']), ...
        'LDAperf', 'LDAperf_shuf');
end

end

