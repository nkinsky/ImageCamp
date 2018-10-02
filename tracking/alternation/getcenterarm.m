function center = getcenterarm(x,y,w,l)
%function getcenterarm(x,y,w,l)
%   Takes position information and outputs boundaries of the center arm.
%   
%   X and Y are vectors of position information. 
%
%   BORDER is a struct with fields:
%       x = x coordinates of the rectangle surrounding the center arm. 
%       y = y coordinates of the rectangle surrounding the center arm. 
%       w = width of arm, same value used in sections function
%       l = length of shift from top/bottom of maze, same value used in 
%       sections function
%

%%
    w_adj = 1.3; % Amount to increase width for center arm, since there seems to be a bit more jitter in the position for the center...

%% Get xy coordinate bounds for center arm. 
    xmax = max(x); xmin = min(x); 
    ymax = max(y); ymin = min(y); 
    
    %Calculations. 
    ymid = mean([ymin ymax]); 
    
    %For now, width is manually set to 40 AU and downward shift is set to 20. 
%     w = (ymax-ymin)/5.5; % 55; 
    w = w*w_adj;
    shift = w/2; % 30; 
    
    %l is the the length of center arm chopped off at the choice point. 
%     l = (xmax-xmin)/8.1; %80; 
    
    %Border. 
    center.x = [xmin+l, xmax-l, xmax-l, xmin+l]; 
    center.y = [ymid-shift, ymid-shift, ymid-shift+w, ymid-shift+w]; 
    
end