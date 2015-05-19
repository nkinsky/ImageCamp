function [ stats ] = replay_stats( replay_length, replay_dist )
% [ stats ] = replay_stats( replay_length, replay_dist )
% Take lengths of replays and distances between neuron PFs within a
% replay and dump them into some nice stats.

length_mean = mean(replay_length);
length_sem = std(replay_length)/sqrt(length(replay_length));

dist_mean = mean(replay_dist);
dist_sem = std(replay_dist)/sqrt(length(replay_dist));

stats.length = replay_length;
stats.length_mean = length_mean;
stats.length_sem = length_sem;
stats.dist = replay_dist;
stats.dist_mean = dist_mean;
stats.dist_sem = dist_sem;

end

