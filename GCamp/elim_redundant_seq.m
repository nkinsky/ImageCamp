function [ seq_sparse, seq_pos_sparse] = elim_redundant_seq( seq, seq_pos, min_length )
% sparse_seq  = elim_redundant_seq( seq, length_limit )
%   Takes a list of sequences of any length and cleans them up, eliminating
%   any sequences under a given length and any sequences that are
%   recapitulated within a longer sequence
%
%   INPUTS
%       seq: a 1xn cell with sequences of neuron activations
%       seq_pos: same as seq but with the linear positions of each neuron
%       min_length: a postive integer that sets the minimum length for a
%       sequence to be included, discarding all sequences below that
%       length
%
%   OUTPUTS
%       sparse_seq: a cell in the same format as seq, but containing only
%       sequences above the minimum length with non-redundant entries
%       sparse_pos_seq: same as sparse_seq but with the linear positions of
%       each neuron

%% Get length of all sequences
length_seq = cellfun(@(a) length(a),seq);
[~,ind_sort] = sort(length_seq,2,'descend'); % sort from longest to shortest
abv_length = length_seq(ind_sort) >= min_length; % Get boolean of sequences that meet length criteria
seq_use = ind_sort(abv_length); % Pull out their actual indices in seq

%% 
% Step through each sequence in descending order to eliminate redundant
% sequences and/or sequences below the length limit
n = 1; % number of sequences you have looked at
ind_skip = zeros(size(seq)); % Store indices of sequences to skip / remove from sparse sequence here. 1 = remove, 0 = keep.
while n < length(seq_use) % End loop when all sequences have been iterated through
    a = seq{seq_use(n)}; % Longer sequnece to compare others to
    for j = n+1:length(seq_use) % Step through each subsequent sequence and compare it to sequence a
        b = seq{seq_use(j)}; % Sequence to compare to a to see if b is entirely repeated within a
        length_diff = length(a) - length(b); % Get length difference
        for k = 1:length_diff+1
            a_use = a(k:length(a) - 1 - length_diff + k); % get sub-parts of a to match length of b
            if sum(a_use == b) == length(b)
                ind_skip(j) = 1; % skip over sequence b / remove from future consideration
                continue
            end
            % If all of sequence b does not match any part of a, move onto
            % seqence b as next sequence to consider
        end
    end
    n = n + 1; % Move onto next sequence
end

% Pull only sequences that meet the two criteria
ind_include = ind_sort(abv_length & ~ind_skip);
seq_sparse = seq(1,ind_include);
seq_pos_sparse = seq_pos(1,ind_include);
end

