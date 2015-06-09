function [L_INFO,R_INFO,active] = splitter_info(session,Alt,TMap)
%[L_INFO,R_INFO,active] = splitter_info(session)
%
%   Finds the spatial information for neurons after sorting alternation
%   trials.
%
%   INPUT:
%       session: Path containing Alternation.mat and PlaceMaps.mat.
%
%   OUTPUTS: 
%       L_INFO: Spatial information content for each neuron for left-turn
%       trials.
%  
%       R_INFO: Same for right-turn trials. 
%
%       active: Vector containing booleans indicating cells that have place
%       fields. 
%
    
%% Parameters.
    NumNeurons = size(TMap,2); 
    
%% Get left/right frames. 
    NumFrames = max(Alt.frames); 

    left = logical(zeros(NumFrames,1));
    left(Alt.choice == 1) = 1; 
    
    right = logical(zeros(NumFrames,1));
    right(Alt.choice == 2) = 1; 

%% Find spatial information for left and right trials. 
    [R_INFO,p_i,L_lambda,L_lambda_i] = CalculateSpatialInfo(session,right); 
    [L_INFO,p_i,R_lambda,R_lambda_i] = CalculateSpatialInfo(session,left); 
    
    %Get indices of neurons with no active PFs. 
    active = zeros(NumNeurons,1);
    bad = cellfun(@isnan,TMap,'UniformOutput',false); 

    for this_neuron = 1:NumNeurons
        active(this_neuron) = ~all(bad{this_neuron}(:)); 
    end
    
    active = logical(active); 
end