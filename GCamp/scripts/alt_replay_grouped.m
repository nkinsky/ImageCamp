% alt_replay_analysis_grouped

global GROUPED_FLAG

GROUPED_FLAG = 1; % overwrites auto-checking of things like maze rotation

min_length_replay = 4;

folder{1} = 'J:\GCamp Mice\Working\G30\alternation\11_06_2014\Working';
folder{2} = 'J:\GCamp Mice\Working\G30\alternation\11_07_2014\Working';
folder{3} = 'J:\GCamp Mice\Working\G30\alternation\11_11_2014\Working';
folder{4} = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working';
folder{5} = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\take2';

for jj = 1:5 % 1:length(folder)
    [num_temp, pval_temp] = alt_replay_analysis(folder{jj},min_length_replay);
    session(jj).num_activations = num_temp;
    session(jj).pval = pval_temp;
end