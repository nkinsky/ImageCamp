function sorted_combs = BestSessionComb(AllSessionMap)
%[sorted_combs,sorted_num_neurons] = BestSessionComb(AllSessionMap)
%
%   For finding the best combination of recording sessions that maximizes
%   the number of active neurons on each day. 
%
%   INPUT:
%       AllSessionMap - all_session_map field from Reg_NeuronIDs.mat.
%
%   OUTPUTS: 
%       sorted_combs - N-element cell array (N = total number of sessions)
%       where the column index is the number of considered sessions. Each
%       element contains a MxN array (M = number of possible session
%       combinations given index N) where each row is a combination of
%       recording session days.
%
%       sorted_num_neurons - N-element cell array containing M-element
%       arrays with the sorted number of active neurons across the
%       combination specified by the same index in sorted_combs.
%

%% Preprocessing. 
    %Cut out the first column because it's redundant. 
    AllSessionMap(:,1) = []; 
    
    %Get the total number of sessions. 
    total_num_sessions = size(AllSessionMap,2); 
    
    %Preallocate. 
    combs = cell(1,total_num_sessions);
    num_neurons = combs; 
    sorted_num_neurons = num_neurons; 
    sorted_combs = combs; 
    
%% Maximize neuron count as a function of recording sessions. 
    %Initialize progress bar. 
    p = ProgressBar(total_num_sessions); 
    
    for num_sessions = 3:total_num_sessions
        %Get all the possible combinations with the number of sessions
        %we're looking at. 
        combs{num_sessions} = combnk(1:total_num_sessions,num_sessions); 
        
        %Number of session combinations. 
        num_combs = size(combs{num_sessions},1); 
        
        %Preallocate. 
        num_neurons{num_sessions} = zeros(num_combs,1); 
        
        for this_comb = 1:num_combs
            %Extract those sessions from the list of all sessions. 
            SomeSessions = AllSessionMap(:,combs{num_sessions}(this_comb,:)); 

            %Get the indices of neurons that are active in all the sessions
            %specified for this iteration. 
            allactive = find(all(~cellfun('isempty',SomeSessions),2)); 
            
            %How many neurons is that? 
            num_neurons{num_sessions}(this_comb) = length(allactive); 
        end
       
        %Display progress. 
        p.progress; 
    end
    
    %Sort the session combinations by the number of active neurons. 
    for num_sessions = 3:total_num_sessions
        [sorted_combs{num_sessions}(:,1),inds] = sort(num_neurons{num_sessions},'descend'); 
        sorted_combs{num_sessions}(:,2:num_sessions+1) = combs{num_sessions}(inds,:); 
    end
    
    p.stop; 
    
end