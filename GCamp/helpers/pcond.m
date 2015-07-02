function [pBgA,pA,pB] = pcond(a,b)
%x = pcond(a,b)
%   
%   Finds the conditional probability of B given A [P(B|A)]. Also the
%   probabilities of A and B individually. 
%
%   INPUTS: 
%       a and b: Logical vectors. 
%
%   OUTPUT: 
%       pAB: P(B|A). As a proportion. 
%
%       pA: P(A).
%
%       pB: P(B). 

%% Calculate condition probability. 
    %Length of the session. 
    duration = length(a); 
    
    %P(A & B)
    i = a & b; 
    pAB = sum(i)/duration;
    
    %P(A) 
    pA = sum(a)/duration;
    
    %P(B)
    pB = sum(b)/duration; 
    
    %P(B|A)
    pBgA = pAB/pA; 
    
end