function Alt_shuff = shuff_trials(Alt)
%Alt_shuff = shuff_trials(Alt)
%
%   Shuffle left/right labels in the Alternation.mat struct. 
%
%   INPUT: 
%       Alt: Struct from Alternation.mat containing the sorted alternation
%       trials. 
%
%   OUTPUT:
%       Alt_shuff: Struct almost identical to Alt, except that the
%       left/right trials are shuffled. 
%
    
%% Useful parameters.
    num_trials = max(Alt.trial); 
    
    %Shuffle the indices. 
    ind = randperm(num_trials); 
    
    %Make the new struct. 
    Alt_shuff = Alt; 
    Alt_shuff.summary(:,2) = Alt.summary(ind,2);
    
%% Shuffle. 
    for this_trial = 1:num_trials
        turn = Alt_shuff.summary(this_trial,2); 
        Alt_shuff.choice(Alt_shuff.trial == this_trial) = turn; 
    end
    
end
                