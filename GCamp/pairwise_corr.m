function [r,r_shuf,TMap_lin] = pairwise_corr(TMap)
%
%
%

%% Useful parameters.
    [num_cells,num_sessions] = size(TMap); 
    [l,w] = cellfun(@size,TMap,'UniformOutput',false);
    sizing = max(max(cellfun(@max, l))).*max(max(cellfun(@max, w)));    %Total number of pixels. 
    
    %Preallocate. 
    B = 1000; 
    shuffled = nan(num_cells,B); 
    TMap_lin = nan(sizing,num_sessions,num_cells); 
    TMap_shuf = nan(sizing,num_sessions,num_cells); 
    r = nan(num_sessions,num_sessions,num_cells); 
    r_shuf = nan(num_sessions,num_sessions,num_cells,B); 
    
%% Linearize. 
    for this_neuron = 1:num_cells
        for this_sesh = 1:num_sessions
            if ~isempty(TMap{this_neuron,this_sesh})
                TMap_lin(:,this_sesh,this_neuron) = TMap{this_neuron,this_sesh}(:);
            else 
                TMap_lin(:,this_sesh,this_neuron) = nan(sizing,1); 
            end
        end
    end
    
%% Shuffle. 
    for i = 1:B
        i
        shuffled = randperm(num_cells); 
        
        for this_neuron = 1:num_cells
            for this_sesh = 1:num_sessions
                
                if ~isempty(TMap{shuffled(this_neuron),this_sesh});
                    TMap_shuf(:,this_sesh,this_neuron) = TMap{shuffled(this_neuron),this_sesh}(:); 
                else
                    TMap_shuf(:,this_sesh,this_neuron) = nan(sizing,1); 
                end
                
            end
            
        r_shuf(:,:,this_neuron,i) = corr(TMap_shuf(:,:,this_neuron));
        
        end
    end
    
%     for i=1:B
%         i
%         for this_sesh = 1:num_sessions
%             shuffled = randperm(num_cells); 
% 
%             for this_neuron = 1:num_cells
%                 
%             end
%         end
%         %Correlation of shuffled cells. 
%         r_shuf(:,:,this_neuron,i) = corr(TMap_shuf(:,:,this_neuron));
%     end
    
%% Correlation. 
    for this_neuron = 1:num_cells
        r(:,:,this_neuron) = corr(TMap_lin(:,:,this_neuron)); 
    end
    
    
end