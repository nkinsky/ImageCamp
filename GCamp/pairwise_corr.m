function [r,r_shuf] = pairwise_corr(TMap)
%[r,r_shuf] = pairwise_corr(TMap)
%
%   Performs pairwise correlations between TMaps across multiple sessions. 
%
%   INPUT: 
%       TMap: NxS cell (where N is the number of neurons and S is the
%       number of sessions) of resized TMaps. 
%
%   OUTPUTS:
%       r: SxSxN matrix of pairwise correlation coefficients for each
%       within-neuron TMap across sessions.
%
%       r_shuf: SxSxNxB matrix (where B is the number of permutation
%       iterations) of pairwise correlation coefficients for each shuffled
%       group of TMaps. 
%


%% Useful parameters.
    [num_cells,num_sessions] = size(TMap); 
    thresh = 0.02; 
    [l,w] = cellfun(@size,TMap,'UniformOutput',false);
    sizing = max(max(cellfun(@max, l))).*max(max(cellfun(@max, w)));    %Total number of pixels. 
    
    %Preallocate. 
    B = 100; 
    TMap_lin = nan(sizing,num_sessions,num_cells); 
    TMap_shuf = nan(sizing,num_sessions,num_cells); 
    r = nan(num_sessions,num_sessions,num_cells); 
    r_shuf = nan(num_sessions,num_sessions,num_cells,B); 
    
%% Linearize for each neuron in each session. 
    for this_neuron = 1:num_cells
        for this_sesh = 1:num_sessions
            if ~isempty(TMap{this_neuron,this_sesh})
                TMap_lin(:,this_sesh,this_neuron) = TMap{this_neuron,this_sesh}(:);
                bad = find(TMap_lin(:,this_sesh,this_neuron) < thresh); 
                TMap_lin(bad,this_sesh,this_neuron) = 0; 
            else 
                TMap_lin(:,this_sesh,this_neuron) = nan(sizing,1); 
            end
        end
    end
    
%% Shuffle and do pairwise session correlations between different neurons. 
    for i = 1:B
        i
        %Produce shuffled indices. 
        shuffle_ind = randperm(num_cells); 
        
        for this_sesh = 1:num_sessions
            for this_neuron = 1:num_cells
                %Assign random TMap to the this_neuronth space. 
                if ~isempty(TMap{shuffle_ind(this_neuron),this_sesh})
                    TMap_shuf(:,this_sesh,this_neuron) = TMap{shuffle_ind(this_neuron),this_sesh}(:); 
%                     bad = find(TMap_shuf(:,this_sesh,this_neuron) < thresh); 
%                     TMap_shuf(bad,this_sesh,this_neuron) = 0; 
                else
                    TMap_shuf(:,this_sesh,this_neuron) = nan(sizing,1); 
                end
            end
        end
        
        %Correlate between sessions within a single neuron. These are
        %actually different neurons because they've been shuffled.         
        for this_pseudoneuron = 1:num_cells
            r_shuf(:,:,this_pseudoneuron,i) = corr(TMap_shuf(:,:,this_pseudoneuron));
        end
    end
    
%% Within-neuron pairwise session correlations. 
    for this_neuron = 1:num_cells
        r(:,:,this_neuron) = corr(TMap_lin(:,:,this_neuron)); 
    end
    
end