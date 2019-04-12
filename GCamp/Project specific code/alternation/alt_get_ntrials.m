function [ntrials, ncorr] = alt_get_ntrials(sesh)
% [ntrials, ncorr] = alt_get_ntrials(sesh)
%   Gets total # trials and # correct trials in sesh

load(fullfile(sesh.Location, 'Alternation.mat'), 'Alt')
ntrials = size(Alt.summary,1);
ncorr = sum(Alt.summary(:,3));

end
