function d = linearize_dist(ref,x,y)
%d = linearize_dist(ref,x,y)
%
%   Calculates the Euclidean distance between many points. 
%
%   INPUTS: 
%       ref: 1x2 vector containing the XY coordinate of the middle of the
%       exit boundary for the start or choice point. 
%       
%       X & Y: Position vectors from the output of postrials.m. 
%   
%   OUTPUT:
%       d: Distances of XY coordinates from ref. 
%

    %Make the matrix. 
    dist_mat = [ref; x', y']; 
    
    %Calculate Euclidean distance. 
    dists = pdist(dist_mat); 
    
    %Extract distances of interest (those relative to ref). 
    d = dists(1,2:end); 
end