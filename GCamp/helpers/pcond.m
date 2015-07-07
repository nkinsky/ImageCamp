function [pBgA,pA,pB] = pcond(a,b,sampsize)
%x = pcond(a,b)
%   
%   Finds the conditional probability of B given A [P(B|A)]. Also the
%   probabilities of A and B individually. 
%
%   INPUTS: 
%       a and b: Logical vectors. 
%
%       sampsize: Sample size. 
%
%   OUTPUT: 
%       pAB: P(B|A). As a proportion. 
%
%       pA: P(A).
%
%       pB: P(B). 

%% Calculate condition probability. 
    %P(A & B)
    i = a & b; 
    pAB = sum(i)/sampsize;
    
    %P(A) 
    pA = sum(a)/sampsize;
    
    %P(B)
    pB = sum(b)/sampsize; 
    
    %P(B|A)
    pBgA = pAB/pA; 
    
end